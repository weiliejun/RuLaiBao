package com.rulaibao.fragment;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewSwitcher;

import com.rulaibao.R;
import com.rulaibao.activity.PolicyRecordListActivity;
import com.rulaibao.activity.TransactionRecordActivity;
import com.rulaibao.adapter.PolicyRecordAdapter;
import com.rulaibao.bean.PolicyRecordList1B;
import com.rulaibao.bean.PolicyRecordList2B;
import com.rulaibao.bean.TrackingList1B;
import com.rulaibao.bean.TrackingList2B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;

import java.util.LinkedHashMap;


public class PolicyRecordListFragment extends Fragment {
    private static final String KEY = "param1";

    private String mParam1;
    private SwipeRefreshLayout swipe_refresh;
    private RecyclerView recycler_view;
    private PolicyRecordAdapter policyRecordAdapter;
    private MouldList<PolicyRecordList2B> totalList = new MouldList<>();
    private int currentPage = 1; //当前页
    private Context context;
    private PolicyRecordList1B data;
    private String status = "";
    private String userId = "";
    private ViewSwitcher vs;
    private MouldList<PolicyRecordList2B> everyList;


    public static PolicyRecordListFragment newInstance(String param1) {
        PolicyRecordListFragment fragment = new PolicyRecordListFragment();
        Bundle bundle = new Bundle();
        bundle.putString(KEY, param1);
        fragment.setArguments(bundle);
//        Log.i("hh", "PolicyRecordListFragment --" + fragment);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mParam1 = getArguments().getString(KEY);
        }
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        this.context = context;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_recycle_layout, container, false);
        initView(view);
        initListener();
        return view;
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            //页面可见时调接口刷新数据
//            Log.i("hh", this + " -- setUserVisibleHint --" + isVisibleToUser);
            totalList.clear();
            currentPage = 1;
            requestData();
        } else {
//            Log.i("hh", this + " -- setUserVisibleHint --" + isVisibleToUser);
            if (policyRecordAdapter != null) {
                totalList.clear();
                currentPage = 1;
                policyRecordAdapter.changeMoreStatus(policyRecordAdapter.NO_LOAD_MORE);
            }
        }
    }

    private void initView(View view) {
        vs = (ViewSwitcher) view.findViewById(R.id.vs);
        swipe_refresh = (SwipeRefreshLayout) view.findViewById(R.id.swipe_refresh);
        recycler_view = (RecyclerView) view.findViewById(R.id.recycler_view);

        TextView tv_empty = (TextView) view.findViewById(R.id.tv_empty);
        tv_empty.setText("暂无保单记录");

        initRecyclerView();
    }

    private void initRecyclerView() {
        recycler_view.setLayoutManager(new LinearLayoutManager(getActivity()));
        policyRecordAdapter = new PolicyRecordAdapter(getActivity(), totalList);
        recycler_view.setAdapter(policyRecordAdapter);
        //添加动画
        recycler_view.setItemAnimator(new DefaultItemAnimator());
    }

    private void initListener() {
        initPullRefresh();
        initLoadMoreListener();
    }

    // 列表下拉监听
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

    // 列表上拉监听
    private void initLoadMoreListener() {
        recycler_view.setOnScrollListener(new RecyclerView.OnScrollListener() {
            private int firstVisibleItem = 0;
            private int lastVisibleItem = 0;

            @Override
            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
                //判断RecyclerView的状态 是空闲时，同时，是最后一个可见的ITEM时才加载
                if (newState == RecyclerView.SCROLL_STATE_IDLE && lastVisibleItem + 1 == policyRecordAdapter.getItemCount() && firstVisibleItem != 0) {
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

    public void requestData() {
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("userId", userId);
        param.put("page", currentPage + "");
        param.put("status", status);

//        Log.i("hh", this + " 保单列表 -- userId: " + userId);
//        Log.i("hh", this + " 保单列表 -- page: " + currentPage);
//        Log.i("hh", this + " 保单列表 -- status: " + status);

        HtmlRequest.getPolicyRecordListData(context, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (swipe_refresh.isRefreshing()) {
                    //请求返回后，无论本次请求成功与否，都关闭下拉旋转
                    swipe_refresh.setRefreshing(false);
                }

                if (params == null || params.result == null) {
                    vs.setDisplayedChild(1);
                    //     Toast.makeText(context, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }

                data = (PolicyRecordList1B) params.result;

                // 没有认证的用户无保单记录
                if ("false".equals(data.getFlag())) {
                    vs.setDisplayedChild(1);
//                    Toast.makeText(context, data.getMessage() + "", Toast.LENGTH_SHORT).show();
                    policyRecordAdapter.changeMoreStatus(policyRecordAdapter.NO_LOAD_MORE);
                    return;
                }

                // 更新顶部 Tab 数据
                ((PolicyRecordListActivity) context).refreshTabTitle(data);

                everyList = data.getList();
                if (everyList == null) {
                    vs.setDisplayedChild(1);
                    return;
                }
                if (everyList.size() == 0 && currentPage != 1) {
                    Toast.makeText(context, "已显示全部", Toast.LENGTH_SHORT).show();
                    policyRecordAdapter.changeMoreStatus(policyRecordAdapter.NO_LOAD_MORE);
                }
                if (currentPage == 1) {
                    //刚进来时 加载第一页数据，或下拉刷新 重新加载数据 。这两种情况之前的数据都清掉
                    totalList.clear();
                }
                //模拟数据
//                if (everyList.size() != 0) {
//                    while (everyList.size() < 10) {
//                        everyList.add(everyList.get(0));
//                    }
//                }
                totalList.addAll(everyList);
                // 0:从后台获取到数据展示的布局；1：从后台没有获取到数据时展示的布局；
                if (totalList.size() == 0) {
                    vs.setDisplayedChild(1);
                    return;
                }
                vs.setDisplayedChild(0);

                if (everyList.size() != 10) {
                    // 本次取回的数据为不是10条，代表取完了
                    policyRecordAdapter.changeMoreStatus(policyRecordAdapter.NO_LOAD_MORE);
                } else {
                    // 其他，均显示“数据加载中”的提示
                    policyRecordAdapter.changeMoreStatus(policyRecordAdapter.PULLUP_LOAD_MORE);
                }

            }
        });
    }

    public void getTabTitleCurrentPosition(int currentPosition) {
        if (currentPosition == 0) {
            status = "all";  //保单列表中全部数量=待审核+已承保+问题件+回执签收
        } else if (currentPosition == 1) {
            status = "init";  //待审核
        } else if (currentPosition == 2) {
            status = "payed";  //已承保
        } else if (currentPosition == 3) {
            status = "rejected";  //问题件
        } else if (currentPosition == 4) {
            status = "receiptSigned";  //回执签收
        }
    }

    public String setUserId(String userId) {
        this.userId = userId;
        return userId;
    }
}