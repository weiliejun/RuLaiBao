package com.rulaibao.test;

import android.content.Context;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.tencent.smtt.sdk.WebChromeClient;

public class VideoPlayActivity extends BaseActivity {
    private String videoUrl;
    private X5WebView x5webView;

    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_video_play);
        getIntentData();
        initView();
        startPlay(videoUrl);
    }

    /**
     * 跳转至此页面
     *
     * @param context
     * @param videoUrl 视频地址
     */
    public static void actionStart(Context context, String videoUrl) {
        Intent intent = new Intent(context, VideoPlayActivity.class);
        intent.putExtra("videoUrl", videoUrl);
        context.startActivity(intent);
    }

    /**
     * 获取上个页面传过来的数据
     */
    private void getIntentData() {
        Intent intent = getIntent();
        videoUrl = intent.getStringExtra("videoUrl");
    }

    private void initView() {
        x5webView = (X5WebView) findViewById(R.id.x5_webview);
    }

    /**
     * 使用自定义webview播放视频
     * @param vedioUrl 视频地址
     */
    private void startPlay(String vedioUrl) {
        x5webView.loadUrl(vedioUrl);
        getWindow().setFormat(PixelFormat.TRANSLUCENT);
        x5webView.getView().setOverScrollMode(View.OVER_SCROLL_ALWAYS);
        x5webView.setWebChromeClient(new WebChromeClient());
    }
}
