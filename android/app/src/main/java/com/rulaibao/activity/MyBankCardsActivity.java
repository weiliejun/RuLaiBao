package com.rulaibao.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewSwitcher;

import com.rulaibao.R;
import com.rulaibao.adapter.MyBankCardsAdapter;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.BankCardList1B;
import com.rulaibao.bean.BankCardList2B;
import com.rulaibao.bean.OK2B;
import com.rulaibao.dialog.CancelNormalDialog;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.ViewUtils;
import com.rulaibao.widget.TitleBar;

import java.util.HashMap;
import java.util.LinkedHashMap;

/**
 * 我的银行卡
 * Created by hong on 2018/11/14.
 */

public class MyBankCardsActivity extends BaseActivity implements View.OnClickListener {

    private ViewSwitcher vs;
    private SwipeRefreshLayout swipe_refresh;
    private RecyclerView recycler_view;
    private MyBankCardsAdapter myBankCardsAdapter;
    private MouldList<BankCardList2B> totalList = new MouldList<>();
    private int currentPage = 1;    //当前页
    private Button btn_add_new_bank_card; //  新增银行卡
    private MouldList<BankCardList2B> everyList;
    private BankCardList1B data;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_my_bank_cards);

        initTopTitle();
        initView();
        initListener();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false).setIndicator(R.mipmap.icon_back)
             .setCenterText(getResources().getString(R.string.title_my_bank_cards)).showMore(false).setOnActionListener(new TitleBar.OnActionListener() {

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
        tv_empty.setText("暂无银行卡");
        btn_add_new_bank_card = (Button) findViewById(R.id.btn_add_new_bank_card);

        btn_add_new_bank_card.setOnClickListener(this);

        initRecylerView();
    }

    private void initRecylerView() {
        recycler_view.setLayoutManager(new LinearLayoutManager(this));
        myBankCardsAdapter = new MyBankCardsAdapter(this, totalList);
        myBankCardsAdapter.setBankCardDeleteClickListener(new MyBankCardsAdapter.OnBankCardDeleteClickListener() {
            @Override
            public void onDeleteClick(int position) { // 删除银行卡
                showDeleteDialog(position);
            }

            @Override
            public void setUpSalaryCard(int position,String isWageCard) { // 设置工资卡
                if (isWageCard.equals("0")) {
                    showSetUpDialog(position,"0");
                }
            }
        });
        recycler_view.setAdapter(myBankCardsAdapter);

        //添加动画
        recycler_view.setItemAnimator(new DefaultItemAnimator());
    }

    /**
     *  弹出删除银行卡提示框
     * @param position
     */
    private void showDeleteDialog(final int position) {
        CancelNormalDialog dialog = new CancelNormalDialog(this, new CancelNormalDialog.IsCancel() {
            @Override
            public void onConfirm() {
                requestDeleteData(position);
            }

            @Override
            public void onCancel() {
//                Toast.makeText(MyBankCardsActivity.this, "取消成功", Toast.LENGTH_LONG).show();
            }
        });
        dialog.setTitle("是否确定删除该银行卡？");
        dialog.show();
    }

    /**
     *  弹出设置工资卡的提示框
     * @param position
     */
    private void showSetUpDialog(final int position,final String isWageCard) {
        CancelNormalDialog dialog = new CancelNormalDialog(this, new CancelNormalDialog.IsCancel() {
            @Override
            public void onConfirm() {
                requestSetUpSalaryCardData(position);
            }

            @Override
            public void onCancel() {
//                Toast.makeText(MyBankCardsActivity.this, "取消成功", Toast.LENGTH_LONG).show();
            }
        });
        dialog.setTitle("确定设为工资卡吗？");
        dialog.show();
    }

    /**
     *  （我的银行卡）删除
     */
    private void requestDeleteData(final int position) {
        HashMap<String, Object> param = new HashMap<>();
        param.put("id", totalList.get(position).getId()); // 银行卡id
        param.put("userId", userId);

        HtmlRequest.deleteBankCardData(this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params==null || params.result == null) {
                    //    Toast.makeText(mContext, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }
                OK2B data = (OK2B) params.result;
                if (data.getFlag().equals("true")) {
                    Toast.makeText(mContext, data.getMessage(), Toast.LENGTH_LONG).show();
                    totalList.clear();
                    requestData();
                    recycler_view.scrollToPosition(0);
                } else {
                    Toast.makeText(mContext, data.getMessage(), Toast.LENGTH_LONG).show();
                }
            }
        });
    }
    /**
     *  （我的银行卡）设置工资卡
     */
    private void requestSetUpSalaryCardData(final int position) {
        HashMap<String, Object> param = new HashMap<>();
        param.put("id", totalList.get(position).getId()); // 银行卡id
        param.put("userId", userId);

        HtmlRequest.setUpSalaryCardData(this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params==null || params.result == null) {
                    //    Toast.makeText(mContext, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }
                OK2B data = (OK2B) params.result;
                if (data.getFlag().equals("true")) {
                    Toast.makeText(mContext, "工资卡设置成功", Toast.LENGTH_LONG).show();
                    totalList.clear();
                    requestData();
                    recycler_view.scrollToPosition(0);
                } else {
                    Toast.makeText(mContext, data.getMessage(), Toast.LENGTH_LONG).show();
                }
            }
        });
    }

    private void initListener() {
        initPullRefresh();
//        initLoadMoreListener();
    }

    /**
     *  列表下拉监听
     */
    private void initPullRefresh() {
        swipe_refresh.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {  // 下拉刷新
                totalList.clear();
//                currentPage = 1;
                requestData();
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
                if (newState == RecyclerView.SCROLL_STATE_IDLE && lastVisibleItem + 1 == myBankCardsAdapter.getItemCount() && firstVisibleItem != 0) {
                    if (everyList.size() == 0) {
                        return;
                    }
//                    currentPage++;
//                    requestData();
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

    @Override
    protected void onResume() {
        super.onResume();
        totalList.clear();
        requestData();
    }

    /**
     *  获取银行卡列表 数据
     */
    private void requestData() {
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("userId", userId);

        HtmlRequest.getBankCardListData(this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (swipe_refresh.isRefreshing()) {
                    //请求返回后，无论本次请求成功与否，都关闭下拉旋转
                    swipe_refresh.setRefreshing(false);
                }

                if (params==null || params.result == null) {
                    vs.setDisplayedChild(1);
                    // Toast.makeText(mContext, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }
                data = (BankCardList1B) params.result;
                everyList = data.getUserBankCardList();
                if (everyList == null) {
                    return;
                }
//                if (everyList.size() == 0 && currentPage != 1) {
//                    Toast.makeText(mContext, "已显示全部", Toast.LENGTH_SHORT).show();
//                    myBankCardsAdapter.changeMoreStatus(myBankCardsAdapter.NO_LOAD_MORE);
//                }
//                if (currentPage == 1) {
//                    //刚进来时 加载第一页数据，或下拉刷新 重新加载数据 。这两种情况之前的数据都清掉
//                    totalList.clear();
//                }
                totalList.addAll(everyList);
                myBankCardsAdapter.changeMoreStatus(myBankCardsAdapter.NO_LOAD_MORE);
                // 0:从后台获取到数据展示的布局；1：从后台没有获取到数据时展示的布局；
                if (totalList.size() == 0) {
                    vs.setDisplayedChild(1);
                } else {
                    vs.setDisplayedChild(0);
                }

//                if (everyList.size() != 10) {
//                    // 本次取回的数据为不是10条，代表取完了
//                    myBankCardsAdapter.changeMoreStatus(myBankCardsAdapter.NO_LOAD_MORE);
//                } else {
//                    // 其他，均显示“数据加载中”的提示
//                    myBankCardsAdapter.changeMoreStatus(myBankCardsAdapter.PULLUP_LOAD_MORE);
//                }
            }
        });
    }

    @Override
    public void onClick(View v) {
        Intent intent;
        switch (v.getId()) {
            case R.id.btn_add_new_bank_card: // 新增银行卡
                if (PreferenceUtil.getCheckStatus().equals("success")) { // 已认证的跳转新增银行卡页面
                    intent = new Intent(this, AddNewBankCardActivity.class);
                    startActivity(intent);
                } else { // 未销售认证的提示认证
                    ViewUtils.showToSaleCertificationDialog(this, "您还未认证，是否去认证");
                }
        }

    }
}
