package com.rulaibao.activity;

import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewSwitcher;

import com.rulaibao.R;
import com.rulaibao.adapter.CommissionListAdapter;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.TrackingList1B;
import com.rulaibao.bean.TrackingList2B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.widget.TitleBar;

import java.util.LinkedHashMap;

/**
 *  佣金明细 列表
 * Created by junde on 2018/11/13.
 */

public class CommissionListActivity extends BaseActivity {


    private ViewSwitcher vs;
    private SwipeRefreshLayout swipe_refresh;
    private RecyclerView recycler_view;
    private CommissionListAdapter commissionListAdapter;
    private MouldList<TrackingList2B> totalList = new MouldList<>();
    private MouldList<TrackingList2B> everyList;
    private int currentPage = 1;
    private String currentMonth;
    private TextView tv_count_commission; // 有几份佣金
    private TextView tv_total_commission; // 佣金总金额


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_commission_list);

        initTopTitle();
        initView();
        initListener();
        requestData();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.title_commission_detail))
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
        currentMonth = getIntent().getStringExtra("currentMonth");

        vs = (ViewSwitcher) findViewById(R.id.vs);
        swipe_refresh = (SwipeRefreshLayout) findViewById(R.id.swipe_refresh);
        recycler_view = (RecyclerView) findViewById(R.id.recycler_view);
        tv_count_commission = (TextView) findViewById(R.id.tv_count_commission);
        tv_total_commission = (TextView) findViewById(R.id.tv_total_commission);

        TextView tv_empty = (TextView) findViewById(R.id.tv_empty);
        tv_empty.setText("暂无佣金");

        initRecyclerView();
    }

    private void initRecyclerView() {
        recycler_view.setLayoutManager(new LinearLayoutManager(this));
        commissionListAdapter = new CommissionListAdapter(this, totalList);
        recycler_view.setAdapter(commissionListAdapter);
        //添加动画
        recycler_view.setItemAnimator(new DefaultItemAnimator());
    }

    private void initListener() {
        initPullRefresh();
        initLoadMoreListener();
    }

    /**
     *  佣金明细列表下拉监听
     */
    private void initPullRefresh() {
        swipe_refresh.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {  // 下拉刷新
                totalList.clear();
                currentPage = 1;
                requestData();
            }
        });
    }

    /**
     * 获取佣金明细列表数据
     */
    private void requestData() {
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("userId", userId);
        param.put("currentMonth", currentMonth);
        param.put("page", currentPage+"");

        HtmlRequest.getTradeRecordData(this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (swipe_refresh.isRefreshing()) {
                    //请求返回后，无论本次请求成功与否，都关闭下拉旋转
                    swipe_refresh.setRefreshing(false);
                }

                if (params==null || params.result == null) {
//                    vs.setDisplayedChild(1);
                    // Toast.makeText(mContext, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }
                TrackingList1B data = (TrackingList1B) params.result;
                tv_count_commission.setText(data.getTotal()+"份佣金");
                tv_total_commission.setText("共计"+data.getTotalCommission()+"元");

                everyList = data.getRecordList();
                if (everyList == null) {
                    return;
                }
                if (everyList.size() == 0 && currentPage != 1) {
                    Toast.makeText(mContext, "已显示全部", Toast.LENGTH_SHORT).show();
                    commissionListAdapter.changeMoreStatus(commissionListAdapter.NO_LOAD_MORE);
                }
                if (currentPage == 1) {
                    //刚进来时 加载第一页数据，或下拉刷新 重新加载数据 。这两种情况之前的数据都清掉
                    totalList.clear();
                }
                totalList.addAll(everyList);
                // 0:从后台获取到数据展示的布局；1：从后台没有获取到数据时展示的布局；
//                if (totalList.size() == 0) {
//                    vs.setDisplayedChild(1);
//                } else {
//                    vs.setDisplayedChild(0);
//                }
//                if (totalList.size() != 0 && totalList.size() % 10 == 0) {
//                    myAskAdapter.changeMoreStatus(myAskAdapter.PULLUP_LOAD_MORE);
//                } else {
//                    myAskAdapter.changeMoreStatus(myAskAdapter.NO_LOAD_MORE);
//                }
                if (everyList.size() != 10) {
                    // 本次取回的数据为不是10条，代表取完了
                    commissionListAdapter.changeMoreStatus(commissionListAdapter.NO_LOAD_MORE);
                } else {
                    // 其他，均显示“数据加载中”的提示
                    commissionListAdapter.changeMoreStatus(commissionListAdapter.PULLUP_LOAD_MORE);
                }
            }
        });
    }


    /**
     *  列表上拉监听
     */
    private void initLoadMoreListener() {
        recycler_view.setOnScrollListener(new RecyclerView.OnScrollListener() {
            private int firstVisibleItem = 0;
            private int lastVisibleItem = 0;

            @Override
            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
                //判断RecyclerView的状态 是空闲时，同时，是最后一个可见的ITEM时才加载
                if (newState == RecyclerView.SCROLL_STATE_IDLE && lastVisibleItem + 1 == commissionListAdapter.getItemCount() && firstVisibleItem != 0) {
                    if (everyList.size() == 0) {
                        return;
                    }
                    currentPage++;
                    requestData();
                }
            }

            @Override
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                LinearLayoutManager layoutManager = (LinearLayoutManager) recyclerView.getLayoutManager();
                firstVisibleItem = layoutManager.findFirstVisibleItemPosition();
                lastVisibleItem = layoutManager.findLastVisibleItemPosition();
            }
        });
    }
    @Override
    public void initData() {
    }
}
