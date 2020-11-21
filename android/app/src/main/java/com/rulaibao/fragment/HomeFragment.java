package com.rulaibao.fragment;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.support.v4.widget.SwipeRefreshLayout;
import android.text.style.ParagraphStyle;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.activity.InsuranceProductActivity;
import com.rulaibao.activity.InsuranceProductDetailActivity;
import com.rulaibao.activity.LoginActivity;
import com.rulaibao.activity.PlanActivity;
import com.rulaibao.activity.PlatformBulletinDetailActivity;
import com.rulaibao.activity.ProductAppointmentActivity;
import com.rulaibao.activity.WebActivity;
import com.rulaibao.adapter.HomeAdapter;
import com.rulaibao.adapter.InsuranceProductAdapter;
import com.rulaibao.bean.Bulletin2B;
import com.rulaibao.bean.CycleIndex2B;
import com.rulaibao.bean.HomeIndex2B;
import com.rulaibao.bean.HomeViewPager2B;
import com.rulaibao.bean.InsuranceProduct2B;
import com.rulaibao.bean.InsuranceProduct3B;
import com.rulaibao.bean.OK2B;
import com.rulaibao.bean.Repo;
import com.rulaibao.common.Urls;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.MarqueeView;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.encrypt.DESUtil;
import com.rulaibao.widget.MyListView;
import com.rulaibao.widget.MyRollViewPager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

/**
 * 首页模块
 */

public class HomeFragment extends Fragment implements View.OnClickListener {
    private View mView;
    private Context context;
    private Intent intent;
    private SwipeRefreshLayout swipe_refresh;
    private ScrollView scrollView;
    private LinearLayout ll_vp; //顶部轮播图
    private LinearLayout ll_point_container; // 轮播图下面的圆点
    private MouldList<CycleIndex2B> picList;
    private CycleIndex2B cycleIndex2B; //  CycleIndex2B 类型的对象
    private MyRollViewPager rollViewPager;
    private String url; // url
    private String linkType; // 轮播图跳转类型（url:h5页面跳转、product:产品详情 为id、none:无跳转）
    private String name;
    //   private MarqueeView marqueeView;
    private TextView marqueeView;
    private MouldList<Bulletin2B> bulletinlist = new MouldList<>();

    private TextView tv_project_plan;//计划书
    private TextView tv_disease_guarantee;//疾病保障
    private TextView tv_pension_guarantee;//养老保障
    private TextView tv_property_guarantee;//资产保障
    private TextView tv_accident_guarantee;//意外保障
    private TextView tv_medical_guarantee;//医疗保障
    private TextView tv_old_young;//一老一小
    private TextView tv_enterprise_team;//企业团

    //重磅推荐
    private ViewPager mViewPager;
    private ArrayList<View> viewList;
    private ArrayList<ImageView> indicator_imgs = new ArrayList<>();
    private MouldList<HomeViewPager2B> homeVpList = new MouldList<>();
    private HomeAdapter homeAdapter;
    private View vIndicator;
    private LinearLayout ll_recommend;

    private MyListView listView;
    private InsuranceProductAdapter mAdapter;
    private MouldList<InsuranceProduct2B> totalList = new MouldList<>();

    private String userId;
    //   private HomeIndex2B homeIndexData;
    private boolean isRefresh = true;      //  控制无数据不加载

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        if (mView == null) {
            mView = inflater.inflate(R.layout.fragment_home, container, false);
            try {
                initView(mView);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            if (mView.getParent() != null) {
                ((ViewGroup) mView.getParent()).removeView(mView);
            }
        }
        return mView;
    }

    @Override
    public void onResume() {
        super.onResume();
    }

