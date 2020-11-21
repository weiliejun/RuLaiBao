package com.rulaibao.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.MyCommission2B;
import com.rulaibao.bean.UserInfo2B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.widget.TitleBar;

import java.util.LinkedHashMap;

/**
 *  我的佣金
 * Created by hong on 2018/11/5.
 */

public class MyCommissionActivity extends BaseActivity implements View.OnClickListener {

    private TextView tv_accumulated_commission; // 累计佣金
    private TextView tv_waiting_commission; // 待发佣金
    private TextView tv_get_commission; // 已发佣金

    private LinearLayout ll_waiting_commission; // 待发佣金
    private LinearLayout ll_my_commission; // 已发佣金
    private RelativeLayout rl_my_payroll; // 我的工资单
    private RelativeLayout rl_my_bank_card; // 我的银行卡
    private RelativeLayout rl_tax_rules; // 扣税规则
    private MyCommission2B data;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_my_commission);

        initTopTitle();
        initView();
        initData();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.title_my_commission))
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
        tv_accumulated_commission = (TextView) findViewById(R.id.tv_accumulated_commission);
        tv_waiting_commission = (TextView) findViewById(R.id.tv_waiting_commission);
        tv_get_commission = (TextView) findViewById(R.id.tv_get_commission);

        ll_waiting_commission = (LinearLayout) findViewById(R.id.ll_waiting_commission);
        ll_my_commission = (LinearLayout) findViewById(R.id.ll_my_commission);
        rl_my_payroll = (RelativeLayout) findViewById(R.id.rl_my_payroll);
        rl_my_bank_card = (RelativeLayout) findViewById(R.id.rl_my_bank_card);
        rl_tax_rules = (RelativeLayout) findViewById(R.id.rl_tax_rules);

        ll_waiting_commission.setOnClickListener(this);
        ll_my_commission.setOnClickListener(this);
        rl_my_payroll.setOnClickListener(this);
        rl_my_bank_card.setOnClickListener(this);
        rl_tax_rules.setOnClickListener(this);
    }

    @Override
    public void initData() {
        requestAllCommissionData();
    }

    /**
     *  获取 我的佣金数据
     */
    private void requestAllCommissionData() {
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("userId", userId);

        HtmlRequest.getMyCommissionData(this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params == null || params.result == null) {
                    //  Toast.makeText(MyInfoActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }
                data = (MyCommission2B) params.result;
                if (data != null) {
                    setData(data);
                }
            }
        });
    }

    private void setData(MyCommission2B data) {
        if (data.getTotalCommission()!= null) { // 累计佣金
            tv_accumulated_commission.setText(data.getTotalCommission());
        }
        if (data.getUnCommissioned()!= null) { // 待发佣金
            tv_waiting_commission.setText(data.getUnCommissioned());
        }
        if (data.getUnCommissioned()!= null) { // 已发佣金
            tv_get_commission.setText(data.getCommissioned());
        }
    }

    @Override
    public void onClick(View v) {
        Intent intent;
        switch (v.getId()) {
            case R.id.ll_waiting_commission: // 待发佣金
                intent = new Intent(this, WaitingCommissionActivity.class);
                intent.putExtra("commissionStatus", "no");
                startActivity(intent);
                break;
            case R.id.ll_my_commission: // 已发佣金
                intent = new Intent(this, HaveGetCommissionActivity.class);
                intent.putExtra("commissionStatus", "yes");
                startActivity(intent);
                break;
            case R.id.rl_my_payroll: // 我的工资单
                intent = new Intent(this, MyPayrollActivity.class);
                startActivity(intent);
                break;
            case R.id.rl_my_bank_card: // 我的银行卡
                intent = new Intent(this, MyBankCardsActivity.class);
                startActivity(intent);
                break;
            case R.id.rl_tax_rules: // 扣税规则
                intent = new Intent(this, TaxDeductionRulesActivity.class);
                startActivity(intent);
                break;
        }
    }
}
