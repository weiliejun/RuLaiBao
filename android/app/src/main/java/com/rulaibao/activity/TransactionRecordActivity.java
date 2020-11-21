package com.rulaibao.activity;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewSwitcher;

import com.rulaibao.R;
import com.rulaibao.adapter.TransactionRecordAdapter;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.RecommendRecordList1B;
import com.rulaibao.bean.RecommendRecordList2B;
import com.rulaibao.bean.TrackingList1B;
import com.rulaibao.bean.TrackingList2B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.ActivityStack;
import com.rulaibao.widget.TitleBar;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

/**
 * 交易记录页面
 * Created by hong on 2018/4/10
 */
public class TransactionRecordActivity extends BaseActivity {

    private ActivityStack stack;
    private Intent intent;
    private TextView tv_total_commission; // 佣金总额
    private SwipeRefreshLayout swipe_refresh;
    private RecyclerView recycler_view;
    private MouldList<TrackingList2B> totalList = new MouldList<>();
    private TransactionRecordAdapter transactionRecordAdapter;
    private int currentPage = 1;    //当前页
    private String totalCommission;
    private ViewSwitcher vs;

    @Override
    public void initData() {
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_transaction_record);

        initTopTitle();
        initView();
        requestTrackingRecordData();
        initListener();

    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
             .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.title_transaction_record))
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
        stack = ActivityStack.getActivityManage();
        stack.addActivity(this);
        totalCommission = getIntent().getStringExtra("totalCommission");

        tv_total_commission = (TextView) findViewById(R.id.tv_total_commission);
        vs = (ViewSwitcher) findViewById(R.id.vs);
        swipe_refresh = (SwipeRefreshLayout) findViewById(R.id.swipe_refresh);
        recycler_view = (RecyclerView) findViewById(R.id.recycler_view);
//        tv_total_commission.setText(totalCommission+"元");

        TextView tv_empty = (TextView) findViewById(R.id.tv_empty);
        tv_empty.setText("暂无交易记录");

        initRecylerView();
    }

    private void initRecylerView() {
        recycler_view.setLayoutManager(new LinearLayoutManager(this));
        transactionRecordAdapter = new TransactionRecordAdapter(this, totalList);
        recycler_view.setAdapter(transactionRecordAdapter);
        //添加动画
        recycler_view.setItemAnimator(new DefaultItemAnimator());

        //添加分割线
//        recycler_view.addItemDecoration(new RefreshItemDecoration(this,RefreshItemDecoration.VERTICAL_LIST));
//        recycler_view.addItemDecoration(new RecyclerViewDivider(this, LinearLayoutManager.VERTICAL));
    }

    private void initListener() {
        initPullRefresh();
        initLoadMoreListener();
    }

    private void initPullRefresh() {
        swipe_refresh.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {  // 下拉刷新
                currentPage = 1;
                requestTrackingRecordData();
            }
        });
    }

    private void initLoadMoreListener() {
        recycler_view.setOnScrollListener(new RecyclerView.OnScrollListener() {
            private int firstVisibleItem;
            private int lastVisibleItem;
            @Override
            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);

                //判断RecyclerView的状态 是空闲时，同时，是最后一个可见的ITEM时才加载
                if(newState==RecyclerView.SCROLL_STATE_IDLE&&lastVisibleItem+1==transactionRecordAdapter.getItemCount()&& firstVisibleItem != 0){

                    //设置正在加载更多
//                    transactionRecordAdapter.changeMoreStatus(transactionRecordAdapter.LOADING_MORE);

                    currentPage ++;
                    requestTrackingRecordData();
                }

            }

            @Override
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);

                LinearLayoutManager layoutManager = (LinearLayoutManager) recyclerView.getLayoutManager();
                firstVisibleItem = layoutManager.findFirstVisibleItemPosition();
                lastVisibleItem=layoutManager.findLastVisibleItemPosition();
            }
        });
    }

    /**
     *  获取 交易记录数据
     */
    private void requestTrackingRecordData() {
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("userId", userId);
        param.put("page", currentPage + "");

        HtmlRequest.getTradeRecordData(TransactionRecordActivity.this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (swipe_refresh.isRefreshing()) {
                    //请求返回后，无论本次请求成功与否，都关闭下拉旋转
                    swipe_refresh.setRefreshing(false);
                }
                if (params==null || params.result == null) {
                    vs.setDisplayedChild(1);
                 //   Toast.makeText(TransactionRecordActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }

                TrackingList1B data = (TrackingList1B) params.result;
                tv_total_commission.setText(data.getTotalCommission());
                MouldList<TrackingList2B> everyList = data.getRecordList();
                if (everyList == null) {
                    return;
                }
                if ((everyList.size() == 0) && currentPage != 1) {
                    Toast.makeText(mContext, "已显示全部", Toast.LENGTH_SHORT).show();
                    transactionRecordAdapter.changeMoreStatus(transactionRecordAdapter.NO_LOAD_MORE);
                }
                if (currentPage == 1) {
                    //刚进来时 加载第一页数据，或下拉刷新 重新加载数据 。这两种情况之前的数据都清掉
                    totalList.clear();
                }
                totalList.addAll(everyList);
                // 0:从后台获取到数据展示的布局；1：从后台没有获取到数据时展示的布局；
                if (totalList.size() == 0) {
                    vs.setDisplayedChild(1);
                } else {
                    vs.setDisplayedChild(0);
                }
                if (totalList.size() != 0 && totalList.size() % 10 == 0) {
                    transactionRecordAdapter.changeMoreStatus(transactionRecordAdapter.PULLUP_LOAD_MORE);
                } else {
                    transactionRecordAdapter.changeMoreStatus(transactionRecordAdapter.NO_LOAD_MORE);
                }
            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onResume() {
        super.onResume();

    }

}
