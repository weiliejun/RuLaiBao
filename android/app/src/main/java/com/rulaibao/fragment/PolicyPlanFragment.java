package com.rulaibao.fragment;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewSwitcher;

import com.rulaibao.R;
import com.rulaibao.activity.LoginActivity;
import com.rulaibao.activity.SearchForPolicyPlanActivity;
import com.rulaibao.adapter.PolicyPlanListAdapter;
import com.rulaibao.adapter.TrainingHotAskListAdapter;
import com.rulaibao.bean.Login2B;
import com.rulaibao.bean.PolicyPlan2B;
import com.rulaibao.bean.PolicyPlan3B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.encrypt.DESUtil;

import java.util.LinkedHashMap;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * 保单规划
 */

public class PolicyPlanFragment extends Fragment implements View.OnClickListener{
    @BindView(R.id.lv_policy_plan)
    RecyclerView lvPolicyPlan;

    private View mView;
    private Context context;
    private ImageView iv_right_btn;
    private PolicyPlanListAdapter adapter;
    private MouldList<PolicyPlan3B> totalList = new MouldList<>();
    private ViewSwitcher vs;
    private FrameLayout fl_nologin;
    private Button btn_login;
    private Intent intent;
    private Login2B bean;
    private boolean isRefresh = true;      //  处理刷新数据

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        if (mView == null) {
            mView = inflater.inflate(R.layout.fragment_policy_plan, container, false);
            ButterKnife.bind(this, mView);
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
        if (PreferenceUtil.isLogin()) {
            fl_nologin.setVisibility(View.GONE);
            vs.setVisibility(View.VISIBLE);
            iv_right_btn.setVisibility(View.VISIBLE);
            if(isRefresh){
                requestListData();
            }

        } else {
            fl_nologin.setVisibility(View.VISIBLE);
            iv_right_btn.setVisibility(View.GONE);
            vs.setVisibility(View.GONE);
        }
    }

    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            if (context != null) {
                isRefresh = false;
                if (PreferenceUtil.isLogin()) {
                    fl_nologin.setVisibility(View.GONE);
                    vs.setVisibility(View.VISIBLE);
                    iv_right_btn.setVisibility(View.VISIBLE);
                    requestListData();

                } else {
                    fl_nologin.setVisibility(View.VISIBLE);
                    iv_right_btn.setVisibility(View.GONE);
                    vs.setVisibility(View.GONE);
                }
            }

        } else {
            isRefresh = true;
        }

    }

    private void initView(View mView) {
        context = getActivity();
        iv_right_btn = (ImageView) mView.findViewById(R.id.iv_right_btn);
        iv_right_btn.setOnClickListener(this);
        vs = (ViewSwitcher) mView.findViewById(R.id.vs);
        TextView tv_empty = (TextView) mView.findViewById(R.id.tv_empty);
        tv_empty.setText("暂无保单规划");

        fl_nologin = (FrameLayout) mView.findViewById(R.id.fl_nologin);
        btn_login = (Button) mView.findViewById(R.id.btn_login);
        btn_login.setOnClickListener(this);

        lvPolicyPlan.setLayoutManager(new LinearLayoutManager(getActivity()));
        adapter = new PolicyPlanListAdapter(getActivity(), totalList);
        lvPolicyPlan.setAdapter(adapter);


        lvPolicyPlan.setOnScrollListener(new RecyclerView.OnScrollListener() {
            int lastVisibleItem;

            @Override
            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);

            }

            @Override
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                LinearLayoutManager layoutManager = (LinearLayoutManager) recyclerView.getLayoutManager();
                //最后一个可见的ITEM
                lastVisibleItem = layoutManager.findLastVisibleItemPosition();


            }
        });

    }

    /**
     * 获取保单规划数据
     */
    private void requestListData() {
        String userId = null;
        try {
            userId = DESUtil.decrypt(PreferenceUtil.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("userId", userId);
        param.put("customerName", "");

        try {
            HtmlRequest.getPolicyPlanData(context, param, new BaseRequester.OnRequestListener() {
                @Override
                public void onRequestFinished(BaseParams params) {
                    if (params == null || params.result == null) {
                        vs.setDisplayedChild(1);
                   //     Toast.makeText(context, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                        return;
                    }
                    PolicyPlan2B data = (PolicyPlan2B) params.result;
                    if ("true".equals(data.getFlag())) {
                        MouldList<PolicyPlan3B> everyList = data.getList();

                        totalList.clear();
                        totalList.addAll(everyList);
                        if (totalList.size() == 0) {
                            vs.setDisplayedChild(1);
                        } else {
                            vs.setDisplayedChild(0);
                        }
                        adapter.changeMoreStatus(TrainingHotAskListAdapter.NO_LOAD_MORE);
                        adapter.notifyDataSetChanged();
                    } else {
                        vs.setDisplayedChild(1);
                        //            Toast.makeText(context, data.getMessage(), Toast.LENGTH_LONG).show();
                    }

                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_right_btn:
                if (PreferenceUtil.isLogin()) {
                    if ("success".equals(PreferenceUtil.getCheckStatus())){
                        intent = new Intent(context, SearchForPolicyPlanActivity.class);
                        context.startActivity(intent);
                    }else{
                        Toast.makeText(context, "请到账户中心进行认证。", Toast.LENGTH_LONG).show();
                    }
                }else{
                    intent = new Intent(context, LoginActivity.class);
                    context.startActivity(intent);
                }

                break;
            case R.id.btn_login:
                intent = new Intent(context, LoginActivity.class);
                context.startActivity(intent);
                break;
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        isRefresh = true;
    }
}
