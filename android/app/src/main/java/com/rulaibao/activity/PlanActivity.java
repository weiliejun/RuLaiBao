package com.rulaibao.activity;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ObjectAnimator;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewSwitcher;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.rulaibao.R;
import com.rulaibao.adapter.PlanAdapter;
import com.rulaibao.adapter.TagAdapter;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.Plan2B;
import com.rulaibao.bean.Plan3B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.FlowLayout;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.TagFlowLayout;
import com.rulaibao.uitls.ViewUtils;
import com.rulaibao.widget.TitleBar;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Set;

/**
 * 计划书
 */
public class PlanActivity extends BaseActivity implements View.OnClickListener {
    private PullToRefreshListView listView;
    private PlanAdapter mAdapter;
    private MouldList<Plan3B> totalList = new MouldList<>();
    private int currentPage = 1;    //当前页
    private ViewSwitcher vs;
    private String category="";
    private Intent intent;
    private Plan2B data;
    private ImageView iv_search; // 搜索
    private ImageView iv_back;

    private TagFlowLayout mFlowLayout;
    private TagAdapter<String> tagAdapter;
    private LinearLayout ll_insurance;
    private ImageView iv_arrows;
    private LinearLayout ll_insurance_company;
    private TextView tv_reset;
    private TextView tv_ok;
    private View v_hidden;

