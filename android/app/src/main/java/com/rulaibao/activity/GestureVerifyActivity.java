package com.rulaibao.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.FrameLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.Login2B;
import com.rulaibao.bean.OK2B;
import com.rulaibao.common.Urls;
import com.rulaibao.dialog.BasicDialog;
import com.rulaibao.net.UserLogin;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.StringUtil;
import com.rulaibao.uitls.encrypt.DESUtil;
import com.rulaibao.widget.GestureContentView;
import com.rulaibao.widget.GestureDrawline;
import com.rulaibao.widget.TitleBar;

import java.util.Observable;
import java.util.Observer;

/**
 * 手势绘制/校验界面
 */
public class GestureVerifyActivity extends BaseActivity implements View.OnClickListener, Observer {
    private TextView mTextTip;
    private FrameLayout mGestureContainer;
    private GestureContentView mGestureContentView;
    private TextView mTextForget; // 忘记手势密码
    private TextView mTextOther;
    String s = null;
    private int current_num = 1;
    private static final int MAX_NUM = 5;
    public static final String TOMAIN = "6";

    private String from = null;
    private String titleName;
    private String message;
    private TitleBar title;

    @Override
    public void initData() {

    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_gesture_verify);

        from = getIntent().getExtras().getString("from");
        titleName = getIntent().getStringExtra("title");
        message = getIntent().getStringExtra("message");
        initTopTitle();
        initView();
    }

    @Override
    protected void onResume() {
        super.onResume();
        UserLogin.getInstance().addObserver(this);
        setUpViews();
    }

    private void initTopTitle() {
        title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null))
                .setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back)
                .setCenterText(titleName).showMore(false)
                .setOnActionListener(new TitleBar.OnActionListener() {

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
        mTextTip = (TextView) findViewById(R.id.text_title_message);
        mTextTip.setText(message);
        mGestureContainer = (FrameLayout) findViewById(R.id.gesture_container);
        mTextForget = (TextView) findViewById(R.id.text_forget_gesture);
        mTextOther = (TextView) findViewById(R.id.text_other_account);

		/*if(netHint_2!=null){
            netHint_2.setVisibility(View.GONE);
			llContent.setVisibility(View.VISIBLE);
		}
		netFail_2 = false;*/
    }

    private void setUpViews() {
        try {
            s = DESUtil.decrypt(PreferenceUtil.getGesturePwd());
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (from.equals(Urls.ACTIVITY_GESVERIFY)) {
            mTextForget.setVisibility(View.GONE);
            mTextOther.setVisibility(View.GONE);
        } else if (from.equals(Urls.ACTIVITY_ACCOUNT)) {
            mTextForget.setText("忘记手势密码");
            mTextForget.setOnClickListener(this);
        } else if (from.equals(Urls.ACTIVITY_SPLASH)) { // 从启动页进来
            title.showLeftImg(false);//只有登录进来的手势密码验证，左侧返回键隐藏
            mTextForget.setText("忘记手势密码");
            mTextForget.setOnClickListener(this);
            mTextOther.setVisibility(View.GONE);
        } else if (from.equals(Urls.ACTIVITY_GESEDIT)) {
            mTextForget.setText("忘记手势密码");
            mTextForget.setOnClickListener(this);
        } else if (from.equals(Urls.ACTIVITY_CHANGE_GESTURE)) { // 从设置页面点修改手势密码进来
            mTextForget.setText("忘记手势密码");
            mTextForget.setOnClickListener(this);
            mTextOther.setVisibility(View.GONE);
        }
        // 初始化一个显示各个点的viewGroup
        mGestureContentView = new GestureContentView(this, true, s, new GestureDrawline.GestureCallBack() {

            @Override
            public void onGestureCodeInput(String inputCode) {
            }

            @Override
            public void checkedSuccess() {
                mGestureContentView.clearDrawlineState(0L);
                try {
                    if (from.equals(Urls.ACTIVITY_SPLASH)) {
                        GestureVerifyActivity.this.finish();
//								UserLogin.getInstance().userlogining(
//										getApplicationContext(),
//										DESUtil.decrypt(PreferenceUtil
//												.getAutoLoginAccount()),
//										DESUtil.decrypt(PreferenceUtil
//												.getAutoLoginPwd()), "");
                        Intent i = new Intent(GestureVerifyActivity.this, MainActivity.class);
                        startActivity(i);
                    } else if (from.equals(Urls.ACTIVITY_ACCOUNT)) {
//								Intent i = new Intent(
//										GestureVerifyActivity.this,
//										AccountActivity.class);
//								setResult(2000, i);
//								finish();
                    } else if (from.equals(Urls.ACTIVITY_GESEDIT)) {
                        Toast.makeText(GestureVerifyActivity.this, "设置成功", Toast.LENGTH_SHORT).show();
                        finish();
                    } else if (from.equals(Urls.ACTIVITY_GESVERIFY)) {
                        UserLogin.getInstance().userlogining(getApplicationContext(), DESUtil.decrypt(PreferenceUtil.getAutoLoginAccount()), DESUtil.decrypt(PreferenceUtil.getAutoLoginPwd()), "");
                        Intent i = new Intent(GestureVerifyActivity.this, MainActivity.class);
                        Toast.makeText(GestureVerifyActivity.this, "设置成功", Toast.LENGTH_SHORT).show();
                        startActivity(i);
                        finish();
                    } else if (from.equals(Urls.ACTIVITY_CHANGE_GESTURE)) {
                        GestureVerifyActivity.this.finish();
                        Intent i = new Intent(GestureVerifyActivity.this, GestureEditActivity.class);
                        //判断从账户设置手势密码，点击跳过，再次登录时不会关闭手势密码
                        i.putExtra("skip", "skip_from_account");
                        i.putExtra("title", getString(R.string.setting_change_gesture_password));
                        i.putExtra("comeflag", 4);
                        startActivity(i);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void checkedFail() {
                if (current_num >= MAX_NUM) {
							/*Builder builder = new Builder(
									GestureVerifyActivity.this);
							builder.setMessage("您输入的手势密码错误次数已达到最大次数，请使用登录密码进行登录");
							builder.setTitle("密码错误");
							builder.setPositiveButton("确认",
									new DialogInterface.OnClickListener() {

										@Override
										public void onClick(
												DialogInterface dialog,
												int which) {
											from = Urls.ACTIVITY_GESVERIFY;
											Intent intent = new Intent();
											intent.setClass(
													GestureVerifyActivity.this,
													LoginActivity.class);

											intent.putExtra("GOTOMAIN", LoginActivity.GOTOMAIN);
											intent.putExtra("not_finish", "not_finish");//判断从手势登录页进登录，不finish
											PreferenceUtil.setFirstLogin(true);
											PreferenceUtil.setGesturePwd("");
											PreferenceUtil.setLogin(false);
											startActivity(intent);
											finish();
										}
									});
							builder.create().show();*/

                    BasicDialog dialog = new BasicDialog(GestureVerifyActivity.this, new BasicDialog.OnBasicChanged() {
                        @Override
                        public void onConfim() {
//									delete(position,list.get(position).getId());
                            from = Urls.ACTIVITY_GESVERIFY;
                            Intent intent = new Intent();
                            intent.setClass(GestureVerifyActivity.this, LoginActivity.class);

                            intent.putExtra("GOTOMAIN", LoginActivity.GOTOMAIN);
                            intent.putExtra("not_finish", "not_finish");//判断从手势登录页进登录，不finish
                            PreferenceUtil.setFirstLogin(true);
                            PreferenceUtil.setGesturePwd("");
                            PreferenceUtil.setLogin(false);
                            startActivity(intent);
                            finish();

                        }

                        @Override
                        public void onCancel() {
                        }
                    }, "您输入的手势密码错误次数已达到最大次数，请使用登录密码进行登录", "确认", false);
                    dialog.show();


                } else {
                    mGestureContentView.clearDrawlineState(1300L);
                    mTextTip.setVisibility(View.VISIBLE);
                    String str1, str2, str3;
                    str1 = "密码错误,您还可以尝试";
                    str2 = str1 + (MAX_NUM - current_num);
                    str3 = str2 + "次";

                    mTextTip.setText(StringUtil.setTextStyle(GestureVerifyActivity.this, str1, str2, str3, R.color.txt_red, R.color.txt_red, R.color.txt_red, 16, 16, 16, 0, 0, 0));
                    // 左右移动动画
                    Animation shakeAnimation = AnimationUtils.loadAnimation(GestureVerifyActivity.this, R.anim.shake);
                    mTextTip.startAnimation(shakeAnimation);
                    current_num++;
                }
            }
        });
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT);
        params.gravity = Gravity.CENTER_HORIZONTAL;
        mGestureContentView.setLayoutParams(params);
        // 设置手势解锁显示到哪个布局里面
        mGestureContentView.setParentView(mGestureContainer);
    }


    private String getProtectedMobile(String phoneNumber) {
        if (TextUtils.isEmpty(phoneNumber) || phoneNumber.length() < 11) {
            return "";
        }
        StringBuilder builder = new StringBuilder();
        builder.append(phoneNumber.subSequence(0, 3));
        builder.append("****");
        builder.append(phoneNumber.subSequence(7, 11));
        return builder.toString();
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
			/*case R.id.id_img_back:
				finish();
				break;*/
            case R.id.text_forget_gesture: // 忘记手势密码

//					VerifyPassWordDialog dialog_phone = new VerifyPassWordDialog(GestureVerifyActivity.this, new VerifyPassWordDialog.OnVerifyPW() {
//						@Override
//						public void onConfirm(String input) {
////							requestAskData(input,"splash");
//						}
//
//						@Override
//						public void onCancel() {
//
//						}
//					},"请输入登录密码");
//					dialog_phone.show();


                BasicDialog dialog_1 = new BasicDialog(GestureVerifyActivity.this, new BasicDialog.OnBasicChanged() {
                    @Override
                    public void onConfim() {
                        GestureVerifyActivity.this.finish();
//							delete(position,list.get(position).getId());
                        Intent i_login = new Intent(GestureVerifyActivity.this, LoginActivity.class);
                        i_login.putExtra("GOTOMAIN", LoginActivity.GOTOMAIN);
                        startActivity(i_login);
                    }

                    @Override
                    public void onCancel() {
                    }
                }, "忘记手势密码需要重新登录", "确认");
                dialog_1.show();


//				CheckVersionDialog dialog = new CheckVersionDialog(GestureVerifyActivity.this,
//						new CheckVersionDialog.OnCheckVersion() {
//
//							@Override
//							public void onConfim() {
//								UserLoadout out = new UserLoadout(GestureVerifyActivity.this,userId);
//								out.requestAskData();
//							}
//
//							@Override
//							public void onCancel() {
//
//							}
//						},"忘记手势密码，需要重新登录并设置手势密码","false");
//				dialog.show();

                break;
            case R.id.text_other_account: // 用其他帐号登录
                Intent i_login = new Intent(this, LoginActivity.class);
                i_login.putExtra("not_finish", "not_finish");//判断从手势登录页进登录，不finish
                startActivity(i_login);
                break;
            default:
                break;
        }
    }
	/*private void requestAskData(String password, final String from) {

		try {
			HtmlRequest.getVerifyPassWord(GestureVerifyActivity.this, userId, password,token,
					new BaseRequester.OnRequestListener() {

						@Override
						public void onRequestFinished(BaseParams params) {
							if (params.result != null) {
								ResultOkContentBean bean = (ResultOkContentBean) params.result;
								if (bean.getFlag().equals("true")) {
									PreferenceUtil.setGesturePwd("");
									PreferenceUtil.setGestureChose(false);
									if (from.equals("splash")) {
										Intent i = new Intent(GestureVerifyActivity.this,
												GestureEditActivity.class);
										i.putExtra("comeflag", 4);
										i.putExtra("back_from_splah","back_from_splah");
										i.putExtra("skip","skip_from_account");
										i.putExtra("title", R.string.setup_gesture_code);
										startActivity(i);
										finish();
									} else if(from.equals("change_gesture")){
										Intent i = new Intent(GestureVerifyActivity.this,
												GestureEditActivity.class);
										i.putExtra("comeflag", 4);
										i.putExtra("skip","skip_from_account");
										i.putExtra("title", R.string.setup_gesture_code);
										startActivity(i);
										finish();
									}
								} else {
									Toast.makeText(GestureVerifyActivity.this,
											bean.getMsg(), Toast.LENGTH_SHORT)
											.show();
								}
							}
						}
					});
		} catch (Exception e) {
			e.printStackTrace();
		}
	}*/

	/*public void dialog() {
		AlertDialog.Builder builder = new Builder(GestureVerifyActivity.this);
		builder.setMessage("忘记手势密码，需要重新登录并设置手势密码");
		builder.setTitle("提示");
		builder.setPositiveButton("确认", new DialogInterface.OnClickListener() {

			@Override
			public void onClick(DialogInterface dialog, int which) {
				dialog.dismiss();
				if(from.equals(ApplicationConsts.ACTIVITY_SPLASH)||from.equals(ApplicationConsts.ACTIVITY_GESEDIT)){
					Intent intent=new Intent(GestureVerifyActivity.this,LoginActivity.class);
					intent.putExtra("tomain", TOMAIN);
					PreferenceUtil.setFirstLogin(true);
					PreferenceUtil.setGesturePwd("");
					PreferenceUtil.setLogin(false);
					startActivity(intent);
					finish();
				}else{

				}
			}
		});

		builder.setNegativeButton("取消", new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				dialog.dismiss();
			}
		});
		builder.create().show();
	}*/

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == 99) {
            if (resultCode == RESULT_OK) {
                Intent i = new Intent();
                i.setClass(GestureVerifyActivity.this, MainActivity.class);
                startActivity(i);
                finish();
            }
        } else if (requestCode == 88) {
            if (resultCode == RESULT_OK) {
                finish();
            }
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    private Login2B bean;

    @Override
    public void update(Observable observable, Object data) {
        bean = (Login2B) data;
        if (bean != null) {
            if (Boolean.parseBoolean(bean.getFlag())) {
                if (from.equals(Urls.ACTIVITY_SPLASH)) {
                    finish();
                }
            }
        }
    }

}
