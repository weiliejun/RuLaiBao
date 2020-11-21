package com.rulaibao.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewSwitcher;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.Collection2B;
import com.rulaibao.bean.InsuranceDetail1B;
import com.rulaibao.common.Urls;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.uitls.ImageLoaderManager;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.StringUtil;
import com.rulaibao.uitls.encrypt.DESUtil;
import com.rulaibao.widget.CircularImage;
import com.rulaibao.widget.TitleBar;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.util.LinkedHashMap;


/**
 * 保险产品详情
 */
public class InsuranceProductDetailBeiFenActivity extends BaseActivity implements View.OnClickListener {
    private TitleBar titleBar;

    private CircularImage iv_product_logo;//产品logo
    private DisplayImageOptions displayImageOptions = ImageLoaderManager.initDisplayImageOptions
            (R.mipmap.iv_product_default, R.mipmap.iv_product_default, R.mipmap.iv_product_default);
    private ImageView iv_collect;//收藏
    private TextView tv_product_name;//产品名称

    private TextView tv_age;//年龄
    private TextView tv_insurance_profession;//承保职业
    private TextView tv_gurantee_limit;//保障期限
    private TextView tv_purchase_limit;//限购份数
    private TextView tv_recommendations;//推荐说明

    private boolean isShowGuarantee;//不显示保障责任
    private boolean isShowInsureNotice;//不显示投保须知
    private boolean isShowClauseData;//不显示条款资料
    private boolean isShowClaimsProcess;//不显示理赔流程
    private boolean isShowFAQ;//不显示常见问题

    private RelativeLayout rl_guarantee;//保障责任
    private RelativeLayout rl_insure_notice;//投保须知
    private RelativeLayout rl_clause_data;//条款资料
    private RelativeLayout rl_claims_process;//理赔流程
    private RelativeLayout rl_faq;//常见问题

    //  保障责任、投保须知、条款资料、理赔流程、常见问题  后面的箭头图标
    private ImageView iv_guarantee_arrow;
    private ImageView iv_insure_notice_arrow;
    private ImageView iv_clause_data_arrow;
    private ImageView iv_claims_process_arrow;
    private ImageView iv_faq_arrow;

    private LinearLayout ll_guarantee;//保障责任
    private LinearLayout ll_insure_notice;//投保须知
    private LinearLayout ll_clause_data;//条款资料
    private LinearLayout ll_claims_process;//理赔流程
    private LinearLayout ll_faq;//常见问题

    private WebView webview_guarantee;//保障责任
    private WebView webview_insure_notice;//投保须知
    private WebView webview_clause_data;//条款资料
    private WebView webview_claims_process;//理赔流程
    private WebView webview_faq;//常见问题

    private RelativeLayout rl_appointment;
    private Button btn_appointment;//预约
    private TextView tv_appointment_minimumPremium;
    private TextView tv_appointment_promotionmoney;

    private RelativeLayout rl_appointmented;
    private Button btn_planbook;//计划书
    private Button btn_buy;//购买
    private TextView tv_appointmented_minimumPremium;
    private TextView tv_appointmented_promotionmoney;

    private InsuranceDetail1B result;
    private String id;
    private String collectionStatus;
    private Intent intent;

