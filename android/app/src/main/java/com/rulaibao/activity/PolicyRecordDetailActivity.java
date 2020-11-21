package com.rulaibao.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.view.ViewPager;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.ImageLoader;
import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.PolicyRecordDetail1B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.widget.TitleBar;

import java.util.LinkedHashMap;

/**
 * 保单详情
 * Created by junde on 2018/4/18.
 */

public class PolicyRecordDetailActivity extends BaseActivity implements View.OnClickListener {

    private RelativeLayout rl_audit_status; // 审核状态
    private ImageView iv_delete; // 删除 图标
    private TextView tv_turn_down; // 驳回原因
    private RelativeLayout rl_insurance_name; // 保险产品名布局
    private TextView tv_insurance_name; // 保险产品名字
    private TextView tv_policy_status; // 保单状态
    private LinearLayout ll_underwriting_time; //  承保时间 布局（待审核、驳回状态时不显示）
    private TextView tv_underwriting_time; // 承保时间
    private TextView tv_product_name; // 产品名称
    private LinearLayout ll_policy_number; // 保单编号 布局（待审核、驳回状态时不显示）
    private TextView tv_policy_number; // 保单编号
    private TextView tv_customer_name; // 客户姓名
    private TextView tv_id_number; // 身份证号
    private TextView tv_insurance_period; // 保险期限
    private TextView tv_payment_period; // 缴费期限
    private TextView tv_renewal_date2; // 续期日期
    private TextView tv_have_insurance_premiums; // 已交保费
    private TextView tv_promotion_fee; // 推广费
    private LinearLayout ll_get_commission; // 获得佣金 布局
    private TextView tv_get_commission; // 获得佣金

