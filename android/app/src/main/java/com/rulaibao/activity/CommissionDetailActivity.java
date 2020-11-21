package com.rulaibao.activity;

import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.TrackingDetail1B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.widget.TitleBar;

import java.util.LinkedHashMap;

/**
 * 佣金详情
 * Created by hong on 2018/11/13.
 */

public class CommissionDetailActivity extends BaseActivity {

    private TextView tv_total_commission; // 佣金总额
    private TextView tv_bill_type; // 帐单类型
    private TextView tv_underwriting_time; // 承保时间
    private TextView tv_product_name; // 产品名称
    private TextView tv_policy_number; // 保单编号
    private TextView tv_customer_name; // 客户姓名
    private TextView tv_id_number; // 身份证号
    private TextView tv_insurance_period; // 保险期限
    private TextView tv_payment_period; // 缴费期限
    private TextView tv_renewal_date; // 续费日期
    private TextView tv_have_insurance_premiums; // 已交保费
    private TextView tv_promotion_fee; // 推广费
    private TextView tv_individual_income_tax; // 个人所得税
    private TextView tv_value_added_tax;  // 增值税
    private TextView tv_additional_tax;  // 附加税
    private TextView tv_get_commission; // 获得佣金
    private TextView tv_record_date; // 记录日期
    private TextView tv_settlement_time; // 结算时间
    private TrackingDetail1B data;
    private String id;


    @Override
    public void initData() {
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_commission_detail);

        initTopTitle();
        initView();
        requestData();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
             .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.title_transaction_detail))
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
        id = getIntent().getStringExtra("id");
//        Log.i("hh", "佣金消息列表传的id----" + id);

        tv_total_commission = (TextView) findViewById(R.id.tv_total_commission);
        tv_bill_type = (TextView) findViewById(R.id.tv_bill_type);
        tv_underwriting_time = (TextView) findViewById(R.id.tv_underwriting_time);
        tv_product_name = (TextView) findViewById(R.id.tv_product_name);
        tv_policy_number = (TextView) findViewById(R.id.tv_policy_number);
        tv_customer_name = (TextView) findViewById(R.id.tv_customer_name);
        tv_id_number = (TextView) findViewById(R.id.tv_id_number);
        tv_insurance_period = (TextView) findViewById(R.id.tv_insurance_period);
        tv_payment_period = (TextView) findViewById(R.id.tv_payment_period);
        tv_renewal_date = (TextView) findViewById(R.id.tv_renewal_date);
        tv_have_insurance_premiums = (TextView) findViewById(R.id.tv_have_insurance_premiums);
        tv_promotion_fee = (TextView) findViewById(R.id.tv_promotion_fee);
        tv_individual_income_tax = (TextView) findViewById(R.id.tv_individual_income_tax);
        tv_value_added_tax = (TextView) findViewById(R.id.tv_value_added_tax);
        tv_additional_tax = (TextView) findViewById(R.id.tv_additional_tax);
        tv_get_commission = (TextView) findViewById(R.id.tv_get_commission);
        tv_record_date = (TextView) findViewById(R.id.tv_record_date);
        tv_settlement_time = (TextView) findViewById(R.id.tv_settlement_time);
    }

    /**
     * 获取佣金详情页数据
     */
    private void requestData() {
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("id", id);
        param.put("userId", userId);

        HtmlRequest.getTradeRecordDetail(CommissionDetailActivity.this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params.result == null) {
                    Toast.makeText(CommissionDetailActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }

                data = (TrackingDetail1B) params.result;
                setView();
            }
        });
    }

    private void setView() {
        tv_total_commission.setText("+" + data.getCommissionGained());
        tv_bill_type.setText(data.getOrderType());
        tv_underwriting_time.setText(data.getUnderwirteTime());
        tv_product_name.setText(data.getProductName());
        tv_policy_number.setText(data.getOrderCode());
        tv_customer_name.setText(data.getCustomerName());
        tv_id_number.setText(data.getIdNo());
        tv_insurance_period.setText(data.getInsurancePeriod()+"");      //  后台录入单位
        tv_payment_period.setText(data.getPaymentPeriod()+"");          //  后台录入单位
        tv_renewal_date.setText(data.getRenewalDate());
        tv_have_insurance_premiums.setText(data.getPaymentedPremiums() + "元");
        tv_promotion_fee.setText(data.getPromotioinCost() + "%");
        tv_individual_income_tax.setText(data.getIndividualTax()+ "元");  // 个人所得税
        tv_value_added_tax.setText(data.getValueaddedTax()+ "元");  // 增值税
        tv_additional_tax.setText(data.getAdditionalTax()+ "元");  // 附加税
        tv_get_commission.setText(data.getCommissionGained() + "元");
        tv_record_date.setText(data.getCreateTime());
        tv_settlement_time.setText(data.getCommissionedTime());
    }

}
