package com.rulaibao.activity;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.InputType;
import android.text.Selection;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.OK2B;
import com.rulaibao.common.Urls;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.uitls.StringUtil;
import com.rulaibao.uitls.ViewUtils;
import com.rulaibao.widget.TitleBar;

import java.util.LinkedHashMap;

/**
 * 密码找回
 */

public class FindPasswordActivity extends BaseActivity implements View.OnClickListener{

    private EditText et_findpassword_phone;        //  注册的手机号
    private TextView tv_findpassword_get_verify_code;       //  获取验证码
    private EditText et_findpassword_verify_code;       //  验证码
    private EditText et_findpassword_password;      //  密码
    private EditText et_findpassword_password_again;     //
    private Button btn_findpassword;        //  密码重置

    private String mobile = "";
    private String verifyCode = "";
    private String password = "";
    private String password_again = "";


    private boolean smsflag = true;
    private boolean flag = true;
    private MyHandler mHandler;
    private String btnString;
    private int time = 60;
    private Context context;
    private boolean isOpenOne=false;
    private boolean isOpenTwo=false;
    private ImageView iv_hide_password;//隐藏密码
    private ImageView iv_hide_password_again;//隐藏密码


    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_findpassword);
        initTopTitle();
        initView();
    }

    public void initView(){
        context = this;
        et_findpassword_phone = (EditText) findViewById(R.id.et_findpassword_phone);
        tv_findpassword_get_verify_code = (TextView) findViewById(R.id.tv_findpassword_get_verify_code);
        et_findpassword_verify_code = (EditText) findViewById(R.id.et_findpassword_verify_code);
        et_findpassword_password = (EditText) findViewById(R.id.et_findpassword_password);
        et_findpassword_password_again = (EditText) findViewById(R.id.et_findpassword_password_again);
        btn_findpassword = (Button) findViewById(R.id.btn_findpassword);
        iv_hide_password= (ImageView) findViewById(R.id.iv_hide_password);
        iv_hide_password_again= (ImageView) findViewById(R.id.iv_hide_password_again);

        tv_findpassword_get_verify_code.setOnClickListener(this);
        btn_findpassword.setOnClickListener(this);
        iv_hide_password.setOnClickListener(this);
        iv_hide_password_again.setOnClickListener(this);

        mHandler = new MyHandler();
        btnString = getResources().getString(R.string.sign_getsms_again);

    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null))
                .setLogo(R.mipmap.logo, false).setIndicator(R.mipmap.icon_back)
                .setCenterText(getResources().getString(R.string.find_password_title))
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
        mHandler.removeCallbacks(myRunnable);
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.iv_hide_password: // 隐藏密码
                password = et_findpassword_password.getText().toString();
                if (TextUtils.isEmpty(password)){
                    return;
                }
                if (!isOpenOne) {
                    // 显示为普通文本
                    et_findpassword_password.setInputType(InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
                    // 使光标始终在最后位置
                    Editable etable = et_findpassword_password.getText();
                    Selection.setSelection(etable, etable.length());
                    iv_hide_password.setImageResource(R.mipmap.icon_open_password);
                    isOpenOne = true;
                } else {
                    isOpenOne = false;
                    // 显示为密码
                    et_findpassword_password.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
                    // 使光标始终在最后位置
                    Editable etable = et_findpassword_password.getText();
                    Selection.setSelection(etable, etable.length());
                    iv_hide_password.setImageResource(R.mipmap.icon_hide_password);
                }
                break;
            case R.id.iv_hide_password_again: // 隐藏密码
                password_again = et_findpassword_password_again.getText().toString();
                if (TextUtils.isEmpty(password_again)){
                    return;
                }
                if (!isOpenTwo) {
                    // 显示为普通文本
                    et_findpassword_password_again.setInputType(InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
                    // 使光标始终在最后位置
                    Editable etable = et_findpassword_password_again.getText();
                    Selection.setSelection(etable, etable.length());
                    iv_hide_password_again.setImageResource(R.mipmap.icon_open_password);
                    isOpenTwo = true;
                } else {
                    isOpenTwo = false;
                    // 显示为密码
                    et_findpassword_password_again.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
                    // 使光标始终在最后位置
                    Editable etable = et_findpassword_password_again.getText();
                    Selection.setSelection(etable, etable.length());
                    iv_hide_password_again.setImageResource(R.mipmap.icon_hide_password);
                }
                break;
            case R.id.btn_findpassword: // 密码重置
                checkDataNull();
                break;
            case R.id.tv_findpassword_get_verify_code: // 获取验证码
                mobile = et_findpassword_phone.getText().toString();
                if(TextUtils.isEmpty(mobile.trim())){
                    Toast.makeText(context,"请输入手机号",Toast.LENGTH_SHORT).show();
                    return;
                }
                if(!StringUtil.isMobileNO(mobile)){
                    Toast.makeText(context,"请输入正确的手机号",Toast.LENGTH_SHORT).show();
                    return;
                }
                tv_findpassword_get_verify_code.setClickable(false);
                requestSMS();
                break;

            default:

                break;


        }

    }
    /**
     * 判断为空条件
     */
    private void checkDataNull() {
        mobile = et_findpassword_phone.getText().toString();
        verifyCode = et_findpassword_verify_code.getText().toString();
        password = et_findpassword_password.getText().toString();
        password_again = et_findpassword_password_again.getText().toString();
        if(TextUtils.isEmpty(mobile.trim())){
            Toast.makeText(context,"请输入手机号",Toast.LENGTH_SHORT).show();
            return;
        }
        if(!StringUtil.isMobileNO(mobile.trim())){
            Toast.makeText(context,"请输入正确的手机号",Toast.LENGTH_SHORT).show();
            return;
        }
        if(TextUtils.isEmpty(verifyCode)){
            Toast.makeText(context,"请输入验证码",Toast.LENGTH_SHORT).show();
            return;
        }
        if(TextUtils.isEmpty(password)){
            Toast.makeText(context,"请输入密码",Toast.LENGTH_SHORT).show();
            return;
        }
        if(!StringUtil.checkPassword(password)){
            Toast.makeText(context,"请输入6至16位字母数字组合密码",Toast.LENGTH_SHORT).show();
            return;
        }
        if(TextUtils.isEmpty(password_again)){
            Toast.makeText(context,"请输入确认密码",Toast.LENGTH_SHORT).show();
            return;
        }
        if(!StringUtil.checkPassword(password_again)){
            Toast.makeText(context,"请输入6至16位字母数字组合密码",Toast.LENGTH_SHORT).show();
            return;
        }
        if(!password.equals(password_again)){
            Toast.makeText(context,"两次密码输入不一致，请重新输入",Toast.LENGTH_SHORT).show();
            return;
        }
        findpassword();
    }
    /**
     * 获取验证码
     */
    private void requestSMS() {
        final LinkedHashMap<String, Object> param = new LinkedHashMap<>();

        param.put("mobile", mobile);
        param.put("userId",userId);
        param.put("busiType", Urls.LOGINRET);

        HtmlRequest.sendSMS(FindPasswordActivity.this, param,new BaseRequester.OnRequestListener() {

            @Override
            public void onRequestFinished(BaseParams params) {
                if(params==null){
                    return;
                }
                OK2B b = (OK2B) params.result;
                if (b != null) {
                    if (Boolean.parseBoolean(b.getFlag())) {
                        Toast.makeText(FindPasswordActivity.this, b.getMessage(),
                                Toast.LENGTH_LONG).show();
                        smsflag = true;
                        startThread();
                    } else {
                        tv_findpassword_get_verify_code.setClickable(true);
                        smsflag = false;
                        Toast.makeText(FindPasswordActivity.this,
                                b.getMessage(), Toast.LENGTH_LONG)
                                .show();
                    }
                } else {
                    Toast.makeText(FindPasswordActivity.this, "加载失败，请确认网络通畅",
                            Toast.LENGTH_LONG).show();
                    tv_findpassword_get_verify_code.setClickable(true);
                }
            }
        });
    }
    /**
     * 密码找回
     */
    private void findpassword() {
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();

        param.put("mobile", mobile);
        param.put("newPassword", password);
        param.put("validateCode", verifyCode);

        HtmlRequest.findPassword(FindPasswordActivity.this, param,new BaseRequester.OnRequestListener() {

            @Override
            public void onRequestFinished(BaseParams params) {
                OK2B b = (OK2B) params.result;
                if (b != null) {
                    if (Boolean.parseBoolean(b.getFlag())) {
                        Toast.makeText(FindPasswordActivity.this,
                                b.getMessage(), Toast.LENGTH_LONG)
                                .show();
                        Intent i_login = new Intent(FindPasswordActivity.this, LoginActivity.class);
                        i_login.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                        startActivity(i_login);
                        finish();
                    } else {
                        Toast.makeText(FindPasswordActivity.this,
                                b.getMessage(), Toast.LENGTH_LONG)
                                .show();
                    }
                } else {
                    Toast.makeText(FindPasswordActivity.this, "加载失败，请确认网络通畅",
                            Toast.LENGTH_LONG).show();
                }
            }
        });
    }


    private void startThread() {
        if (smsflag) {
            Thread t = new Thread(myRunnable);
            flag = true;
            t.start();
        }
    }

    Runnable myRunnable = new Runnable() {

        @Override
        public void run() {
            while (flag) {
                Message msg = new Message();
                time -= 1;
                msg.arg1 = time;
                if (time == 0) {
                    flag = false;
                    mHandler.sendMessage(msg);
                    time = 60;
                    mHandler.removeCallbacks(myRunnable);
                } else {
                    mHandler.sendMessage(msg);
                }
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }

        }
    };
    @SuppressLint("HandlerLeak")
    class MyHandler extends Handler {

        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            setButtonStyle(msg.arg1);
        }

    }
    private void setButtonStyle(int time) {
        if (time == 0) {
            tv_findpassword_get_verify_code.setClickable(true);
            tv_findpassword_get_verify_code
                    .setTextColor(getResources().getColor(R.color.main_color_yellow));
            tv_findpassword_get_verify_code.setText(getResources().getString(
                    R.string.sign_getsms_again));
        } else if (time < 60) {
            tv_findpassword_get_verify_code.setClickable(false);
            tv_findpassword_get_verify_code
                    .setTextColor(getResources().getColor(R.color.gray_d));
            tv_findpassword_get_verify_code.setText(btnString+"("+time+")");

        }
    }

    public void checkNull(){

        //  监听输入手机号变化

        et_findpassword_phone.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                if(TextUtils.isEmpty(editable)){
                    btn_findpassword.setBackgroundResource(R.drawable.shape_center_gray);
                    btn_findpassword.setClickable(false);
                }else{
                    mobile = et_findpassword_phone.getText().toString();
                    verifyCode = et_findpassword_verify_code.getText().toString();
                    password = et_findpassword_password.getText().toString();
                    password_again = et_findpassword_password_again.getText().toString();

                    ViewUtils.setButton(verifyCode,password,password_again,btn_findpassword);

                }
            }
        });

        //  监听输入验证码

        et_findpassword_verify_code.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                if(TextUtils.isEmpty(editable)){
                    btn_findpassword.setBackgroundResource(R.drawable.shape_center_gray);
                    btn_findpassword.setClickable(false);
                }else{

                    mobile = et_findpassword_phone.getText().toString();
                    verifyCode = et_findpassword_verify_code.getText().toString();
                    password = et_findpassword_password.getText().toString();
                    password_again = et_findpassword_password_again.getText().toString();

                    ViewUtils.setButton(mobile,password,password_again,btn_findpassword);

                }
            }
        });

        //  监听输入密码变化

        et_findpassword_password.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                if(TextUtils.isEmpty(editable)){
                    btn_findpassword.setBackgroundResource(R.drawable.shape_center_gray);
                    btn_findpassword.setClickable(false);
                }else{
                    mobile = et_findpassword_phone.getText().toString();
                    verifyCode = et_findpassword_verify_code.getText().toString();
                    password = et_findpassword_password.getText().toString();
                    password_again = et_findpassword_password_again.getText().toString();

                    ViewUtils.setButton(mobile,verifyCode,password_again,btn_findpassword);
                }
            }
        });

        //  监听真实姓名输入变化

        et_findpassword_password_again.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                if(TextUtils.isEmpty(editable)){
                    btn_findpassword.setBackgroundResource(R.drawable.shape_center_gray);
                    btn_findpassword.setClickable(false);
                }else{
                    mobile = et_findpassword_phone.getText().toString();
                    verifyCode = et_findpassword_verify_code.getText().toString();
                    password = et_findpassword_password.getText().toString();
                    password_again = et_findpassword_password_again.getText().toString();
                    ViewUtils.setButton(mobile,verifyCode,password,btn_findpassword);

                }
            }
        });

    }

}
