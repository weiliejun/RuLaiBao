package com.rulaibao.activity;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.graphics.Color;
import android.net.http.SslError;
import android.os.Build;
import android.os.Bundle;
import android.util.TypedValue;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.JavascriptInterface;
import android.webkit.SslErrorHandler;
import android.webkit.WebSettings.LayoutAlgorithm;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.TextView;

import com.lzy.imagepicker.view.SystemBarTintManager;
import com.rulaibao.R;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.uitls.ActivityStack;


public class WebActivity extends Activity implements View.OnClickListener {
    private WebView mWebview;
    private String type = null;
    private String url = null;
    public static final String WEBTYPE_BANNER = "banner";            //轮播图
    public static final String WEBTYPE_PLAN_BOOK = "plan_book";            //计划书
    public static final String WEBTYPE_BUY = "buy";            //购买链接
    public static final String WEB_TYPE_NOTICE = "notice_detail "; // 公告详情/其他消息详情
    public static final String WEBTYPE_SERVICE_AGREEMENT = "service_agreement "; // 服务协议
    public static final String WEB_TYPE_SIGN_AGREEMENT = "sign_agreement "; // 国恒保险协议
    public static final String WEB_TYPE_ABOUT_US = "about_us "; // 关于我们
    public static final String WEB_TYPE_SING = "signup_web"; // 注册协议
    public static final String WEBTYPE_VERSION = "version "; // 版本号
    public static final String WEBTYPE_PROJECT_MATERIAL_DETAIL = "project_material_detail "; //项目材料

    public String title;
    private TextView tv_web_title; // 标题
    private ImageView iv_back; // 返回按钮
    private ImageView iv_btn_share; // 分享按钮

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
       /* //设置状态栏为透明
        initSystemBarTint();
        //设置状态栏为字体黑色
        OSUtils.ROM_TYPE romType =  OSUtils.getRomType();
        if (romType== OSUtils.ROM_TYPE.MIUI){
            StatusBarUtil.statusBarDarkMode(this,MIUI);
        }else if (romType== OSUtils.ROM_TYPE.FLYME){
            StatusBarUtil.statusBarDarkMode(this,FLYME);
        }else if (romType== OSUtils.ROM_TYPE.ANDROID_M){
            StatusBarUtil.statusBarDarkMode(this,ANDROID_M);
        }*/
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_web);
        type = getIntent().getStringExtra("type");
        url = getIntent().getStringExtra("url");
        initView();
    }

    @SuppressLint({"JavascriptInterface", "SetJavaScriptEnabled", "AddJavascriptInterface"})
    private void initView() {

        ActivityStack stack = ActivityStack.getActivityManage();
        stack.addActivity(this);

        mWebview = (WebView) findViewById(R.id.web_view);
        tv_web_title = (TextView) findViewById(R.id.tv_web_title);
        iv_back = (ImageView) findViewById(R.id.iv_back);
        iv_btn_share = (ImageView) findViewById(R.id.iv_btn_share);

        iv_back.setOnClickListener(this);
        iv_btn_share.setOnClickListener(this);

        mWebview.getSettings().setSupportZoom(true);
        // 设置出现缩放工具
        mWebview.getSettings().setBuiltInZoomControls(true);
        mWebview.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                view.loadUrl(url);
                return true;
            }
            @Override
            public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
                handler.proceed();

                super.onReceivedSslError(view, handler, error);

            }
        });
        mWebview.getSettings().setLayoutAlgorithm(LayoutAlgorithm.NORMAL);
        mWebview.getSettings().setUseWideViewPort(true);
        mWebview.getSettings().setTextZoom(100);
        mWebview.getSettings().setJavaScriptEnabled(true);
        mWebview.getSettings().setDomStorageEnabled(true);
        mWebview.addJavascriptInterface(new MyJavaScriptinterface(), "click");

        if (type.equals(WEBTYPE_BANNER)) {// 轮播图
            tv_web_title.setText(getIntent().getExtras().getString("title"));
        }else if (type.equals(WEB_TYPE_NOTICE)) { // 公告详情
            tv_web_title.setText(getIntent().getExtras().getString("title"));
        } else if (type.equals(WEBTYPE_SERVICE_AGREEMENT)) {
            tv_web_title.setText(getIntent().getExtras().getString("title"));
        } else if (type.equals(WEB_TYPE_ABOUT_US)) { // 关于我们
            tv_web_title.setText(getIntent().getExtras().getString("title"));

        }else if (type.equals(WEB_TYPE_SING)) { // 注册协议
            tv_web_title.setText(getIntent().getExtras().getString("title"));

        } else if (type.equals(WEB_TYPE_SIGN_AGREEMENT)) { // 国恒保险协议
            tv_web_title.setText(getIntent().getExtras().getString("title"));
        } else if (type.equals(WEBTYPE_VERSION)) { // 版本号
            tv_web_title.setText(getIntent().getExtras().getString("title"));
        } else if (type.equals(WEBTYPE_PROJECT_MATERIAL_DETAIL)) {
            tv_web_title.setText(getIntent().getExtras().getString("title"));

        }else if (type.equals(WEBTYPE_PLAN_BOOK)) {//计划书
            tv_web_title.setText(getIntent().getExtras().getString("title"));

        }else if (type.equals(WEBTYPE_BUY)) {//购买链接
            tv_web_title.setText(getIntent().getExtras().getString("title"));

        }


        HtmlRequest.synCookies(this, url);

        mWebview.loadUrl(url);

    }

    public class MyJavaScriptinterface {
        @JavascriptInterface
        public void result() {
            /*if (type.equals(WEBTYPE_WITHDRAW)) {
                setResult(RESULT_OK);
			} */
            WebActivity.this.finish();
        }

        @JavascriptInterface
        public void login() {
//            if (type.equals(WEBTYPE_ADVERTIS_2)) {
//                Intent i_login = new Intent();
//                i_login.setClass(WebActivity.this, LoginActivity.class);
//                startActivity(i_login);
//            }
//            WebActivity.this.finish();
        }
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            this.finish();
            return true;
        } else {
            return super.onKeyDown(keyCode, event);
        }
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.iv_back:
                finish();
                break;
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        mWebview.reload();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        ActivityStack stack = ActivityStack.getActivityManage();
        stack.removeActivity(this);
    }

    /** 子类可以重写改变状态栏颜色 GApp*/
    protected int setStatusBarColor() {
        return getColorPrimary();
    }

    /** 子类可以重写决定是否使用透明状态栏 */
    protected boolean translucentStatusBar() {
        return false;
    }

    /** 设置状态栏颜色 */
    protected void initSystemBarTint() {
        Window window = getWindow();
        if (translucentStatusBar()) {
            // 设置状态栏全透明
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
                window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_STABLE);
                window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
                window.setStatusBarColor(Color.TRANSPARENT);
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            }
            return;
        }
        // 沉浸式状态栏
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            //5.0以上使用原生方法
            window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(setStatusBarColor());
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            //4.4-5.0使用三方工具类，有些4.4的手机有问题，这里为演示方便，不使用沉浸式
            //        getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            SystemBarTintManager tintManager = new SystemBarTintManager(this);
            tintManager.setStatusBarTintEnabled(true);
            tintManager.setStatusBarTintColor(setStatusBarColor());
        }
    }

    /** 获取主题色 */
    public int getColorPrimary() {
        TypedValue typedValue = new TypedValue();
        getTheme().resolveAttribute(R.attr.colorPrimary, typedValue, true);
        return typedValue.data;
    }
}
