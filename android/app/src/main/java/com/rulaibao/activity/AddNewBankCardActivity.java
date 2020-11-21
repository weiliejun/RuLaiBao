package com.rulaibao.activity;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.OK2B;
import com.rulaibao.common.Urls;
import com.rulaibao.dialog.BankDialog;
import com.rulaibao.dialog.CancelNormalDialog;
import com.rulaibao.dialog.SelectAddressDialog;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.StringUtil;
import com.rulaibao.uitls.encrypt.DESUtil;
import com.rulaibao.widget.TitleBar;

import java.util.LinkedHashMap;

/**
 * 新增银行卡
 * Created by hong on 2018/11/15.
 */

public class AddNewBankCardActivity extends BaseActivity implements View.OnClickListener {

    private TextView tv_user_name; // 真实姓名
    private TextView tv_user_id; // 身份证号
    private TextView tv_selected_opening_bank; // 选择开户银行
    private TextView tv_selected_opening_bank_address; // 选择开户银行地址
    private TextView tv_user_phone; // 手机号

    private EditText et_account_opening_bank_name; // 输入开户行名称
    private EditText et_bank_card_num; // 输入银行卡号
    private EditText et_input_validation_code; // 输入验证码

    private RelativeLayout rl_account_opening_bank;  // 选择开户银行
    private RelativeLayout rl_account_opening_bank_address; // 开户地

    private Button btn_save; // 保存
    private Button btn_get_verification_code; // 获取验证码
    private String userPhone;
    private String userName;
    private String userIdNo;
    private String bankName;  // 开户银行名称
    private String bankCardNum;
    private String validationCode;
    private String selectedOpeningBank = ""; // 开户银行
    private String selectedOpeningBankAddress = "";

    private boolean smsflag = true;
    private boolean flag = true;
    private MyHandler mHandler;
    private String btnString;
    private int time = 60;

