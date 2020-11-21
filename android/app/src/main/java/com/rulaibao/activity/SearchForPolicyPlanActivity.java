package com.rulaibao.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewSwitcher;

import com.rulaibao.R;
import com.rulaibao.adapter.PolicyPlanAdapter;
import com.rulaibao.adapter.TagAdapter;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.PolicyPlan2B;
import com.rulaibao.bean.PolicyPlan3B;
import com.rulaibao.dialog.DeleteHistoryDialog;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.FlowLayout;
import com.rulaibao.uitls.ListDataSave;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.TagFlowLayout;
import com.rulaibao.uitls.encrypt.DESUtil;
import com.rulaibao.widget.TitleBar;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Set;

import static android.view.View.GONE;
import static android.view.View.VISIBLE;


/**
 * 保单规划搜索页面
 */
public class SearchForPolicyPlanActivity extends BaseActivity implements View.OnClickListener,TextWatcher {
    private TitleBar titleBar;
    private EditText et_search;//输入框
    private Button bt_clear;//清除
    private TextView tv_search_cancel;
    private ViewSwitcher vs;
    private ViewSwitcher vs_listview;
    private ListView listView;
    private PolicyPlanAdapter mAdapter;
    private MouldList<PolicyPlan3B> totalList = new MouldList<>();
    Context mContext;
   private ArrayList listString=new ArrayList();;//历史搜索list
    private TagFlowLayout mFlowLayoutHistory;//历史搜索
    private LinearLayout ll_delete_history;
    private TextView tv_search_history_lines;
    private ImageView iv_delete_history;
    ListDataSave dataSave;
    boolean isDelete;

