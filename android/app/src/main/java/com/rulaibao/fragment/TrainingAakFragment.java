package com.rulaibao.fragment;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.adapter.RecyclerBaseAapter;
import com.rulaibao.adapter.TrainingAskListAdapter;
import com.rulaibao.adapter.TrainingClassListAdapter;
import com.rulaibao.adapter.TrainingHotAskListAdapter;
import com.rulaibao.bean.ResultAskIndexBean;
import com.rulaibao.bean.ResultAskIndexItemBean;
import com.rulaibao.bean.ResultAskTypeItemBean;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.RlbActivityManager;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.LinkedHashMap;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * 研修--问答frament
 */

public class TrainingAakFragment extends BaseFragment {

    private static final String KEY = "title";
    @BindView(R.id.lv_training_ask)
    RecyclerView lvTrainingAsk;
    private ArrayList arrayList = new ArrayList();
    private String string = "";
    private TrainingAskListAdapter adapter;
    private MouldList<ResultAskIndexItemBean> indexItemBeans;
    private int page = 1;
    private ResultAskTypeItemBean key;
    private boolean noDataFlag = true;      //  控制无数据不加载

    @Override
    protected View attachLayoutRes(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        if (mView == null) {
            mView = inflater.inflate(R.layout.fragment_training_ask, container, false);

        } else {
            if (mView.getParent() != null) {
                ((ViewGroup) mView.getParent()).removeView(mView);
            }
        }
        return mView;
    }

    @Override
    protected void initViews() {
        indexItemBeans = new MouldList<ResultAskIndexItemBean>();
        initRecyclerView();
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            if (context != null) {
                indexItemBeans.clear();
            }
            key = new ResultAskTypeItemBean();
            key = (ResultAskTypeItemBean) getArguments().getSerializable(KEY);
            page = 1;
            noDataFlag = true;
            requestAsk(key);

        } else {

        }
    }

    public void initRecyclerView() {

        lvTrainingAsk.setLayoutManager(new LinearLayoutManager(getActivity()));
        adapter = new TrainingAskListAdapter(getActivity(), indexItemBeans);
        lvTrainingAsk.setAdapter(adapter);
        lvTrainingAsk.setOnScrollListener(new RecyclerView.OnScrollListener() {
            int lastVisibleItem;

            @Override
            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
                if (newState == RecyclerView.SCROLL_STATE_IDLE && lastVisibleItem + 1 == adapter.getItemCount()) {

                    if (noDataFlag) {
                        adapter.changeMoreStatus(TrainingHotAskListAdapter.LOADING_MORE);
                        page++;
                        requestAsk(key);
                    }
                }
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

    //获取问答
    public void requestAsk(ResultAskTypeItemBean appQuestionType) {
//        ArrayMap<String,Object> map = new ArrayMap<String,Object>();
        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
        map.put("appQuestionType", appQuestionType.getTypeCode());
        map.put("page", page + "");

        HtmlRequest.getTrainingAskIndex(context, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params.result != null) {
                    ResultAskIndexBean b = (ResultAskIndexBean) params.result;
                    if (b.getList().size() == 0) {
                        if (page != 1) {
                            page--;
                            adapter.changeMoreStatus(RecyclerBaseAapter.NO_LOAD_BLACK);
                        } else {
                            adapter.setNoDataMessage("暂无问答");
                            adapter.changeMoreStatus(RecyclerBaseAapter.NO_DATA_MATCH_PARENT);
                            noDataFlag = false;
//                            adapter.changeMoreStatus(RecyclerBaseAapter.NO_LOAD_MORE);
                        }
                    } else {
                        indexItemBeans.addAll(b.getList());
                        adapter.notifyDataSetChanged();
                    }
                } else {

                }
            }
        });
    }

    public static TrainingAakFragment newInstance(ResultAskTypeItemBean newsId) {
        TrainingAakFragment fragment = new TrainingAakFragment();
        Bundle bundle = new Bundle();
        fragment.setArguments(bundle);
        bundle.putSerializable(KEY, newsId);
        return fragment;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // TODO: inflate a fragment view
        View rootView = super.onCreateView(inflater, container, savedInstanceState);
        ButterKnife.bind(this, rootView);
        return rootView;
    }
}
