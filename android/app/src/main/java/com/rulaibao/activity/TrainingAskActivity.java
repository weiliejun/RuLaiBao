package com.rulaibao.activity;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.text.TextUtils;
import android.widget.Button;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.ResultAskTypeBean;
import com.rulaibao.bean.ResultAskTypeItemBean;
import com.rulaibao.fragment.TrainingAakFragment;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.RlbActivityManager;
import com.rulaibao.uitls.ViewUtils;
import com.rulaibao.widget.TitleBar;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 问答
 */

public class TrainingAskActivity extends BaseActivity {

    @BindView(R.id.tl_training_ask)
    TabLayout tlTrainingAsk;
    @BindView(R.id.vp_training_ask)
    ViewPager vpTrainingAsk;
    @BindView(R.id.btn_training_ask)
    Button btnTrainingAsk;

    private List<ResultAskTypeItemBean> listTitles;
    private List<Fragment> fragments;
    private Context context;
    private ArrayList<ResultAskTypeItemBean> typeBean;

    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_training_ask);
        initTopTitle();

        initView();

        requestAskType();
    }

    public void initTabView() {

        ResultAskTypeItemBean hot = new ResultAskTypeItemBean();
        hot.setTypeCode("");
        hot.setTypeName("热门推荐");
        listTitles.add(hot);


        if (typeBean != null) {
            listTitles.addAll(typeBean);
        }

        for (int i = 0; i < listTitles.size(); i++) {
            TrainingAakFragment fragment = TrainingAakFragment.newInstance(listTitles.get(i));
            fragments.add(fragment);

        }
        //mTabLayout.setTabMode(TabLayout.SCROLL_AXIS_HORIZONTAL);//设置tab模式，当前为系统默认模式
        for (int i = 0; i < listTitles.size(); i++) {
            tlTrainingAsk.addTab(tlTrainingAsk.newTab().setText(listTitles.get(i).getTypeName()));//添加tab选项
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
        vpTrainingAsk.setAdapter(mAdapter);

        tlTrainingAsk.setupWithViewPager(vpTrainingAsk);//将TabLayout和ViewPager关联起来。
        tlTrainingAsk.setTabsFromPagerAdapter(mAdapter);//给Tabs设置适配器

    }


    public void initView() {


        context = this;
        listTitles = new ArrayList<>();
        fragments = new ArrayList<>();

    }


    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.training_ask))
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

    @OnClick(R.id.btn_training_ask)
    public void onClick() {

        if (!PreferenceUtil.isLogin()) {

            HashMap<String, Object> map = new HashMap<>();
            RlbActivityManager.toLoginActivity(TrainingAskActivity.this, map, false);

        } else {
            String checkStatus = PreferenceUtil.getCheckStatus();
            if (!checkStatus.equals("success")) {


                ViewUtils.showToSaleCertificationDialog(this, "您还未认证，是否去认证");

            } else {

                HashMap<String, Object> map = new HashMap<>();
                if (typeBean != null) {
                    if (typeBean.size() == 0) {
                        Toast.makeText(context, "请联系管理员添加问题类型", Toast.LENGTH_SHORT).show();
                    } else {
                        map.put("type", typeBean);
                        RlbActivityManager.toTrainingToAskActivity(this, map, false);
                    }
                }

            }
        }


    }

    //获取问答类型
    public void requestAskType() {


//        ArrayMap<String,Object> map = new ArrayMap<String,Object>();
        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();


        HtmlRequest.getTrainingAskType(context, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {

                if (params.result != null) {

                    ResultAskTypeBean bean = (ResultAskTypeBean) params.result;
                    if (typeBean == null) {
                        typeBean = new MouldList<ResultAskTypeItemBean>();
                    }
                    typeBean.addAll(bean.getList());
                    initTabView();

                } else {

                }

            }
        });

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