    private TextView tv_record_date; // 记录日期
    private ImageView iv_id_card_positive; // 身份证正面
    private ImageView iv_id_card_negative; // 身份证反面
    private ImageView iv_bank_card; // 银行卡
    private ImageView iv_other_card_first; // 其他
    private ImageView iv_other_card_second; // 其他
    private TextView tv_remarks_description; // 备注内容
    private String orderId;
    private PolicyRecordDetail1B data;


    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_policy_record_detail);

        initTopTitle();
        initView();
        requestData();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false).setIndicator(R.mipmap.icon_back)
             .setCenterText(getResources().getString(R.string.title_policy_record_detail)).showMore(false).setOnActionListener(new TitleBar.OnActionListener() {

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
        orderId = getIntent().getStringExtra("orderId");

        rl_audit_status = (RelativeLayout) findViewById(R.id.rl_audit_status);
        iv_delete = (ImageView) findViewById(R.id.iv_delete);
        tv_turn_down = (TextView) findViewById(R.id.tv_turn_down);
        rl_insurance_name = (RelativeLayout) findViewById(R.id.rl_insurance_name);
        tv_insurance_name = (TextView) findViewById(R.id.tv_insurance_name);
        tv_policy_status = (TextView) findViewById(R.id.tv_policy_status);
        ll_underwriting_time = (LinearLayout) findViewById(R.id.ll_underwriting_time);
        tv_underwriting_time = (TextView) findViewById(R.id.tv_underwriting_time);
        tv_product_name = (TextView) findViewById(R.id.tv_product_name);
        ll_policy_number = (LinearLayout) findViewById(R.id.ll_policy_number);
        tv_policy_number = (TextView) findViewById(R.id.tv_policy_number);
        tv_customer_name = (TextView) findViewById(R.id.tv_customer_name);
        tv_id_number = (TextView) findViewById(R.id.tv_id_number);
        tv_insurance_period = (TextView) findViewById(R.id.tv_insurance_period);
        tv_payment_period = (TextView) findViewById(R.id.tv_payment_period);
        tv_renewal_date2 = (TextView) findViewById(R.id.tv_renewal_date2);
        tv_have_insurance_premiums = (TextView) findViewById(R.id.tv_have_insurance_premiums);
        tv_promotion_fee = (TextView) findViewById(R.id.tv_promotion_fee);

        ll_get_commission = (LinearLayout) findViewById(R.id.ll_get_commission);
        tv_get_commission = (TextView) findViewById(R.id.tv_get_commission);
        tv_record_date = (TextView) findViewById(R.id.tv_record_date);
        iv_id_card_positive = (ImageView) findViewById(R.id.iv_id_card_positive);
        iv_id_card_negative = (ImageView) findViewById(R.id.iv_id_card_negative);
        iv_bank_card = (ImageView) findViewById(R.id.iv_bank_card);
        iv_other_card_first = (ImageView) findViewById(R.id.iv_other_card_first);
        iv_other_card_second = (ImageView) findViewById(R.id.iv_other_card_second);
        tv_remarks_description = (TextView) findViewById(R.id.tv_remarks_description);

        iv_delete.setOnClickListener(this);
        rl_insurance_name.setOnClickListener(this);
    }

    /**
     * 获取保单详情页数据
     */
    private void requestData() {
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("userId", userId);
        param.put("orderId", orderId);

        HtmlRequest.getPolicyRecordDetail(this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params==null || params.result == null) {
               //     Toast.makeText(PolicyRecordDetailActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }

                data = (PolicyRecordDetail1B) params.result;
                setView();
            }
        });
    }

    private void setView() {
        if (!TextUtils.isEmpty(data.getInsuranceName())) {
            tv_insurance_name.setText(data.getInsuranceName());
            tv_product_name.setText(data.getInsuranceName());
        }
//        if (!TextUtils.isEmpty(data.getAuditDesc())) {
//            rl_audit_status.setVisibility(View.VISIBLE);
//            tv_turn_down.setText(data.getAuditDesc());
//        }

        String status = data.getStatus();
        if (TextUtils.isEmpty(data.getStatus())) {
            return;
        }
        if ("init".equals(status)) {
            tv_policy_status.setText("待审核");
        } else if ("payed".equals(status)) {
            tv_policy_status.setText("已承保");
            //  承保时间 布局（待审核、驳回状态时不显示）
            ll_underwriting_time.setVisibility(View.VISIBLE);
            tv_underwriting_time.setText(data.getUnderwirteTime());

            // 保单编号 布局（待审核、驳回状态时不显示）
            ll_policy_number.setVisibility(View.VISIBLE);
            tv_policy_number.setText(data.getOrderCode());
        } else if ("rejected".equals(status)) {
            tv_policy_status.setText("问题件");
            rl_audit_status.setVisibility(View.VISIBLE);
            String auditDesc = data.getAuditDesc();
            if (TextUtils.isEmpty(auditDesc)) {
                tv_turn_down.setText("保单驳回："+ "暂无驳回信息。"+"{"+data.getAuditTime()+"}");
            }else {
                tv_turn_down.setText("保单驳回："+auditDesc+"{"+data.getAuditTime()+"}");
            }
        } else if ("receiptSigned".equals(status)) {
            tv_policy_status.setText("回执签收");
            ll_underwriting_time.setVisibility(View.VISIBLE);
            tv_underwriting_time.setText(data.getUnderwirteTime());
            ll_policy_number.setVisibility(View.VISIBLE);
            tv_policy_number.setText(data.getOrderCode());
        }else if ("commissioned".equals(status)) {
            tv_policy_status.setText("已结算");
            ll_underwriting_time.setVisibility(View.VISIBLE);
            tv_underwriting_time.setText(data.getUnderwirteTime());
            ll_policy_number.setVisibility(View.VISIBLE);
            tv_policy_number.setText(data.getOrderCode());
            ll_get_commission.setVisibility(View.VISIBLE);
            if (!TextUtils.isEmpty(data.getCommissionGained())) { // 获得佣金
                tv_get_commission.setText(data.getCommissionGained());
            }
        }else if ("renewing".equals(status)) {
            tv_policy_status.setText("续保中");
            ll_underwriting_time.setVisibility(View.VISIBLE);
            tv_underwriting_time.setText(data.getUnderwirteTime());
            ll_policy_number.setVisibility(View.VISIBLE);
            tv_policy_number.setText(data.getOrderCode());
            ll_get_commission.setVisibility(View.VISIBLE);
            if (!TextUtils.isEmpty(data.getCommissionGained())) { // 获得佣金
                tv_get_commission.setText(data.getCommissionGained());
            }
        }else if ("renewed".equals(status)) {
            tv_policy_status.setText("已续保");
            ll_underwriting_time.setVisibility(View.VISIBLE);
            tv_underwriting_time.setText(data.getUnderwirteTime());
            ll_policy_number.setVisibility(View.VISIBLE);
            tv_policy_number.setText(data.getOrderCode());
            ll_get_commission.setVisibility(View.VISIBLE);
            if (!TextUtils.isEmpty(data.getCommissionGained())) { // 获得佣金
                tv_get_commission.setText(data.getCommissionGained());
            }
        }

        if (!TextUtils.isEmpty(data.getCustomerName())) {  // 客户姓名
            tv_customer_name.setText(data.getCustomerName());
        }
        if (!TextUtils.isEmpty(data.getCustomerIdNo())) {  // 身份证号
            tv_id_number.setText(data.getCustomerIdNo());
        }
        if (!TextUtils.isEmpty(data.getInsurancePeriod())) {  // 保险期限
            tv_insurance_period.setText(data.getInsurancePeriod());
        }
        if (!TextUtils.isEmpty(data.getPaymentPeriod())) { // 缴费期限
            tv_payment_period.setText(data.getPaymentPeriod());
        }
        if (!TextUtils.isEmpty(data.getRenewalDate())) { // 续期日期
            tv_renewal_date2.setText(data.getRenewalDate());
        }
        if (!TextUtils.isEmpty(data.getPaymentedPremiums())) {  // 已交保费
            tv_have_insurance_premiums.setText(data.getPaymentedPremiums());
        }
        if (!TextUtils.isEmpty(data.getPromotioinCost())) { // 推广费
            tv_promotion_fee.setText(data.getPromotioinCost());
        }
        if (!TextUtils.isEmpty(data.getRecordTime())) { // 记录日期
            tv_record_date.setText(data.getRecordTime());
        }

        if (!TextUtils.isEmpty(data.getIdcardPositive())){
        ImageLoader.getInstance().displayImage(data.getIdcardPositive(), iv_id_card_positive); // 身份证正面
        }
        if (!TextUtils.isEmpty(data.getIdcardNegative())){
        ImageLoader.getInstance().displayImage(data.getIdcardNegative(), iv_id_card_negative); // 身份证反面
        }
        if (!TextUtils.isEmpty(data.getBankCard())){
        ImageLoader.getInstance().displayImage(data.getBankCard(), iv_bank_card); // 银行卡
        }
        if (!TextUtils.isEmpty(data.getAttachmentFirst())){
        ImageLoader.getInstance().displayImage(data.getAttachmentFirst(), iv_other_card_first); // 其他卡1
        }
        if (!TextUtils.isEmpty(data.getAttachmentSecond())){
        ImageLoader.getInstance().displayImage(data.getAttachmentSecond(), iv_other_card_second); // 其他卡2
        }

        if (!TextUtils.isEmpty(data.getRemark())) {
            tv_remarks_description.setText(data.getRemark());
        }
    }

    @Override
    public void onClick(View v) {

        switch (v.getId()) {
            case R.id.rl_insurance_name: // 跳转保险产品详情页
                Intent intent = new Intent(this,InsuranceProductDetailActivity.class );
                intent.putExtra("id", data.getProductId());
                startActivity(intent);
                break;
            case R.id.iv_delete:
                rl_audit_status.setVisibility(View.GONE);
                break;
        }
    }
}
