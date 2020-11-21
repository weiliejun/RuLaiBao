package com.rulaibao.activity;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.view.ViewPager;

import com.rulaibao.R;
import com.rulaibao.adapter.MyPartakeVpAdapter;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.fragment.MyPartakeAskFragment;
import com.rulaibao.fragment.MyPartakeTopicFragment;
import com.rulaibao.widget.TitleBar;

/**
 *  我参与的
 * Created by junde on 2018/4/23.
 */

public class MyPartakeActivity extends BaseActivity {

    private TabLayout sliding_tabs;
    private ViewPager viewpager;
    private String[] titles;
    private MyPartakeVpAdapter myPartakeVpAdapter;
    private int currentTabPosition = 0; // 0:提问   1:话题

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_my_partake);

        initTopTitle();
        initView();
        initData();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.title_my_partake))
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

    private void initView() {
        sliding_tabs = (TabLayout) findViewById(R.id.sliding_tabs);
        viewpager = (ViewPager) findViewById(R.id.viewpager);
    }

    public void initData() {
        titles = new String[]{"提问", "话题"};
        myPartakeVpAdapter = new MyPartakeVpAdapter(getSupportFragmentManager(), titles, this);
        ((MyPartakeAskFragment) myPartakeVpAdapter.getItem(0)).setUserId(userId);
        ((MyPartakeTopicFragment) myPartakeVpAdapter.getItem(1)).setUserId(userId);
        viewpager.setAdapter(myPartakeVpAdapter);

        //将TabLayout和ViewPager关联起来
        sliding_tabs.setupWithViewPager(viewpager);

        viewpager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
            }

            @Override
            public void onPageSelected(int position) {
                if (position == 0) {
                    ((MyPartakeAskFragment) myPartakeVpAdapter.getItem(position)).setUserId(userId);
                    MyPartakeAskFragment myPartakeAskFragment = (MyPartakeAskFragment) myPartakeVpAdapter.getItem(position);
                    myPartakeAskFragment.getCurrentTab(position);
                } else if (position==1){
                    ((MyPartakeTopicFragment) myPartakeVpAdapter.getItem(position)).setUserId(userId);
                    MyPartakeTopicFragment myPartakeTopicFragment = (MyPartakeTopicFragment) myPartakeVpAdapter.getItem(position);
                    myPartakeTopicFragment.getCurrentTab(position);
                }
            }

            @Override
            public void onPageScrollStateChanged(int state) {
            }
        });
    }

}
