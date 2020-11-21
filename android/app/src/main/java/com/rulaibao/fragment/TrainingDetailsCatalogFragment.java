package com.rulaibao.fragment;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import com.rulaibao.R;
import com.rulaibao.adapter.RecyclerBaseAapter;
import com.rulaibao.adapter.TrainingClassListAdapter;
import com.rulaibao.adapter.TrainingHotAskListAdapter;
import com.rulaibao.bean.ResultClassDetailsCatalogBean;
import com.rulaibao.bean.ResultClassDetailsIntroductionBean;
import com.rulaibao.bean.ResultClassIndexItemBean;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.widget.ViewPagerForScrollView;

import java.util.ArrayList;
import java.util.LinkedHashMap;

import butterknife.BindView;
import butterknife.ButterKnife;


/**
 * 课程详情 目录栏
 */

@SuppressLint("ValidFragment")
public class TrainingDetailsCatalogFragment extends BaseFragment {

    @BindView(R.id.lv_training_class_details_catalog)
    RecyclerView lvTrainingClassDetailsCatalog;

    private ArrayList arrayList = new ArrayList();

    private String string = "";
    private TrainingClassListAdapter adapter;
    private MouldList<ResultClassIndexItemBean> courseList;
    private String speechmakeId = "";
    private int page = 1;


    private ViewPagerForScrollView vp;
    private boolean noDataFlag = true;      //  控制无数据不加载

    public TrainingDetailsCatalogFragment() {
    }

    public TrainingDetailsCatalogFragment(ViewPagerForScrollView vp) {
        this.vp = vp;
    }

    @Override
    protected View attachLayoutRes(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {


        if (mView == null) {
            mView = inflater.inflate(R.layout.fragment_training_details_catalog, container, false);
//            vp.setObjectForPosition(mView,1);
        } else {
            if (mView.getParent() != null) {
                ((ViewGroup) mView.getParent()).removeView(mView);
            }
        }
        return mView;
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            if (courseList != null) {
                courseList.clear();
            }
            page = 1;
            requestData();

//            scrollView.smoothScrollTo(0, 0);
        } else {

        }

    }


    @Override
    protected void initViews() {

        speechmakeId = getArguments().getString("speechmakeId");
        courseList = new MouldList<ResultClassIndexItemBean>();
        initRecyclerView();


    }

    public void initRecyclerView() {

        LinearLayoutManager layoutManager = new LinearLayoutManager(context) {
            @Override
            public boolean canScrollVertically() {
                // 直接禁止垂直滑动
//                return false;
                return true;
            }
        };

        lvTrainingClassDetailsCatalog.setLayoutManager(layoutManager);
        adapter = new TrainingClassListAdapter(getActivity(), courseList);
        lvTrainingClassDetailsCatalog.setAdapter(adapter);


        lvTrainingClassDetailsCatalog.setOnScrollListener(new RecyclerView.OnScrollListener() {
            int lastVisibleItem;

            @Override
            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
                if (newState == RecyclerView.SCROLL_STATE_IDLE && lastVisibleItem + 1 == adapter.getItemCount()) {

                    if (noDataFlag) {
                        adapter.changeMoreStatus(TrainingHotAskListAdapter.LOADING_MORE);

                        page++;
                        requestData();
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

    public void requestData() {

        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();

        map.put("speechmakeId", speechmakeId);      //  演讲人id
        map.put("page", page + "");      //  课程id

        HtmlRequest.getClassDetailsCatalog(context, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {

                if (params.result != null) {

                    ResultClassDetailsCatalogBean bean = (ResultClassDetailsCatalogBean) params.result;

                    if (bean.getCourseList() != null) {
                        if (bean.getCourseList().size() == 0) {
                            if (page != 1) {
                                page--;
                                adapter.changeMoreStatus(RecyclerBaseAapter.NO_LOAD_MORE);
                            } else {
                                adapter.setNoDataMessage("暂无相关课程");
                                adapter.changeMoreStatus(RecyclerBaseAapter.NO_DATA_MATCH_PARENT);
                                noDataFlag = false;
                            }

                        } else {
                            courseList.addAll(bean.getCourseList());

                            if (courseList.size() % 10 == 0) {
                                adapter.changeMoreStatus(RecyclerBaseAapter.PULLUP_LOAD_MORE);
                            } else {
                                adapter.changeMoreStatus(RecyclerBaseAapter.NO_LOAD_MORE);
                            }


                        }
                        adapter.notifyDataSetChanged();
                    }

                } else {

                }
            }
        });
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // TODO: inflate a fragment view
        View rootView = super.onCreateView(inflater, container, savedInstanceState);
        ButterKnife.bind(this, rootView);
        return rootView;
    }
}
