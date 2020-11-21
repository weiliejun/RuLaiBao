package com.rulaibao.activity;

import android.annotation.SuppressLint;
import android.app.Application;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.PixelFormat;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.text.TextUtils;
import android.util.Log;
import android.util.TypedValue;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;

import com.rulaibao.R;
import com.rulaibao.adapter.TrainingClassDiscussAdapter;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.ResultClassDetailsIntroductionBean;
import com.rulaibao.bean.ResultClassDetailsIntroductionItemBean;
import com.rulaibao.common.Urls;
import com.rulaibao.fragment.TrainingDetailsCatalogFragment;
import com.rulaibao.fragment.TrainingDetailsDiscussFragment;
import com.rulaibao.fragment.TrainingDetailsIntroductionFragment;
import com.rulaibao.fragment.TrainingDetailsPPTFragment;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.test.X5WebView;
import com.rulaibao.uitls.InputMethodUtils;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.RlbActivityManager;
import com.rulaibao.uitls.SystemInfo;
import com.rulaibao.uitls.ViewUtils;
import com.rulaibao.widget.TitleBar;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

import static android.webkit.WebSettings.LayoutAlgorithm.NARROW_COLUMNS;

/**
 * 课程详情
 */


public class TrainingClassDetailsActivity extends BaseActivity implements TrainingClassDiscussAdapter.DiscussReply {

    @BindView(R.id.tl_class_details)
    TabLayout tlClassDetails;
//    @BindView(R.id.vp_class_details)
//    ViewPagerForScrollView vpClassDetails;

    @BindView(R.id.vp_class_details)
    ViewPager vpClassDetails;
    @BindView(R.id.fl_details_discuss)
    FrameLayout flDetailsDiscuss;
    @BindView(R.id.et_detail_discuss)
    EditText etDetailDiscuss;
    @BindView(R.id.btn_details_discuss)
    Button btnDetailsDiscuss;
    @BindView(R.id.x5_webview)
    X5WebView x5Webview;

    private TrainingDetailsIntroductionFragment introdutionFragment;            //  简介模块
    private TrainingDetailsCatalogFragment catalogFragment;            //  目录模块
    private TrainingDetailsDiscussFragment discussFragment;            //  研讨模块
    private TrainingDetailsPPTFragment pptFragment;            //  PPT模块


    private List<Fragment> fragments;
    private List<String> listTitles;
    private String id = "";
    private ResultClassDetailsIntroductionItemBean course;
    private String speechmakeId = "";       //  演讲人id
    private String courseId = "";       //  课程id


