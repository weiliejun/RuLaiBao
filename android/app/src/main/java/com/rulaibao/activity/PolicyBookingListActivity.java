package com.rulaibao.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.adapter.PolicyBookingVpAdapter;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.PolicyBookingList1B;
import com.rulaibao.bean.PolicyRecordList1B;
import com.rulaibao.fragment.PolicyBookingFragment;
import com.rulaibao.fragment.PolicyRecordListFragment;
import com.rulaibao.widget.TitleBar;

/**
 * (我的预约)预约列表
 * Created by junde on 2018/4/19.
 */

public class PolicyBookingListActivity extends BaseActivity {
    public static int REQUEST_CODE = 100;
    private TabLayout tab_layout;
    private ViewPager vp;
    private String[] titles;
    private PolicyBookingVpAdapter vpAdapter;
    private int currentTabPosition = 0;  // 默认进来加载“全部”的数据

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_policy_booking_list);

        initTopTitle();
        initView();
        initData();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.title_policy_booking_list))
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
        tab_layout = (TabLayout) findViewById(R.id.tab_layout);
        vp = (ViewPager) findViewById(R.id.vp);
    }

    public void initData() {
        titles = new String[]{"全部（）", "待确认（）", "已确认（）", "已驳回（）", "已取消（）"};

        vpAdapter = new PolicyBookingVpAdapter(getSupportFragmentManager(), titles, this);
        ((PolicyBookingFragment) vpAdapter.getItem(currentTabPosition)).getTabTitleCurrentPosition(currentTabPosition);
        ((PolicyBookingFragment) vpAdapter.getItem(currentTabPosition)).setUserId(userId);
        vp.setAdapter(vpAdapter);

        //将TabLayout和ViewPager关联起来
        tab_layout.setupWithViewPager(vp);

        initTitleStyle();

        vp.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
            }

            @Override
            public void onPageSelected(int position) {
            }

            @Override
            public void onPageScrollStateChanged(int state) {
            }
        });

        tab_layout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
//                Log.i("hh", this + "-- onTabSelected --" +tab.getPosition());
                currentTabPosition = tab.getPosition();

                ((PolicyBookingFragment) vpAdapter.getItem(currentTabPosition)).setUserId(userId);
                ((PolicyBookingFragment) vpAdapter.getItem(currentTabPosition)).getTabTitleCurrentPosition(currentTabPosition);

                //选中的view
                View view = tab.getCustomView();
                TextView tv_title = (TextView) view.findViewById(R.id.tv_title);
                tv_title.setTextColor(getResources().getColor(R.color.txt_black1));
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {
                //释放的view
                View view = tab.getCustomView();
                TextView tv_title = (TextView) view.findViewById(R.id.tv_title);
                tv_title.setTextColor(getResources().getColor(R.color.txt_black2));
            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {
            }
        });
    }

    /**
     * 初始化顶部的TabTitle
     */
    private void initTitleStyle() {
        refreshTitleStyle();

        //设置1tab选中
        tab_layout.getTabAt(currentTabPosition).select();
//        viewpager.setCurrentItem(currentTabPosition);
    }

    private void refreshTitleStyle() {
        for (int i = 0; i < tab_layout.getTabCount(); i++) {
            TabLayout.Tab tab = tab_layout.getTabAt(i);
            if (tab != null) {
                View view = getTabView(i);
                tab.setCustomView(view);
//                Log.i("aaa", "refreshTitleStyle: " + tab);
            }
        }
    }

    public View getTabView(int position) {
        View titleView = LayoutInflater.from(this).inflate(R.layout.title_item, null);
        TextView title = (TextView) titleView.findViewById(R.id.tv_title);
        title.setText(titles[position]);
        if (position == currentTabPosition) {
            title.setTextColor(this.getResources().getColor(R.color.txt_black1));
        } else {
            title.setTextColor(this.getResources().getColor(R.color.txt_black2));
        }
//        TextView num = (TextView) titleView.findViewById(R.id.tv_num);
//        num.setVisibility(View.VISIBLE);
//        num.setText("1");
        return titleView;
    }

    /**
     * 更新顶部 tab 各个状态的数据
     * @param data
     */
    public void refreshTabTitle(PolicyBookingList1B data) {
        View titleView1 = (View) tab_layout.getTabAt(0).getCustomView();
        TextView title1 = (TextView) titleView1.findViewById(R.id.tv_title);
        title1.setText("全部（" + data.getTotalCount() + "）");

        View titleView2 = (View) tab_layout.getTabAt(1).getCustomView();
        TextView title2 = (TextView) titleView2.findViewById(R.id.tv_title);
        title2.setText("待确认（" + data.getConfirmingCount() + "）");

        View titleView3 = (View) tab_layout.getTabAt(2).getCustomView();
        TextView title3 = (TextView) titleView3.findViewById(R.id.tv_title);
        title3.setText("已确认（" + data.getConfirmedCount() + "）");

        View titleView4 = (View) tab_layout.getTabAt(3).getCustomView();
        TextView title4 = (TextView) titleView4.findViewById(R.id.tv_title);
        title4.setText("已驳回（" + data.getRefuseCount() + "）");

        View titleView5 = (View) tab_layout.getTabAt(4).getCustomView();
        TextView title5 = (TextView) titleView5.findViewById(R.id.tv_title);
        title5.setText("已取消（" + data.getCanceledCount() + "）");

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_CODE) {
            Intent intent = new Intent();
            intent.putExtra("position", currentTabPosition);
            ((PolicyBookingFragment) vpAdapter.getItem(currentTabPosition)).onActivityResult(PolicyBookingFragment.REQUEST_CODE, resultCode, intent);
        }
        super.onActivityResult(requestCode, resultCode, data);
    }
}