    private boolean isOpened = false;   //动画是否开启

    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_plan);
        initTopTitle();
        initView();
        requestData();
        initRefresh();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setVisibility(View.GONE);
    }

    private void initView() {
        iv_search = (ImageView) findViewById(R.id.iv_search);
        iv_back= (ImageView) findViewById(R.id.iv_back);
        ll_insurance= (LinearLayout) findViewById(R.id.ll_insurance);
        v_hidden = findViewById(R.id.v_hidden);
        iv_arrows= (ImageView) findViewById(R.id.iv_arrows);
        ll_insurance_company = (LinearLayout) findViewById(R.id.ll_insurance_company);
        tv_reset= (TextView) findViewById(R.id.tv_reset);
        tv_ok= (TextView) findViewById(R.id.tv_ok);

        iv_search.setOnClickListener(this);
        iv_back.setOnClickListener(this);
        ll_insurance.setOnClickListener(this);
        tv_reset.setOnClickListener(this);
        tv_ok.setOnClickListener(this);
        v_hidden.setOnClickListener(this);
    }
    private void initData(final ArrayList<String> mPlan) {
        mFlowLayout = (TagFlowLayout) findViewById(R.id.tagflowLayout_plan);

        mFlowLayout.setAdapter(tagAdapter = new TagAdapter<String>(mPlan)
        {

            @Override
            public View getView(FlowLayout parent, int position, String s)
            {
                TextView tv = (TextView) LayoutInflater.from(PlanActivity.this).inflate(R.layout.flow_plan_item,
                        mFlowLayout, false);
                tv.setText(s);
                return tv;
            }
        });
        mFlowLayout.setOnTagClickListener(new TagFlowLayout.OnTagClickListener()
        {
            @Override
            public boolean onTagClick(View view, int position, FlowLayout parent)
            {
                return true;
            }
        });


        mFlowLayout.setOnSelectListener(new TagFlowLayout.OnSelectListener()
        {
            @Override
            public void onSelected(Set<Integer> selectPosSet)
            {
         //       category=stringBuilder(selectPosSet);
            }
        });
    }
    private String stringBuilder(Set<Integer> selectPosSet) {
        StringBuilder stringBuilder=new StringBuilder();

        for(Integer integer: selectPosSet){
            stringBuilder.append("'");
            stringBuilder.append(data.getCompanyList().get(integer));
            stringBuilder.append("'");
            stringBuilder.append(",");
        }
        String sb="";
        if (selectPosSet.size()!=0){

            sb=stringBuilder.toString().substring(0,stringBuilder.toString().length()-1);
        }

        return sb;
    }
    private void initRefresh() {
        vs = (ViewSwitcher)findViewById(R.id.vs);
        TextView tv_empty = (TextView)findViewById(R.id.tv_empty);
        tv_empty.setText("暂无计划书");
        listView = (PullToRefreshListView)findViewById(R.id.listview_plan);
        //PullToRefreshListView  上滑加载更多及下拉刷新
        ViewUtils.slideAndDropDown(listView);
        mAdapter = new PlanAdapter(mContext, totalList);
        listView.setAdapter(mAdapter);

        requestListData();

        listView.setOnRefreshListener(new PullToRefreshBase.OnRefreshListener<ListView>() {
            public void onRefresh(PullToRefreshBase<ListView> refreshView) {
                if (refreshView.isHeaderShown()) {
                    //下拉刷新
                    currentPage = 1;
                } else {
                    //上划加载下一页
                    currentPage++;
                }
                requestListData();
            }
        });

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() { // item 点击监听
            @Override
            public void onItemClick(AdapterView<?> parent, View view,int position, long id) {
                if (!PreferenceUtil.isLogin()) {
                    intent = new Intent(PlanActivity.this, LoginActivity.class);
                    intent.putExtra("GOTOMAIN", LoginActivity.GOTOMAIN);
                    startActivity(intent);
                    return;
                }
                if (!"success".equals(PreferenceUtil.getCheckStatus())) {
                    intent = new Intent(PlanActivity.this, SalesCertificationActivity.class);
                    startActivity(intent);
                    return;
                }
                intent= new Intent(PlanActivity.this, WebActivity.class);
                intent.putExtra("type", WebActivity.WEBTYPE_PLAN_BOOK);
                intent.putExtra("url", totalList.get(position-1).getProspectus());
                intent.putExtra("title", "计划书");
                startActivity(intent);
            }
        });

    }
    /**
     * 获取保险公司
     */
    private void requestData() {
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("page", currentPage + "");
        param.put("name", category);

        try {
            HtmlRequest.getPlanData(mContext, param, new BaseRequester.OnRequestListener() {
                @Override
                public void onRequestFinished(BaseParams params) {
                    if (params==null || params.result == null) {
                        return;
                    }
                    data = (Plan2B) params.result;
                    initData(data.getCompanyList());
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    /**
     * 获取计划书数据
     */
    private void requestListData() {
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("companyName", category);
        param.put("page", currentPage + "");
        param.put("userId", userId);

        try {
            HtmlRequest.getPlanData(mContext, param, new BaseRequester.OnRequestListener() {
                @Override
                public void onRequestFinished(BaseParams params) {
                    if (params==null || params.result == null) {
                        vs.setDisplayedChild(1);
                        Toast.makeText(mContext, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                        listView.postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                listView.onRefreshComplete();
                            }
                        }, 1000);
                        return;
                    }
                    data = (Plan2B) params.result;
                    MouldList<Plan3B> everyList = data.getList();
                    if ((everyList == null || everyList.size() == 0) && currentPage != 1) {
                        Toast.makeText(mContext, "已显示全部", Toast.LENGTH_SHORT).show();
                    }
                    if (currentPage == 1) {
                        //刚进来时 加载第一页数据，或下拉刷新 重新加载数据 。这两种情况之前的数据都清掉
                        totalList.clear();
                    }
                    totalList.addAll(everyList);
                    if (totalList.size() == 0) {
                        vs.setDisplayedChild(1);
                    } else {
                        vs.setDisplayedChild(0);
                    }
                    //刷新数据
                    mAdapter.notifyDataSetChanged();

                    listView.postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            listView.onRefreshComplete();
                        }
                    }, 1000);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_search: // 搜索 图标
                if (PreferenceUtil.isLogin()) {
                    intent = new Intent(mContext, SearchForPlanActivity.class);
                    mContext.startActivity(intent);
                }else{
                    intent = new Intent(mContext, LoginActivity.class);
                    intent.putExtra("GOTOMAIN", LoginActivity.GOTOMAIN);
                    mContext.startActivity(intent);
                }
                break;
            case R.id.iv_back:
                finish();
                break;
            case R.id.ll_insurance: // 保险公司

                if (isOpened) {
                    //动画是开启状态
                    iv_arrows.setBackgroundResource(R.mipmap.ic_drop_down_unselected);
                        closeShopping(ll_insurance_company);
                } else {
                    //动画是关闭状态
                    openShopping(ll_insurance_company);
                    iv_arrows.setBackgroundResource(R.mipmap.ic_drop_down_selected);
                }

                break;
            case R.id.v_hidden:  // 隐藏布局 关闭动画
       ///         closeShopping(ll_insurance_company);
                break;
            case R.id.tv_reset:  // 重置
                category="";
                tagAdapter.setSelectedList();
                break;
            case R.id.tv_ok:  // 确定
                //点确定时，请求接口
                currentPage = 1;
                //获得所有选中的pos集合
                Set<Integer> selectPosSet= mFlowLayout.getSelectedList();
                category=stringBuilder(selectPosSet);

                requestListData();
                listView.getRefreshableView().setSelection(0);

                //该按钮被点击了 则类型一定处于展开状态，此时需关闭动画，且箭头置成向下
                iv_arrows.setBackgroundResource(R.mipmap.ic_drop_down_unselected);
                closeShopping(ll_insurance_company);
                break;
        }
    }
    //开启动画
    private void openShopping(LinearLayout ll_hidden_layout) {
        ObjectAnimator oa = ObjectAnimator.ofFloat(ll_hidden_layout, "translationY", -ll_hidden_layout.getMeasuredHeight(), 0f);
        oa.setDuration(200);
        oa.start();
        v_hidden.setVisibility(View.VISIBLE);
        ll_hidden_layout.setVisibility(View.VISIBLE);
        isOpened = true;
    }

    //关闭动画
    private void closeShopping(final LinearLayout ll_hidden_layout) {
        ObjectAnimator oa = ObjectAnimator.ofFloat(ll_hidden_layout, "translationY", 0f, -ll_hidden_layout.getMeasuredHeight());
        oa.setDuration(200);
        oa.start();
        oa.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                v_hidden.setVisibility(View.GONE);
                ll_hidden_layout.setVisibility(View.GONE);
                resetLayout(ll_insurance);
            }
        });
        isOpened = false;
    }
    //将布局重置到原始位置
    private void resetLayout(final LinearLayout ll_hidden_layout) {
        ObjectAnimator oa = ObjectAnimator.ofFloat(ll_hidden_layout, "translationY", -ll_hidden_layout.getMeasuredHeight(), 0f);
        oa.setDuration(0);
        oa.start();
    }
}