package com.rulaibao.activity;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.ResultAskTypeItemBean;
import com.rulaibao.bean.ResultClassIndexBean;
import com.rulaibao.bean.ResultClassIndexItemBean;
import com.rulaibao.fragment.TrainingClassFragment;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.widget.TitleBar;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

/**
 * 课程列表
 * 点研修首页的课程跳到课程列表
 */

public class TrainingClassListActivity extends BaseActivity {
    private TabLayout mTabLayout;
    private ViewPager mViewPager;
    private List<ResultAskTypeItemBean> listTitles; // 存放课程类型title的list
    private List<Fragment> fragments;
    private MouldList<ResultClassIndexItemBean> courseTypeList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_training_class);
        initTopTitle();
        initView();
        requestIndexData();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.training_class))
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

    public void initView() {

        listTitles = new ArrayList<ResultAskTypeItemBean>();
        fragments = new ArrayList<>();
        courseTypeList = new MouldList<ResultClassIndexItemBean>();

        mTabLayout = (TabLayout) findViewById(R.id.zx_tl);
        mViewPager = (ViewPager) findViewById(R.id.zx_vp);

    }

    /**
     *  获取课程列表数据
     */
    public void requestIndexData(){
        LinkedHashMap<String,Object> map = new LinkedHashMap<String,Object>();
        map.put("page", 1+"");
        map.put("typeCode", "");

        HtmlRequest.getTrainingClassList(this, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if(params.result!=null){
                    ResultClassIndexBean bean = (ResultClassIndexBean)params.result;
//                    courseList.addAll(bean.getCourseList());
//                    adapter.notifyDataSetChanged();
                    courseTypeList = bean.getCourseTypeList(); // 获取到当前课程类型列表
                    initData();
                }else{

                }

            }
        });
    }

    public void initData(){
        ResultAskTypeItemBean itemBean = new ResultAskTypeItemBean();
        itemBean.setTypeName("热门推荐");
        itemBean.setTypeCode("");
        listTitles.add(itemBean);

        // 遍历上面课程类型的数量
        for(int i=0; i < courseTypeList.size(); i++){
            ResultAskTypeItemBean itemBean1 = new ResultAskTypeItemBean();
            itemBean1.setTypeName(courseTypeList.get(i).getTypeName());
            itemBean1.setTypeCode(courseTypeList.get(i).getTypeCode());
            listTitles.add(itemBean1);
        }

        // 遍历上面课程对应的Fragment
        for (int i = 0; i < listTitles.size(); i++) {
            TrainingClassFragment fragment = TrainingClassFragment.newInstance(listTitles.get(i).getTypeCode());
            fragments.add(fragment);

        }
        //mTabLayout.setTabMode(TabLayout.SCROLL_AXIS_HORIZONTAL);//设置tab模式，当前为系统默认模式
        for (int i=0;i<listTitles.size();i++){
            mTabLayout.addTab(mTabLayout.newTab().setText(listTitles.get(i).getTypeName()));//添加tab选项
        }

        FragmentPagerAdapter mAdapter = new FragmentPagerAdapter(getSupportFragmentManager()) {
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
                return listTitles.get(position).getTypeName();
            }
        };
        mViewPager.setAdapter(mAdapter);

        mTabLayout.setupWithViewPager(mViewPager);//将TabLayout和ViewPager关联起来。
        mTabLayout.setTabsFromPagerAdapter(mAdapter);//给Tabs设置适配器

    }
    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }
}