    private String customerName;//搜索字段
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_search_policy_plan);
        initTopTitle();
        initView();
        initData();
    }

    private void initTopTitle() {
        titleBar = (TitleBar) findViewById(R.id.rl_title);
        titleBar.setVisibility(GONE);
    }

    private void initView() {
        mContext = getApplicationContext();
        dataSave = new ListDataSave(mContext, "search_pre_policy_plan");//搜索sp
        et_search = (EditText) findViewById(R.id.et_search);
        bt_clear = (Button) findViewById(R.id.btn_clear);
        bt_clear.setVisibility(GONE);
        et_search.addTextChangedListener(this);
        tv_search_cancel= (TextView) findViewById(R.id.tv_search_cancel);
        mFlowLayoutHistory = (TagFlowLayout) findViewById(R.id.tagflowLayout_history);
        iv_delete_history= (ImageView) findViewById(R.id.iv_delete_history);
        ll_delete_history= (LinearLayout) findViewById(R.id.ll_delete_history);
        tv_search_history_lines= (TextView) findViewById(R.id.tv_search_history_lines);
        vs= (ViewSwitcher) findViewById(R.id.vs);
        vs_listview= (ViewSwitcher) findViewById(R.id.vs_list_view);
        TextView tv_empty = (TextView) findViewById(R.id.tv_empty);
        tv_empty.setText("暂无保单规划");

        listView= (ListView) findViewById(R.id.listView);
        mAdapter = new PolicyPlanAdapter(mContext, totalList);
        listView.setAdapter(mAdapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() { // item 点击监听
            @Override
            public void onItemClick(AdapterView<?> parent, View view,int position, long id) {
                Intent intent = new Intent(SearchForPolicyPlanActivity.this, PolicyRecordDetailActivity.class);
                intent.putExtra("orderId", totalList.get(position).getOrderId());
                startActivity(intent);
            }
        });

    }

    public void initData() {
        bt_clear.setOnClickListener(this);
        tv_search_cancel.setOnClickListener(this);
        iv_delete_history.setOnClickListener(this);
        flowLayoutHistory();//历史搜索
        et_search.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_SEARCH){
                    // 先隐藏键盘
                    ((InputMethodManager) getSystemService(INPUT_METHOD_SERVICE))
                            .hideSoftInputFromWindow(SearchForPolicyPlanActivity.this.getCurrentFocus()
                                    .getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
                    //将搜索内容保存到SharedPreferences
                    isDelete=false;
                    if(!TextUtils.isEmpty(v.getText().toString())){
                        listString.add(v.getText().toString());
                        dataSave.setDataList("search_string", listString);
                    }

                    customerName=v.getText().toString();
                    //请求数据要搜索的内容
                    requestListData(customerName);
                    return true;
                }
                return false;
            }
        });

    }
    //历史搜索
    private void flowLayoutHistory() {
        listString=(ArrayList)dataSave.getDataList("search_string".toString(),isDelete);//获取保存在本地的历史搜索数据
        if (listString.size()==0){
            ll_delete_history.setVisibility(GONE);
            tv_search_history_lines.setVisibility(GONE);
        }else{
            ll_delete_history.setVisibility(VISIBLE);
            tv_search_history_lines.setVisibility(VISIBLE);
        }
        mFlowLayoutHistory.setAdapter(new TagAdapter<String>(listString){
            @Override
            public View getView(FlowLayout parent, int position, String s){
                TextView tv = (TextView) LayoutInflater.from(SearchForPolicyPlanActivity.this).inflate(R.layout.search_flow_item_tv,
                        mFlowLayoutHistory, false);
                tv.setText(s);
                return tv;}
        });

        mFlowLayoutHistory.setOnTagClickListener(new TagFlowLayout.OnTagClickListener(){
            @Override
            public boolean onTagClick(View view, int position, FlowLayout parent){

                et_search.setText(listString.get(position).toString());
                et_search.setSelection(et_search.getText().toString().length());

                customerName = listString.get(position).toString();
                //请求数据要搜索的内容
                requestListData(customerName);
                return true;
            }
        });
        mFlowLayoutHistory.setOnSelectListener(new TagFlowLayout.OnSelectListener(){
            @Override
            public void onSelected(Set<Integer> selectPosSet){
                setTitle("choose:" + selectPosSet.toString());}
        });
    }
    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_clear:
                et_search.setText("");
                flowLayoutHistory();//重新加载搜索内容
                vs.setDisplayedChild(0);
                break;
           case R.id.tv_search_cancel:
               finish();
                break;
            case R.id.iv_delete_history:
                DeleteHistoryDialog dialog = new DeleteHistoryDialog(SearchForPolicyPlanActivity.this,
                        new DeleteHistoryDialog.OnExitChanged() {

                            @Override
                            public void onConfirm() {
                                listString.clear();
                                isDelete=true;
                                flowLayoutHistory();//重新加载搜索内容
                                ll_delete_history.setVisibility(GONE);
                                tv_search_history_lines.setVisibility(GONE);
                            }

                            @Override
                            public void onCancel() {

                            }
                        }, "确定清除历史搜索记录吗？");
                dialog.show();
                break;
        }
    }

    @Override
    public void beforeTextChanged(CharSequence s, int start, int count, int after) {

    }

    @Override
    public void onTextChanged(CharSequence s, int start, int before, int count) {

    }
    /****
     * 对用户输入文字的监听
     *
     * @param editable
     */
    @Override
    public void afterTextChanged(Editable editable) {
        /**获取输入文字**/
        String input = et_search.getText().toString().trim();
        if (input.isEmpty()) {
            bt_clear.setVisibility(GONE);
            vs.setDisplayedChild(0);
        } else {
            bt_clear.setVisibility(VISIBLE);
            vs.setDisplayedChild(1);
        }
    }
    /**
     * 获取计划书搜索数据
     */
    private void requestListData(String customerName) {
        String userId = null;
        try {
            userId = DESUtil.decrypt(PreferenceUtil.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("userId", userId);
        param.put("customerName", customerName);

        try {
            HtmlRequest.getPolicyPlanData(mContext, param, new BaseRequester.OnRequestListener() {
                @Override
                public void onRequestFinished(BaseParams params) {
                    if (params == null || params.result == null) {
                        vs_listview.setDisplayedChild(1);
                        return;
                    }
                    PolicyPlan2B data = (PolicyPlan2B) params.result;
                    if ("true".equals(data.getFlag())){
                        MouldList<PolicyPlan3B> everyList = data.getList();
                        totalList.clear();
                        totalList.addAll(everyList);
                        if (totalList.size() == 0) {
                            vs_listview.setDisplayedChild(1);
                        } else {
                            vs_listview.setDisplayedChild(0);
                        }
                        //刷新数据
                        mAdapter.notifyDataSetChanged();
                    }else{
                        vs_listview.setDisplayedChild(1);
                        Toast.makeText(mContext, data.getMessage(), Toast.LENGTH_SHORT).show();
                    }


                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}