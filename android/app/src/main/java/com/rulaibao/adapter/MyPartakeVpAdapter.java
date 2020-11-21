package com.rulaibao.adapter;

import android.content.Context;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import com.rulaibao.fragment.MyPartakeAskFragment;
import com.rulaibao.fragment.MyPartakeTopicFragment;

import java.util.ArrayList;
import java.util.List;


/**
 * 我参与的列表  viewPager  Adapter类
 * Created by junde on 2018/4/23.
 */

public class MyPartakeVpAdapter extends FragmentStatePagerAdapter {

    private final String[] mTitles;
    private List<Fragment> fragments = null;

    public MyPartakeVpAdapter(FragmentManager fm, String[] titles, Context context) {
        super(fm);
        mTitles = titles;

        initFragments();
    }

    private void initFragments() {
        fragments = new ArrayList<>();
        fragments.add(MyPartakeAskFragment.newInstance("提问"));
        fragments.add(MyPartakeTopicFragment.newInstance("话题"));
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
