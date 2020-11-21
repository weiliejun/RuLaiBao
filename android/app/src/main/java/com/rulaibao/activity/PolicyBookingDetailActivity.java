package com.rulaibao.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.OK2B;
import com.rulaibao.bean.PolicyBookingDetail1B;
import com.rulaibao.dialog.CancelNormalDialog;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.widget.TitleBar;

import java.util.LinkedHashMap;

/**
 *  预约详情
 * Created by junde on 2018/4/19.
 */

public class PolicyBookingDetailActivity extends BaseActivity implements View.OnClickListener {

    private RelativeLayout rl_audit_status; // 审核状态
    private ImageView iv_delete; // 删除 图标
    private TextView tv_turn_down; // 驳回原因
    private RelativeLayout rl_insurance_name; // 保险产品名布局
    private TextView tv_insurance_name; // 保险产品名字
    private TextView tv_policy_booking_status; // 预约状态
    private TextView tv_policy_booking_time; // 预约时间
    private TextView tv_policy_booking_people; // 预约人
    private TextView tv_policy_booking_phone; // 预约电话
    private TextView tv_insurance_company; // 保险公司
    private TextView tv_insurance_plan; // 保险计划
    private TextView tv_insurance_amount; // 保险金额
    private TextView tv_annual_premium; // 年缴保费
    private TextView tv_insurance_period; // 保险期限
    private TextView tv_payment_period; // 缴费期限
    private TextView tv_expected_policy; // 预计交单
    private TextView tv_remarks_description; // 备注内容
    private Button btn_cancel_booking; // 取消预约
    private String id;
    private PolicyBookingDetail1B data;
    private String status;


    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_policy_booking_detail);

        initTopTitle();
        initView();
        requestData();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.title_policy_booking_detail))
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

        rl_audit_status = (RelativeLayout) findViewById(R.id.rl_audit_status);
        iv_delete = (ImageView) findViewById(R.id.iv_delete);
        tv_turn_down = (TextView) findViewById(R.id.tv_turn_down);
        rl_insurance_name = (RelativeLayout) findViewById(R.id.rl_insurance_name);
        tv_insurance_name = (TextView) findViewById(R.id.tv_insurance_name);
        tv_policy_booking_status = (TextView) findViewById(R.id.tv_policy_booking_status);
        tv_policy_booking_time = (TextView) findViewById(R.id.tv_policy_booking_time);
        tv_policy_booking_people = (TextView) findViewById(R.id.tv_policy_booking_people);
        tv_policy_booking_phone = (TextView) findViewById(R.id.tv_policy_booking_phone);
        tv_insurance_company = (TextView) findViewById(R.id.tv_insurance_company);
        tv_insurance_plan = (TextView) findViewById(R.id.tv_insurance_plan);
        tv_insurance_amount = (TextView) findViewById(R.id.tv_insurance_amount);
        tv_annual_premium = (TextView) findViewById(R.id.tv_annual_premium);
        tv_insurance_period = (TextView) findViewById(R.id.tv_insurance_period);
        tv_payment_period = (TextView) findViewById(R.id.tv_payment_period);
        tv_expected_policy = (TextView) findViewById(R.id.tv_expected_policy);
        tv_remarks_description = (TextView) findViewById(R.id.tv_remarks_description);
        btn_cancel_booking = (Button) findViewById(R.id.btn_cancel_booking);

        rl_insurance_name.setOnClickListener(this);
        iv_delete.setOnClickListener(this);
        rl_insurance_name.setOnClickListener(this);
        btn_cancel_booking.setOnClickListener(this);
    }

    /**
     *  获取预约详情页数据
     */
    private void requestData() {
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("id", id);

        HtmlRequest.getPolicyBookingDetailData(this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params.result == null) {
                    Toast.makeText(PolicyBookingDetailActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }

                data = (PolicyBookingDetail1B) params.result;
                setView();
            }
        });
    }

    private void setView() {
        if (!TextUtils.isEmpty(data.getProductName())) { // 保险产品名字
            tv_insurance_name.setText(data.getProductName());
        }

        if (!TextUtils.isEmpty( data.getAuditStatus())) {
             status = data.getAuditStatus();
        }
        if ("confirmed".equals(status)) {
            tv_policy_booking_status.setText("已确认");
        } else if ("confirming".equals(status)) {
            btn_cancel_booking.setVisibility(View.VISIBLE);
            tv_policy_booking_status.setText("待确认");
        } else if ("canceled".equals(status)) {
            btn_cancel_booking.setVisibility(View.GONE);
            tv_policy_booking_status.setText("已取消");
        } else if  ("refuse".equals(status)) {
                tv_policy_booking_status.setText("已驳回");
                rl_audit_status.setVisibility(View.VISIBLE);
                String refuseReason = data.getRefuseReason();
            if (TextUtils.isEmpty(refuseReason)) {
                tv_turn_down.setText("预约驳回："+"暂无驳回信息"+"。{"+data.getAuditTime()+"}");
            }else{
                tv_turn_down.setText("预约驳回："+data.getRefuseReason()+"。{"+data.getAuditTime()+"}");
            }
        }

        if (!TextUtils.isEmpty(data.getCreateTime())) {  // 预约时间
            tv_policy_booking_time.setText(data.getCreateTime());
        }
        if (!TextUtils.isEmpty(data.getUserName())) { // 预约人
            tv_policy_booking_people.setText(data.getUserName());
        }
        if (!TextUtils.isEmpty(data.getMobile())) {  // 预约电话
            tv_policy_booking_phone.setText(data.getMobile());
        }
        if (!TextUtils.isEmpty(data.getCompanyName())) { // 保险公司
            tv_insurance_company.setText(data.getCompanyName());
        }
        if (!TextUtils.isEmpty(data.getInsurancePlan())) { // 保险计划
            tv_insurance_plan.setText(data.getInsurancePlan());
        }
        if (!TextUtils.isEmpty(data.getInsuranceAmount())) { // 保险金额
            tv_insurance_amount.setText(data.getInsuranceAmount());
        }
        if (!TextUtils.isEmpty(data.getPeriodAmount())) { // 年缴保费
            tv_annual_premium.setText(data.getPeriodAmount());
        }
        if (!TextUtils.isEmpty(data.getInsurancePeriod())) { // 保险期限
            tv_insurance_period.setText(data.getInsurancePeriod());
        }
        if (!TextUtils.isEmpty(data.getPaymentPeriod())) { // 缴费期限
            tv_payment_period.setText(data.getPaymentPeriod());
        }
        if (!TextUtils.isEmpty(data.getExceptSubmitTime())) { // 预计交单
            tv_expected_policy.setText(data.getExceptSubmitTime());
        }
        if (!TextUtils.isEmpty(data.getRemark())) { // 备注内容
            tv_remarks_description.setText(data.getRemark());
        }
    }

    @Override
    public void onClick(View v) {

        switch (v.getId()) {
            case R.id.iv_back:
                finish();
                break;
            case R.id.iv_delete: // 驳回原因的关闭
                rl_audit_status.setVisibility(View.GONE);
                break;
            case R.id.rl_insurance_name: // 跳转到产品详情页
                Intent intent = new Intent(this,InsuranceProductDetailActivity.class );
                intent.putExtra("id", data.getProductId());
                startActivity(intent);

                break;
            case R.id.btn_cancel_booking: // 取消预约
                showDialog();
                break;

            default:
                break;
        }
   }

    private void showDialog() {
        CancelNormalDialog dialog = new CancelNormalDialog(this, new CancelNormalDialog.IsCancel() {
            @Override
            public void onConfirm() {
                    requestBookingCanceled();
//                Toast.makeText(PolicyBookingDetailActivity.this, "取消成功", Toast.LENGTH_LONG).show();
            }

            @Override
            public void onCancel() {
            }
        });
        dialog.setTitle("确定取消预约吗？");
        dialog.show();
    }

    /**
     *  取消预约
     */
    private void requestBookingCanceled() {
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("id", data.getId());

         HtmlRequest.getPolicyBookingCanceled(this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params.result == null) {
                    Toast.makeText(PolicyBookingDetailActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }
                    OK2B data = (OK2B) params.result;
                    if (data.getFlag().equals("true")) {
                        Toast.makeText(PolicyBookingDetailActivity.this, data.getMessage(), Toast.LENGTH_LONG).show();
                        finish();
                    } else {
                        Toast.makeText(PolicyBookingDetailActivity.this, data.getMessage(), Toast.LENGTH_LONG).show();
                    }
            }
        });
    }

}
