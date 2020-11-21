package com.rulaibao.activity;

import android.os.Bundle;
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
import com.rulaibao.adapter.RenewalReminderAdapter;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.PolicyRecordDetail1B;
import com.rulaibao.bean.PolicyRecordList2B;
import com.rulaibao.bean.RenewalReminderList1B;
import com.rulaibao.bean.RenewalReminderList2B;
import com.rulaibao.bean.TrackingList1B;
import com.rulaibao.bean.TrackingList2B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.widget.TitleBar;

import java.util.LinkedHashMap;

/**
 * 续保提醒
 * Created by junde on 2018/4/18.
 */

public class RenewalReminderActivity extends BaseActivity implements View.OnClickListener {

    private SwipeRefreshLayout swipe_refresh;
    private RecyclerView recycler_view;
    private RenewalReminderAdapter renewalReminderAdapter;
    private MouldList<RenewalReminderList2B> totalList = new MouldList<>();
    private int currentPage = 1;    //当前页
    private ViewSwitcher vs;

    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_renewal_reminder);

        initTopTitle();
        initView();
        requestData();
        initListener();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
             .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.title_renewal_reminder))
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
        vs = (ViewSwitcher) findViewById(R.id.vs);
        swipe_refresh = (SwipeRefreshLayout) findViewById(R.id.swipe_refresh);
        recycler_view = (RecyclerView) findViewById(R.id.recycler_view);

        TextView tv_empty = (TextView) findViewById(R.id.tv_empty);
        tv_empty.setText("暂无待续保保单");

        initRecylerView();
    }

    private void initRecylerView() {
        recycler_view.setLayoutManager(new LinearLayoutManager(this));
        renewalReminderAdapter = new RenewalReminderAdapter(this, totalList);
        recycler_view.setAdapter(renewalReminderAdapter);
        //添加动画
        recycler_view.setItemAnimator(new DefaultItemAnimator());

    }

    /**
     * 获取续保提醒列表数据
     */
    private void requestData() {
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("userId", userId);
        param.put("page", currentPage + "");

        HtmlRequest.getRenewalReminderData(this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (swipe_refresh.isRefreshing()) {
                    //请求返回后，无论本次请求成功与否，都关闭下拉旋转
                    swipe_refresh.setRefreshing(false);
                }

                if (params==null || params.result == null) {
                    vs.setDisplayedChild(1);
                //    Toast.makeText(RenewalReminderActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }

                RenewalReminderList1B data = (RenewalReminderList1B) params.result;
                // 没有认证的用户 无续保提醒
                if ("false".equals(data.getFlag())) {
                    vs.setDisplayedChild(1);
//                    Toast.makeText(mContext, data.getMessage() + "", Toast.LENGTH_SHORT).show();
                    renewalReminderAdapter.changeMoreStatus(renewalReminderAdapter.NO_LOAD_MORE);
                    return;
                }
                MouldList<RenewalReminderList2B> everyList = data.getList();
                if (everyList == null) {
                    vs.setDisplayedChild(1);
                    return;
                }

                if (everyList.size() == 0 && currentPage != 1) {
                    Toast.makeText(mContext, "已显示全部", Toast.LENGTH_SHORT).show();
                    renewalReminderAdapter.changeMoreStatus(renewalReminderAdapter.NO_LOAD_MORE);
                }
                if (currentPage == 1) {
                    //刚进来时 加载第一页数据，或下拉刷新 重新加载数据 。这两种情况之前的数据都清掉
                    totalList.clear();
                }
                totalList.addAll(everyList);
                // 0:从后台获取到数据展示的布局；1：从后台没有获取到数据时展示的布局；
                if (totalList.size() == 0) {
                    vs.setDisplayedChild(1);
                    return;
                }

                vs.setDisplayedChild(0);
                if (totalList.size() % 10 == 0) {
                    renewalReminderAdapter.changeMoreStatus(renewalReminderAdapter.PULLUP_LOAD_MORE);
                } else {
                    renewalReminderAdapter.changeMoreStatus(renewalReminderAdapter.NO_LOAD_MORE);
                }
            }
        });
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
                requestData();

                //刷新完成
                swipe_refresh.setRefreshing(false);
//                new Handler().postDelayed(new Runnable() {
//                    @Override
//                    public void run() {
//                        List<String> headDatas = new ArrayList<String>();
//                        for (int i = 20; i <30 ; i++) {
//                            headDatas.add("Heard Item "+i);
//                        }
//                        transactionRecordAdapter.AddHeaderItem(headDatas);
//
//                        //刷新完成
//                        swipe_refresh.setRefreshing(false);
//                        Toast.makeText(TransactionRecordActivity.this, "更新了 "+headDatas.size()+" 条目数据", Toast.LENGTH_SHORT).show();
//                    }
//                }, 3000);

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
                if (newState == RecyclerView.SCROLL_STATE_IDLE && lastVisibleItem + 1 == renewalReminderAdapter.getItemCount() && firstVisibleItem != 0) {

                    //设置正在加载更多
//                    transactionRecordAdapter.changeMoreStatus(transactionRecordAdapter.LOADING_MORE);

                    currentPage++;
                    requestData();

                    //改为网络请求
//                    new Handler().postDelayed(new Runnable() {
//                        @Override
//                        public void run() {
//                            //
//                            List<String> footerDatas = new ArrayList<String>();
//                            for (int i = 0; i< 10; i++) {
//                                footerDatas.add("footer  item" + i);
//                            }
//                            transactionRecordAdapter.AddFooterItem(footerDatas);
//                            //设置回到上拉加载更多
//                            transactionRecordAdapter.changeMoreStatus(transactionRecordAdapter.PULLUP_LOAD_MORE);
//                            //没有加载更多了
//                            //mRefreshAdapter.changeMoreStatus(mRefreshAdapter.NO_LOAD_MORE);
//                            Toast.makeText(TransactionRecordActivity.this, "更新了 "+footerDatas.size()+" 条目数据", Toast.LENGTH_SHORT).show();
//                        }
//                    }, 3000);
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
    public void onClick(View v) {

    }
}
