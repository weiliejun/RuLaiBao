package com.rulaibao.adapter;

import android.content.Context;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import com.rulaibao.fragment.PolicyRecordListFragment;

import java.util.ArrayList;
import java.util.List;

/**
 *  保单列表  viewPager  Adapter类
 */
public class PolicyRrcordListVPAdapter extends FragmentStatePagerAdapter {

    private String[] mTitles;
    private List<Fragment> list = null;

    public PolicyRrcordListVPAdapter(FragmentManager fm, String[] titles, Context context) {
        super(fm);
        mTitles = titles;

        initFragments();
    }

    private void initFragments() {
        list = new ArrayList<>();
        if (list.size() <= 0) {
            list.add(PolicyRecordListFragment.newInstance("全部（）"));
            list.add(PolicyRecordListFragment.newInstance("待审核（）"));
            list.add(PolicyRecordListFragment.newInstance("已承保（）"));
            list.add(PolicyRecordListFragment.newInstance("问题件（）"));
            list.add(PolicyRecordListFragment.newInstance("回执签收（）"));
//            list.add(ItemFragment.newInstance(1));
        }
    }

    @Override
    public Fragment getItem(int position) {

        return list.get(position);
    }

    @Override
    public int getCount() {
        return mTitles.length;
    }

    @Override
    public CharSequence getPageTitle(int position) { //获取标题
        return mTitles[position];
    }


}
