package com.rulaibao.fragment;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.Nullable;
import android.support.v4.widget.NestedScrollView;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.activity.FileDisplayActivity;
import com.rulaibao.activity.WebActivity;
import com.rulaibao.adapter.RecyclerBaseAapter;
import com.rulaibao.adapter.TrainingHotAskListAdapter;
import com.rulaibao.bean.ResultClassIndexBean;
import com.rulaibao.bean.ResultCycleIndex2B;
import com.rulaibao.bean.ResultHotAskBean;
import com.rulaibao.bean.ResultHotAskItemBean;
import com.rulaibao.common.Urls;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.test.VideoPlayActivity;
import com.rulaibao.uitls.RlbActivityManager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Timer;
import java.util.TimerTask;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import pub.devrel.easypermissions.EasyPermissions;

import static com.rulaibao.uitls.ImageUtils.getClassImgIndex;


/**
 * 研修
 * Created by junde on 2018/3/26.
 */

public class TrainingFragment extends BaseFragment implements TrainingHotAskListAdapter.LoadMoreData, SwipeRefreshLayout.OnRefreshListener {

    private static final int stopAnimMsg = 001;

    @BindView(R.id.tv_training_class)
    TextView tvTrainingClass;       //  课程
    @BindView(R.id.tv_training_ask)
    TextView tvTrainingAsk;         //  问答
    @BindView(R.id.tv_training_circle)
    TextView tvTrainingCircle;      //  圈子
    @BindView(R.id.tv_training_promote)
    TextView tvTrainingPromote;     //  展业

    @BindView(R.id.tv_training_recommend_date)
    TextView tvTrainingRecommendDate;       //  课程推荐 时间
    @BindView(R.id.iv_training_recommend)
    ImageView ivTrainingRecommend;
    @BindView(R.id.ll_training_recommend)
    LinearLayout llTrainingRecommend;

    @BindView(R.id.tv_training_refresh)
    TextView tvTrainingRefresh;             //  精品课程  换一换
    @BindView(R.id.tv_training_boutique_first)
    TextView tvTrainingBoutiqueFirst;       //
    @BindView(R.id.iv_training_boutique_first)
    ImageView ivTrainingBoutiqueFirst;
    @BindView(R.id.tv_training_boutique_second)
    TextView tvTrainingBoutiqueSecond;
    @BindView(R.id.iv_training_boutique_second)
    ImageView ivTrainingBoutiqueSecond;
    @BindView(R.id.tv_training_boutique_third)
    TextView tvTrainingBoutiqueThird;
    @BindView(R.id.iv_training_boutique_third)
    ImageView ivTrainingBoutiqueThird;
    @BindView(R.id.tv_training_boutique_forth)
    TextView tvTrainingBoutiqueForth;
    @BindView(R.id.iv_training_boutique_forth)
    ImageView ivTrainingBoutiqueForth;
    @BindView(R.id.tv_training_recommend_manager)
    TextView tvTrainingRecommendManager;
    @BindView(R.id.tv_training_recommend_manager_name)
    TextView tvTrainingRecommendManagerName;
    @BindView(R.id.iv_training_refresh)
    ImageView ivTrainingRefresh;

    @BindView(R.id.lv_training_hot_ask)         //  热门回答
            RecyclerView lvTrainingHotAsk;

    @BindView(R.id.title_center)
    TextView titleCenter;           //  标题
    @BindView(R.id.rsv_fragment_training)
    NestedScrollView rsvFragmentTraining;
    @BindView(R.id.swipe_training)
    SwipeRefreshLayout swipeTraining;
    @BindView(R.id.ll_training_recommend_refresh)
    LinearLayout llTrainingRecommendRefresh;
    @BindView(R.id.rl_training_boutique_first)
    RelativeLayout rlTrainingBoutiqueFirst;
    @BindView(R.id.rl_training_boutique_second)
    RelativeLayout rlTrainingBoutiqueSecond;
    @BindView(R.id.rl_training_boutique_third)
    RelativeLayout rlTrainingBoutiqueThird;
    @BindView(R.id.rl_training_boutique_forth)
    RelativeLayout rlTrainingBoutiqueForth;
    @BindView(R.id.tv_boutique_nodata)
    TextView tvBoutiqueNodata;

