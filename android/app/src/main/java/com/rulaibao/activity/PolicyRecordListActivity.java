package com.rulaibao.activity;

import android.app.LauncherActivity;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewSwitcher;

import com.rulaibao.R;
import com.rulaibao.adapter.PolicyRrcordListVPAdapter;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.PolicyRecordList1B;
import com.rulaibao.fragment.PolicyRecordListFragment;
import com.rulaibao.widget.TitleBar;

/**
 * 保单记录
 * Created by junde on 2018/4/13.
 */

public class PolicyRecordListActivity extends BaseActivity {

    private TabLayout sliding_tabs;
    private ViewPager viewpager;
    private String[] titles;
    private PolicyRrcordListVPAdapter vpAdapter;
    private ViewSwitcher vs;
    /**
     * currentTabPosition = 0 (全部)、currentTabPosition = 1 (待审核)、
     * currentTabPosition = 2 (已承保)、currentTabPosition = 3 (问题件)、
     * currentTabPosition = 4 (回执签收)
     */
    private int currentTabPosition = 0;
    private ImageView iv_back;
    private ImageView iv_add_insurance_policy; // (新增保单)图标


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_policy_record_list);

        initTopTitle();
        initView();
        initData();

    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setVisibility(View.GONE);
      /*  title.setTitle(getResources().getString(R.string.title_null))
                .setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back)
                .setCenterText(getResources().getString(R.string.title_policy_record))
                .showMore(false)
                .setTitleRightButton(R.mipmap.add_new_insurance_policy)
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
                });*/
    }

    private void initView() {
        currentTabPosition = getIntent().getIntExtra("position", 0);

        iv_back = (ImageView) findViewById(R.id.iv_back);
        iv_add_insurance_policy = (ImageView) findViewById(R.id.iv_add_insurance_policy);
        sliding_tabs = (TabLayout) findViewById(R.id.sliding_tabs);
        viewpager = (ViewPager) findViewById(R.id.viewpager);

        iv_back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        iv_add_insurance_policy.setOnClickListener(new View.OnClickListener() { // (跳转至)新增保单
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(PolicyRecordListActivity.this, AddNewInsurancePolicyActivity.class);
//                intent.putExtra("currentTabPosition",currentTabPosition);
                startActivityForResult(intent,100);
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 100) {
            int position = data.getIntExtra("currentTabPosition", 0);
            Log.i("hh", "onActivityResult -- " + position);
            //设置1tab选中
            sliding_tabs.getTabAt(position).select();
        }
    }

    public void initData() {
        titles = new String[]{"全部（0）", "待审核（0）", "已承保（0）", "问题件（0）", "回执签收（0）"};
        vpAdapter = new PolicyRrcordListVPAdapter(getSupportFragmentManager(), titles, this);
        ((PolicyRecordListFragment) vpAdapter.getItem(currentTabPosition)).getTabTitleCurrentPosition(currentTabPosition);
        ((PolicyRecordListFragment) vpAdapter.getItem(currentTabPosition)).setUserId(userId);
        viewpager.setAdapter(vpAdapter);
        sliding_tabs.setupWithViewPager(viewpager);  //将TabLayout和ViewPager关联起来
        initTitleStyle();

        viewpager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
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

        sliding_tabs.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                ((PolicyRecordListFragment) vpAdapter.getItem(tab.getPosition())).setUserId(userId);
                ((PolicyRecordListFragment) vpAdapter.getItem(tab.getPosition())).getTabTitleCurrentPosition(tab.getPosition());

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

    @Override
    protected void onResume() {
        super.onResume();
        currentTabPosition = 0;

    }

    /**
     * 初始化顶部的TabTitle
     */
    private void initTitleStyle() {
        refreshTitleStyle();

        //设置1tab选中
        sliding_tabs.getTabAt(currentTabPosition).select();
//        viewpager.setCurrentItem(currentTabPosition);
    }

    private void refreshTitleStyle() {
        for (int i = 0; i < sliding_tabs.getTabCount(); i++) {
            TabLayout.Tab tab = sliding_tabs.getTabAt(i);
            if (tab != null) {
                View view = getTabView(i);
                tab.setCustomView(view);
//                Log.i("aaa", "refreshTitleStyle: " + tab);
            }
        }
    }

    /**
     *  获取顶部Tab数据
     * @param data
     */
    public void refreshTabTitle(PolicyRecordList1B data) {
        if (data.getAllTotal() != null) {
            View titleView1 = (View) sliding_tabs.getTabAt(0).getCustomView();
            TextView title1 = (TextView) titleView1.findViewById(R.id.tv_title);
            title1.setText("全部（" + data.getAllTotal() + "）");
        }
        if (data.getInitTotal() != null) {
            View titleView2 = (View) sliding_tabs.getTabAt(1).getCustomView();
            TextView title2 = (TextView) titleView2.findViewById(R.id.tv_title);
            title2.setText("待审核（" + data.getInitTotal() + "）");
        }
        if (data.getPayedTotal() != null) {
            View titleView3 = (View) sliding_tabs.getTabAt(2).getCustomView();
            TextView title3 = (TextView) titleView3.findViewById(R.id.tv_title);
            title3.setText("已承保（" + data.getPayedTotal() + "）");
        }
        if (data.getRejectedTotal() != null) {
            View titleView4 = (View) sliding_tabs.getTabAt(3).getCustomView();
            TextView title4 = (TextView) titleView4.findViewById(R.id.tv_title);
            title4.setText("问题件（" + data.getRejectedTotal() + "）");
        }
        if (data.getReceiptSignedTotal() != null) {
            View titleView5 = (View) sliding_tabs.getTabAt(4).getCustomView();
            TextView title5 = (TextView) titleView5.findViewById(R.id.tv_title);
            title5.setText("回执签收（" + data.getReceiptSignedTotal() + "）");
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


}
