package com.rulaibao.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.OK2B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.widget.TitleBar;

import java.util.LinkedHashMap;

/**
 * Created by junde on 2019/5/16.
 */

public class AddNewInsurancePolicyActivity extends BaseActivity {

    private EditText et_policy_holder; // 投保人
    private EditText et_insurance_num; // 投保单号
    private Button btn_submit; // 提交
    private String policyHolderName;
    private String insuranceNum;
    private int currentTabPosition = 0; // 代表是从保单记录页面哪个tab过来的

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_add_new_insurance_policy);

        initTopTitle();
        initView();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false).setIndicator(R.mipmap.icon_back)
             .setCenterText(getResources().getString(R.string.title_add_new_insurance_policy)).showMore(false).setOnActionListener(new TitleBar.OnActionListener() {

            @Override
            public void onMenu(int id) {
            }

            @Override
            public void onBack() {
                Intent intent = new Intent();
                intent.putExtra("currentTabPosition", currentTabPosition);
                Log.i("hh", "新增保单页返回数据：" + currentTabPosition);
                AddNewInsurancePolicyActivity.this.setResult(100,intent);
                finish();
            }

            @Override
            public void onAction(int id) {
            }
        });
    }

    private void initView() {
//        currentTabPosition = getIntent().getIntExtra("currentTabPosition",0);

        et_policy_holder = (EditText) findViewById(R.id.et_policy_holder);
        et_insurance_num = (EditText) findViewById(R.id.et_insurance_num);
        btn_submit = (Button) findViewById(R.id.btn_submit);

        btn_submit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Todo 此处调接口
                checkNull(); //判空
            }
        });
    }

    private void checkNull() {
        policyHolderName = et_policy_holder.getText().toString();
        insuranceNum = et_insurance_num.getText().toString();

        if (TextUtils.isEmpty(policyHolderName)) {
            Toast.makeText(mContext,"请输入投保人",Toast.LENGTH_SHORT).show();
            return;
        }
        if(TextUtils.isEmpty(insuranceNum)){
            Toast.makeText(mContext,"请输入投保单号",Toast.LENGTH_SHORT).show();
            return;
        }

        // 获取提交接口
        requestSubmitData();
    }

    /**
     * 提交 接口
     */
    private void requestSubmitData() {
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("policyHolder", policyHolderName);
        param.put("orderCode", insuranceNum);
        param.put("userId", userId);
        Log.i("hh", "userId = " + userId);

        HtmlRequest.addInsurancePoliceSubmit(AddNewInsurancePolicyActivity.this, param, new BaseRequester.OnRequestListener() {

            @Override
            public void onRequestFinished(BaseParams params) {
                if (params == null || params.result == null) {
                    //     Toast.makeText(ProductAppointmentActivity.this, "加载失败，请确认网络通畅",Toast.LENGTH_LONG).show();
                    return;
                }
                OK2B b = (OK2B) params.result;
                if (b != null) {
                    if (Boolean.parseBoolean(b.getFlag())) {
                        Toast.makeText(AddNewInsurancePolicyActivity.this, b.getMessage(), Toast.LENGTH_LONG).show();
                        Intent intent = new Intent();
                        intent.putExtra("currentTabPosition", currentTabPosition);
                        Log.i("hh", "新增保单页返回数据：" + currentTabPosition);
                        AddNewInsurancePolicyActivity.this.setResult(100,intent);
                        finish();
                    } else {
                        Toast.makeText(AddNewInsurancePolicyActivity.this, b.getMessage(), Toast.LENGTH_LONG).show();
                    }
                } else {
                    Toast.makeText(AddNewInsurancePolicyActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                }
            }
        });
    }


    @Override
    public void initData() {

    }
}
