package com.rulaibao.fragment;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.rulaibao.R;
import com.rulaibao.activity.TrainingCircleDetailsActivity;
import com.rulaibao.activity.TrainingClassDetailsActivity;
import com.rulaibao.bean.ResultClassDetailsIntroductionBean;
import com.rulaibao.bean.ResultClassDetailsIntroductionItemBean;
import com.rulaibao.bean.ResultInfoBean;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.uitls.ImageLoaderManager;
import com.rulaibao.uitls.ViewUtils;
import com.rulaibao.widget.CircularImage;
import com.rulaibao.widget.ViewPagerForScrollView;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.util.LinkedHashMap;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * 课程详情 简介栏
 */

@SuppressLint("ValidFragment")
public class TrainingDetailsIntroductionFragment extends BaseFragment {

    private DisplayImageOptions displayImageOptions = ImageLoaderManager.initDisplayImageOptions(R.mipmap.ic_ask_photo_default, R.mipmap.ic_ask_photo_default, R.mipmap.ic_ask_photo_default);


    @BindView(R.id.iv_introduction)
    CircularImage ivIntroduction;
    @BindView(R.id.tv_introduction_manager)
    TextView tvIntroductionManager;
    @BindView(R.id.tv_introduction_manager_name)
    TextView tvIntroductionManagerName;
    @BindView(R.id.tv_introduction_class_name)
    TextView tvIntroductionClassName;
    @BindView(R.id.tv_introduction_class_time)
    TextView tvIntroductionClassTime;
    @BindView(R.id.tv_introduction_class_type)
    TextView tvIntroductionClassType;
    @BindView(R.id.tv_introduction_content)
    WebView tvIntroductionContent;

    private String id = "";
    private ResultClassDetailsIntroductionItemBean course;
    private Context context;
    private ViewPagerForScrollView vp;

    public TrainingDetailsIntroductionFragment() {
    }

    public TrainingDetailsIntroductionFragment(ViewPagerForScrollView vp) {
        this.vp = vp;
    }

    @Override
    protected View attachLayoutRes(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {


        if (mView == null) {
            mView = inflater.inflate(R.layout.fragment_training_details_introduction, container, false);
//            vp.setObjectForPosition(mView,0);
        } else {
            if (mView.getParent() != null) {
                ((ViewGroup) mView.getParent()).removeView(mView);
            }
        }
        return mView;
    }

    @Override
    protected void initViews() {

        context = getActivity();
        id = getArguments().getString("id");
        course = new ResultClassDetailsIntroductionItemBean();
        requestData();
//

    }


    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {

            if (context != null) {

            }

//            scrollView.smoothScrollTo(0, 0);
        } else {

        }

    }


    public void requestData() {

//        ArrayMap<String,Object> map = new ArrayMap<String,Object>();
        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();

        map.put("id", id);      //  课程id

        HtmlRequest.getClassDetailsDesc(context, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {

                if (params.result != null) {

                    ResultClassDetailsIntroductionBean bean = (ResultClassDetailsIntroductionBean) params.result;
                    if (bean.getFlag().equals("true")) {
                        course = bean.getCourse();
                        setView();
                    } else {
                        ViewUtils.showDeleteDialog(getActivity(), bean.getMessage());
                    }

                } else {

                }
            }
        });
    }

    public void setView() {

        ImageLoader.getInstance().displayImage(course.getHeadPhoto(), ivIntroduction, displayImageOptions);
        tvIntroductionManager.setText(course.getPosition());
        tvIntroductionManagerName.setText(course.getRealName());
        tvIntroductionClassName.setText(course.getCourseName());
        tvIntroductionClassTime.setText(course.getCourseTime());
        tvIntroductionClassType.setText(course.getTypeName());

        setWebView(course.getCourseContent(), tvIntroductionContent);
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // TODO: inflate a fragment view
        View rootView = super.onCreateView(inflater, container, savedInstanceState);
        ButterKnife.bind(this, rootView);
        return rootView;
    }

    @SuppressLint({"JavascriptInterface", "SetJavaScriptEnabled", "AddJavascriptInterface"})
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
        webView.addJavascriptInterface(new MyJavaScriptinterface(), "click");

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            webView.getSettings().setMixedContentMode(webView.getSettings()
                    .MIXED_CONTENT_ALWAYS_ALLOW);  //注意安卓5.0以上的权限
        }
        webView.loadDataWithBaseURL(null, html, "text/html", "UTF-8", null);
    }

    public class MyJavaScriptinterface {

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


}