    private String[] selectInfo;
    private String addressId;
    private String aa;
    private String bb;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_add_new_bank_card);

        initTopTitle();
        initView();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false).setIndicator(R.mipmap.icon_back)
             .setCenterText(getResources().getString(R.string.title_add_bank_card)).showMore(false).setOnActionListener(new TitleBar.OnActionListener() {

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
        tv_user_name = (TextView) findViewById(R.id.tv_user_name);
        tv_user_id = (TextView) findViewById(R.id.tv_user_id);
        tv_selected_opening_bank = (TextView) findViewById(R.id.tv_selected_opening_bank);
        tv_selected_opening_bank_address = (TextView) findViewById(R.id.tv_selected_opening_bank_address);
        tv_user_phone = (TextView) findViewById(R.id.tv_user_phone);

        et_account_opening_bank_name = (EditText) findViewById(R.id.et_account_opening_bank_name);
        et_bank_card_num = (EditText) findViewById(R.id.et_bank_card_num);
        et_input_validation_code = (EditText) findViewById(R.id.et_input_validation_code);

        rl_account_opening_bank = (RelativeLayout) findViewById(R.id.rl_account_opening_bank);
        rl_account_opening_bank_address = (RelativeLayout) findViewById(R.id.rl_account_opening_bank_address);

        btn_get_verification_code = (Button) findViewById(R.id.btn_get_verification_code);
        btn_save = (Button) findViewById(R.id.btn_save);

        try {
            userPhone = DESUtil.decrypt(PreferenceUtil.getPhone());
            userName = DESUtil.decrypt(PreferenceUtil.getUserRealName());
            userIdNo = DESUtil.decrypt(PreferenceUtil.getIdNo());


            tv_user_name.setText(userName);
            tv_user_phone.setText(StringUtil.replaceSubString(userPhone));
            tv_user_id.setText(StringUtil.replaceSubStringIdNo(userIdNo));
        } catch (Exception e) {
            e.printStackTrace();
        }

        rl_account_opening_bank.setOnClickListener(this);
        rl_account_opening_bank_address.setOnClickListener(this);
        btn_get_verification_code.setOnClickListener(this);
        btn_save.setOnClickListener(this);

        mHandler = new MyHandler();
        btnString = getResources().getString(R.string.sign_getsms_again);
    }

    @Override
    public void initData() {
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.rl_account_opening_bank: // 选择开户银行
                showBankDialog();
                break;
            case R.id.rl_account_opening_bank_address: // 选择开户地
                showSelectAddressDialog();
                break;
            case R.id.btn_get_verification_code: // 获取验证码
                if (TextUtils.isEmpty(userPhone.trim())) {
                    Toast.makeText(this, "手机号不能为空", Toast.LENGTH_SHORT).show();
                    return;
                }
                requestSMS();
                btn_get_verification_code.setClickable(false);
                break;
            case R.id.btn_save: // 保存
                checkDataNull();
                break;

        }
    }

    /**
     * 选择开户银行
     */
    private void showBankDialog() {
        BankDialog dialog = new BankDialog(this, new BankDialog.BankChooseInterface() {
            @Override
            public void getBankName(String name) {
                selectedOpeningBank = name;
                tv_selected_opening_bank.setText(name);
            }
        });
        dialog.setTitle("");
        dialog.setCancelOutside(true);//点击阴影处是否能取消对话框
        dialog.showDialog();
    }

    /**
     * 选择银行开户地
     */
    private void showSelectAddressDialog() {
        SelectAddressDialog dialog = new SelectAddressDialog(this, new SelectAddressDialog.OnExitChanged() {
            @Override
            public void onConfim(String selectText) {
                selectedOpeningBankAddress = selectText;
                tv_selected_opening_bank_address.setText(selectText);
                selectInfo = selectText.split("-");
                aa = selectInfo[0];
                bb = selectInfo[1];
//                cc = selectInfo[2];
            }

            @Override
            public void onCancel() {

            }
        });
        dialog.show();
    }

    /**
     * 获取验证码
     */
    private void requestSMS() {
        final LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        String userPhone = null;
        try {
            userPhone = DESUtil.decrypt(PreferenceUtil.getPhone());
        } catch (Exception e) {
            e.printStackTrace();
        }
        param.put("mobile", userPhone);
//        Log.i("hh", "获取验证码时传给后台的手机号1：" + userPhone);
//        Log.i("hh", "获取验证码时传给后台的手机号2：" +  PreferenceUtil.getPhone());
        param.put("userId", userId);
        param.put("busiType", Urls.ADDBANKCARD);

        HtmlRequest.sendSMS(AddNewBankCardActivity.this, param, new BaseRequester.OnRequestListener() {

            @Override
            public void onRequestFinished(BaseParams params) {
                if (params == null) {
                    return;
                }
                OK2B b = (OK2B) params.result;
                if (b != null) {
                    if (Boolean.parseBoolean(b.getFlag())) {
                        Toast.makeText(AddNewBankCardActivity.this, b.getMessage(), Toast.LENGTH_LONG).show();
                        smsflag = true;
                        startThread();
                    } else {
                        btn_get_verification_code.setClickable(true);
                        smsflag = false;
                        Toast.makeText(AddNewBankCardActivity.this, b.getMessage(), Toast.LENGTH_LONG).show();
                    }
                } else {
                    Toast.makeText(AddNewBankCardActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    btn_get_verification_code.setClickable(true);
                }
            }
        });
    }

    /**
     * 判断为空条件
     */
    private void checkDataNull() {
        userName = tv_user_name.getText().toString();
        userIdNo = tv_user_id.getText().toString();
        selectedOpeningBank = tv_selected_opening_bank.getText().toString();
        selectedOpeningBankAddress = tv_selected_opening_bank_address.getText().toString();
        bankName = et_account_opening_bank_name.getText().toString();
        bankCardNum = et_bank_card_num.getText().toString();
        userPhone = tv_user_phone.getText().toString();
        validationCode = et_input_validation_code.getText().toString();

        if (TextUtils.isEmpty(userName)) {
            Toast.makeText(this, "姓名不能为空", Toast.LENGTH_SHORT).show();
            return;
        }
        if (TextUtils.isEmpty(userIdNo)) {
            Toast.makeText(this, "身份证号不能为空", Toast.LENGTH_SHORT).show();
            return;
        }
        if (TextUtils.isEmpty(selectedOpeningBank)) {
            Toast.makeText(this, "请选择开户银行", Toast.LENGTH_SHORT).show();
            return;
        }
        if (TextUtils.isEmpty(selectedOpeningBankAddress)) {
            Toast.makeText(this, "请选择开户地", Toast.LENGTH_SHORT).show();
            return;
        }
        if (TextUtils.isEmpty(bankName)) {
            Toast.makeText(this, "请输入开户行名称", Toast.LENGTH_SHORT).show();
            return;
        }
        if (TextUtils.isEmpty(bankCardNum)) {
            Toast.makeText(this, "请输入银行帐号", Toast.LENGTH_SHORT).show();
            return;
        }
        if (TextUtils.isEmpty(userPhone.trim())) {
            Toast.makeText(this, "手机号不能为空", Toast.LENGTH_SHORT).show();
            return;
        }
        if (TextUtils.isEmpty(validationCode)) {
            Toast.makeText(this, "请输入验证码", Toast.LENGTH_SHORT).show();
            return;
        }
        showSaveNewBankDialog();

    }

    /**
     * 我的银行卡-新增银行卡的保存
     */
    private void requestSaveBankCard() {
        final LinkedHashMap<String, Object> param = new LinkedHashMap<>();

        String userPhone = null;
        try {
            userPhone = DESUtil.decrypt(PreferenceUtil.getPhone());
        } catch (Exception e) {
            e.printStackTrace();
        }
        param.put("userId", userId);
        param.put("realName", userName);
        param.put("mobile", userPhone);
        param.put("idNo", userIdNo);// 身份证号
        param.put("validateCode", validationCode);
        param.put("bank", selectedOpeningBank); // 选择的银行名称
        param.put("bankName", bankName); // 手动输入的开户行名称
        param.put("bankcardNo", bankCardNum); // 银行卡号
        param.put("bankAddress", selectedOpeningBankAddress); // 开户行地址

        HtmlRequest.requestSaveBankCardData(AddNewBankCardActivity.this, param, new BaseRequester.OnRequestListener() {

            @Override
            public void onRequestFinished(BaseParams params) {
                if (params == null) {
                    return;
                }
                OK2B b = (OK2B) params.result;
                if (b != null) {
                    if (Boolean.parseBoolean(b.getFlag())) {
                        Toast.makeText(AddNewBankCardActivity.this, b.getMessage(), Toast.LENGTH_LONG).show();
                        finish();
                    } else {
                        Toast.makeText(AddNewBankCardActivity.this, b.getMessage(), Toast.LENGTH_LONG).show();
                    }
                } else {
                    Toast.makeText(AddNewBankCardActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                }
            }
        });
    }

    /**
     * 保存新银行卡弹框
     */
    private void showSaveNewBankDialog() {
        CancelNormalDialog dialog = new CancelNormalDialog(this, new CancelNormalDialog.IsCancel() {
            @Override
            public void onConfirm() {
                requestSaveBankCard();
//                btn_save.setClickable(false);
            }

            @Override
            public void onCancel() {
//                Toast.makeText(MyBankCardsActivity.this, "取消成功", Toast.LENGTH_LONG).show();
            }
        });
        dialog.setTitle("确定保存新银行卡吗？");
        dialog.show();
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
            btn_get_verification_code.setClickable(true);
            btn_get_verification_code.setBackgroundResource(R.drawable.shape_center_blue_light);
            btn_get_verification_code.setTextColor(getResources().getColor(R.color.white));
            btn_get_verification_code.setText(getResources().getString(R.string.sign_getsms_again));
        } else if (time < 60) {
            btn_get_verification_code.setClickable(false);
            btn_get_verification_code.setBackgroundResource(R.drawable.shape_center_gray_light);
            btn_get_verification_code.setTextColor(getResources().getColor(R.color.txt_black2));
            btn_get_verification_code.setText(btnString + "(" + time + ")");

        }
    }
}
