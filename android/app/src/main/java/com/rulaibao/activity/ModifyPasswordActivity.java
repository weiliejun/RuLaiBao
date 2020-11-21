package com.rulaibao.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputType;
import android.text.Selection;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.OK2B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.StringUtil;
import com.rulaibao.widget.TitleBar;

import java.util.LinkedHashMap;

/**
 *  修改密码 页面
 * Created by junde on 2018/5/14.
 */

public class ModifyPasswordActivity extends BaseActivity implements View.OnClickListener {

    private EditText et_old_password; // 旧密码
    private EditText et_new_password; // 新密码
    private EditText et_confirm_password; // 确认密码

    private ImageView iv_old_hide_password; //旧密码 显示的图标
    private ImageView iv_new_hide_password; //新密码 显示的图标
    private ImageView iv_confirm_hide_password; //确认密码 显示的图标

    private Button btn_sure; // 确定
    private String oldPassword;
    private String newPassword;
    private String confirmPassword;
    private boolean isShowPasswordOld = false; // 旧密码
    private boolean isShowPasswordNew = false; // 新密码
    private boolean isShowPasswordAgain = false; // 确认密码


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_modify_password);

        initTopTitle();
        initView();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false).setIndicator(R.mipmap.icon_back)
                .setCenterText(getResources().getString(R.string.setting_modify_password)).showMore(false).setOnActionListener(new TitleBar.OnActionListener() {

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
        et_old_password = (EditText) findViewById(R.id.et_old_password);
        et_new_password = (EditText) findViewById(R.id.et_new_password);
        et_confirm_password = (EditText) findViewById(R.id.et_confirm_password);

        iv_old_hide_password = (ImageView) findViewById(R.id.iv_old_hide_password);
        iv_new_hide_password = (ImageView) findViewById(R.id.iv_new_hide_password);
        iv_confirm_hide_password = (ImageView) findViewById(R.id.iv_confirm_hide_password);

        btn_sure = (Button) findViewById(R.id.btn_sure);

        iv_old_hide_password.setOnClickListener(this);
        iv_new_hide_password.setOnClickListener(this);
        iv_confirm_hide_password.setOnClickListener(this);
        btn_sure.setOnClickListener(this);

        //  监听输入密码变化
        et_old_password.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                oldPassword = et_old_password.getText().toString();
                newPassword = et_new_password.getText().toString();
                confirmPassword = et_confirm_password.getText().toString();

                setButton(oldPassword, newPassword, confirmPassword, btn_sure);
            }
        });
        //  监听输入密码变化
        et_new_password.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                oldPassword = et_old_password.getText().toString();
                newPassword = et_new_password.getText().toString();
                confirmPassword = et_confirm_password.getText().toString();

                setButton(oldPassword, newPassword, confirmPassword, btn_sure);
            }
        });
        //  监听输入密码变化
        et_confirm_password.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                oldPassword = et_old_password.getText().toString();
                newPassword = et_new_password.getText().toString();
                confirmPassword = et_confirm_password.getText().toString();

                setButton(oldPassword, newPassword, confirmPassword, btn_sure);
            }
        });
    }

    @Override
    public void initData() {

    }

    private static void setButton(String str1, String str2, String str3, Button btn_sure) {
        if (TextUtils.isEmpty(str1)) {
            btn_sure.setBackgroundResource(R.drawable.shape_non_clickable);
            btn_sure.setEnabled(false);
        } else {
            if (TextUtils.isEmpty(str2)) {
                btn_sure.setBackgroundResource(R.drawable.shape_non_clickable);
                btn_sure.setEnabled(false);
            } else {
                if (TextUtils.isEmpty(str3)) {
                    btn_sure.setBackgroundResource(R.drawable.shape_non_clickable);
                    btn_sure.setEnabled(false);
                } else {
                    btn_sure.setBackgroundResource(R.drawable.shape_gradient_orange);
                    btn_sure.setEnabled(true);
                }
            }
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_old_hide_password: // 旧密码
                oldPassword = et_old_password.getText().toString();
                if (TextUtils.isEmpty(oldPassword)) {
                    return;
                }

                if (!isShowPasswordOld) {
                    // 显示为普通文本
                    et_old_password.setInputType(InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
                    // 使光标始终在最后位置
                    Editable etable = et_old_password.getText();
                    Selection.setSelection(etable, etable.length());
                    iv_old_hide_password.setImageResource(R.mipmap.icon_open_password);
                    isShowPasswordOld = true;
                } else {
                    isShowPasswordOld = false;
                    // 显示为密码
                    et_old_password.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
                    // 使光标始终在最后位置
                    Editable etable = et_old_password.getText();
                    Selection.setSelection(etable, etable.length());
                    iv_old_hide_password.setImageResource(R.mipmap.icon_hide_password);
                }
                break;
            case R.id.iv_new_hide_password: //新密码
                newPassword = et_new_password.getText().toString();
                if (TextUtils.isEmpty(newPassword)) {
                    return;
                }
                if (!isShowPasswordNew) {
                    // 显示为普通文本
                    et_new_password.setInputType(InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
                    // 使光标始终在最后位置
                    Editable etable = et_new_password.getText();
                    Selection.setSelection(etable, etable.length());
                    iv_new_hide_password.setImageResource(R.mipmap.icon_open_password);
                    isShowPasswordNew = true;
                } else {
                    isShowPasswordNew = false;
                    // 显示为密码
                    et_new_password.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
                    // 使光标始终在最后位置
                    Editable etable = et_new_password.getText();
                    Selection.setSelection(etable, etable.length());
                    iv_new_hide_password.setImageResource(R.mipmap.icon_hide_password);
                }
                break;
            case R.id.iv_confirm_hide_password: // 确认密码
                confirmPassword = et_confirm_password.getText().toString();
                if (TextUtils.isEmpty(confirmPassword)) {
                    return;
                }
                if (!isShowPasswordAgain) {
                    // 显示为普通文本
                    et_confirm_password.setInputType(InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
                    // 使光标始终在最后位置
                    Editable etable = et_confirm_password.getText();
                    Selection.setSelection(etable, etable.length());
                    iv_confirm_hide_password.setImageResource(R.mipmap.icon_open_password);
                    isShowPasswordAgain = true;
                } else {
                    isShowPasswordAgain = false;
                    // 显示为密码
                    et_confirm_password.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
                    // 使光标始终在最后位置
                    Editable etable = et_confirm_password.getText();
                    Selection.setSelection(etable, etable.length());
                    iv_confirm_hide_password.setImageResource(R.mipmap.icon_hide_password);
                }
                break;
            case R.id.btn_sure: // 确定
                if (!StringUtil.checkPassword(oldPassword)) {
                    Toast.makeText(mContext, "请输入6至16位字母数字组合密码", Toast.LENGTH_LONG).show();
                    return;
                }
                if (!StringUtil.checkPassword(newPassword)) {
                    Toast.makeText(mContext, "请输入6至16位字母数字组合密码", Toast.LENGTH_SHORT).show();
                    return;
                }
                if (!newPassword.equals(confirmPassword)) {
                    Toast.makeText(mContext, "两次密码输入不一致，请重新输入", Toast.LENGTH_SHORT).show();
                    return;
                }
                modifyPassword();
                break;


            default:
                break;
        }

    }

    /**
     * 判断为空条件
     */
    private void checkDataNull() {
        oldPassword = et_old_password.getText().toString();
        newPassword = et_new_password.getText().toString();
        confirmPassword = et_confirm_password.getText().toString();
        if (TextUtils.isEmpty(oldPassword.trim())) {
            btn_sure.setEnabled(false);
//            Toast.makeText(this, "请输入原始密码", Toast.LENGTH_SHORT).show();
            return;
        }
        if (TextUtils.isEmpty(newPassword)) {
            Toast.makeText(this, "请输入新密码", Toast.LENGTH_SHORT).show();
            return;
        }
        if (!StringUtil.checkPassword(newPassword)) {
            Toast.makeText(this, "请输入6至16位字母数字组合密码", Toast.LENGTH_SHORT).show();
            return;
        }
        if (TextUtils.isEmpty(confirmPassword)) {
            Toast.makeText(this, "请输入确认密码", Toast.LENGTH_SHORT).show();
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            Toast.makeText(this, "两次密码输入不一致，请重新输入", Toast.LENGTH_SHORT).show();
            return;
        }
        modifyPassword();
    }

    /**
     * 重新修改密码后调接口
     */
    private void modifyPassword() {
        final LinkedHashMap<String, Object> param = new LinkedHashMap<>();

        param.put("userId", userId);
        param.put("password", oldPassword);
        param.put("newPassword", newPassword);

        HtmlRequest.modifyPassword(ModifyPasswordActivity.this, param, new BaseRequester.OnRequestListener() {

            @Override
            public void onRequestFinished(BaseParams params) {
                if (params==null){
                    return;
                }
                OK2B b = (OK2B) params.result;
                if (b != null) {
                    if (Boolean.parseBoolean(b.getFlag())) {
                        Toast.makeText(ModifyPasswordActivity.this, b.getMessage(), Toast.LENGTH_LONG).show();
                        finish();
                        Intent intent = new Intent(mContext, LoginActivity.class);
                        intent.putExtra("GOTOMAIN", LoginActivity.GOTOMAIN);
                        startActivity(intent);
                    } else {
                        Toast.makeText(ModifyPasswordActivity.this, b.getMessage(), Toast.LENGTH_LONG).show();
                    }
                } else {
                    Toast.makeText(ModifyPasswordActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                }
            }
        });
    }
}
