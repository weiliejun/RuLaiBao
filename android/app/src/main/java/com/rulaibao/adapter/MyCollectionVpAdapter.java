package com.rulaibao.adapter;

import android.content.Context;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import com.rulaibao.fragment.MyCollectionFragment;
import com.rulaibao.fragment.PolicyBookingFragment;

import java.util.ArrayList;
import java.util.List;


/**
 * 我的收藏列表  viewPager  Adapter类
 * Created by junde on 2018/4/21.
 */

public class MyCollectionVpAdapter extends FragmentStatePagerAdapter {

    private final String[] mTitles;
    private List<Fragment> fragments = null;

    public MyCollectionVpAdapter(FragmentManager fm, String[] titles, Context context) {
        super(fm);
        mTitles = titles;

        initFragments();
    }

    private void initFragments() {
        fragments = new ArrayList<>();
        fragments.add(MyCollectionFragment.newInstance("全部"));
        fragments.add(MyCollectionFragment.newInstance("重疾险"));
        fragments.add(MyCollectionFragment.newInstance("年金险"));
        fragments.add(MyCollectionFragment.newInstance("终身寿险"));
        fragments.add(MyCollectionFragment.newInstance("意外险"));
        fragments.add(MyCollectionFragment.newInstance("医疗险"));
        fragments.add(MyCollectionFragment.newInstance("一老一小"));
        fragments.add(MyCollectionFragment.newInstance("企业团体"));
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
