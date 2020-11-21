package com.rulaibao.activity;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.OK2B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.StringUtil;
import com.rulaibao.uitls.encrypt.DESUtil;
import com.rulaibao.widget.TitleBar;

import java.util.LinkedHashMap;

/**
 * 联系客服 页面
 * Created by junde on 2018/4/16.
 */

public class ContactCustomerServiceActivity extends BaseActivity implements View.OnClickListener {

    private EditText et_consulting_questions; // 用户咨询的问题
    private EditText et_phone; // 手机号
    private TextView tv_change_text;  // 用户输入时字数的变化
    private Button btn_submit; // 提交 按钮
    private String content = "";
    private String realName;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_contact_customer_service);

        initTopTitle();
        initView();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
             .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.title_contact_customer_service))
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
        et_consulting_questions = (EditText) findViewById(R.id.et_consulting_questions);
        et_phone = (EditText) findViewById(R.id.et_phone);
        tv_change_text = (TextView) findViewById(R.id.tv_change_text);
        btn_submit = (Button) findViewById(R.id.btn_submit);

        btn_submit.setOnClickListener(this);

        // 咨询问题文本的监听
        et_consulting_questions.addTextChangedListener(new TextWatcher() {
            public int editEnd;
            public int editStart;
            public CharSequence temp;

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                temp = s;
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
//                Log.i("hh", "onTextChanged -- " + s.length());
                tv_change_text.setText(s.length() + "/200");
            }

            @Override
            public void afterTextChanged(Editable s) {
                editStart = et_consulting_questions.getSelectionStart();
                editEnd = et_consulting_questions.getSelectionEnd();
                if (s.length() > 200) {
//                    Log.i("hh", "afterTextChanged -- " + s.length());
                    Toast.makeText(ContactCustomerServiceActivity.this, "您输入的字数已经超过限制！", Toast.LENGTH_SHORT).show();
                    s.delete(editStart - 1, editEnd);
                    int tempSelection = editStart;
                    et_consulting_questions.setText(s);
                    et_consulting_questions.setSelection(editEnd);

                }
                if (TextUtils.isEmpty(s) || TextUtils.isEmpty(et_phone.getText().toString())) {
                    btn_submit.setClickable(false);
                    btn_submit.setBackgroundResource(R.drawable.shape_non_clickable);
                } else {
                    btn_submit.setClickable(true);
                    btn_submit.setBackgroundResource(R.drawable.shape_gradient_orange);
                }
            }
        });

        // 手机号 文本监听
        et_phone.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                if (TextUtils.isEmpty(s) || TextUtils.isEmpty(et_consulting_questions.getText().toString())) {
                    btn_submit.setClickable(false);
                    btn_submit.setBackgroundResource(R.drawable.shape_non_clickable);
                } else {
                    btn_submit.setClickable(true);
                    btn_submit.setBackgroundResource(R.drawable.shape_gradient_orange);
                }
            }
        });

    }

    @Override
    public void initData() {
    }

    @Override
    public void onClick(View v) {

        switch (v.getId()) {
            case R.id.btn_submit: // 提交
                if (TextUtils.isEmpty(et_consulting_questions.getText().toString())||TextUtils.isEmpty(et_phone.getText().toString())) {
                    btn_submit.setClickable(false);
                    return;
                }
                if (StringUtil.isMobileNO(et_phone.getText().toString())) {
                    requestData();
                } else {
                    Toast.makeText(ContactCustomerServiceActivity.this, "您输入的手机号格式不正确", Toast.LENGTH_SHORT).show();
                }
                break;


            default:
                break;
        }

    }

    /**
     *  请求后台数据
     */
    private void requestData() {
        content = et_consulting_questions.getText().toString();
        phone = et_phone.getText().toString();
        try {
            realName = DESUtil.decrypt(PreferenceUtil.getUserRealName());
        } catch (Exception e) {
            e.printStackTrace();
        }
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("content", content);
        param.put("mobileNumber",  phone);
        param.put("userId",  userId);
        param.put("userName", realName);

        HtmlRequest.getFeedbackData(this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params==null || params.result == null) {
               //     Toast.makeText(ContactCustomerServiceActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }
                OK2B data = (OK2B) params.result;
                if (data != null) {
                    if (data.getFlag().equals("true")) {
                        Toast.makeText(ContactCustomerServiceActivity.this, data.getMessage(), Toast.LENGTH_LONG).show();
                        finish();
                    } else {
                        Toast.makeText(ContactCustomerServiceActivity.this, data.getMessage(), Toast.LENGTH_LONG).show();
                    }
                }
            }
        });
    }
}
