package com.rulaibao.activity;

/**
 * 设置圈子权限
 */

import android.os.Bundle;
import android.os.Message;
import android.view.View;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.ResultInfoBean;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.RlbActivityManager;
import com.rulaibao.widget.TitleBar;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Timer;
import java.util.TimerTask;

import butterknife.BindView;
import butterknife.OnClick;

public class TrainingSetAuthorityActivity extends BaseActivity {

    @BindView(R.id.iv_authority_arrow)
    ImageView ivAuthorityArrow;
    @BindView(R.id.ib_authority)
    ImageButton ibAuthority;

    private String auditStatus = "";        //  是否需要验证
    private String circleId = "";
    private String allowClick = "true";     //  处理频繁点击

    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_training_authority);
        initTopTitle();
        initView();


    }

    public void initView() {
        auditStatus = getIntent().getStringExtra("isNeedAduit");
        circleId = getIntent().getStringExtra("circleId");
        if (auditStatus.equals("yes")) {
            ibAuthority.setImageResource(R.mipmap.img_set_on);

        } else {
            ibAuthority.setImageResource(R.mipmap.img_set_off);
//            imgGestureSwitch.setVisibility(View.GONE);
        }

    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.training_set_authority))
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

    //设置权限
    public void requestSetAuthorityData(){

        LinkedHashMap<String,Object> map = new LinkedHashMap<String,Object>();

        map.put("userId",userId);
        map.put("circleId",circleId);
        map.put("auditStatus",auditStatus);
//        map.put("content",content);

        HtmlRequest.getTrainingCircleSetAuthority(this, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {

                if(params.result!=null){

                    ResultInfoBean bean = (ResultInfoBean)params.result;

                    if(bean.getFlag().equals("true")){
                        if (auditStatus.equals("yes")) {
                            ibAuthority.setImageResource(R.mipmap.img_set_on);
                            auditStatus = "yes";
                            Toast.makeText(TrainingSetAuthorityActivity.this,"验证开启！加入圈子需要审核！",Toast.LENGTH_SHORT).show();

                        } else {
                            ibAuthority.setImageResource(R.mipmap.img_set_off);
                            auditStatus = "no";
                            Toast.makeText(TrainingSetAuthorityActivity.this,"验证关闭！加入圈子不需要审核！",Toast.LENGTH_SHORT).show();

                        }

                    }else{

                        Toast.makeText(TrainingSetAuthorityActivity.this,bean.getMessage(),Toast.LENGTH_SHORT).show();

                        if (auditStatus.equals("yes")) {
                            auditStatus = "no";
                        } else {
                            auditStatus = "yes";
                        }
                    }

                }else{

                }
                ibAuthority.setClickable(true);
            }
        });
    }


    @OnClick(R.id.ib_authority)
    public void onClick(){


        Timer timer = new Timer();
        timer.schedule(new TimerTask() {
            @Override
            public void run() {

                allowClick = "true";

            }

        },3000);

        if(allowClick.equals("true")){
            if (auditStatus.equals("yes")) {

                auditStatus = "no";
            } else {

                auditStatus = "yes";
            }
            allowClick = "false";
            ibAuthority.setClickable(false);
            requestSetAuthorityData();
        }else{
            Toast.makeText(TrainingSetAuthorityActivity.this,"请勿频繁操作",Toast.LENGTH_SHORT).show();
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
    protected void onStop() {
        super.onStop();
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }
}
