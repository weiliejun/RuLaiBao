package com.rulaibao.activity;

import android.os.Build;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.KeyEvent;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.rulaibao.R;

public class PlayerVideoActivity extends AppCompatActivity {
    static final String iframeStr = "<iframe height=498 width=510 src='http://player.youku.com/embed/XOTMyOTAwNDE2' frameborder=0 'allowfullscreen'></iframe>";
    static final String url1= "http://player.youku.com/embed/XMzQ3MDUwMzkyMA"; // 优酷地址
    static final String url2= "https://v.qq.com/iframe/player.html?vid=m1424gnxctl&tiny=0&auto=0"; // 腾讯地址
    static final String url3= "https://v.qq.com/iframe/player.html?vid=b0517fv9m0z&tiny=0&auto=0"; // 腾讯地址
    private  WebView videoWebView;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_player_video);
//
         videoWebView = (WebView) findViewById(R.id.webview_video);

        WebSettings ws = videoWebView.getSettings();
        ws.setBuiltInZoomControls(true);// 隐藏缩放按钮
        ws.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.NARROW_COLUMNS);// 排版适应屏幕
        ws.setUseWideViewPort(true);// 可任意比例缩放
        ws.setLoadWithOverviewMode(true);// setUseWideViewPort方法设置webview推荐使用的窗口。setLoadWithOverviewMode方法是设置webview加载的页面的模式。
        ws.setSavePassword(true);
        ws.setSaveFormData(true);// 保存表单数据
        ws.setJavaScriptEnabled(true);

        ws.setDomStorageEnabled(true);
        ws.setSupportMultipleWindows(true);// 新加

        /**
         * 解决Android 5.0以后，WebView默认不支持同时加载Https和Http混合模式，
         * 当一个安全的站点（https）去加载一个非安全的站点（http）时，需要配置Webview加载内容的混合模式
         */
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            videoWebView.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }

        videoWebView.setWebChromeClient(new WebChromeClient());
        videoWebView.setWebViewClient(new WebViewClient(){
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                return false;
            }
        });

        videoWebView.loadUrl(url2);
    }

    @Override
    protected void onResume() {
        super.onResume();
        //恢复播放
        videoWebView.resumeTimers();
    }

    @Override
    protected void onPause() {
        super.onPause();
        //暂停播放
        videoWebView.pauseTimers();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        //一定要销毁，否则无法停止播放
        videoWebView.destroy();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (event.getKeyCode() == KeyEvent.KEYCODE_BACK) {
            videoWebView.loadData("", "text/html; charset=UTF-8", null);
            this.finish();
            return true;
        } else {
            return super.onKeyDown(keyCode, event);
        }
    }

}
