package com.rulaibao.photo_preview;

import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.rulaibao.base.BaseActivity;
import com.rulaibao.R;
import com.rulaibao.widget.TitleBar;

import java.util.ArrayList;

/**
 * 图片预览页面
 * 注意，SHOW_SELECT_BTN属性为true时或底部操作栏显示时，KEY_SELECTED 值不能为null
 */

public class PhotoPreviewAc extends BaseActivity implements View.OnClickListener {
    private ViewPager mViewPager;
    private ImageView iv_close;
    private TextView tv_num;

    private ArrayList<String> urls = new ArrayList<>();
    private PreviewAdapter previewAdapter;
    private int currentPos;

    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_photo_preview);
        initTopTitle();
        initUI();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.showLeftImg(true);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
             .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.title_house_detail))
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

    private void initUI() {
        iv_close = (ImageView) findViewById(R.id.iv_close);
        mViewPager = (ViewPager) findViewById(R.id.vp);
        tv_num = (TextView) findViewById(R.id.tv_num);

        iv_close.setOnClickListener(this);

        urls = getIntent().getStringArrayListExtra("urls");
        currentPos = getIntent().getIntExtra("currentPos", -1);

        //设置适配器
        previewAdapter = new PreviewAdapter(urls);
        mViewPager.setAdapter(previewAdapter);
        mViewPager.addOnPageChangeListener(pageChangeListener);
        if (currentPos != -1) {
            mViewPager.setCurrentItem(currentPos);
        }

        if (currentPos != -1) {
            updateNum(currentPos);
        }
    }

    private ViewPager.OnPageChangeListener pageChangeListener = new ViewPager.OnPageChangeListener() {
        @Override
        public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
        }

        @Override
        public void onPageSelected(int position) {
            updateNum(position);
        }

        @Override
        public void onPageScrollStateChanged(int state) {
        }
    };

    private void updateNum(int currentPos) {
        if (currentPos != -1) {
            tv_num.setText(currentPos + 1 + "/" + urls.size());
            iv_close.setVisibility(View.VISIBLE);
        } else {
            iv_close.setVisibility(View.INVISIBLE);
        }
    }

    @Override
    protected void onDestroy() {
        mViewPager.removeOnPageChangeListener(pageChangeListener);
        super.onDestroy();
    }


    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.iv_close:
                finish();
                break;
        }
    }

}
