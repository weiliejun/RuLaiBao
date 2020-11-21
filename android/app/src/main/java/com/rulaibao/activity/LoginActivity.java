package com.rulaibao.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputType;
import android.text.Selection;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.Login2B;
import com.rulaibao.net.UserLogin;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.widget.TitleBar;

import java.util.Observable;
import java.util.Observer;

/**
 * 用户登录
 */

public class LoginActivity extends BaseActivity implements View.OnClickListener, Observer {

    private EditText et_login_phone; //  用户名
    private EditText et_login_password; //  密码
    private ImageView iv_hide_password; //隐藏密码
    private Button btn_login; //  登录
    private TextView tv_login_forget_password; //  忘记密码
    private TextView tv_login_sign; //  注册
    private Login2B bean;
    public static String GOTOMAIN = "1000";
    private String resultCode = "";
    //    private ImageView iv_back;
    private boolean isOpen = false;

    private String username;
    private String password;

    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_login);
        initTopTitle();
        initView();

    }

    public void initView() {
        resultCode = getIntent().getStringExtra("GOTOMAIN");

        PreferenceUtil.setAutoLoginPwd("");
        PreferenceUtil.setLogin(false);
        PreferenceUtil.setPhone("");
        PreferenceUtil.setUserId("");
        PreferenceUtil.setUserNickName("");
        PreferenceUtil.setCookie("");
        PreferenceUtil.setToken("");
        PreferenceUtil.setGestureChose(false);
        PreferenceUtil.setGesturePwd("");

//        bean = new ResultUserLoginContentBean();
        et_login_phone = (EditText) findViewById(R.id.et_login_phone);
        et_login_password = (EditText) findViewById(R.id.et_login_password);
        iv_hide_password = (ImageView) findViewById(R.id.iv_hide_password);
        btn_login = (Button) findViewById(R.id.btn_login);
        tv_login_forget_password = (TextView) findViewById(R.id.tv_login_forget_password);
        tv_login_sign = (TextView) findViewById(R.id.tv_login_sign);
//        iv_back= (ImageView) findViewById(R.id.iv_back);


        btn_login.setOnClickListener(this);
        tv_login_sign.setOnClickListener(this);
        iv_hide_password.setOnClickListener(this);
        tv_login_forget_password.setOnClickListener(this);
//        iv_back.setOnClickListener(this);
        /*et_login_phone.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                if (TextUtils.isEmpty(editable)) {

                    btn_login.setClickable(false);
                    btn_login.setBackgroundResource(R.drawable.shape_center_gray);

                } else {
                    if (TextUtils.isEmpty(et_login_password.getText().toString())) {
                        btn_login.setClickable(false);
                        btn_login.setBackgroundResource(R.drawable.shape_center_gray);
                    } else {
                        btn_login.setClickable(true);
                        btn_login.setBackgroundResource(R.drawable.shape_center_orange_white);
                    }

                }
            }
        });

        et_login_password.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {
            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
            }

            @Override
            public void afterTextChanged(Editable editable) {
                if (TextUtils.isEmpty(editable)) {
                    btn_login.setClickable(false);
                    btn_login.setBackgroundResource(R.drawable.shape_center_gray);
                } else {
                    if (TextUtils.isEmpty(et_login_phone.getText().toString())) {
                        btn_login.setClickable(false);
                        btn_login.setBackgroundResource(R.drawable.shape_center_gray);
                    } else {
                        btn_login.setClickable(true);
                        btn_login.setBackgroundResource(R.drawable.shape_center_orange_white);
                    }


                }
            }
        });*/

    }

    public void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setVisibility(View.GONE);
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onResume() {
        super.onResume();
        UserLogin.getInstance().addObserver(this);
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
        UserLogin.getInstance().deleteObserver(this);
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btn_login: // 登录
                username = et_login_phone.getText().toString();
                password = et_login_password.getText().toString();
                UserLogin.getInstance().userlogining(LoginActivity.this, username, password, "");

                break;
            case R.id.iv_hide_password: // 隐藏密码
                password = et_login_password.getText().toString();
                if (TextUtils.isEmpty(password)) {
                    return;
                }
                if (!isOpen) {
                    // 显示为普通文本
                    et_login_password.setInputType(InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
                    // 使光标始终在最后位置
                    Editable etable = et_login_password.getText();
                    Selection.setSelection(etable, etable.length());
                    iv_hide_password.setImageResource(R.mipmap.icon_open_password);
                    isOpen = true;
                } else {
                    isOpen = false;
                    // 显示为密码
                    et_login_password.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
                    // 使光标始终在最后位置
                    Editable etable = et_login_password.getText();
                    Selection.setSelection(etable, etable.length());
                    iv_hide_password.setImageResource(R.mipmap.icon_hide_password);
                }

                break;

            case R.id.tv_login_forget_password: // 忘记密码
                Intent i_find_password = new Intent(this, FindPasswordActivity.class);
                startActivity(i_find_password);
                break;

            case R.id.tv_login_sign: // 注册
                Intent i_sign = new Intent(this, SignActivity.class);
                startActivity(i_sign);
                break;
//            case R.id.iv_back: // 返回
//                finish();
//                break;
            default:

                break;


        }

    }

    @Override
    public void update(Observable observable, Object data) {
        bean = (Login2B) data;
        if (bean != null) {
            if (Boolean.parseBoolean(bean.getFlag())) {
                if (!TextUtils.isEmpty(resultCode)) {
                    if (resultCode.equals(GOTOMAIN)) {  //  登录完成跳至主页
                        Intent iMain = new Intent(LoginActivity.this, MainActivity.class);
                        iMain.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                        startActivity(iMain);
                        finish();
                    } else {
                        finish();
                    }
                } else {
                    finish();
                }
            } else {
//                Toast.makeText(LoginActivity.this, bean.getMessage(), Toast.LENGTH_SHORT).show();
            }
        }
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            if (!TextUtils.isEmpty(resultCode)) {
                if (resultCode.equals(GOTOMAIN)) {  // 点忘记密码跳转到登录页面时，若用户不登录直接点手机上返回键时，返回到主页
                    Intent iMain = new Intent(LoginActivity.this, MainActivity.class);
                    iMain.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                    startActivity(iMain);
                    finish();
                } else {
                    finish();
                }
            } else {
                finish();
            }
        }
        return false;
    }

}
