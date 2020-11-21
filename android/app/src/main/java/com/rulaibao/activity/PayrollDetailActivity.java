package com.rulaibao.activity;

import android.content.Intent;
import android.graphics.Paint;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.PayrollDetail2B;
import com.rulaibao.bean.UserInfo2B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.StringUtil;
import com.rulaibao.uitls.encrypt.DESUtil;
import com.rulaibao.widget.TitleBar;

import java.util.HashMap;

/**
 * 工资单详情
 * Created by hong on 2018/11/9.
 */

public class PayrollDetailActivity extends BaseActivity implements View.OnClickListener {

    private TextView tv_commission_income; // 佣金收益
    private TextView tv_personal_income_tax; // 个人所得税
    private TextView tv_value_added_tax; // 增值税
    private TextView tv_additional_tax; // 附加税
    private TextView tv_bank_card_num; // 银行帐号
    private TextView tv_total_income;  // 到账金额
    private TextView tv_transfer_status; // 发放状态
    private TextView tv_look_commission_detail; // 查看佣金明细
    private PayrollDetail2B data;

    private String payrollId; // 工资单
    private String currentMonth; // 当前月份

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_payroll_detail);

        initTopTitle();
        initView();
        requestData();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.title_payroll_detail))
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
        payrollId = getIntent().getStringExtra("id");
        currentMonth = getIntent().getStringExtra("currentMonth");
        Log.i("hh", getClass() + " --- " + currentMonth);

        tv_commission_income = (TextView) findViewById(R.id.tv_commission_income);
        tv_personal_income_tax = (TextView) findViewById(R.id.tv_personal_income_tax);
        tv_value_added_tax = (TextView) findViewById(R.id.tv_value_added_tax);
        tv_additional_tax = (TextView) findViewById(R.id.tv_additional_tax);
        tv_bank_card_num = (TextView) findViewById(R.id.tv_bank_card_num);
        tv_total_income = (TextView) findViewById(R.id.tv_total_income);
        tv_transfer_status = (TextView) findViewById(R.id.tv_transfer_status);
        tv_look_commission_detail = (TextView) findViewById(R.id.tv_look_commission_detail);
        tv_look_commission_detail.getPaint().setFlags(Paint. UNDERLINE_TEXT_FLAG ); //下划线
//        tv_look_commission_detail.setPadding(0,0,0,100);

        tv_look_commission_detail.setOnClickListener(this);
    }

    /**
     *  获取工资单详情
     */
    private void requestData() {
        try {
            userId = DESUtil.decrypt(PreferenceUtil.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
        }

        HashMap<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("id", payrollId);

        HtmlRequest.getPayrollDetailData(this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params == null || params.result == null) {
                    //  Toast.makeText(MyInfoActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }
                data = (PayrollDetail2B) params.result;
                if (data != null) {
                    setData(data);
                }
            }
        });
    }

    private void setData(PayrollDetail2B data) {
        if (data.getCommission() != null) {  // 佣金收益
            tv_commission_income.setText( data.getCommission()+"元");
        }
        if (data.getIndividualTax() != null) {  //个人所得税
            tv_personal_income_tax.setText(data.getIndividualTax()+"元");
        }
        if (data.getValueaddedTax() != null) {  // 增值税
            tv_value_added_tax.setText(data.getValueaddedTax()+"元");
        }
        if (data.getAdditionalTax() != null) {  // 附加税
            tv_additional_tax.setText(data.getAdditionalTax()+"元");
        }
        if (data.getBankcardNo() != null) {  // 银行帐号
            tv_bank_card_num.setText(data.getBankcardNo());
        }
        if (data.getIncome() != null) {  // 到账金额
            tv_total_income.setText(data.getIncome()+"元");
        }
        if (data.getStatus() != null) {  // 发放状态
            tv_transfer_status.setText(data.getStatus());
        }
    }

    @Override
    public void initData() {

    }

    @Override
    public void onClick(View v) {

        switch (v.getId()) {
            case R.id.tv_look_commission_detail: // 查看佣金明细
                Intent intent = new Intent(this, CommissionListActivity.class);
                intent.putExtra("currentMonth", currentMonth);
                startActivity(intent);
        }
    }
}
