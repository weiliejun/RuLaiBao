package com.rulaibao.activity;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ListAdapter;
import android.widget.TextView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.adapter.TagAdapter;
import com.rulaibao.adapter.TrainingToAskListAdapter;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.ResultAskTypeItemBean;
import com.rulaibao.bean.ResultInfoBean;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.uitls.FlowLayout;
import com.rulaibao.uitls.TagFlowLayout;
import com.rulaibao.widget.TitleBar;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Set;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 我要提问
 */

public class TrainingToAskActivity extends BaseActivity {
    @BindView(R.id.et_toask_title)
    EditText etToaskTitle;
    @BindView(R.id.et_toask_content)
    EditText etToaskContent;
    @BindView(R.id.btn_training_toask)
    Button btnTrainingToask;
    @BindView(R.id.gv_training_toask)
    TagFlowLayout gv_training_toask;
    private TagAdapter<String> tagAdapter;
    private String string = "";
    private TrainingToAskListAdapter adapter;
    private String questionTitle = "";
    private String questionDesc = "";
    private int position = 0;
    private TextView tv;
    private ArrayList<ResultAskTypeItemBean> typeList;
    private ArrayList<String> nameList = new ArrayList<>();
    private ArrayList<String> codeList = new ArrayList<>();

    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_training_toask);
        initTopTitle();
        initView();
    }

    public void initView() {
        typeList = (ArrayList<ResultAskTypeItemBean>) getIntent().getSerializableExtra("type");
        for (int i = 0; i < typeList.size(); i++) {
            nameList.add(typeList.get(i).getTypeName());
            codeList.add(typeList.get(i).getTypeCode());
        }
        if (typeList.size() > 0) {
            typeList.get(0).setFlag(true);
        }
        flowLayoutAsk();
    }

    //
    private void flowLayoutAsk() {
        gv_training_toask.setAdapter(tagAdapter = new TagAdapter<String>(nameList) {
            @Override
            public View getView(FlowLayout parent, int position, String s) {
                tv = (TextView) LayoutInflater.from(TrainingToAskActivity.this).inflate(R.layout.ask_flow_item,
                        gv_training_toask, false);
                tv.setText(s);
                if (typeList.get(position).getFlag()) {
                    tv.setBackgroundResource(R.drawable.shape_ring_orange);
                    tv.setTextColor(TrainingToAskActivity.this.getResources().getColor(R.color.txt_orange));
                } else {
                    tv.setBackgroundResource(R.drawable.shape_ring_gray);
                    tv.setTextColor(TrainingToAskActivity.this.getResources().getColor(R.color.txt_gray));
                }
                return tv;
            }
        });
        gv_training_toask.setOnTagClickListener(new TagFlowLayout.OnTagClickListener() {
            @Override
            public boolean onTagClick(View view, int position, FlowLayout parent) {
                setPosition(position);

                notifyData(position);
                tagAdapter.notifyDataChanged();
                return true;
            }
        });
        gv_training_toask.setOnSelectListener(new TagFlowLayout.OnSelectListener() {
            @Override
            public void onSelected(Set<Integer> selectPosSet) {
                setTitle("choose:" + selectPosSet.toString());
            }
        });
    }

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

    //发布提问
    public void requestAsk() {
//        ArrayMap<String,Object> map = new ArrayMap<String,Object>();
        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
        map.put("userId", userId);
        map.put("questionTitle", questionTitle);
        map.put("questionDesc", questionDesc);
        map.put("typeCode", codeList.get(getPosition()));
        btnTrainingToask.setClickable(false);
        HtmlRequest.getTrainingToAsk(this, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params.result != null) {
                    ResultInfoBean b = (ResultInfoBean) params.result;
                    if (b.getFlag().equals("true")) {
                        Toast.makeText(TrainingToAskActivity.this, b.getMessage(), Toast.LENGTH_SHORT).show();
                        finish();
                    } else {
                        Toast.makeText(TrainingToAskActivity.this, b.getMessage(), Toast.LENGTH_SHORT).show();

                    }
                } else {

                }
                btnTrainingToask.setClickable(true);
            }
        });
    }

    public void notifyData(int position) {
        for (int i = 0; i < typeList.size(); i++) {
            if (i == position) {
                typeList.get(i).setFlag(true);
            } else {
                typeList.get(i).setFlag(false);
            }
        }
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.training_toask))
                .showMore(false).setOnActionListener(new TitleBar.OnActionListener() {
            @Override
            public void onMenu(int id) {
            }

            @Override
            public void onBack() {
                finish();
            }

            @Override
            public void onAction(int id) {

            }
        });
    }

    @OnClick(R.id.btn_training_toask)
    public void onClick() {
        questionTitle = etToaskTitle.getText().toString();
        questionDesc = etToaskContent.getText().toString();
        if (questionTitle.length() < 10) {
            Toast.makeText(TrainingToAskActivity.this, "标题至少十个字", Toast.LENGTH_SHORT).show();
        } else {
            if (TextUtils.isEmpty(questionDesc.trim())) {
                Toast.makeText(TrainingToAskActivity.this, "请输入问题", Toast.LENGTH_SHORT).show();
            } else {
                requestAsk();
            }
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }
}
