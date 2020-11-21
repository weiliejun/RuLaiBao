package com.rulaibao.activity;

import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.ViewSwitcher;

import com.rulaibao.R;
import com.rulaibao.adapter.TrainingMyCircleListAdapter;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.ResultCircleIndexBean;
import com.rulaibao.bean.ResultCircleIndexItemBean;
import com.rulaibao.bean.TestBean;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.RlbActivityManager;
import com.rulaibao.widget.MyListView;
import com.rulaibao.widget.TitleBar;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;

import butterknife.BindView;

/**
 * 圈子
 */

public class TrainingCircleActivity extends BaseActivity {

    @BindView(R.id.lv_mycircle)
    MyListView lvMycircle;
    @BindView(R.id.lv_mycircle_join)
    MyListView lvMycircleJoin;
    @BindView(R.id.lv_recommend_circle)
    MyListView lvRecommendCircle;

    public static final String MINE = "mine";
    public static final String JOIN = "join";
    public static final String RECOMMEND = "recommend";

    @BindView(R.id.ll_mycircle)
    LinearLayout llMycircle;
    @BindView(R.id.ll_mycircle_join)
    LinearLayout llMycircleJoin;
    @BindView(R.id.ll_recommend_circle)
    LinearLayout llRecommendCircle;
    @BindView(R.id.tv_empty)
    TextView tvEmpty;
    @BindView(R.id.vs_training_circle)
    ViewSwitcher vsTrainingCircle;

    private ArrayList<TestBean> arrayList = new ArrayList<TestBean>();
    private String string = "";

    private MouldList<ResultCircleIndexItemBean> myAppCircle;
    private MouldList<ResultCircleIndexItemBean> myJoinAppCircle;
    private MouldList<ResultCircleIndexItemBean> myRecomAppCircle;

    private String type = "";           //  圈子类型   mine我的圈子    join 我的加入的圈子   recommend 推荐的圈子


    private TrainingMyCircleListAdapter myCircleAdapter;        //  我的圈子
    private TrainingMyCircleListAdapter joinAdapter;        //  我加入的圈子
    private TrainingMyCircleListAdapter recommendAdapter;        //  推荐的圈子

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_training_circle);
        initTopTitle();
        initView();


    }

    public void initData() {

        requestIndexData();

    }

    public void initView() {

        myAppCircle = new MouldList<ResultCircleIndexItemBean>();
        myJoinAppCircle = new MouldList<ResultCircleIndexItemBean>();
        myRecomAppCircle = new MouldList<ResultCircleIndexItemBean>();
        setRereshEnable(true);
        vsTrainingCircle.setDisplayedChild(0);
    }

    public void initAdapterData() {

        if (myAppCircle.size() == 0 && myJoinAppCircle.size() == 0 && myRecomAppCircle.size() == 0) {
            vsTrainingCircle.setDisplayedChild(1);
            tvEmpty.setText("暂无圈子");
        } else {
            vsTrainingCircle.setDisplayedChild(0);


            if (myAppCircle.size() == 0) {
                llMycircle.setVisibility(View.GONE);
            } else {
                llMycircle.setVisibility(View.VISIBLE);
            }

            if (myJoinAppCircle.size() == 0) {
                llMycircleJoin.setVisibility(View.GONE);
            } else {
                llMycircleJoin.setVisibility(View.VISIBLE);
            }

            if (myRecomAppCircle.size() == 0) {
                llRecommendCircle.setVisibility(View.GONE);
            } else {
                llRecommendCircle.setVisibility(View.VISIBLE);
            }


            myCircleAdapter = new TrainingMyCircleListAdapter(this, myAppCircle, MINE, userId);
            lvMycircle.setAdapter(myCircleAdapter);

            joinAdapter = new TrainingMyCircleListAdapter(this, myJoinAppCircle, JOIN, userId);
            lvMycircleJoin.setAdapter(joinAdapter);

            recommendAdapter = new TrainingMyCircleListAdapter(this, myRecomAppCircle, RECOMMEND, userId);
            lvRecommendCircle.setAdapter(recommendAdapter);

            lvMycircle.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                    HashMap<String, Object> map = new HashMap<String, Object>();
                    map.put("circleId", myAppCircle.get(position).getCircleId());
                    map.put("isApply", myAppCircle.get(position).getIsApply());
                    RlbActivityManager.toTrainingCircleDetailsActivity(TrainingCircleActivity.this, map, false);

                }
            });

            lvMycircleJoin.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                    HashMap<String, Object> map = new HashMap<String, Object>();
                    map.put("circleId", myJoinAppCircle.get(position).getCircleId());
                    RlbActivityManager.toTrainingCircleDetailsActivity(TrainingCircleActivity.this, map, false);

                }
            });

            lvRecommendCircle.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                    HashMap<String, Object> map = new HashMap<String, Object>();
                    map.put("circleId", myRecomAppCircle.get(position).getCircleId());
                    RlbActivityManager.toTrainingCircleDetailsActivity(TrainingCircleActivity.this, map, false);

                }
            });

        }


    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.training_circle_all))
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


    public void requestIndexData() {

        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();

        map.put("userId", userId);
        HtmlRequest.getTrainingCircleIndex(this, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {

                if (params.result != null) {

                    ResultCircleIndexBean bean = (ResultCircleIndexBean) params.result;
                    myAppCircle = bean.getMyAppCircle();
                    myJoinAppCircle = bean.getMyJoinAppCircle();
                    myRecomAppCircle = bean.getMyRecomAppCircle();

                    initAdapterData();

                } else {

                }
                swipe.setRefreshing(false);
            }
        });
    }


    @Override
    protected void onResume() {
        super.onResume();
        initData();
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void onRefresh() {
        initData();
    }
}