    private String collectionId;
    private ViewSwitcher vs;
    private TextView tv_empty;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_insurance_detail);
        initTopTitle();
        initView();
        initData();
    }

    private void initTopTitle() {
        titleBar = (TitleBar) findViewById(R.id.rl_title);
        titleBar.showLeftImg(true);
        titleBar.setFromActivity("1000");
        titleBar.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false).setIndicator(R.mipmap.icon_back)
                .setCenterText(getResources().getString(R.string.title_insurance_product_detail)).showMore(false).setTitleRightButton(R.drawable.ic_share_title)
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
        iv_product_logo = (CircularImage) findViewById(R.id.iv_product_logo);
        iv_collect = (ImageView) findViewById(R.id.iv_collect);
        tv_product_name = (TextView) findViewById(R.id.tv_product_name);

        tv_age = (TextView) findViewById(R.id.tv_age);
        tv_insurance_profession = (TextView) findViewById(R.id.tv_insurance_profession);
        tv_gurantee_limit = (TextView) findViewById(R.id.tv_gurantee_limit);
        tv_purchase_limit = (TextView) findViewById(R.id.tv_purchase_limit);
        tv_recommendations = (TextView) findViewById(R.id.tv_recommendations);

        rl_guarantee = (RelativeLayout) findViewById(R.id.rl_guarantee);
        rl_insure_notice = (RelativeLayout) findViewById(R.id.rl_insure_notice);
        rl_clause_data = (RelativeLayout) findViewById(R.id.rl_clause_data);
        rl_claims_process = (RelativeLayout) findViewById(R.id.rl_claims_process);
        rl_faq = (RelativeLayout) findViewById(R.id.rl_faq);

        iv_guarantee_arrow = (ImageView) findViewById(R.id.iv_guarantee_arrow);
        iv_insure_notice_arrow = (ImageView) findViewById(R.id.iv_insure_notice_arrow);
        iv_clause_data_arrow = (ImageView) findViewById(R.id.iv_clause_data_arrow);
        iv_claims_process_arrow = (ImageView) findViewById(R.id.iv_claims_process_arrow);
        iv_faq_arrow = (ImageView) findViewById(R.id.iv_faq_arrow);

        ll_guarantee = (LinearLayout) findViewById(R.id.ll_guarantee);
        ll_insure_notice = (LinearLayout) findViewById(R.id.ll_insure_notice);
        ll_clause_data = (LinearLayout) findViewById(R.id.ll_clause_data);
        ll_claims_process = (LinearLayout) findViewById(R.id.ll_claims_process);
        ll_faq = (LinearLayout) findViewById(R.id.ll_faq);

        webview_guarantee = (WebView) findViewById(R.id.webview_guarantee);
        webview_insure_notice = (WebView) findViewById(R.id.webview_insure_notice);
        webview_clause_data = (WebView) findViewById(R.id.webview_clause_data);
        webview_claims_process = (WebView) findViewById(R.id.webview_claims_process);
        webview_faq = (WebView) findViewById(R.id.webview_faq);

        rl_appointment = (RelativeLayout) findViewById(R.id.rl_long_insurance_appointment);
        btn_appointment = (Button) findViewById(R.id.btn_appointment);
        tv_appointment_minimumPremium = (TextView) findViewById(R.id.tv_appointment_minimumPremium);
        tv_appointment_promotionmoney = (TextView) findViewById(R.id.tv_appointment_promotionmoney);

        rl_appointmented = (RelativeLayout) findViewById(R.id.rl_short_insurance_buy);
        btn_planbook = (Button) findViewById(R.id.btn_plan_book);
        btn_buy = (Button) findViewById(R.id.btn_buy);
        tv_appointmented_minimumPremium = (TextView) findViewById(R.id.tv_buy_minimumPremium);
        tv_appointmented_promotionmoney = (TextView) findViewById(R.id.tv_buy_promotion_money);

        vs = (ViewSwitcher) findViewById(R.id.vs);
        tv_empty = (TextView) findViewById(R.id.tv_empty);
    }

    public void initData() {
        id = getIntent().getStringExtra("id");
        iv_collect.setOnClickListener(this);
        rl_guarantee.setOnClickListener(this);
        rl_insure_notice.setOnClickListener(this);
        rl_clause_data.setOnClickListener(this);
        rl_claims_process.setOnClickListener(this);
        rl_faq.setOnClickListener(this);
        btn_appointment.setOnClickListener(this);
        btn_planbook.setOnClickListener(this);
        btn_buy.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_collect://收藏
                iv_collect.setClickable(false);
                collection();
                break;
            case R.id.rl_guarantee: // 保障责任
                if (!isShowGuarantee) {
                    ll_guarantee.setVisibility(View.VISIBLE);
                    if (!TextUtils.isEmpty(result.getSecurityResponsibility())) {
                        setWebView(result.getSecurityResponsibility(), webview_guarantee);
                    }
                    iv_guarantee_arrow.setBackgroundResource(R.mipmap.ic_data_close);
                    isShowGuarantee = true;
                } else {
                    isShowGuarantee = false;
                    ll_guarantee.setVisibility(View.GONE);
                    iv_guarantee_arrow.setBackgroundResource(R.mipmap.ic_data_open);
                }
                break;
            case R.id.rl_insure_notice: // 投保须知
                if (!isShowInsureNotice) {
                    ll_insure_notice.setVisibility(View.VISIBLE);
                    if (!TextUtils.isEmpty(result.getCoverNotes())) {
                        setWebView(result.getCoverNotes(), webview_insure_notice);
                    }
                    iv_insure_notice_arrow.setBackgroundResource(R.mipmap.ic_data_close);
                    isShowInsureNotice = true;
                } else {
                    isShowInsureNotice = false;
                    ll_insure_notice.setVisibility(View.GONE);
                    iv_insure_notice_arrow.setBackgroundResource(R.mipmap.ic_data_open);
                }
                break;
            case R.id.rl_clause_data:// 条款资料
                if (!isShowClauseData) {
                    ll_clause_data.setVisibility(View.VISIBLE);
                    if (!TextUtils.isEmpty(result.getDataTerms())) {
                        setWebView(result.getDataTerms(), webview_clause_data);
                    }
                    iv_clause_data_arrow.setBackgroundResource(R.mipmap.ic_data_close);
                    isShowClauseData = true;
                } else {
                    isShowClauseData = false;
                    ll_clause_data.setVisibility(View.GONE);
                    iv_clause_data_arrow.setBackgroundResource(R.mipmap.ic_data_open);
                }
                break;
            case R.id.rl_claims_process: // 理赔流程
                if (!isShowClaimsProcess) {
                    ll_claims_process.setVisibility(View.VISIBLE);
                    if (!TextUtils.isEmpty(result.getClaimProcess())) {
                        setWebView(result.getClaimProcess(), webview_claims_process);
                    }
                    iv_claims_process_arrow.setBackgroundResource(R.mipmap.ic_data_close);
                    isShowClaimsProcess = true;
                } else {
                    isShowClaimsProcess = false;
                    ll_claims_process.setVisibility(View.GONE);
                    iv_claims_process_arrow.setBackgroundResource(R.mipmap.ic_data_open);
                }
                break;
            case R.id.rl_faq: // 常见问题
                if (!isShowFAQ) {
                    ll_faq.setVisibility(View.VISIBLE);
                    if (!TextUtils.isEmpty(result.getCommonProblem())) {
                        setWebView(result.getCommonProblem(), webview_faq);
                    }
                    iv_faq_arrow.setBackgroundResource(R.mipmap.ic_data_close);
                    isShowFAQ = true;
                } else {
                    isShowFAQ = false;
                    ll_faq.setVisibility(View.GONE);
                    iv_faq_arrow.setBackgroundResource(R.mipmap.ic_data_open);
                }
                break;

            /**
             *以下要判断是否登录，是否认证
             */
            case R.id.btn_appointment://预约
                if (!PreferenceUtil.isLogin()) {
                    intent = new Intent(this, LoginActivity.class);
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
            case R.id.btn_plan_book://计划书
                if (!PreferenceUtil.isLogin()) {
                    intent = new Intent(this, LoginActivity.class);
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
            case R.id.btn_buy://购买
                if (!PreferenceUtil.isLogin()) {
                    intent = new Intent(this, LoginActivity.class);
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
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        requestData();
    }

    /**
     * 保险详情
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

        HtmlRequest.getInsuranceDetails(InsuranceProductDetailBeiFenActivity.this, param, new BaseRequester.OnRequestListener() {

            @Override
            public void onRequestFinished(BaseParams params) {
                if (param == null || params.result == null) {
            //        Toast.makeText(InsuranceProductDetailActivity.this, "加载失败，请确认网络通畅",Toast.LENGTH_LONG).show();
                    return;
                }
                result = (InsuranceDetail1B) params.result;
                String productStatus=result.getProductStatus();
                if ("normal".equals(productStatus)){
                    vs.setDisplayedChild(0);
                    setData(result);
                    titleBar.setVisibilityState(View.VISIBLE);
                }else if ("delete".equals(productStatus)){
                    vs.setDisplayedChild(1);
                    tv_empty.setText("该产品已不存在");
                    titleBar.setVisibilityState(View.GONE);

                } else if ("down".equals(productStatus)){
                    vs.setDisplayedChild(1);
                    tv_empty.setText("该产品已下架");
                    titleBar.setVisibilityState(View.GONE);
                }
                String shareUrl= Urls.URL_SHARE_PRODUCT_DETAILS+id;
                // 设置分享参数
                titleBar.setActivityParameters(shareUrl,id, result.getName(), "推荐说明："+result.getRecommendations());
            }
        });
    }

    /**
     * 收藏
     */
    private void collection() {
        final LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("userId", userId);
        param.put("productId", id);
        param.put("dataStatus", collectionStatus);
        param.put("collectionId", collectionId);
        HtmlRequest.collection(InsuranceProductDetailBeiFenActivity.this, param, new BaseRequester.OnRequestListener() {

            @Override
            public void onRequestFinished(BaseParams params) {
                if (param == null || params.result == null) {
             //       Toast.makeText(InsuranceProductDetailActivity.this, "加载失败，请确认网络通畅",Toast.LENGTH_LONG).show();
                    return;
                }
                Collection2B collection2B = (Collection2B) params.result;
                iv_collect.setClickable(true);
                if ("true".equals(collection2B.getFlag())) {
                    Toast.makeText(InsuranceProductDetailBeiFenActivity.this, collection2B.getMessage(),
                            Toast.LENGTH_LONG).show();
                    //是否收藏
                    if ("valid".equals(collection2B.getDataStatus())) {//收藏
                        iv_collect.setImageResource(R.mipmap.ic_collected);
                        collectionStatus = "invalid";

                    } else if ("invalid".equals(collection2B.getDataStatus())) {//未收藏
                        iv_collect.setImageResource(R.mipmap.ic_collect);
                        collectionStatus = "valid";
                    }
                    collectionId=collection2B.getCollectionId();
                } else {
                    Toast.makeText(InsuranceProductDetailBeiFenActivity.this, collection2B.getMessage(),
                            Toast.LENGTH_LONG).show();

                }
            }
        });
    }

    private void setData(InsuranceDetail1B data) {
        collectionId=result.getCollectionId();
        String logo = data.getLogo();
        String collectionDataStatus = data.getCollectionDataStatus();
        String name = data.getName();
        String insuranceAge = data.getInsuranceAge();
        String insuranceOccupation = data.getInsuranceOccupation();
        String insurancePeriod = data.getInsurancePeriod();
        String purchaseNumber = data.getPurchaseNumber();
        String recommendations = data.getRecommendations();
        String appointmentStatus = data.getAppointmentStatus();
        String prospectusStatus = data.getProspectusStatus();
        String type = data.getType();

        // ImageLoader 加载图片
        if (!TextUtils.isEmpty(logo)) {
            ImageLoader.getInstance().displayImage(logo, iv_product_logo, displayImageOptions);
        }
        //是否收藏
        if ("valid".equals(collectionDataStatus)) {//收藏
            iv_collect.setImageResource(R.mipmap.ic_collected);
            collectionStatus = "invalid";
        } else if ("invalid".equals(collectionDataStatus)) {//未收藏
            iv_collect.setImageResource(R.mipmap.ic_collect);
            collectionStatus = "valid";
        }
        //产品名称
        if (!TextUtils.isEmpty(name)) {
            tv_product_name.setText(name);
        } else {
            tv_product_name.setText("--");
        }
        //年龄
        if (!TextUtils.isEmpty(insuranceAge)) {
            tv_age.setText(insuranceAge);
        } else {
            tv_age.setText("--");
        }
        //承保职业
        if (!TextUtils.isEmpty(insuranceOccupation)) {
            tv_insurance_profession.setText(insuranceOccupation);
        } else {
            tv_insurance_profession.setText("--");
        }
        //保障期限
        if (!TextUtils.isEmpty(insurancePeriod)) {
            tv_gurantee_limit.setText(insurancePeriod);
        } else {
            tv_gurantee_limit.setText("--");
        }
        //限购份数
        if (!TextUtils.isEmpty(purchaseNumber)) {
            tv_purchase_limit.setText(purchaseNumber);
        } else {
            tv_purchase_limit.setText("--");
        }
        //推荐说明
        if (!TextUtils.isEmpty(recommendations)) {
            tv_recommendations.setText(recommendations);
        } else {
            tv_recommendations.setText("--");
        }
        /**
         * 是否认证可见
         */
        //根据预约type longTermInsurance:长期险;shortTermInsurance:短期险 判断显示底部布局
        if (!TextUtils.isEmpty(type)) {
            if ("longTermInsurance".equals(type)) {//长期险---有预约
                rl_appointment.setVisibility(View.VISIBLE);
                rl_appointmented.setVisibility(View.GONE);
                if (TextUtils.isEmpty(data.getMinimumPremium())){
                    tv_appointment_minimumPremium.setText("--元起");
                }else{
                    tv_appointment_minimumPremium.setText(setTextStyle2(this,data.getMinimumPremium()));
                }

                if ("success".equals(data.getCheckStatus())) {

                    tv_appointment_promotionmoney.setText(setTextStyle1(this,data.getPromotionMoney()));
                } else {
                    tv_appointment_promotionmoney.setText(setTextStyle1(this,"认证可见"));
                }

            } else if ("shortTermInsurance".equals(type)) {//短期险---计划书购买

                rl_appointment.setVisibility(View.GONE);
                rl_appointmented.setVisibility(View.VISIBLE);
                if (TextUtils.isEmpty(data.getMinimumPremium())){
                    tv_appointmented_minimumPremium.setText("--元起");
                }else{
                    tv_appointmented_minimumPremium.setText(setTextStyle2(this,data.getMinimumPremium()));
                }
                if ("success".equals(data.getCheckStatus())) {
                    tv_appointmented_promotionmoney.setText(setTextStyle1(this,data.getPromotionMoney()));
                } else {
                    tv_appointmented_promotionmoney.setText(setTextStyle1(this,"认证可见"));
                }

            }
        }
        //是否预约
        if (!TextUtils.isEmpty(appointmentStatus)) {
            if ("true".equals(appointmentStatus)) {
                btn_appointment.setVisibility(View.GONE);

            } else if ("false".equals(appointmentStatus)) {
                btn_appointment.setVisibility(View.VISIBLE);
            }
        }
        //是否有计划书
        if (!TextUtils.isEmpty(prospectusStatus)) {
            if ("yes".equals(prospectusStatus)) {
                btn_planbook.setVisibility(View.VISIBLE);

            } else if ("no".equals(prospectusStatus)) {
                btn_planbook.setVisibility(View.GONE);
            }
        }

    }

    private void setWebView(String html, WebView webView) {
        webView.getSettings().setJavaScriptEnabled(true);
        //支持屏幕缩放
        webView.getSettings().setSupportZoom(true);
        webView.getSettings().setBuiltInZoomControls(true);
        webView.getSettings().setDisplayZoomControls(false);
        webView.setScrollBarStyle(View.SCROLLBARS_INSIDE_OVERLAY); //取消滚动条白边效果
        webView.setWebChromeClient(new WebChromeClient());
        webView.setWebViewClient(new WebViewClient());
        webView.getSettings().setDefaultTextEncodingName("UTF-8");
        webView.getSettings().setBlockNetworkImage(false);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            webView.getSettings().setMixedContentMode(webView.getSettings()
                    .MIXED_CONTENT_ALWAYS_ALLOW);  //注意安卓5.0以上的权限
        }
        webView.loadDataWithBaseURL(null, html, "text/html", "UTF-8", null);
    }

    private String getNewContent(String htmltext) {

        Document doc = Jsoup.parse(htmltext);
        Elements elements = doc.getElementsByTag("img");
        for (Element element : elements) {
            element.attr("width", "100%").attr("height", "auto");
        }

        Log.d("VACK", doc.toString());
        return doc.toString();
    }
    private static SpannableStringBuilder setTextStyle1(Context context, String str) {
        String str3;
        String str1= "推广费:";
        String str2=str1+str;
        if ("认证可见".equals(str)){
             str3=str2+"";
        }else{
             str3=str2+"%";
        }
        SpannableStringBuilder ssb= StringUtil.setTextStyle(context, str1, str2, str3,
                R.color.txt_black2, R.color.txt_black1, R.color.txt_black1,
                14, 16, 14, 0, 0, 0);
        return  ssb;
    }
    private static SpannableStringBuilder  setTextStyle2(Context context, String str) {
        String str1= str;
        String str2=str1+"元起";
        String str3=str2+"";
        SpannableStringBuilder ssb= StringUtil.setTextStyle(context, str1, str2, str3,
                R.color.txt_black1, R.color.txt_black2, R.color.txt_black2,
                16, 14, 14, 0, 0, 0);
        return  ssb;
    }

}