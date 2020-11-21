package com.rulaibao.activity;

import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.ResultCircleDetailsTopicListBean;
import com.rulaibao.bean.ResultInfoBean;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.uitls.RlbActivityManager;
import com.rulaibao.widget.TitleBar;

import java.util.HashMap;
import java.util.LinkedHashMap;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 发布话题
 */

public class TrainingIssueTopicActivity extends BaseActivity {


    @BindView(R.id.et_issue_topic_content)
    EditText etIssueTopicContent;
    @BindView(R.id.btn_training_issue_topic)
    Button btnTrainingIssueTopic;

    private String circleId = "";

    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_training_issue_topic);
        initTopTitle();
        initView();

    }

    public void initView() {

        circleId = getIntent().getStringExtra("circleId");
    }


    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.training_topic_add))
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


    @OnClick(R.id.btn_training_issue_topic)
    public void onClick(){

        requestAddTopicData();

    }

    //发布话题
    public void requestAddTopicData(){

        LinkedHashMap<String,Object> map = new LinkedHashMap<String,Object>();

        final String content  = etIssueTopicContent.getText().toString();

        map.put("circleId",circleId);
        map.put("userId",userId);
        map.put("content",content);

        btnTrainingIssueTopic.setClickable(false);

        HtmlRequest.getTrainingCircleAddTopic(this, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {

                if(params.result!=null){

                    ResultInfoBean bean = (ResultInfoBean)params.result;

                    if(bean.getFlag().equals("true")){

                        Toast.makeText(TrainingIssueTopicActivity.this,bean.getMessage(),Toast.LENGTH_SHORT).show();
                        finish();

                    }else{
                        Toast.makeText(TrainingIssueTopicActivity.this,bean.getMessage(),Toast.LENGTH_SHORT).show();
                    }
                    btnTrainingIssueTopic.setClickable(true);

                }else{

                }
            }
        });
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
