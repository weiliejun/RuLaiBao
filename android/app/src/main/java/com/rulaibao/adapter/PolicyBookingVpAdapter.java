package com.rulaibao.adapter;

import android.content.Context;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import com.rulaibao.fragment.PolicyBookingFragment;

import java.util.ArrayList;
import java.util.List;


/**
 * 预约列表  viewPager  Adapter类
 * Created by junde on 2018/4/19.
 */

public class PolicyBookingVpAdapter extends FragmentStatePagerAdapter {

    private final String[] mTitles;
    private List<Fragment> fragments = null;

    public PolicyBookingVpAdapter(FragmentManager fm, String[] titles, Context context) {
        super(fm);
        mTitles = titles;

        initFragments();
    }

    private void initFragments() {
        fragments = new ArrayList<>();
        fragments.add(PolicyBookingFragment.newInstance("全部"));
        fragments.add(PolicyBookingFragment.newInstance("待确认"));
        fragments.add(PolicyBookingFragment.newInstance("已确认"));
        fragments.add(PolicyBookingFragment.newInstance("已驳回"));
        fragments.add(PolicyBookingFragment.newInstance("已取消"));
    }

    @Override
    public Fragment getItem(int position) {
        return fragments.get(position);
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