    private ArrayList<ResultCycleIndex2B> picList;
    private Animation mRefreshAnim;
    private Context context;

    private ArrayList arrayList = new ArrayList();
    private String string = "";
    private MouldList<ResultHotAskItemBean> list;

    private TrainingHotAskListAdapter adapter;
    private ResultClassIndexBean bean;
    private int hotPage = 1;
    private int classPage = 1;

    private int qualityCount = 1;  // 精品课程总页数
    private boolean noDataFlag = true; // 控制无数据不加载

    /**
     * 绑定布局文件
     *
     * @param inflater           1
     * @param container          1
     * @param savedInstanceState 1
     * @return 1
     */
    @Override
    protected View attachLayoutRes(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        if (mView == null) {
            mView = inflater.inflate(R.layout.fragment_training, container, false);

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
            if (context != null) {
                initData();

            }

//            scrollView.smoothScrollTo(0, 0);
        }

    }

    public void initData() {
        hotPage = 1;
        noDataFlag = true;
        list.clear();
        requestIndexData();// 获取研修首页数据
        requestHotAskData();// 获取研修首页热门问答的数据


    }

    /**
     * 初始化参数、视图控件
     */
    @Override
    protected void initViews() {

        context = getActivity();

        picList = new ArrayList<ResultCycleIndex2B>();
        list = new MouldList<ResultHotAskItemBean>();
        bean = new ResultClassIndexBean();

        swipeTraining.setOnRefreshListener(this);
        titleCenter.setText(getString(R.string.training));
        mRefreshAnim = AnimationUtils.loadAnimation(context, R.anim.anim_rotate_refresh);
        setAdapterData();

    }

    public void setAdapterData() {

        LinearLayoutManager layoutManager = new LinearLayoutManager(context) {
            @Override
            public boolean canScrollVertically() {
                // 直接禁止垂直滑动
                return false;
            }
        };

        lvTrainingHotAsk.setLayoutManager(layoutManager);
        adapter = new TrainingHotAskListAdapter(getActivity(), list, this);
        lvTrainingHotAsk.setAdapter(adapter);

        //添加分割线
//        lvTrainingHotAsk.addItemDecoration(new RefreshItemDecoration(getActivity(),RefreshItemDecoration.VERTICAL_LIST));
//        lvTrainingHotAsk.addItemDecoration(new RecyclerViewDivider(getActivity(), LinearLayoutManager.VERTICAL, R.drawable.shape_divider_training));

        initLoadMoreListener();

    }


