package com.rulaibao.fragment;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.rulaibao.R;
import com.rulaibao.adapter.RecyclerBaseAapter;
import com.rulaibao.adapter.CxyTestClassListAdapter;
import com.rulaibao.bean.ResultClassIndexBean;
import com.rulaibao.bean.ResultClassIndexItemBean;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;

import java.util.LinkedHashMap;

import butterknife.BindView;

public class CxyTestClassFragment extends BaseFragment {

    @BindView(R.id.rv_test_class)
    RecyclerView rvTestClass;

    private CxyTestClassListAdapter adapter;
    private int page = 1;
    private MouldList<ResultClassIndexItemBean> courseList;
    private static final String KEY="title";
    private String typeCode;
    private boolean noDataFlag = true;      //  控制无数据不加载

    @Override
    protected View attachLayoutRes(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        if (mView == null) {
            mView = inflater.inflate(R.layout.fragment_test_class, container, false);
        } else {
            if (mView.getParent() != null) {
                ((ViewGroup) mView.getParent()).removeView(mView);
            }
        }
        return mView;
    }

    @Override
    protected void initViews() {
        context=getActivity();
        courseList=new MouldList<>();

        rvTestClass.setLayoutManager(new LinearLayoutManager(context));
        adapter=new CxyTestClassListAdapter(context,courseList);
        rvTestClass.setAdapter(adapter);

        rvTestClass.setOnScrollListener(new RecyclerView.OnScrollListener() {
            int lastVisibleItem;

            @Override
            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
                if (newState == RecyclerView.SCROLL_STATE_IDLE && lastVisibleItem + 1 == adapter.getItemCount()) {

                    if (noDataFlag) {
                        adapter.changeMoreStatus(RecyclerBaseAapter.LOADING_MORE);

                        page++;
                        requestIndexData();

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

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser){
            if (context!=null){
                courseList.clear();
            }
            typeCode = getArguments().getString(KEY);         //  解决初始点击fragment拿不到参数的问题
            page = 1;
            noDataFlag = true;
            requestIndexData();//
        }
    }


    public void requestIndexData() {
        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
        map.put("page", page);
        map.put("typeCode", typeCode);
        HtmlRequest.getTrainingClassList(context, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params.result != null) {
                    ResultClassIndexBean bean = (ResultClassIndexBean) params.result;
                    if (bean.getCourseList().size() == 0) {
                        if (page != 1) {
                            page--;//实践并不需要page--
                            adapter.changeMoreStatus(RecyclerBaseAapter.NO_LOAD_MORE);
                        } else {
                            adapter.setNoDataMessage("暂无课程");
                            adapter.changeMoreStatus(RecyclerBaseAapter.NO_DATA_MATCH_PARENT);
                            noDataFlag = false;
                        }

                    }else{
                        courseList.addAll(bean.getCourseList());
                        adapter.notifyDataSetChanged();
                    }

                }
            }
        });
    }
    public static CxyTestClassFragment newInstance(String newsId) {
        CxyTestClassFragment fragment = new CxyTestClassFragment();
        Bundle bundle = new Bundle();
        fragment.setArguments(bundle);
        bundle.putString(KEY, newsId);
        return fragment;
    }
}