    private int index;
    private int oldPosition = 0;
    private int bottomOffset = 0;
    private String commentName = "";
    private int position;
    private String toUserId = "";
    private String commentId = "";
    private String linkId = "";
    private TitleBar title = null;

    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_training_class_details);
        getWindow().setFormat(PixelFormat.TRANSLUCENT);
        initTopTitle();
        initView();


    }

    public void initView() {
        id = getIntent().getStringExtra("id");
        speechmakeId = getIntent().getStringExtra("speechmakeId");
        courseId = getIntent().getStringExtra("courseId");
        requestData();

    }

    public void initTabView() {


        String shardId = "23232323";
        String url = Urls.URL_SHARED_CLASS + courseId;
        String content = "演讲人：" + course.getRealName() + "\n课程时间：" + course.getCourseTime() + "\n课程类型：" + course.getTypeName();
        title.setActivityParameters(url, shardId, course.getCourseName(), content);


        fragments = new ArrayList<>();
        listTitles = new ArrayList<>();

//        introdutionFragment = new TrainingDetailsIntroductionFragment(vpClassDetails);
        introdutionFragment = new TrainingDetailsIntroductionFragment();
        Bundle bundle = new Bundle();
        bundle.putString("id", id);
        bundle.putString("speechmakeId", speechmakeId);
        bundle.putSerializable("course", course);
        bundle.putSerializable("courseId", courseId);
        introdutionFragment.setArguments(bundle);
        fragments.add(introdutionFragment);

//        catalogFragment = new TrainingDetailsCatalogFragment(vpClassDetails);
        catalogFragment = new TrainingDetailsCatalogFragment();
        catalogFragment.setArguments(bundle);
        fragments.add(catalogFragment);

//        discussFragment = new TrainingDetailsDiscussFragment(vpClassDetails);
        discussFragment = new TrainingDetailsDiscussFragment(this);
        discussFragment.setArguments(bundle);
        fragments.add(discussFragment);

//        pptFragment = new TrainingDetailsPPTFragment(vpClassDetails);
        pptFragment = new TrainingDetailsPPTFragment();
        pptFragment.setArguments(bundle);
        fragments.add(pptFragment);

//        pptFragment = new TrainingDetailsPPT_2Fragment();
//        pptFragment.setArguments(bundle);
//        fragments.add(pptFragment);


        listTitles.add("简介");
        listTitles.add("目录");
        listTitles.add("研讨");
        listTitles.add("PPT");

        //mTabLayout.setTabMode(TabLayout.SCROLL_AXIS_HORIZONTAL);//设置tab模式，当前为系统默认模式
        for (int i = 0; i < listTitles.size(); i++) {
            tlClassDetails.addTab(tlClassDetails.newTab().setText(listTitles.get(i)));//添加tab选项
        }


        FragmentPagerAdapter mAdapter = new FragmentPagerAdapter(getSupportFragmentManager()) {
            @Override
            public Fragment getItem(int position) {
                return fragments.get(position);
            }

            @Override
            public int getCount() {
                return fragments.size();
            }

            //ViewPager与TabLayout绑定后，这里获取到PageTitle就是Tab的Text
            @Override
            public CharSequence getPageTitle(int position) {
                return listTitles.get(position);
            }
        };
        vpClassDetails.setAdapter(mAdapter);

        tlClassDetails.setupWithViewPager(vpClassDetails);//将TabLayout和ViewPager关联起来。
        tlClassDetails.setTabsFromPagerAdapter(mAdapter);//给Tabs设置适配器

        vpClassDetails.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

                if (position % 4 == 2) {
                    flDetailsDiscuss.setVisibility(View.VISIBLE);
                } else {
                    flDetailsDiscuss.setVisibility(View.GONE);
                }

            }

            @Override
            public void onPageSelected(int position) {
//                vpClassDetails.resetHeight(position);

            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
//        vpClassDetails.resetHeight(0);


    }


    public void requestData() {

//        ArrayMap<String,Object> map = new ArrayMap<String,Object>();
        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();

        map.put("id", id);      //  课程id

        HtmlRequest.getClassDetailsDesc(this, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {

                if (params.result != null) {

                    ResultClassDetailsIntroductionBean bean = (ResultClassDetailsIntroductionBean) params.result;

                    if (bean.getFlag().equals("true")) {
                        course = bean.getCourse();
                        initPlayView();
                        initTabView();
                    } else {
                        ViewUtils.showDeleteDialog(TrainingClassDetailsActivity.this, bean.getMessage());
                    }

                } else {

                }
            }
        });
    }


    @SuppressLint({"JavascriptInterface", "SetJavaScriptEnabled", "AddJavascriptInterface"})
    public void initPlayView() {


        com.tencent.smtt.sdk.WebSettings ws = x5Webview.getSettings();
        ws.setBuiltInZoomControls(true);// 隐藏缩放按钮
        ws.setLayoutAlgorithm(com.tencent.smtt.sdk.WebSettings.LayoutAlgorithm.NARROW_COLUMNS);// 排版适应屏幕
        ws.setUseWideViewPort(true);// 可任意比例缩放
        ws.setLoadWithOverviewMode(true);// setUseWideViewPort方法设置webview推荐使用的窗口。setLoadWithOverviewMode方法是设置webview加载的页面的模式。
        ws.setSavePassword(true);
        ws.setSaveFormData(true);// 保存表单数据
        ws.setJavaScriptEnabled(true);

        ws.setDomStorageEnabled(true);
        ws.setSupportMultipleWindows(true);// 新加

//        x5Webview.addJavascriptInterface(new MyJavaScriptinterface(), "click");

        /********************************************* 测试 ***********************************************/

        Bundle data = new Bundle();
        data.putBoolean("standardFullScreen", false);
        //true表示标准全屏，false表示X5全屏；不设置默认false，
        data.putBoolean("supportLiteWnd", true);
        //false：关闭小窗；true：开启小窗；不设置默认true，
        data.putInt("DefaultVideoScreen", 2);
        //1：以页面内开始播放，2：以全屏开始播放；不设置默认：1
        x5Webview.getX5WebViewExtension().invokeMiscMethod("setVideoParams", data);

        /********************************************* 测试 ************************************************/

        x5Webview.setWebChromeClient(new com.tencent.smtt.sdk.WebChromeClient());
//        x5Webview.setWebViewClient(new com.tencent.smtt.sdk.WebViewClient() {
//
//            @Override
//            public boolean shouldOverrideUrlLoading(com.tencent.smtt.sdk.WebView webView, String s) {
//
//                return true;
//            }
//        });


        /**
         * 解决Android 5.0以后，WebView默认不支持同时加载Https和Http混合模式，
         * 当一个安全的站点（https）去加载一个非安全的站点（http）时，需要配置Webview加载内容的混合模式
         */
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            x5Webview.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }

        if (!TextUtils.isEmpty(course.getCourseVideo())) {
//            wvTrainingClassDetails.loadUrl(course.getCourseVideo());
//            wvTrainingClassDetails.loadUrl(url1);
//            setWebView(url1,wvTrainingClassDetails);
//            wvTrainingClassDetails.addJavascriptInterface(new JsObject(TrainingClassDetailsActivity.this), "console");
            String url = Urls.URL_TRAINGCLASS+"?videoPath="+course.getCourseVideo();

            startPlay(url);

        }

    }

    /**
     * 使用自定义webview播放视频
     * @param vedioUrl 视频地址
     */
    private void startPlay(String vedioUrl) {
        x5Webview.loadUrl(vedioUrl);
//        setWebView(vedioUrl,x5Webview);
//        x5Webview.loadDataWithBaseURL(null, vedioUrl, "text/html", "UTF-8", null);
        getWindow().setFormat(PixelFormat.TRANSLUCENT);
        x5Webview.getView().setOverScrollMode(View.OVER_SCROLL_ALWAYS);
        x5Webview.setWebChromeClient(new com.tencent.smtt.sdk.WebChromeClient());
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        // TODO Auto-generated method stub
        try {
            super.onConfigurationChanged(newConfig);
            if (this.getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
                getWindow().addFlags(
                        WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);
            }
            else if (this.getResources().getConfiguration().orientation == Configuration.ORIENTATION_PORTRAIT) {
                getWindow().clearFlags(
                        WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 处理Javascript的对话框、网站图标、网站标题以及网页加载进度等
     *
     * @author
     */
    /*public class xWebChromeClient extends WebChromeClient {
        private Bitmap xdefaltvideo;
        private View xprogressvideo;

        @Override
        // 播放网络视频时全屏会被调用的方法
        public void onShowCustomView(View view, WebChromeClient.CustomViewCallback callback) {
            if(a!=null){
                a.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
            }
            if(webview!=null){
                webview.setVisibility(View.GONE);
            }
            // 如果一个视图已经存在，那么立刻终止并新建一个
            if (xCustomView != null&&callback!=null) {
                callback.onCustomViewHidden();
                return;
            }
            if (view != null&&videoview!=null) {
                videoview.addView(view);
                xCustomView = view;
            }
            if(xCustomViewCallback!=null){
                xCustomViewCallback = callback;
            }
            if(videoview!=null){
                videoview.setVisibility(View.VISIBLE);
            }
        }

        @SuppressLint("NewApi")
        @Override
        // 视频播放退出全屏会被调用的
        public void onHideCustomView() {
            if (xCustomView == null||videoview==null)// 不是全屏播放状态
                return;
            videoview.removeView(xCustomView);
            if(a!=null){
                a.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
            }
            xCustomView.setVisibility(View.GONE);
            xCustomView = null;
            videoview.setVisibility(View.GONE);
            if(xCustomViewCallback!=null){
                xCustomViewCallback.onCustomViewHidden();
            }
            if(webview!=null){
                webview.setVisibility(View.VISIBLE);
            }
            if(setting!=null){
                setting.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.NARROW_COLUMNS);// 排版适应屏幕
            }
        }

        // 视频加载添加默认图标
        @Override
        public Bitmap getDefaultVideoPoster() {
            if (xdefaltvideo == null) {
                xdefaltvideo = BitmapFactory.decodeResource(getResources(), R.mipmap.ic_launcher);
            }
            return xdefaltvideo;
        }
        // 视频加载时进程loading
        @SuppressLint("InflateParams")
        @Override
        public View getVideoLoadingProgressView() {
            if (xprogressvideo == null) {
                LayoutInflater inflater = LayoutInflater.from(a);
                xprogressvideo = inflater.inflate(R.layout.video_loading_progress, null);
            }
            return xprogressvideo;
        }

        // 网页标题
        @Override
        public void onReceivedTitle(WebView view, String title) {
            // a.setTitle(title)
            //view.getSettings().setBlockNetworkImage(false);
        }

        @Override
        // 当WebView进度改变时更新窗口进度
        public void onProgressChanged(WebView view, int newProgress) {
            a.getWindow().setFeatureInt(Window.FEATURE_PROGRESS, newProgress * 100);
        }
    }*/

    public class MyJavaScriptinterface {

    }

    private void initTopTitle() {
        title = (TitleBar) findViewById(R.id.rl_title);
        title.showLeftImg(true);
        title.setFromActivity("1000");
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.training_class_details)).showMore(false).setTitleRightButton(R.drawable.ic_share_title)
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
    protected void onResume() {
        super.onResume();
        //恢复播放
        x5Webview.resumeTimers();
    }

    @Override
    protected void onStart() {
        super.onStart();
        tlClassDetails.post(new Runnable() {
            @Override
            public void run() {
                setIndicator(tlClassDetails, 20, 20);
            }
        });
    }

    @Override
    protected void onPause() {
        super.onPause();
        //暂停播放
        x5Webview.pauseTimers();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        //一定要销毁，否则无法停止播放
        x5Webview.destroy();
    }


    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (event.getKeyCode() == KeyEvent.KEYCODE_BACK) {
//            x5Webview.loadData("", "text/html; charset=UTF-8", null);
            this.finish();
            return true;
        } else {
            return super.onKeyDown(keyCode, event);
        }
    }

    /**
     * 代码设置tablayout底部tabIndicator距左右的距离
     *
     * @param tabs
     * @param leftDip
     * @param rightDip
     */
    public void setIndicator(TabLayout tabs, int leftDip, int rightDip) {
        Class<?> tabLayout = tabs.getClass();
        Field tabStrip = null;
        try {
            tabStrip = tabLayout.getDeclaredField("mTabStrip");
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        }

        tabStrip.setAccessible(true);
        LinearLayout llTab = null;
        try {
            llTab = (LinearLayout) tabStrip.get(tabs);
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }

        int left = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, leftDip, Resources.getSystem().getDisplayMetrics());
        int right = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, rightDip, Resources.getSystem().getDisplayMetrics());

        for (int i = 0; i < llTab.getChildCount(); i++) {
            View child = llTab.getChildAt(i);
            child.setPadding(0, 0, 0, 0);
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.MATCH_PARENT, 1);
            params.leftMargin = left;
            params.rightMargin = right;
            child.setLayoutParams(params);
            child.invalidate();
        }


    }


    @OnClick({R.id.btn_details_discuss})
    public void onclick(View view) {

        switch (view.getId()) {

            /*case R.id.fl_training_class_details:

                String url = "<iframe scrolling=no height=100% width=100% src='" + course.getCourseVideo() + "' frameborder=0 'allowfullscreen=true'></iframe>";

                Uri uri = Uri.parse(course.getCourseVideo());
                Intent intent = new Intent(Intent.ACTION_VIEW, uri);
                startActivity(intent);

                break;*/
            case R.id.btn_details_discuss:
                String commentContent = etDetailDiscuss.getText().toString();

                if (!PreferenceUtil.isLogin()) {
                    HashMap<String, Object> map = new HashMap<>();

                    RlbActivityManager.toLoginActivity(this, map, false);

                } else {
                    if (!PreferenceUtil.getCheckStatus().equals("success")) {

                        ViewUtils.showToSaleCertificationDialog(this, "您还未认证，是否去认证");
                    } else {

                        discussFragment.toReply(commentContent, toUserId, commentId, commentName, index, linkId);
                        hiddenInputLayout();
                    }
                }
                break;
        }


    }

    @Override
    public void reply(String toUserId, String commentId, String commentName, int index, String linkId) {
        this.toUserId = toUserId;
        this.commentId = commentId;
        this.index = index;
        this.commentName = commentName;
        this.linkId = linkId;
        etDetailDiscuss.setHint("回复" + commentName + "：");

//        setBottomOffset(index);


    }

    @Override
    public void refresh() {
        commentId = "";
        hiddenInputLayout();
    }

    private void hiddenInputLayout() {
//        isShowComment.set(false);
        etDetailDiscuss.setText("");
        etDetailDiscuss.setHint(getString(R.string.training_class_details_discuss_comment_hint));
//        flAnswerDetails.setVisibility(View.GONE);
        InputMethodUtils.hiddenSoftKeyboard(this);
    }


}