    @OnClick({R.id.tv_training_class, R.id.tv_training_ask, R.id.tv_training_circle, R.id.tv_training_promote,
            R.id.iv_training_recommend, R.id.ll_training_recommend_refresh, R.id.rl_training_boutique_first,
            R.id.rl_training_boutique_second, R.id.rl_training_boutique_third, R.id.rl_training_boutique_forth})
    public void onclick(View view) {
        switch (view.getId()) {
            case R.id.tv_training_class: //  课程
                RlbActivityManager.toTrainingClassActivity(getActivity(), false);
                break;
            case R.id.tv_training_ask: // 问答
                HashMap<String, Object> map = new HashMap<>();
                RlbActivityManager.toTrainingAskActivity(getActivity(), map, false);
                break;
            case R.id.tv_training_circle: // 圈子
                RlbActivityManager.toTrainingCircleActivity(getActivity(), false);
                break;
            case R.id.tv_training_promote: // 展业
//                RlbActivityManager.toTrainingPromoteActivity(getActivity(), false);
//                RlbActivityManager.toTestActivity(getActivity(), false);

                Toast.makeText(context, "该功能暂未开放", Toast.LENGTH_SHORT).show();

                break;

            case R.id.iv_training_recommend: // 推荐课程(跳转课程详情)
                HashMap<String, Object> classMap = new HashMap<>();
                if (bean != null) {
                    if (bean.getCourseRecommend() != null) {
                        if (!TextUtils.isEmpty(bean.getCourseRecommend().getCourseId())) {
                            classMap.put("id", bean.getCourseRecommend().getCourseId());
                            classMap.put("speechmakeId", bean.getCourseRecommend().getSpeechmakeId());
                            classMap.put("courseId", bean.getCourseRecommend().getCourseId());
                            RlbActivityManager.toTrainingClassDetailsActivity(getActivity(), classMap, false);
                        }
                    }
                }
                break;
            case R.id.ll_training_recommend_refresh: //  精品课程 刷新（换一换）
                if (qualityCount < 1) {
                    qualityCount = 1;
                }
                classPage = (classPage) % ((qualityCount + 3) / 4) + 1;

                startAnim();
                requestRefreshClassData();

                break;

            case R.id.rl_training_boutique_first: // 精品课程一
                HashMap<String, Object> classFirstMap = new HashMap<>();
                if (bean != null) {
                    if (bean.getQualityCourseList() != null) {
                        if (bean.getQualityCourseList().size() > 0) {
                            if (bean.getQualityCourseList().get(0) != null) {
                                classFirstMap.put("id", bean.getQualityCourseList().get(0).getCourseId());
                                classFirstMap.put("speechmakeId", bean.getQualityCourseList().get(0).getSpeechmakeId());
                                classFirstMap.put("courseId", bean.getQualityCourseList().get(0).getCourseId());
                                RlbActivityManager.toTrainingClassDetailsActivity(getActivity(), classFirstMap, false);
                            }
                        }
                    }
                }
                break;
            case R.id.rl_training_boutique_second: // 精品课程二
                HashMap<String, Object> classSecondMap = new HashMap<>();
                if (bean != null) {
                    if (bean.getQualityCourseList() != null) {
                        if (bean.getQualityCourseList().size() > 1) {
                            if (bean.getQualityCourseList().get(1) != null) {
                                classSecondMap.put("id", bean.getQualityCourseList().get(1).getCourseId());
                                classSecondMap.put("speechmakeId", bean.getQualityCourseList().get(1).getSpeechmakeId());
                                classSecondMap.put("courseId", bean.getQualityCourseList().get(1).getCourseId());
                                RlbActivityManager.toTrainingClassDetailsActivity(getActivity(), classSecondMap, false);
                            }
                        }
                    }
                }
                break;
            case R.id.rl_training_boutique_third:  // 精品课程三
                HashMap<String, Object> classThirdMap = new HashMap<>();
                if (bean != null) {
                    if (bean.getQualityCourseList() != null) {
                        if (bean.getQualityCourseList().size() > 2) {
                            if (bean.getQualityCourseList().get(2) != null) {
                                classThirdMap.put("id", bean.getQualityCourseList().get(2).getCourseId());
                                classThirdMap.put("speechmakeId", bean.getQualityCourseList().get(2).getSpeechmakeId());
                                classThirdMap.put("courseId", bean.getQualityCourseList().get(2).getCourseId());
                                RlbActivityManager.toTrainingClassDetailsActivity(getActivity(), classThirdMap, false);
                            }
                        }
                    }
                }
                break;
            case R.id.rl_training_boutique_forth: // 精品课程四
                HashMap<String, Object> classforthMap = new HashMap<>();
                if (bean != null) {
                    if (bean.getQualityCourseList() != null) {
                        if (bean.getQualityCourseList().size() > 3) {
                            if (bean.getQualityCourseList().get(3) != null) {
                                classforthMap.put("id", bean.getQualityCourseList().get(3).getCourseId());
                                classforthMap.put("speechmakeId", bean.getQualityCourseList().get(3).getSpeechmakeId());
                                classforthMap.put("courseId", bean.getQualityCourseList().get(3).getCourseId());
                                RlbActivityManager.toTrainingClassDetailsActivity(getActivity(), classforthMap, false);
                            }
                        }
                    }
                }

                break;

            default:

                break;

        }

    }

