package com.rulaibao.activity;

import android.content.Context;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.OK2B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.uitls.ConvertUtils;
import com.rulaibao.uitls.DatePicker;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.encrypt.DESUtil;
import com.rulaibao.widget.TitleBar;

import java.util.Calendar;
import java.util.LinkedHashMap;

/**
 * (保险)产品预约
 */

public class ProductAppointmentActivity extends BaseActivity implements View.OnClickListener {
    private Context context;
    private TextView tv_name;//产品名称
    private TextView tv_your_name;//你的姓名
    private TextView tv_your_phone;//你的电话
    private TextView tv_insurance_company;//保险公司
    private TextView tv_select_time;//时间

    private EditText et_insurance_plan;//保险计划
    private EditText et_insurance_amount;//保险金额
    private EditText et_pay_year;//年缴保费
    private EditText et_insurance_limit;//保险期限
    private EditText et_pay_limit;//缴费期限
    private EditText et_remark;//备注说明

    private RelativeLayout rl_select_time;//选择时间
    private Button btn_submit;//提交预约

    private String id;
    private String name;
    private String phone;
    private String category;
    private String realName;
    private String companyName;
    private String insurancePlan;
    private String insuranceAmount;
    private String periodAmount;
    private String insurancePeriod;
    private String paymentPeriod;
    private String exceptSubmitTime;
    private String remark;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_product_appointment);

        initTopTitle();
        initView();
        initData();
    }

    private void initTopTitle() {
        TitleBar titleBar = (TitleBar) findViewById(R.id.rl_title);
        titleBar.showLeftImg(true);
        titleBar.setFromActivity("6000");//
        titleBar.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false).setIndicator(R.mipmap.icon_back)
                .setCenterText(getResources().getString(R.string.title_product_appointment)).showMore(false).setOnActionListener(new TitleBar.OnActionListener() {

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

    public void initView() {
        context = this;
        tv_name = (TextView) findViewById(R.id.tv_name);
        tv_your_name = (TextView) findViewById(R.id.tv_your_name);
        tv_your_phone = (TextView) findViewById(R.id.tv_your_phone);
        tv_insurance_company = (TextView) findViewById(R.id.tv_insurance_company);
        tv_select_time = (TextView) findViewById(R.id.tv_select_time);

        et_insurance_plan = (EditText) findViewById(R.id.et_insurance_plan);
        et_insurance_amount = (EditText) findViewById(R.id.et_insurance_amount);
        et_pay_year = (EditText) findViewById(R.id.et_pay_year);
        et_insurance_limit = (EditText) findViewById(R.id.et_insurance_limit);
        et_pay_limit = (EditText) findViewById(R.id.et_pay_limit);
        et_remark = (EditText) findViewById(R.id.et_remark);

        rl_select_time = (RelativeLayout) findViewById(R.id.rl_select_time);
        btn_submit = (Button) findViewById(R.id.btn_submit);

        rl_select_time.setOnClickListener(this);
        btn_submit.setOnClickListener(this);
    }

    public void initData() {
        id = getIntent().getStringExtra("id");
        companyName = getIntent().getStringExtra("companyName");
        name = getIntent().getStringExtra("name");
        category = getIntent().getStringExtra("category");
        try {
            realName = DESUtil.decrypt(PreferenceUtil.getUserRealName());
            phone = DESUtil.decrypt(PreferenceUtil.getPhone());
        } catch (Exception e) {
            e.printStackTrace();
        }

        tv_name.setText(name);
        tv_your_name.setText(realName);
        tv_your_phone.setText(phone);
        tv_insurance_company.setText(companyName);
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.rl_select_time: // 日期选择
                onYearMonthDayPicker();
                break;
            case R.id.btn_submit: //提交预约
                checkNull(); //判空
                break;
            default:
                break;
        }
    }

    public void onYearMonthDayPicker() {
        final DatePicker picker = new DatePicker(this);
        picker.setCanceledOnTouchOutside(true);
        picker.setUseWeight(true);
        picker.setTopPadding(ConvertUtils.toPx(this, 10));
        picker.setRangeEnd(2111, 12, 31);
        picker.setRangeStart(2016, 1, 1);
        //获取当前年月日
        Calendar c = Calendar.getInstance();//
        int mYear = c.get(Calendar.YEAR); // 获取当前年份
        int mMonth = c.get(Calendar.MONTH) + 1;// 获取当前月份
        int mDay = c.get(Calendar.DAY_OF_MONTH);// 获取当日期
        picker.setSelectedItem(mYear, mMonth, mDay);
        picker.setResetWhileWheel(false);
        picker.setOnDatePickListener(new DatePicker.OnYearMonthDayPickListener() {
            @Override
            public void onDatePicked(String year, String month, String day) {
                tv_select_time.setText(year + "-" + month + "-" + day);
            }
        });
        picker.setOnWheelListener(new DatePicker.OnWheelListener() {
            @Override
            public void onYearWheeled(int index, String year) {
                picker.setTitleText(year + "-" + picker.getSelectedMonth() + "-" + picker.getSelectedDay());
            }

            @Override
            public void onMonthWheeled(int index, String month) {
                picker.setTitleText(picker.getSelectedYear() + "-" + month + "-" + picker.getSelectedDay());
            }

            @Override
            public void onDayWheeled(int index, String day) {
                picker.setTitleText(picker.getSelectedYear() + "-" + picker.getSelectedMonth() + "-" + day);
            }
        });
        picker.show();
    }

    private void checkNull() {
        insurancePlan = et_insurance_plan.getText().toString();
        insuranceAmount = et_insurance_amount.getText().toString();
        periodAmount = et_pay_year.getText().toString();
        insurancePeriod = et_insurance_limit.getText().toString();
        paymentPeriod = et_pay_limit.getText().toString();
        exceptSubmitTime = tv_select_time.getText().toString();
        remark = et_remark.getText().toString();

        if (TextUtils.isEmpty(insurancePlan)) {
            Toast.makeText(context, "请输入保险计划", Toast.LENGTH_SHORT).show();
            return;
        }
        if (TextUtils.isEmpty(insuranceAmount)) {
            Toast.makeText(context, "请输入保险金额", Toast.LENGTH_SHORT).show();
            return;
        }
        if (TextUtils.isEmpty(periodAmount)) {
            Toast.makeText(context, "请输入年缴保费", Toast.LENGTH_SHORT).show();
            return;
        }
        if (TextUtils.isEmpty(insurancePeriod)) {
            Toast.makeText(context, "请输入保险期限", Toast.LENGTH_SHORT).show();
            return;
        }
        if (TextUtils.isEmpty(paymentPeriod)) {
            Toast.makeText(context, "请输入缴费期限", Toast.LENGTH_SHORT).show();
            return;
        }
        if (TextUtils.isEmpty(exceptSubmitTime)) {
            Toast.makeText(context, "请选择交单时间", Toast.LENGTH_SHORT).show();
            return;
        }
        productAppointment();//产品预约
    }

    /**
     * 保险详情 -- 产品预约
     */
    private void productAppointment() {
        final LinkedHashMap<String, Object> param = new LinkedHashMap<>();

        param.put("productId", id);
        param.put("productName", name);
        param.put("mobile", phone);
        param.put("productCategory", category);
        param.put("userId", userId);
        param.put("userName", realName);
        param.put("companyName", companyName);
        param.put("insurancePlan", insurancePlan);
        param.put("insuranceAmount", insuranceAmount);
        param.put("periodAmount", periodAmount);
        param.put("insurancePeriod", insurancePeriod);
        param.put("paymentPeriod", paymentPeriod);
        param.put("exceptSubmitTime", exceptSubmitTime);
        param.put("remark", remark);

        HtmlRequest.apponitmentAdd(ProductAppointmentActivity.this, param, new BaseRequester.OnRequestListener() {

            @Override
            public void onRequestFinished(BaseParams params) {
                if (params == null || params.result == null) {
                    //     Toast.makeText(ProductAppointmentActivity.this, "加载失败，请确认网络通畅",Toast.LENGTH_LONG).show();
                    return;
                }
                OK2B b = (OK2B) params.result;
                if (b != null) {
                    if (Boolean.parseBoolean(b.getFlag())) {
                        Toast.makeText(ProductAppointmentActivity.this, b.getMessage(), Toast.LENGTH_LONG).show();
                        finish();
                    } else {
                        Toast.makeText(ProductAppointmentActivity.this, b.getMessage(), Toast.LENGTH_LONG).show();
                    }
                } else {
                    Toast.makeText(ProductAppointmentActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                }
            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onResume() {
        super.onResume();
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
