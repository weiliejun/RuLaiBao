package com.rulaibao.activity;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.http.SslError;
import android.os.Bundle;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.webkit.JavascriptInterface;
import android.webkit.SslErrorHandler;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.adapter.PromotionMoneyListAdapter;
import com.rulaibao.bean.InsuranceDetail1B;
import com.rulaibao.bean.ResultPromotionMoneyItemBean;
import com.rulaibao.common.Urls;
import com.rulaibao.dialog.ShareSDKDialog;
import com.rulaibao.dialog.TAShareDialog;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.ShareUtil;
import com.rulaibao.uitls.StringUtil;
import com.rulaibao.uitls.encrypt.DESUtil;
import com.rulaibao.widget.MyListView;

import java.util.LinkedHashMap;

import pub.devrel.easypermissions.EasyPermissions;


/**
 * 保险产品详情
 */
public class InsuranceProductDetailActivity extends Activity implements View.OnClickListener {

    private TextView tv_web_title; // 标题
    private ImageView iv_back; // 返回按钮
    private ImageView iv_btn_share; // 分享按钮

    private RelativeLayout rl_long_insurance_appointment; // 计划书、预约布局
    private TextView btn_plan_book;//计划书
    private TextView btn_appointment;//预约
    private TextView btn_share_link_long_term_insurance; // 分享链接 按钮
    private TextView tv_appointment_minimumPremium; // 最低保费
    private TextView tv_appointment_promotionmoney; // 推广费

    private RelativeLayout rl_short_insurance_buy; //（底部）购买 布局
    private TextView btn_buy;//购买
    private TextView btn_share_link_short_term_insurance;
    private TextView tv_buy_minimumPremium; // 最低保费
    private TextView tv_buy_promotion_money; // 推广费
    private ImageView img_promotion_money;

    private WebView web_view;

