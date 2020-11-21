package com.rulaibao.activity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.FrameLayout;
import android.widget.HorizontalScrollView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewSwitcher;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.rulaibao.R;
import com.rulaibao.adapter.InsuranceProductAdapter;
import com.rulaibao.adapter.TabsViewPagerAdapter;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.InsuranceProduct1B;
import com.rulaibao.bean.InsuranceProduct2B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.ViewUtils;
import com.rulaibao.widget.TitleBar;

import java.util.ArrayList;
import java.util.LinkedHashMap;

import calendar.views.NewsTitleTextView;

/**
 * 保险产品
 */
public class InsuranceProductActivity extends BaseActivity implements View.OnClickListener, ViewPager.OnPageChangeListener {
    private ViewPager mViewPager;
    private ViewGroup mViewGroup;
    private HorizontalScrollView h_scroll_view;
    private TabsViewPagerAdapter tabAdapter;
    private String[] mTabItems = new String[]{"重疾险", "年金险", "终身寿险", "意外险", "医疗险", "一老一小", "企业团体", ""};
    View view;

    private int mPreSelectItem;
    private String category = "";

    private PullToRefreshListView listView;
    private InsuranceProductAdapter mAdapter;
    private MouldList<InsuranceProduct2B> totalList = new MouldList<>();
    private int currentPage = 1;    //当前页
    private ViewSwitcher vs;
    private ArrayList<View> newview;
    private ImageView iv_right_btn;
    private ImageView iv_back;
    private Intent intent;
    private InsuranceProduct1B data;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_insurance_product);

        initTopTitle();
        initView();
        addViewPagerView();
        initData();
    }

    public void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setVisibility(View.GONE);
    }

    private void initView() {
        category = getIntent().getStringExtra("category");
        mViewPager = (ViewPager) findViewById(R.id.viewpager);
        h_scroll_view = (HorizontalScrollView) findViewById(R.id.h_scroll_view);
        mViewGroup = (ViewGroup) findViewById(R.id.viewgroup);
        iv_right_btn = (ImageView) findViewById(R.id.iv_right_insurance);
        iv_right_btn.setClickable(false);
        iv_back = (ImageView) findViewById(R.id.iv_back);

        iv_right_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                intent = new Intent(mContext, SearchActivity.class);
                intent.putStringArrayListExtra("companyList", data.getCompanyList());
                mContext.startActivity(intent);
            }
        });
        iv_back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }

    //初始化点击分类的tabbar以及viewpager
    private void addViewPagerView() {
        newview = new ArrayList<View>();
//        LayoutInflater inflater = getLayoutInflater();
        for (int i = 0; i < mTabItems.length; i++) {
            view = getLayoutInflater().inflate(R.layout.insurance_product_list, null);
            String label = mTabItems[i];
            NewsTitleTextView tv = new NewsTitleTextView(this);
            int itemWidth = (int) tv.getPaint().measureText(label);
            tv.setLayoutParams(new LinearLayout.LayoutParams((itemWidth * 2), -1));
            tv.setTextSize(18);
            tv.setText(label);
            tv.setGravity(Gravity.CENTER);
            tv.setOnClickListener(this);
            if (i == 0) {
                tv.setTextColor(getResources().getColor(R.color.gray_dark));
                tv.setIsHorizontaline(true);
            } else {
                tv.setTextColor(getResources().getColor(R.color.gray_d));
                tv.setIsHorizontaline(false);
            }
            tv.setIsVerticalLine(true);
            mViewGroup.addView(tv);
            newview.add(view);
        }
        tabAdapter = new TabsViewPagerAdapter(this, newview);//设置水平滑动控件adapter
        mViewPager.setAdapter(tabAdapter);//设置viewpager的adapter
        mViewPager.setOnPageChangeListener(this);
        if ("重疾险".equals(category)) {
            mPreSelectItem = 0;
            mViewPager.setCurrentItem(mPreSelectItem);

        } else if ("年金险".equals(category)) {
            mPreSelectItem = 1;
            mViewPager.setCurrentItem(mPreSelectItem);

        } else if ("终身寿险".equals(category)) {
            mPreSelectItem = 2;
            mViewPager.setCurrentItem(mPreSelectItem);

        } else if ("意外险".equals(category)) {
            mPreSelectItem = 3;
            mViewPager.setCurrentItem(mPreSelectItem);

        } else if ("医疗险".equals(category)) {
            mPreSelectItem = 4;
            mViewPager.setCurrentItem(mPreSelectItem);

        } else if ("一老一小".equals(category)) {
            mPreSelectItem = 5;
            mViewPager.setCurrentItem(mPreSelectItem);

        } else if ("企业团体".equals(category)) {
            mPreSelectItem = 6;
            mViewPager.setCurrentItem(mPreSelectItem);

        }

    }

    public void initData() {
        vs = (ViewSwitcher) newview.get(mPreSelectItem).findViewById(R.id.vs);
        TextView tv_empty = (TextView) newview.get(mPreSelectItem).findViewById(R.id.tv_empty);
        tv_empty.setText("暂无产品");
        listView = (PullToRefreshListView) newview.get(mPreSelectItem).findViewById(R.id.insurance_product_list);
        //      moveTitleLabel(mPreSelectItem);
        //PullToRefreshListView  上滑加载更多及下拉刷新
        ViewUtils.slideAndDropDown(listView);
        mAdapter = new InsuranceProductAdapter(mContext, totalList);
        listView.setAdapter(mAdapter);

        requestListData();

        listView.setOnRefreshListener(new PullToRefreshBase.OnRefreshListener<ListView>() {
            public void onRefresh(PullToRefreshBase<ListView> refreshView) {
                if (refreshView.isHeaderShown()) {
                    //下拉刷新
                    currentPage = 1;
                } else {
                    //上划加载下一页
                    currentPage++;
                }
                requestListData();
            }
        });

        // item 点击监听
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new Intent(mContext, InsuranceProductDetailActivity.class);
                intent.putExtra("id", totalList.get(position - 1).getId());
                startActivity(intent);
            }
        });

    }

    /**
     * 获取保险产品数据
     */
    private void requestListData() {
        String categoryEng = "";
        if ("意外险".equals(category)) {
            categoryEng = "accident";

        } else if ("重疾险".equals(category)) {
            categoryEng = "criticalIllness";

        } else if ("年金险".equals(category)) {
            categoryEng = "annuity";

        } else if ("医疗险".equals(category)) {
            categoryEng = "medical";

        } else if ("终身寿险".equals(category)) {
            categoryEng = "wholeLife";

        } else if ("一老一小".equals(category)) {
            categoryEng = "oldSmall";

        } else if ("企业团体".equals(category)) {
            categoryEng = "enterpriseGroup";

        }
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("page", currentPage + "");
        param.put("userId", userId);
        param.put("category", categoryEng);
        param.put("securityType", "");
        try {
            HtmlRequest.getInsuranceProductData(mContext, param, new BaseRequester.OnRequestListener() {
                @Override
                public void onRequestFinished(BaseParams params) {
                    if (params == null || params.result == null) {
                        vs.setDisplayedChild(1);
                        //        Toast.makeText(mContext, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                        listView.postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                listView.onRefreshComplete();
                            }
                        }, 1000);
                        return;
                    }
                    data = (InsuranceProduct1B) params.result;
                    iv_right_btn.setClickable(true);
                    MouldList<InsuranceProduct2B> everyList = data.getList();
                    if ((everyList == null || everyList.size() == 0) && currentPage != 1) {
                        Toast.makeText(mContext, "已显示全部", Toast.LENGTH_SHORT).show();
                    }
                    if (currentPage == 1) {
                        //刚进来时 加载第一页数据，或下拉刷新 重新加载数据 。这两种情况之前的数据都清掉
                        totalList.clear();
                    }
                    totalList.addAll(everyList);
                    if (totalList.size() == 0) {
                        vs.setDisplayedChild(1);
                    } else {
                        vs.setDisplayedChild(0);
                    }
                    //刷新数据
                    mAdapter.notifyDataSetChanged();

                    listView.postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            listView.onRefreshComplete();
                        }
                    }, 1000);
                    moveTitleLabel(mPreSelectItem);
                    if (mPreSelectItem == 6) {
                        //控制企业团体 滑到最右边
                        h_scroll_view.fullScroll(HorizontalScrollView.FOCUS_RIGHT);

                    }


                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onClick(View v) {
        // 点击tabbar
        for (int i = 0; i < mViewGroup.getChildCount(); i++) {
            NewsTitleTextView child = (NewsTitleTextView) mViewGroup.getChildAt(i);
            if (child == v) {
                mViewPager.setCurrentItem(i);
                break;
            }
        }
    }

    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

    }

    @Override
    public void onPageSelected(int position) {
        switchTitleLabel(position);
    }

    @Override
    public void onPageScrollStateChanged(int state) {

    }

    /*
    * 点击分类的tabbar，使点击的bar居中显示到屏幕中间
    */
    @SuppressLint("NewApi")
    private void switchTitleLabel(int position) {
        moveTitleLabel(position);
        mPreSelectItem = position;
        category = mTabItems[mPreSelectItem];
        currentPage = 1;
        initData();
    }

    private void moveTitleLabel(int position) {
        // 点击当前按钮所有左边按钮的总宽度
        int visiableWidth = 0;
        // HorizontalScrollView的宽度
        int scrollViewWidth = 0;
        mViewGroup.measure(mViewGroup.getMeasuredWidth(), -1);
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(mViewGroup.getMeasuredWidth(), -1);
        params.gravity = Gravity.CENTER_VERTICAL;
        mViewGroup.setLayoutParams(params);
        for (int i = 0; i < mViewGroup.getChildCount(); i++) {
            NewsTitleTextView itemView = (NewsTitleTextView) mViewGroup.getChildAt(i);
            int width = itemView.getMeasuredWidth();
            if (i < position) {
                visiableWidth += width;
            }
            scrollViewWidth += width;

            if (i == mViewGroup.getChildCount() - 1) {
                break;
            }
            if (position != i) {
                itemView.setTextColor(getResources().getColor(R.color.gray_d));
                itemView.setIsHorizontaline(false);
            } else {
                itemView.setTextColor(getResources().getColor(R.color.gray_dark));
                itemView.setIsHorizontaline(true);
            }
        }
        // 当前点击按钮的宽度
        int titleWidth = mViewGroup.getChildAt(position).getMeasuredWidth();
        int nextTitleWidth = 0;
        if (position > 0) {
            // 当前点击按钮相邻右边按钮的宽度
            nextTitleWidth = position == mViewGroup.getChildCount() - 1 ? 0 : mViewGroup.getChildAt(position - 1).getMeasuredWidth();
        }
        int screenWidth = getWindowManager().getDefaultDisplay().getWidth();
        final int move = visiableWidth - (screenWidth - titleWidth) / 2;
        if (mPreSelectItem < position) {// 向屏幕右边移动
            if ((visiableWidth + titleWidth + nextTitleWidth) >= (screenWidth / 2)) {
                ((HorizontalScrollView) mViewGroup.getParent()).setScrollX(move);
            }
        } else {// 向屏幕左边移动
            if ((scrollViewWidth - visiableWidth) >= (screenWidth / 2)) {
                ((HorizontalScrollView) mViewGroup.getParent()).setScrollX(move);
            }
        }
    }
}