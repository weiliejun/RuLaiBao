package com.rulaibao.fragment;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
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
import com.rulaibao.adapter.MyCollectionRecycleAdapter;
import com.rulaibao.bean.Collection2B;
import com.rulaibao.bean.MyCollectionList1B;
import com.rulaibao.bean.MyCollectionList2B;
import com.rulaibao.dialog.CancelNormalDialog;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;

import java.util.LinkedHashMap;


public class MyCollectionFragment extends Fragment {
    private static final String KEY = "param1";

    private String mParam1;
    private SwipeRefreshLayout swipe_refresh;
    private RecyclerView recycler_view;
    private MyCollectionRecycleAdapter myCollectionRecycleAdapter;
    private MouldList<MyCollectionList2B> totalList = new MouldList<>();
    private Context context;
    private int currentPage = 1;
    private String type;
    private String userId;
    private ViewSwitcher vs;
    private MouldList<MyCollectionList2B> everyList;


    public static MyCollectionFragment newInstance(String param1) {
        MyCollectionFragment fragment = new MyCollectionFragment();
        Bundle bundle = new Bundle();
        bundle.putString(KEY, param1);
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        this.context = context;
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            totalList.clear();
            currentPage = 1;
            requestData();
        } else {
            if (myCollectionRecycleAdapter != null) {
                totalList.clear();
                currentPage = 1;
                myCollectionRecycleAdapter.changeMoreStatus(myCollectionRecycleAdapter.NO_LOAD_MORE);
            }
        }
    }

    /**
     * 获取收藏列表 数据
     */
    private void requestData() {
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("userId", userId);
        param.put("page", currentPage + "");
        param.put("category", type);

//        Log.i("hh", this + "userId ------ " + userId);
        Log.i("hh", this + "category ------ " + type);

        HtmlRequest.getCollectionListData(context, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (swipe_refresh.isRefreshing()) {
                    //请求返回后，无论本次请求成功与否，都关闭下拉旋转
                    swipe_refresh.setRefreshing(false);
                }

                if (params == null || params.result == null) {
                    vs.setDisplayedChild(1);
//                    Toast.makeText(context, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }

                MyCollectionList1B data = (MyCollectionList1B) params.result;
                everyList = data.getList();
                if (everyList == null) {
                    vs.setDisplayedChild(1);
                    return;
                }
                if (everyList.size() == 0 && currentPage != 1) {
                    Toast.makeText(context, "已显示全部", Toast.LENGTH_SHORT).show();
                    myCollectionRecycleAdapter.changeMoreStatus(myCollectionRecycleAdapter.NO_LOAD_MORE);
                    return;
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

                if (everyList.size() != 10) {
                    // 本次取回的数据为不是10条，代表取完了
                    myCollectionRecycleAdapter.changeMoreStatus(myCollectionRecycleAdapter.NO_LOAD_MORE);
                } else {
                    // 其他，均显示“数据加载中”的提示
                    myCollectionRecycleAdapter.changeMoreStatus(myCollectionRecycleAdapter.PULLUP_LOAD_MORE);
                }
            }
        });
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mParam1 = getArguments().getString(KEY);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_recycle_layout, container, false);
        initView(view);
        initListener();
        return view;
    }

    private void initView(View view) {
        vs = (ViewSwitcher) view.findViewById(R.id.vs);
        swipe_refresh = (SwipeRefreshLayout) view.findViewById(R.id.swipe_refresh);
        recycler_view = (RecyclerView) view.findViewById(R.id.recycler_view);
        TextView tv_empty = (TextView) view.findViewById(R.id.tv_empty);
        tv_empty.setText("暂无收藏");


        initRecyclerView();
    }

    private void initRecyclerView() {
        recycler_view.setLayoutManager(new LinearLayoutManager(getActivity()));
        myCollectionRecycleAdapter = new MyCollectionRecycleAdapter(getActivity(), userId, totalList);
        myCollectionRecycleAdapter.setCollectionListener(new MyCollectionRecycleAdapter.CollectionItemClickListener() {
            @Override
            public void showDialog(int position) {
                showCancelCollectionDialog(position);
            }
        });
        recycler_view.setAdapter(myCollectionRecycleAdapter);
        //添加动画
        recycler_view.setItemAnimator(new DefaultItemAnimator());

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
                if (newState == RecyclerView.SCROLL_STATE_IDLE && lastVisibleItem + 1 == myCollectionRecycleAdapter.getItemCount() && firstVisibleItem != 0) {
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

    // 长按弹出的对话框
    private void showCancelCollectionDialog(final int position) {
        CancelNormalDialog dialog = new CancelNormalDialog(context, new CancelNormalDialog.IsCancel() {
            @Override
            public void onConfirm() {
                requestCollectionCanceled(position);
//                Toast.makeText(context, "取消成功", Toast.LENGTH_LONG).show();
            }

            @Override
            public void onCancel() {
            }
        });
        dialog.setTitle("确认取消收藏？");
        dialog.show();
    }

    /**
     * 取消收藏
     *
     * @param position
     */
    private void requestCollectionCanceled(int position) {
        final LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("userId", userId);
        param.put("productId", totalList.get(position).getProductId());
        param.put("dataStatus", "invalid");
        param.put("collectionId", totalList.get(position).getCollectionId());
        HtmlRequest.collection(context, param, new BaseRequester.OnRequestListener() {

            @Override
            public void onRequestFinished(BaseParams params) {
                if (param == null || params.result == null) {
                    //     Toast.makeText(context, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }
                Collection2B data = (Collection2B) params.result;
                if ("true".equals(data.getFlag())) {
                    currentPage = 1;
                    requestData();
                    Toast.makeText(context, data.getMessage(), Toast.LENGTH_LONG).show();
                } else {
                    Toast.makeText(context, data.getMessage(), Toast.LENGTH_LONG).show();

                }
            }
        });
    }

    public void getTabTitleCurrentPosition(int currentPosition) {
        if (currentPosition == 0) {
            type = "";  //默认请求"全部"的数据
        } else if (currentPosition == 1) {
            type = "criticalIllness";  //重疾险
        } else if (currentPosition == 2) {
            type = "annuity";  //年金险
        } else if (currentPosition == 3) {
            type = "wholeLife";  //终身寿险
        } else if (currentPosition == 4) {
            type = "accident";  //意外险
        } else if (currentPosition == 5) {
            type = "medical";  //医疗险
        } else if (currentPosition == 6) {
            type = "oldSmall";  //一老一小
        } else if (currentPosition == 7) {
            type = "enterpriseGroup";  //企业团体
        }
    }

    public String setUserId(String userId) {
        this.userId = userId;
        return userId;
    }
}