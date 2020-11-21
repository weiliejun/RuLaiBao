package com.rulaibao.activity;

import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewSwitcher;

import com.rulaibao.R;
import com.rulaibao.adapter.NewMembersCircleAdapter;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.CommissionNewsList1B;
import com.rulaibao.bean.CommissionNewsList2B;
import com.rulaibao.bean.NewMembersCircleList1B;
import com.rulaibao.bean.NewMembersCircleList2B;
import com.rulaibao.bean.OK2B;
import com.rulaibao.dialog.DeleteHistoryDialog;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.widget.TitleBar;

import java.util.HashMap;

/**
 * 圈子新成员
 * Created by junde on 2018/4/24.
 */

public class NewMembersOfCircleActivity extends BaseActivity {
    private SwipeRefreshLayout swipe_refresh;
    private RecyclerView recycler_view;
    private NewMembersCircleAdapter newMembersCircleAdapter;
    private MouldList<NewMembersCircleList2B> totalList = new MouldList<>();
    private int currentPage = 1; // 当前页
    private ViewSwitcher vs;

    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_same_list_layout);

        initTopTitle();
        initView();
        requestData();
        initListener();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.title_new_members_of_circle))
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
        tv_empty.setText("暂无申请");

        initRecylerView();
    }

    private void initRecylerView() {
        recycler_view.setLayoutManager(new LinearLayoutManager(this));
        newMembersCircleAdapter = new NewMembersCircleAdapter(this, userId, totalList);
        newMembersCircleAdapter.setMyItemClickListener(new NewMembersCircleAdapter.OnMyItemClickListener() {
            @Override
            public void onBtnClick(int position) { // 同意按钮的回调
//                Log.i("hh", "buttonAgreeClickListener --- " + userId);
                requestAgreeData(position);
            }

            @Override
            public void showDialog(int position) {// 长按删除时先弹框
                showDeleteDialog(position);
            }
        });
        recycler_view.setAdapter(newMembersCircleAdapter);
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
            public void onRefresh() {
                currentPage = 1;
                requestData();
            }
        });
    }

    private void initLoadMoreListener() {
        recycler_view.setOnScrollListener(new RecyclerView.OnScrollListener() {
            private int lastVisibleItem = 0;
            private int firstVisibleItem = 0;

            @Override
            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);

                //判断RecyclerView的状态 是空闲时，同时，是最后一个可见的ITEM时才加载
                if (newState == RecyclerView.SCROLL_STATE_IDLE && lastVisibleItem + 1 == newMembersCircleAdapter.getItemCount() && firstVisibleItem != 0) {

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

    private void requestData() {
        HashMap<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("page", currentPage + "");

        HtmlRequest.getNemMembersCircleList(NewMembersOfCircleActivity.this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (swipe_refresh.isRefreshing()) {
                    //请求返回后，无论本次请求成功与否，都关闭下拉旋转
                    swipe_refresh.setRefreshing(false);
                }

                if (params==null || params.result == null) {
                    vs.setDisplayedChild(1);
                 //   Toast.makeText(NewMembersOfCircleActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }

                NewMembersCircleList1B data = (NewMembersCircleList1B) params.result;
                MouldList<NewMembersCircleList2B> everyList = data.getList();
                if (everyList == null) {
                    return;
                }
                if (everyList.size() == 0 && currentPage != 1) {
                    Toast.makeText(NewMembersOfCircleActivity.this, "已显示全部", Toast.LENGTH_SHORT).show();
                    newMembersCircleAdapter.changeMoreStatus(newMembersCircleAdapter.NO_LOAD_MORE);
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
                    newMembersCircleAdapter.changeMoreStatus(newMembersCircleAdapter.PULLUP_LOAD_MORE);
                } else {
                    newMembersCircleAdapter.changeMoreStatus(newMembersCircleAdapter.NO_LOAD_MORE);
                }
            }
        });
    }


    /**
     * 同意申请时调的接口
     */
    private void requestAgreeData(final int position) {
        HashMap<String, Object> param = new HashMap<>();
        param.put("applyId", totalList.get(position).getApplyId());
        param.put("userId", userId);

        HtmlRequest.getCircleApplyAgreeData(this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params==null || params.result == null) {
                //    Toast.makeText(mContext, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }
                OK2B data = (OK2B) params.result;
                if (data.getFlag().equals("true")) {
                    Toast.makeText(mContext, "加入成功", Toast.LENGTH_LONG).show();
                    currentPage = 1;
                    requestData();
                } else {
                    Toast.makeText(mContext, data.getMessage(), Toast.LENGTH_LONG).show();
                    if (data.getMessage().equals("您已经在圈子里")) {
                        currentPage = 1;
                        requestData();
                    }
                }
            }
        });
    }

    private void showDeleteDialog(final int position) {
        DeleteHistoryDialog dialog = new DeleteHistoryDialog(mContext, new DeleteHistoryDialog.OnExitChanged() {

            @Override
            public void onConfirm() {
                requestDeleteData(position);
            }

            @Override
            public void onCancel() {

            }
        }, "确定删除该申请吗？");
        dialog.show();
    }

    /**
     * 删除成员申请信息
     *
     * @param position
     */
    private void requestDeleteData(final int position) {
        HashMap<String, Object> param = new HashMap<>();
        param.put("applyId", totalList.get(position).getApplyId());
        param.put("userId", userId);

        HtmlRequest.getDeletCircleApplyData(mContext, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params==null || params.result == null) {
              //      Toast.makeText(mContext, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }
                OK2B data = (OK2B) params.result;
                if (data != null) {
                    if (data.getFlag().equals("true")) {
                        Toast.makeText(mContext, " 删除成功", Toast.LENGTH_LONG).show();
                        currentPage = 1;
                        requestData();
                    } else {
                        Toast.makeText(mContext, data.getMessage(), Toast.LENGTH_LONG).show();
                    }
                }
            }
        });
    }
}
