package com.rulaibao.activity;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.widget.TextView;
import android.widget.ViewSwitcher;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.MyPayrollYears1B;
import com.rulaibao.fragment.PayrollYearsFragment;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.widget.TitleBar;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

/**
 *  我的工资单
 * Created by hong on 2018/11/12.
 */

public class MyPayrollActivity extends BaseActivity{

    private TabLayout sliding_tabs;
    private ViewPager viewpager;
    private ArrayList years;
    private ArrayList<String> listTitles;
    private List<Fragment> fragments;
    private ViewSwitcher vs;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_my_payroll);

        initTopTitle();
        initView();
        requestYearsData();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.title_my_payroll))
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
        vs = (ViewSwitcher)findViewById(R.id.vs);
        sliding_tabs = (TabLayout) findViewById(R.id.sliding_tabs);
        viewpager = (ViewPager) findViewById(R.id.viewpager);

        TextView tv_empty = (TextView)findViewById(R.id.tv_empty);
        tv_empty.setText("暂无工资单");

        listTitles = new ArrayList<>();
        fragments = new ArrayList<>();
    }

    /**
     *  获取 工资单年份数据
     */
    private void requestYearsData() {
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("userId", userId);

        HtmlRequest.getMyPayrollYearsData(this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params == null || params.result == null) {
                    //  Toast.makeText(MyInfoActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }
                MyPayrollYears1B data = (MyPayrollYears1B) params.result;
                if (data.getWageYears().size() == 0) {
                    vs.setDisplayedChild(1);
                    return;
                }
                if (years == null) {
                    years = new ArrayList();
                }
                years.addAll(data.getWageYears());
                initTabView();
            }
        });
    }

    /**
     *  初始化顶部工资单年份数据
     */
    private void initTabView() {
        if (years != null) {
            listTitles.addAll(years);
        }

        for (int i = 0; i < listTitles.size(); i++) {
            PayrollYearsFragment fragment = PayrollYearsFragment.newInstance(listTitles.get(i));
            fragments.add(fragment);
        }

        for (int i = 0; i < listTitles.size(); i++) {
            sliding_tabs.addTab(sliding_tabs.newTab().setText(listTitles.get(i)));//添加tab选项
        }

        FragmentPagerAdapter vPAdapter = new FragmentPagerAdapter(getSupportFragmentManager()) {
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
                return listTitles.get(position).toString();
            }
        };
        viewpager.setAdapter(vPAdapter);

        sliding_tabs.setupWithViewPager(viewpager);  // 将TabLayout和ViewPager关联起来。
        sliding_tabs.setTabsFromPagerAdapter(vPAdapter); // 给Tabs设置适配器
    }

    @Override
    public void initData() {
    }
}
