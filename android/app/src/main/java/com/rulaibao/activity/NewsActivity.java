package com.rulaibao.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.UnreadNewsCount2B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.widget.TitleBar;

import java.util.HashMap;

/**
 * （我的模块）消息
 * Created by junde on 2018/4/21.
 */

public class NewsActivity extends BaseActivity implements View.OnClickListener {

    private static int CIRCLE_REQUEST_CODE = 0;  // 表示去圈子新成员列表
    private RelativeLayout rl_commission;
    private RelativeLayout rl_policy;
    private RelativeLayout rl_interaction;
    private RelativeLayout rl_new_members_circle;
    private RelativeLayout rl_other_news;

    private TextView tv_commission_news_number; // 佣金消息数
    private TextView tv_policy_news_number; // 保单消息数
    private TextView tv_interaction_news_number; // 互动消息数
    private TextView tv_circle_news_number; // 圈子新成员数
    private TextView tv_other_news_number; // 其它消息
    private String newsType;
    private UnreadNewsCount2B data;


    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_news);

        initTopTitle();
        initView();
        requestData();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
             .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.title_news))
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

    private void initView() {
        rl_commission = (RelativeLayout) findViewById(R.id.rl_commission);
        rl_policy = (RelativeLayout) findViewById(R.id.rl_policy);
        rl_interaction = (RelativeLayout) findViewById(R.id.rl_interaction);
        rl_new_members_circle = (RelativeLayout) findViewById(R.id.rl_new_members_circle);
        rl_other_news = (RelativeLayout) findViewById(R.id.rl_other_news);

        tv_commission_news_number = (TextView) findViewById(R.id.tv_commission_news_number);
        tv_policy_news_number = (TextView) findViewById(R.id.tv_policy_news_number);
        tv_interaction_news_number = (TextView) findViewById(R.id.tv_interaction_news_number);
        tv_circle_news_number = (TextView) findViewById(R.id.tv_circle_news_number);
        tv_other_news_number = (TextView) findViewById(R.id.tv_other_news_number);

        rl_commission.setOnClickListener(this);
        rl_policy.setOnClickListener(this);
        rl_interaction.setOnClickListener(this);
        rl_new_members_circle.setOnClickListener(this);
        rl_other_news.setOnClickListener(this);
    }

    /**
     * 获取消息的未读数
     */
    private void requestData() {
        HashMap<String, Object> param = new HashMap<>();
        param.put("userId", userId);

        HtmlRequest.getUnreadNewsCount(this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params==null || params.result == null) {
              //      Toast.makeText(NewsActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }
                data = (UnreadNewsCount2B) params.result;
                setData(data);
            }
        });
    }

    private void setData(UnreadNewsCount2B data) {
        // 佣金消息
        if (!TextUtils.isEmpty(data.getCommission()) && Integer.parseInt(data.getCommission()) != 0) {
            tv_commission_news_number.setVisibility(View.VISIBLE);
            tv_commission_news_number.setText(data.getCommission());
        }

        // 保单消息
        if (!TextUtils.isEmpty(data.getInsurance()) && Integer.parseInt(data.getInsurance()) != 0) {
            tv_policy_news_number.setVisibility(View.VISIBLE);
            tv_policy_news_number.setText(data.getInsurance());
        }

        // 互动消息
        if (!TextUtils.isEmpty(data.getComment()) && Integer.parseInt(data.getComment()) != 0) {
            tv_interaction_news_number.setVisibility(View.VISIBLE);
            tv_interaction_news_number.setText(data.getComment());
        }

        // 圈子新成员
        if (data.getCircle() == null || Integer.parseInt(data.getCircle()) == 0) {
            tv_circle_news_number.setVisibility(View.GONE);
        } else {
            tv_circle_news_number.setVisibility(View.VISIBLE);
            tv_circle_news_number.setText(data.getCircle());
        }

        // 其它消息
        if (!TextUtils.isEmpty(data.getOtherMessage()) && Integer.parseInt(data.getOtherMessage()) != 0) {
            tv_other_news_number.setVisibility(View.VISIBLE);
            tv_other_news_number.setText(data.getOtherMessage());
        }
    }


    @Override
    public void onClick(View v) {
        Intent intent;
        switch (v.getId()) {
            case R.id.rl_commission: // 佣金消息
                intent = new Intent(this, CommissionNewsActivity.class);
                startActivity(intent);
                if (!TextUtils.isEmpty(data.getCommission())) {
                    tv_commission_news_number.setVisibility(View.GONE);
                }
                tv_commission_news_number.setVisibility(View.GONE);
                break;
            case R.id.rl_policy: // 保单消息
                intent = new Intent(this, PolicyNewsActivity.class);
                startActivity(intent);
                if (!TextUtils.isEmpty(data.getInsurance()) && Integer.parseInt(data.getInsurance()) != 0) {
                    tv_policy_news_number.setVisibility(View.GONE);
                }
                break;
            case R.id.rl_interaction: // 互动消息
                intent = new Intent(this, InteractiveNewsActivity.class);
                startActivity(intent);
                if (!TextUtils.isEmpty(data.getComment()) && Integer.parseInt(data.getComment()) != 0) {
                    tv_interaction_news_number.setVisibility(View.GONE);
                }
                break;
            case R.id.rl_new_members_circle: // 圈子新成员消息
                intent = new Intent(this, NewMembersOfCircleActivity.class);
                startActivityForResult(intent, CIRCLE_REQUEST_CODE);
//                if (!TextUtils.isEmpty(data.getCircle()) && Integer.parseInt(data.getCircle())!=0) {
//                    tv_circle_news_number.setVisibility(View.GONE);
//                }
                break;
            case R.id.rl_other_news: // 其它消息
                intent = new Intent(this, OtherNewsActivity.class);
                startActivity(intent);
                if (!TextUtils.isEmpty(data.getOtherMessage()) && Integer.parseInt(data.getOtherMessage()) != 0) {
                    tv_other_news_number.setVisibility(View.GONE);
                }
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == CIRCLE_REQUEST_CODE) {
            // 在圈子新成员列表同意加入后，再返回消息页面时需要重新刷消息页面的数据
            requestData();
        }
        super.onActivityResult(requestCode, resultCode, data);
    }
}