    @Override
    public void onPause() {
        super.onPause();
//        isRefresh = true;
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            requestAppData();
        }
    }

    private void initView(View mView) {
        context = getContext();
        swipe_refresh = (SwipeRefreshLayout) mView.findViewById(R.id.swipe_refresh);
        swipe_refresh.setColorSchemeResources(R.color.main_color_yellow);

        scrollView = (ScrollView) mView.findViewById(R.id.scrollView);
        picList = new MouldList<CycleIndex2B>();
        ll_vp = (LinearLayout) mView.findViewById(R.id.ll_vp);
        ll_point_container = (LinearLayout) mView.findViewById(R.id.ll_point_container);
        marqueeView = (TextView) mView.findViewById(R.id.marqueeView);//公告
        tv_project_plan = (TextView) mView.findViewById(R.id.tv_project_plan);//计划书
        tv_disease_guarantee = (TextView) mView.findViewById(R.id.tv_disease_guarantee);//疾病保障
        tv_pension_guarantee = (TextView) mView.findViewById(R.id.tv_pension_guarantee);//养老保障
        tv_property_guarantee = (TextView) mView.findViewById(R.id.tv_property_guarantee);//资产保障
        tv_accident_guarantee = (TextView) mView.findViewById(R.id.tv_accident_guarantee);//意外保障
        tv_medical_guarantee = (TextView) mView.findViewById(R.id.tv_medical_guarantee);//医疗保障
        tv_old_young = (TextView) mView.findViewById(R.id.tv_old_young);//一老一小
        tv_enterprise_team = (TextView) mView.findViewById(R.id.tv_enterprise_team);//企业团

        ll_recommend = (LinearLayout) mView.findViewById(R.id.ll_recommend);

        marqueeView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (bulletinlist.size() != 0) {
                    try {
                        userId = null;
                        userId = DESUtil.decrypt(PreferenceUtil.getUserId());
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    Intent intent = new Intent(context, WebActivity.class);
                    intent.putExtra("type", WebActivity.WEB_TYPE_NOTICE);
                    intent.putExtra("title", "公告详情");
                    intent.putExtra("url", Urls.URL_BULLETIN_DETAIL + "?id=" + bulletinlist.get(0).getBulletinId() + "&userId=" + userId);
                    startActivity(intent);
                }
            }
        });
        //热销精品
        listView = (MyListView) mView.findViewById(R.id.home_listview);
        View view = View.inflate(getActivity(), R.layout.listview_home_footerview, null);
        listView.addFooterView(view);// 为listview添加footview
        mAdapter = new InsuranceProductAdapter(context, totalList);
        listView.setAdapter(mAdapter);


        swipe_refresh.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                requestAppData();
            }
        });
        tv_project_plan.setOnClickListener(this);
        tv_disease_guarantee.setOnClickListener(this);
        tv_pension_guarantee.setOnClickListener(this);
        tv_property_guarantee.setOnClickListener(this);
        tv_accident_guarantee.setOnClickListener(this);
        tv_medical_guarantee.setOnClickListener(this);
        tv_old_young.setOnClickListener(this);
        tv_enterprise_team.setOnClickListener(this);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() { // item 点击监听
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                Intent intent = new Intent(context, InsuranceProductDetailActivity.class);
                intent.putExtra("id", totalList.get(position).getId());
                startActivity(intent);
            }
        });
    }

    //重磅推荐
    public void initViewPageData(final MouldList<HomeViewPager2B> homeVpList) {
        //重磅推荐

        mViewPager = (ViewPager) mView.findViewById(R.id.home_viewpager);
        mViewPager.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                switch (motionEvent.getAction()) {
                    case MotionEvent.ACTION_MOVE:
                        swipe_refresh.setEnabled(false);
                        break;
                    case MotionEvent.ACTION_UP:
                    case MotionEvent.ACTION_CANCEL:
                        swipe_refresh.setEnabled(true);
                        break;
                }
                return false;
            }
        });
        vIndicator = mView.findViewById(R.id.home_indicator);// 线性水平布局，负责动态调整导航图标

        ImageView imgView;
        viewList = new ArrayList<>();
        ((ViewGroup) vIndicator).removeAllViews();
        for (int i = 0; i < homeVpList.size(); i++) {
            View view = LayoutInflater.from(context).inflate(R.layout.item_home_viewpager, null);
            imgView = new ImageView(context);
            LinearLayout.LayoutParams params_linear = new LinearLayout.LayoutParams(18, 18);
            params_linear.setMargins(7, 10, 7, 10);
            imgView.setLayoutParams(params_linear);
            indicator_imgs.add(i, imgView);
            if (i == 0) { // 初始化第一个为选中状态
                indicator_imgs.get(i).setBackgroundResource(R.drawable.round_orange);
            } else {
                indicator_imgs.get(i).setBackgroundResource(R.drawable.round_gray);
            }
            ((ViewGroup) vIndicator).addView(indicator_imgs.get(i));
            viewList.add(view);
        }
        homeAdapter = new HomeAdapter(context, viewList, homeVpList, new HomeAdapter.callBack() {
            @Override
            public void callBack(int position) {
                Intent intent = new Intent(context, InsuranceProductDetailActivity.class);
                intent.putExtra("id", homeVpList.get(position).getId());
                startActivity(intent);
            }
        });
        mViewPager.setAdapter(homeAdapter);
        // 绑定动作监听器：如翻页的动画
        mViewPager.setOnPageChangeListener(new MyListener());
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_project_plan://计划书
                intent = new Intent(context, PlanActivity.class);
                startActivity(intent);
                break;
            case R.id.tv_disease_guarantee://疾病保障---重疾险
                intent = new Intent(context, InsuranceProductActivity.class);
                intent.putExtra("category", "重疾险");
                startActivity(intent);
                break;
            case R.id.tv_pension_guarantee://养老保障---年金险
                intent = new Intent(context, InsuranceProductActivity.class);
                intent.putExtra("category", "年金险");
                startActivity(intent);
                break;
            case R.id.tv_property_guarantee://资产保障---终身寿险
                intent = new Intent(context, InsuranceProductActivity.class);
                intent.putExtra("category", "终身寿险");
                startActivity(intent);
                break;
            case R.id.tv_accident_guarantee://意外保障---意外险
                intent = new Intent(context, InsuranceProductActivity.class);
                intent.putExtra("category", "意外险");
                startActivity(intent);
                break;
            case R.id.tv_medical_guarantee://医疗保障---医疗险
                intent = new Intent(context, InsuranceProductActivity.class);
                intent.putExtra("category", "医疗险");
                startActivity(intent);
                break;
            case R.id.tv_old_young://一老一小--- 一老一小
                intent = new Intent(context, InsuranceProductActivity.class);
                intent.putExtra("category", "一老一小");
                startActivity(intent);
                break;
            case R.id.tv_enterprise_team://企业团---企业团体
                intent = new Intent(context, InsuranceProductActivity.class);
                intent.putExtra("category", "企业团体");
                startActivity(intent);
                break;
        }
    }

    /**
     * 获取首页数据
     */
    private void requestHomeData() {
        try {
            userId = null;
            userId = DESUtil.decrypt(PreferenceUtil.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("userId", userId);
        HtmlRequest.getHomeData(context, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {

                if (params == null || params.result == null) {

                    //       Toast.makeText(context, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }
                HomeIndex2B homeIndex2B = (HomeIndex2B) params.result;
                //轮播图
                picList = homeIndex2B.getAdvertiseList();
                freshVP();

                //公告
                bulletinlist = homeIndex2B.getBulletinlist();
                if (bulletinlist.size() != 0) {
                    marqueeView.setText(bulletinlist.get(0).getBulletinTopic());
                } else {
                    marqueeView.setText("暂无公告");
                }

                if (homeIndex2B.getRecommendlist().size() == 0) {
                    ll_recommend.setVisibility(View.GONE);
                } else {
                    ll_recommend.setVisibility(View.VISIBLE);
                }
                indicator_imgs.clear();
                homeVpList.clear();
                homeVpList.addAll(homeIndex2B.getRecommendlist());
                initViewPageData(homeVpList);
                homeAdapter.notifyDataSetChanged();

                //热销精品
                totalList.clear();
                totalList.addAll(homeIndex2B.getSellList());
                mAdapter.notifyDataSetChanged();
                scrollView.smoothScrollTo(0, 0);

            }

        });
    }

    /**
     * 打开app接口 && 控制强制登录设置userid为空
     */
    public void requestAppData() {
        try {
            userId = null;
            userId = DESUtil.decrypt(PreferenceUtil.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        final LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("userId", userId);
        HtmlRequest.getAppData(context, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (swipe_refresh.isRefreshing()) {
                    //请求返回后，无论本次请求成功与否，都关闭下拉旋转
                    swipe_refresh.setRefreshing(false);
                }
                if (params == null || params.result == null) {
                    return;
                }
                Repo<OK2B> b = (Repo<OK2B>) params.result;
                String code = b.getCode();
                if (code.equals("0000")) {

                } else {
                    if (code.equals("9999")) {
                        PreferenceUtil.setAutoLoginPwd("");
                        PreferenceUtil.setLogin(false);
                        PreferenceUtil.setFirstLogin(true);
//				PreferenceUtil.setPhone("");
                        PreferenceUtil.setUserId("");
                        PreferenceUtil.setUserNickName("");
                        PreferenceUtil.setToken("");
                        PreferenceUtil.setCheckStatus("");
                        Toast.makeText(context, "您已被禁止登录，请联系客服", Toast.LENGTH_SHORT).show();
                    }
                }
                requestHomeData();

            }

        });
    }

    /**
     * 请求轮播图数据
     */
    private void freshVP() {
        if (context == null) {
            return;
        }
        if (rollViewPager == null) {
            //第一次从后台获取到数据
            rollViewPager = new MyRollViewPager(context, picList, ll_point_container);
            rollViewPager.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View view, MotionEvent motionEvent) {
                    switch (motionEvent.getAction()) {
                        case MotionEvent.ACTION_MOVE:
                            swipe_refresh.setEnabled(false);
                            break;
                        case MotionEvent.ACTION_UP:
                        case MotionEvent.ACTION_CANCEL:
                            swipe_refresh.setEnabled(true);
                            break;
                    }
                    return false;
                }
            });
            rollViewPager.setCycle(true);
            rollViewPager.setOnMyListener(new MyRollViewPager.MyClickListener() {
                @Override
                public void onMyClick(int position) {
                    if (picList != null && picList.size() != 0) {
                        cycleIndex2B = picList.get(position);
                        url = cycleIndex2B.getTargetUrl();
                        name = cycleIndex2B.getName();
                        linkType = cycleIndex2B.getLinkType();

                        if ("url".equals(linkType)) { // 跳转h5网页
                            Intent intent = new Intent(context, WebActivity.class);
                            intent.putExtra("type", WebActivity.WEBTYPE_BANNER);
                            intent.putExtra("url", url);
                            intent.putExtra("title", name);
                            startActivity(intent);
                        } else if ("product".equals(linkType)) { // 产品详情
                            Intent intent = new Intent(context, InsuranceProductDetailActivity.class);
                            intent.putExtra("id", url);
                            startActivity(intent);
                        } else if ("none".equals(linkType)) { // 无跳转

                        }
                    }

                }
            });
            rollViewPager.startRoll();
            ll_vp.addView(rollViewPager);
        } else {
            //第二或之后获取到数据，刷新vp
            rollViewPager.setPicList(picList);
            rollViewPager.reStartRoll();
        }
    }

    /**
     * 动作监听器，可异步加载图片
     */
    private class MyListener implements ViewPager.OnPageChangeListener {
        @Override
        public void onPageScrollStateChanged(int state) {
            if (state == 0) {
                // new MyAdapter(null).notifyDataSetChanged();
            }
        }

        @Override
        public void onPageScrolled(int arg0, float arg1, int arg2) {
        }

        @Override
        public void onPageSelected(int position) {
            // 改变所有导航的背景图片为：未选中
            for (int i = 0; i < indicator_imgs.size(); i++) {
                indicator_imgs.get(i).setBackgroundResource(R.drawable.round_gray);
            }
            // 改变当前背景图片为：选中
            indicator_imgs.get(position).setBackgroundResource(R.drawable.round_orange);
        }
    }
}