    private InsuranceDetail1B result;
    private String id;
    private Intent intent;
    private String userId = null;
    public String title;
    private String url;
    private MyListView listView; // 多个推广费列表
    private PromotionMoneyListAdapter adapter;
    private MouldList<ResultPromotionMoneyItemBean> list;
    private FrameLayout fl_promotion_money;  // 显示多个推广费布局
    private ImageView img_close; // 多个推广费布局关闭按钮
    private boolean isOpen;//推广费是否打开
    private String shareLink; // 分享链接


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_insurance_detail);
        initView();
    }

    @SuppressLint({"JavascriptInterface", "SetJavaScriptEnabled", "AddJavascriptInterface"})
    private void initView() {
        id = getIntent().getStringExtra("id");
        String userId = null;
        try {
            userId = DESUtil.decrypt(PreferenceUtil.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (TextUtils.isEmpty(userId)) {
            userId = null;
        }
        url = Urls.URL_INSURANCE_DETAILS_NEW_HTML5 + "/" + id + "/" + userId;

        tv_web_title = (TextView) findViewById(R.id.tv_web_title);
        tv_web_title.setText("产品详情");
        iv_back = (ImageView) findViewById(R.id.iv_back);
        iv_btn_share = (ImageView) findViewById(R.id.iv_btn_share);
        rl_long_insurance_appointment = (RelativeLayout) findViewById(R.id.rl_long_insurance_appointment);
        btn_plan_book = (TextView) findViewById(R.id.btn_plan_book);
        btn_appointment = (TextView) findViewById(R.id.btn_appointment);
        btn_share_link_long_term_insurance = (TextView) findViewById(R.id.btn_share_link_long_term_insurance);
        tv_appointment_minimumPremium = (TextView) findViewById(R.id.tv_appointment_minimumPremium);
        tv_appointment_promotionmoney = (TextView) findViewById(R.id.tv_appointment_promotionmoney);

        rl_short_insurance_buy = (RelativeLayout) findViewById(R.id.rl_short_insurance_buy);
        btn_buy = (TextView) findViewById(R.id.btn_buy);
        btn_share_link_short_term_insurance = (TextView) findViewById(R.id.btn_share_link_short_term_insurance);
        tv_buy_minimumPremium = (TextView) findViewById(R.id.tv_buy_minimumPremium);
        tv_buy_promotion_money = (TextView) findViewById(R.id.tv_buy_promotion_money);
        img_promotion_money = (ImageView) findViewById(R.id.img_promotion_money);
        fl_promotion_money = (FrameLayout) findViewById(R.id.fl_promotion_money);
        img_close = (ImageView) findViewById(R.id.img_close);

        list = new MouldList<ResultPromotionMoneyItemBean>();
        listView = (MyListView) findViewById(R.id.lv_promotion_money);
        adapter = new PromotionMoneyListAdapter(this, list);
        listView.setAdapter(adapter);

        btn_plan_book.setOnClickListener(this);
        btn_appointment.setOnClickListener(this);
        btn_share_link_long_term_insurance.setOnClickListener(this);
        btn_share_link_short_term_insurance.setOnClickListener(this);
        img_promotion_money.setOnClickListener(this);
        btn_buy.setOnClickListener(this);
        iv_back.setOnClickListener(this);
        img_close.setOnClickListener(this);
        iv_btn_share.setOnClickListener(this);
        iv_btn_share.setClickable(false);

        web_view = (WebView) findViewById(R.id.web_view);
        web_view.getSettings().setSupportZoom(true);
        // 设置出现缩放工具
        web_view.getSettings().setBuiltInZoomControls(true);
        web_view.setWebViewClient(new WebViewClient() {
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
        web_view.getSettings().setLayoutAlgorithm(WebSettings.LayoutAlgorithm.NORMAL);
        web_view.getSettings().setUseWideViewPort(true);

        web_view.getSettings().setJavaScriptEnabled(true);
        web_view.getSettings().setTextZoom(100);
        web_view.addJavascriptInterface(new MyJavaScriptinterface(), "click");

        HtmlRequest.synCookies(this, url);

        web_view.loadUrl(url);
    }

    public class MyJavaScriptinterface {
        @JavascriptInterface
        public void result() {
            /*if (type.equals(WEBTYPE_WITHDRAW)) {
                setResult(RESULT_OK);
			} */
            InsuranceProductDetailActivity.this.finish();
        }

        @JavascriptInterface
        public void getToMyLogin() {//收藏未登录跳转
            Intent i_login = new Intent();
            i_login.setClass(InsuranceProductDetailActivity.this, LoginActivity.class);
            i_login.putExtra("GOTOMAIN", LoginActivity.GOTOMAIN);
            startActivity(i_login);
        }

        @JavascriptInterface
        public void getToMyPDF(String filePath) {//条款资料本地展示
            String[] perms = new String[]{Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE};
            //      filePath = result.getAttachmentPath();
            if (!TextUtils.isEmpty(filePath)) {
                if (!EasyPermissions.hasPermissions(InsuranceProductDetailActivity.this, perms)) {
                    EasyPermissions.requestPermissions((Activity) InsuranceProductDetailActivity.this, "需要访问手机存储权限！", 10086, perms);
                } else {
                    FileDisplayActivity.show(InsuranceProductDetailActivity.this, filePath);
                }

            }
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_btn_share: // 分享（产品详情）
                final String shareUrl = Urls.URL_SHARE_PRODUCT_DETAILS + id;
                // 设置分享参数
                ShareSDKDialog dialog = new ShareSDKDialog(InsuranceProductDetailActivity.this, new ShareSDKDialog.OnShare() {
                    @Override
                    public void onConfirm(int position) {
                        ShareUtil.sharedSDK(InsuranceProductDetailActivity.this, position, result.getName(), "推荐说明：" + result.getRecommendations(), shareUrl);
                    }

                    @Override
                    public void onCancel() {

                    }
                });
                dialog.show();
                break;
            case R.id.iv_back:
                finish();
                break;
            /**
             *以下要判断是否登录，是否认证
             */
            case R.id.btn_appointment:// 预约
                if (!PreferenceUtil.isLogin()) {
                    intent = new Intent(this, LoginActivity.class);
                    intent.putExtra("GOTOMAIN", LoginActivity.GOTOMAIN);
                    startActivity(intent);
                    return;
                }
                if (!"success".equals(result.getCheckStatus())) {
                    intent = new Intent(this, SalesCertificationActivity.class);
                    startActivity(intent);
                    return;
                }
                intent = new Intent(this, ProductAppointmentActivity.class);
                intent.putExtra("id", result.getId());
                intent.putExtra("companyName", result.getCompanyName());
                intent.putExtra("name", result.getName());
                intent.putExtra("category", result.getCategory());
                startActivity(intent);
                break;
            case R.id.btn_plan_book:// 计划书
                if (!PreferenceUtil.isLogin()) {
                    intent = new Intent(this, LoginActivity.class);
                    intent.putExtra("GOTOMAIN", LoginActivity.GOTOMAIN);
                    startActivity(intent);
                    return;
                }
                if (!"success".equals(result.getCheckStatus())) {
                    intent = new Intent(this, SalesCertificationActivity.class);
                    startActivity(intent);
                    return;
                }
                intent = new Intent(this, WebActivity.class);
                intent.putExtra("type", WebActivity.WEBTYPE_PLAN_BOOK);
                intent.putExtra("url", result.getProspectus());
                intent.putExtra("title", "计划书");
                startActivity(intent);
                break;
            case R.id.btn_buy:// 购买
                if (!PreferenceUtil.isLogin()) {
                    intent = new Intent(this, LoginActivity.class);
                    intent.putExtra("GOTOMAIN", LoginActivity.GOTOMAIN);
                    startActivity(intent);
                    return;
                }
                if (!"success".equals(result.getCheckStatus())) {
                    intent = new Intent(this, SalesCertificationActivity.class);
                    startActivity(intent);
                    return;
                }
                intent = new Intent(this, WebActivity.class);
                intent.putExtra("type", WebActivity.WEBTYPE_BUY);
                intent.putExtra("url", result.getProductLink());
                intent.putExtra("title", "购买");
                startActivity(intent);
                break;
            case R.id.btn_share_link_long_term_insurance: // (天安)分享链接

                // 设置分享参数
                TAShareDialog shareDialog = new TAShareDialog(InsuranceProductDetailActivity.this, new TAShareDialog.OnShare() {
                    @Override
                    public void onConfirm(int position) {
                        ShareUtil.sharedSDK(InsuranceProductDetailActivity.this, position, result.getName(), "推荐说明：" + result.getRecommendations(), shareLink);
                    }

                    @Override
                    public void onCancel() {
                    }
                });
                shareDialog.show();
                break;
            case R.id.btn_share_link_short_term_insurance: // (天安)分享链接

                // 设置分享参数
                TAShareDialog shareDialog1 = new TAShareDialog(InsuranceProductDetailActivity.this, new TAShareDialog.OnShare() {
                    @Override
                    public void onConfirm(int position) {
                        ShareUtil.sharedSDK(InsuranceProductDetailActivity.this, position, result.getName(), "推荐说明：" + result.getRecommendations(), shareLink);
                    }

                    @Override
                    public void onCancel() {
                    }
                });
                shareDialog1.show();
                break;
            case R.id.img_promotion_money:// 长期险--推广费
                if (!PreferenceUtil.isLogin()) {
                    intent = new Intent(this, LoginActivity.class);
                    intent.putExtra("GOTOMAIN", LoginActivity.GOTOMAIN);
                    startActivity(intent);
                    return;
                }
                if (isOpen) {
                    Animation animation = AnimationUtils.loadAnimation(this, R.anim.rotate_opposite);
                    img_promotion_money.startAnimation(animation);
                    fl_promotion_money.setVisibility(View.GONE);
                    isOpen = false;

                    //     img_promotion_money.setImageResource(R.mipmap.img_up);
                } else {
                    Animation animation = AnimationUtils.loadAnimation(this, R.anim.rotate);
                    img_promotion_money.startAnimation(animation);
                    fl_promotion_money.setVisibility(View.VISIBLE);
                    isOpen = true;

                    //  img_promotion_money.setImageResource(R.mipmap.img_down);
                }
                break;
            case R.id.img_close://关闭长期险--推广费
                Animation animation = AnimationUtils.loadAnimation(this, R.anim.rotate_opposite);
                img_promotion_money.startAnimation(animation);
                fl_promotion_money.setVisibility(View.GONE);
                isOpen = false;

                //  img_promotion_money.setImageResource(R.mipmap.img_up);
                break;
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        requestData();
    }

    /**
     * 保险详情(底部悬浮框接口)
     */
    private void requestData() {
        try {
            userId = DESUtil.decrypt(PreferenceUtil.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        final LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("userId", userId);
        param.put("id", id);

        HtmlRequest.getInsuranceDetailsNew(InsuranceProductDetailActivity.this, param, new BaseRequester.OnRequestListener() {

            @Override
            public void onRequestFinished(BaseParams params) {
                if (param == null || params.result == null) {
                    //        Toast.makeText(InsuranceProductDetailActivity.this, "加载失败，请确认网络通畅",Toast.LENGTH_LONG).show();
                    return;
                }
                result = (InsuranceDetail1B) params.result;
                String productStatus = result.getProductStatus();
                if ("normal".equals(productStatus)) { // 正常
                    setData(result);
                    iv_btn_share.setClickable(true);
                } else if ("delete".equals(productStatus)) { // 删除
                    iv_btn_share.setVisibility(View.GONE);
                    rl_long_insurance_appointment.setVisibility(View.GONE);
                    rl_short_insurance_buy.setVisibility(View.GONE);
                } else if ("down".equals(productStatus)) { // 下架
                    iv_btn_share.setVisibility(View.GONE);
                    rl_long_insurance_appointment.setVisibility(View.GONE);
                    rl_short_insurance_buy.setVisibility(View.GONE);
                }
            }
        });
    }

    private void setData(InsuranceDetail1B data) {
        list.clear();
        String appointmentStatus = data.getAppointmentStatus();
        String prospectusStatus = data.getProspectusStatus();
        String shareLinkStatus = data.getShareLinkStatus();
        shareLink = data.getShareLink();
        String type = data.getType();
        /**
         * 是否认证可见
         */
        //根据预约type 判断是长期险or短期险(longTermInsurance:长期险;   shortTermInsurance:短期险 )判断显示底部布局
        // 在长期险和短期险里需要再判断是否是天安产品，是的话则显示分享链接按钮，否的话则按照长、短期险原有逻辑显示
        if (!TextUtils.isEmpty(type)) {
            if ("longTermInsurance".equals(type)) {//长期险---有预约、计划书

                //长期险首先判断是否是天安产品(只有天安产品才显示分享链接按钮)
                if (!TextUtils.isEmpty(shareLinkStatus)) {
                    if ("yes".equals(shareLinkStatus)) { // 是天安产品：只显示分享链接按钮
                        rl_long_insurance_appointment.setVisibility(View.VISIBLE); // 计划书、预约布局
                        rl_short_insurance_buy.setVisibility(View.GONE); // （底部）购买 布局

                        btn_appointment.setVisibility(View.GONE); // 预约 按钮
                        btn_plan_book.setVisibility(View.GONE); // 计划书 按钮
                        btn_share_link_long_term_insurance.setVisibility(View.VISIBLE); // (天安)分享 按钮
                    } else if ("no".equals(shareLinkStatus)) { // 不是天安产品：要判断是否有计划书
                        //是否有计划书
                        if (!TextUtils.isEmpty(prospectusStatus)) {
                            if ("yes".equals(prospectusStatus)) {
                                btn_plan_book.setVisibility(View.VISIBLE);
                            } else if ("no".equals(prospectusStatus)) {
                                btn_plan_book.setVisibility(View.GONE);
                            }
                        }
                        rl_long_insurance_appointment.setVisibility(View.VISIBLE); // 计划书、预约布局
                        rl_short_insurance_buy.setVisibility(View.GONE); //（底部）购买 布局

                        btn_appointment.setVisibility(View.VISIBLE); // 预约 按钮
                        btn_share_link_long_term_insurance.setVisibility(View.GONE); // (天安)分享 按钮
                    }
                }
                if (TextUtils.isEmpty(data.getMinimumPremium())) {
                    tv_appointment_minimumPremium.setText("--元起");
                } else {
                    tv_appointment_minimumPremium.setText(setTextStyle2(this, data.getMinimumPremium()));
                }

                if ("success".equals(data.getCheckStatus())) {
                    tv_appointment_promotionmoney.setText(setTextStyle1(this, data.getPromotionMoney()));
                    img_promotion_money.setVisibility(View.VISIBLE);
                } else {
                    tv_appointment_promotionmoney.setText(setTextStyle1(this, "认证可见"));
                    img_promotion_money.setVisibility(View.GONE);
                }

                // 长期险才有多个推广费
                ResultPromotionMoneyItemBean bean1 = new ResultPromotionMoneyItemBean();
                bean1.setPromotionMoney("第一年推广费：" + data.getPromotionMoney() + "%");
                list.add(bean1);
                if (!TextUtils.isEmpty(data.getPromotionMoney2())) {
                    ResultPromotionMoneyItemBean bean2 = new ResultPromotionMoneyItemBean();
                    bean2.setPromotionMoney("第二年推广费：" + data.getPromotionMoney2() + "%");
                    list.add(bean2);
                }
                if (!TextUtils.isEmpty(data.getPromotionMoney3())) {
                    ResultPromotionMoneyItemBean bean3 = new ResultPromotionMoneyItemBean();
                    bean3.setPromotionMoney("第三年推广费：" + data.getPromotionMoney3() + "%");
                    list.add(bean3);
                }
                if (!TextUtils.isEmpty(data.getPromotionMoney4())) {
                    ResultPromotionMoneyItemBean bean4 = new ResultPromotionMoneyItemBean();
                    bean4.setPromotionMoney("第四年推广费：" + data.getPromotionMoney4() + "%");
                    list.add(bean4);
                }
                if (!TextUtils.isEmpty(data.getPromotionMoney5())) {
                    ResultPromotionMoneyItemBean bean5 = new ResultPromotionMoneyItemBean();
                    bean5.setPromotionMoney("第五年推广费：" + data.getPromotionMoney5() + "%");
                    list.add(bean5);
                }
                adapter.notifyDataSetChanged();
            } else if ("shortTermInsurance".equals(type)) {//短期险---购买

                //短期险首先判断是否是天安产品(只有天安产品才显示分享链接按钮)   shareLinkStatus:yes(表示是天安产品)，no(不是天安产品)
                if (!TextUtils.isEmpty(shareLinkStatus)) {
                    if ("yes".equals(shareLinkStatus)) { // 是天安产品：只显示分享链接按钮
                        rl_long_insurance_appointment.setVisibility(View.GONE); // 计划书、预约布局
                        rl_short_insurance_buy.setVisibility(View.VISIBLE); // （底部）购买 布局

                        btn_share_link_short_term_insurance.setVisibility(View.VISIBLE); // (天安)分享按钮
                        btn_buy.setVisibility(View.GONE); // 购买
                    } else if ("no".equals(shareLinkStatus)) { // 不是天安产品：只显示购买 按钮
                        rl_long_insurance_appointment.setVisibility(View.GONE); // 计划书、预约布局
                        rl_short_insurance_buy.setVisibility(View.VISIBLE); // （底部）购买 布局

                        btn_share_link_short_term_insurance.setVisibility(View.GONE);
                        btn_buy.setVisibility(View.VISIBLE);
                    }
                } else {
                    rl_long_insurance_appointment.setVisibility(View.GONE); // 计划书、预约布局
                    rl_short_insurance_buy.setVisibility(View.VISIBLE); // （底部）购买 布局

                    btn_share_link_short_term_insurance.setVisibility(View.GONE); // (天安)分享按钮
                    btn_buy.setVisibility(View.VISIBLE); // 购买
                }
//                rl_long_insurance_appointment.setVisibility(View.GONE);
//                rl_short_insurance_buy.setVisibility(View.VISIBLE);
                if (TextUtils.isEmpty(data.getMinimumPremium())) {
                    tv_buy_minimumPremium.setText("--元起");
                } else {
                    tv_buy_minimumPremium.setText(setTextStyle2(this, data.getMinimumPremium()));
                }
                if ("success".equals(data.getCheckStatus())) {
                    tv_buy_promotion_money.setText(setTextStyle1(this, data.getPromotionMoney()));
                } else {
                    tv_buy_promotion_money.setText(setTextStyle1(this, "认证可见"));
                }
            }
        }

    }

    private static SpannableStringBuilder setTextStyle1(Context context, String str) {
        String str3;
        String str1 = "推广费:";
        String str2 = str1 + str;
        if ("认证可见".equals(str)) {
            str3 = str2 + "";
        } else {
            str3 = str2 + "%";
        }
        SpannableStringBuilder ssb = StringUtil.setTextStyle(context, str1, str2, str3, R.color.txt_black2, R.color.txt_black1, R.color.txt_black1,
                14, 16, 14, 0, 0, 0);
        return ssb;
    }

    private static SpannableStringBuilder setTextStyle2(Context context, String str) {
        String str1 = str;
        String str2 = str1 + "元起";
        String str3 = str2 + "";
        SpannableStringBuilder ssb = StringUtil.setTextStyle(context, str1, str2, str3, R.color.txt_black1, R.color.txt_black2, R.color.txt_black2,
                16, 14, 14, 0, 0, 0);
        return ssb;
    }

    @Override
    protected void onPause() {
        super.onPause();
        web_view.reload();
    }
}