    /**
     *  获取研修首页数据
     */
    public void requestIndexData() {
        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();

        HtmlRequest.getTrainingIndexClass(context, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params.result == null) {
                   return;
                }

                bean = (ResultClassIndexBean) params.result;
                qualityCount = bean.getCount();
                setView();
            }
        });
    }

    public void setView() {
        if (bean.getCourseRecommend() != null) {
            if (!TextUtils.isEmpty(bean.getCourseRecommend().getCourseId())) {
                llTrainingRecommend.setVisibility(View.VISIBLE);
                tvTrainingRecommendDate.setText(bean.getCourseRecommend().getCourseTime());
                ivTrainingRecommend.setImageResource(getClassImgIndex(bean.getCourseRecommend().getCourseLogo()));
                tvTrainingRecommendManager.setText(bean.getCourseRecommend().getCourseName());
                tvTrainingRecommendManagerName.setText(bean.getCourseRecommend().getSpeechmakeName() + "  " + bean.getCourseRecommend().getPosition());
            } else {
                llTrainingRecommend.setVisibility(View.GONE);
            }
        } else {
            llTrainingRecommend.setVisibility(View.GONE);
        }

        setQualityView();

    }

    public void setQualityView() {
        if (bean.getQualityCourseList().size() > 0) {
            if (bean.getQualityCourseList().get(0) != null) {
                tvBoutiqueNodata.setVisibility(View.GONE);
                rlTrainingBoutiqueFirst.setVisibility(View.VISIBLE);
                rlTrainingBoutiqueSecond.setVisibility(View.INVISIBLE);
                tvTrainingBoutiqueFirst.setText(bean.getQualityCourseList().get(0).getCourseName());
                ivTrainingBoutiqueFirst.setImageResource(getClassImgIndex(bean.getQualityCourseList().get(0).getCourseLogo()));
            }

            if (bean.getQualityCourseList().size() > 1) {
                if (bean.getQualityCourseList().get(1) != null) {
                    rlTrainingBoutiqueSecond.setVisibility(View.VISIBLE);
                    tvTrainingBoutiqueSecond.setText(bean.getQualityCourseList().get(1).getCourseName());
                    ivTrainingBoutiqueSecond.setImageResource(getClassImgIndex(bean.getQualityCourseList().get(1).getCourseLogo()));
                }
                if (bean.getQualityCourseList().size() > 2) {
                    if (bean.getQualityCourseList().get(2) != null) {
                        rlTrainingBoutiqueThird.setVisibility(View.VISIBLE);
                        rlTrainingBoutiqueForth.setVisibility(View.INVISIBLE);
                        tvTrainingBoutiqueThird.setText(bean.getQualityCourseList().get(2).getCourseName());
                        ivTrainingBoutiqueThird.setImageResource(getClassImgIndex(bean.getQualityCourseList().get(2).getCourseLogo()));
                    }
                    if (bean.getQualityCourseList().size() > 3) {
                        if (bean.getQualityCourseList().get(3) != null) {
                            rlTrainingBoutiqueForth.setVisibility(View.VISIBLE);
                            tvTrainingBoutiqueForth.setText(bean.getQualityCourseList().get(3).getCourseName());
                            ivTrainingBoutiqueForth.setImageResource(getClassImgIndex(bean.getQualityCourseList().get(3).getCourseLogo()));
                        }
                    } else {
                        rlTrainingBoutiqueForth.setVisibility(View.INVISIBLE);
                    }
                } else {
                    rlTrainingBoutiqueThird.setVisibility(View.GONE);
                    rlTrainingBoutiqueForth.setVisibility(View.GONE);
                }
            } else {
                rlTrainingBoutiqueSecond.setVisibility(View.INVISIBLE);
                rlTrainingBoutiqueThird.setVisibility(View.GONE);
                rlTrainingBoutiqueForth.setVisibility(View.GONE);
            }
        } else {          //  无精品课程
            rlTrainingBoutiqueFirst.setVisibility(View.GONE);
            rlTrainingBoutiqueSecond.setVisibility(View.GONE);
            rlTrainingBoutiqueThird.setVisibility(View.GONE);
            rlTrainingBoutiqueForth.setVisibility(View.GONE);
            tvBoutiqueNodata.setVisibility(View.VISIBLE);
        }

    }

    /**
     *  获取研修首页热门问答的数据
     */
    public void requestHotAskData() {
        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
        map.put("page", hotPage + "");

        HtmlRequest.getTrainingHotAskClass(context, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {

                if (params.result != null) {
                    ResultHotAskBean bean = (ResultHotAskBean) params.result;
                    if (bean.getList().size() == 0 && hotPage != 1) {     //  非首次的无数据情况
                        hotPage--;
                        adapter.changeMoreStatus(RecyclerBaseAapter.NO_LOAD_MORE);

                    } else if (bean.getList().size() == 0 && hotPage == 1) {      //  没有数据

                        adapter.setNoDataMessage("暂无热门问答");
                        adapter.changeMoreStatus(RecyclerBaseAapter.NO_DATA_NO_PICTURE);
                        noDataFlag = false;
                    } else {

                        list.addAll(bean.getList());
                        if (list.size() % 10 == 0) {
                            adapter.changeMoreStatus(RecyclerBaseAapter.PULLUP_LOAD_MORE);
                        } else {
                            adapter.changeMoreStatus(RecyclerBaseAapter.NO_LOAD_MORE);
                        }
                    }

                    adapter.notifyDataSetChanged();
                } else {

                }
                swipeTraining.setRefreshing(false);
            }
        });

    }

    Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (msg.what == stopAnimMsg) {
                stopAnim();
            }
        }
    };


    public void requestRefreshClassData() {

        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
        map.put("page", classPage + "");

        HtmlRequest.getTrainingRefreshClass(context, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {

                if (params.result != null) {
                    ResultClassIndexBean qualityBean = (ResultClassIndexBean) params.result;
                    if (qualityBean.getQualityCourseList().size() == 4) {
                        bean.setQualityCourseList(qualityBean.getQualityCourseList());
                        setQualityView();
                    }
                    Timer timer = new Timer();
                    timer.schedule(new TimerTask() {
                        @Override
                        public void run() {
                            Message msg = new Message();
                            msg.what = stopAnimMsg;
                            //发送消息
                            handler.sendMessage(msg);
                        }
                    }, 800);
                } else {

                }
            }
        });

    }

    public void stopAnim() {
        mRefreshAnim.reset();
        ivTrainingRefresh.clearAnimation();
        ivTrainingRefresh.setBackgroundResource(R.mipmap.img_training_refresh);
    }

    public void startAnim() {
        mRefreshAnim.reset();
        ivTrainingRefresh.clearAnimation();
        ivTrainingRefresh.setBackgroundResource(R.mipmap.img_training_refresh);
        ivTrainingRefresh.startAnimation(mRefreshAnim);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // TODO: inflate a fragment view
        View rootView = super.onCreateView(inflater, container, savedInstanceState);
        ButterKnife.bind(this, rootView);
        return rootView;
    }

    @Override
    public void getMoreData() {

        hotPage++;
        requestHotAskData();
    }

    public void initLoadMoreListener() {

        rsvFragmentTraining.setOnScrollChangeListener(new NestedScrollView.OnScrollChangeListener() {
            @Override
            public void onScrollChange(NestedScrollView v, int scrollX, int scrollY, int oldScrollX, int oldScrollY) {
                if (scrollY > oldScrollY) {
                    // 向下滑动
                }

                if (scrollY < oldScrollY) {
                    // 向上滑动
                }

                if (scrollY == 0) {
                    // 顶部
                }

                if (scrollY == (v.getChildAt(0).getMeasuredHeight() - v.getMeasuredHeight())) {

                    if (noDataFlag) {
                        adapter.changeMoreStatus(RecyclerBaseAapter.LOADING_MORE);

                        // 底部
                        hotPage++;
                        requestHotAskData();
                    }
                }
            }
        });

    }

    @Override
    public void onRefresh() {
        initData();
    }
}
