package com.rulaibao.activity;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.PopupMenu;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.rulaibao.R;
import com.rulaibao.adapter.RecyclerBaseAapter;
import com.rulaibao.adapter.TrainingAskDetailsListAdapter;
import com.rulaibao.adapter.TrainingHotAskListAdapter;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.ResultAskDetailsAnswerBean;
import com.rulaibao.bean.ResultAskDetailsAnswerItemBean;
import com.rulaibao.bean.ResultAskDetailsBean;
import com.rulaibao.bean.TestBean;
import com.rulaibao.common.Urls;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.ImageLoaderManager;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.RlbActivityManager;
import com.rulaibao.uitls.ViewUtils;
import com.rulaibao.widget.CircularImage;
import com.rulaibao.widget.TitleBar;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 问题详情
 */

public class TrainingAskDetailsActivity extends BaseActivity {


    @BindView(R.id.lv_ask_details)
    RecyclerView lvAskDetails;
    @BindView(R.id.tv_ask_details_answer)
    TextView tvAskDetailsAnswer;

    private DisplayImageOptions displayImageOptions = ImageLoaderManager.initDisplayImageOptions(R.mipmap.ic_ask_photo_default, R.mipmap.ic_ask_photo_default, R.mipmap.ic_ask_photo_default);

    private TextView tv_ask_detais_sort;        //
    private ImageView iv__ask_detais_sort;        //
    private TextView tv_askdetails_title;       //  标题
    private CircularImage iv_ask_detatils_manager;       //  头像
    private TextView tv_ask_details_manager_name;       //  姓名
    private TextView tv_ask_details_time;       //  时间
    private TextView tv_ask_details_content;       //  内容
    private TextView tv_ask_details_ask_count;       //  回答数

    private ArrayList<TestBean> arrayList = new ArrayList<TestBean>();
    private String string = "";
    private TrainingAskDetailsListAdapter adapter;
    private LinearLayout ll_ask_details_sort;
    private PopupWindow popupWindow;
    private String questionId = "";
    private int page = 1;
    private MouldList<ResultAskDetailsAnswerItemBean> list;
    private ResultAskDetailsBean detailsBean;
    private String sortType = "";
    private TitleBar title = null;
    private boolean noDataFlag = true;      //  控制无数据不加载

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_training_ask_details);
        initTopTitle();
        initView();

    }

    public void initData() {
        sortType = "";
        noDataFlag = true;
        page = 1;
        list.clear();
        request();
    }

    public void initView() {

        questionId = getIntent().getStringExtra("questionId");
        detailsBean = new ResultAskDetailsBean();
        list = new MouldList<ResultAskDetailsAnswerItemBean>();
        setRereshEnable(true);
        initRecyclerView();
    }

    public void initRecyclerView() {

        lvAskDetails.setLayoutManager(new LinearLayoutManager(this));
        adapter = new TrainingAskDetailsListAdapter(this, list, questionId);
        lvAskDetails.setAdapter(adapter);


        //为RecyclerView添加HeaderView和FooterView
        setHeaderView(lvAskDetails);
//        setFooterView(lvAskDetails);


        lvAskDetails.setOnScrollListener(new RecyclerView.OnScrollListener() {
            int lastVisibleItem;

            @Override
            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
                if (newState == RecyclerView.SCROLL_STATE_IDLE && lastVisibleItem + 1 == adapter.getItemCount()) {

                    if (noDataFlag) {
                        adapter.changeMoreStatus(TrainingHotAskListAdapter.LOADING_MORE);

                        page++;
                        requestAnswerList();
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

    //获取数据
    public void request() {


//        ArrayMap<String,Object> map = new ArrayMap<String,Object>();
        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
        map.put("questionId", questionId);

        HtmlRequest.getTrainingAskDetails(this, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {

                if (params.result != null) {

                    detailsBean = (ResultAskDetailsBean) params.result;
                    if (detailsBean.getFlag().equals("true")) {

                        requestAnswerList();

                    } else {
                        if (detailsBean.getCode().equals("6001")) {      //  参数错误

                            ViewUtils.showDeleteDialog(TrainingAskDetailsActivity.this, detailsBean.getMessage());
                        } else if (detailsBean.getCode().equals("6002")) {        //  该问题已删除
                            ViewUtils.showDeleteDialog(TrainingAskDetailsActivity.this, detailsBean.getMessage());
                        }
                    }

                } else {

                }

            }
        });
    }

    //回答列表
    public void requestAnswerList() {

//        ArrayMap<String,Object> map = new ArrayMap<String,Object>();
        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
        map.put("questionId", questionId);
        map.put("sortType", sortType);
        map.put("page", page + "");
        map.put("userId", userId);

        HtmlRequest.getTrainingAskDetailsAnswer(this, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {

                if (params.result != null) {

                    ResultAskDetailsAnswerBean b = (ResultAskDetailsAnswerBean) params.result;

                    if (b.getList().size() == 0) {     //
                        if (page != 1) {          //  非首次的无数据情况
                            page--;
                            adapter.changeMoreStatus(RecyclerBaseAapter.NO_LOAD_MORE);
                        } else {
                            adapter.setNoDataMessage("暂无回答");
                            adapter.changeMoreStatus(RecyclerBaseAapter.NO_DATA_WRAP_CONTENT);
                            noDataFlag = false;
                        }


                    } else {

                        tv_ask_details_ask_count.setText(b.getTotal() + "回答");

                        list.addAll(b.getList());
                        if (list.size() % 10 == 0) {
                            adapter.changeMoreStatus(RecyclerBaseAapter.PULLUP_LOAD_MORE);
                        } else {
                            adapter.changeMoreStatus(RecyclerBaseAapter.NO_LOAD_MORE);
                        }
                    }

                    // 处理加载header闪跳的问题
                    if (page == 1 && TextUtils.isEmpty(sortType)) {
                        if (detailsBean != null) {
                            setView(detailsBean);
                        }

                    }

                    adapter.notifyDataSetChanged();

                } else {

                }
                swipe.setRefreshing(false);
            }
        });
    }

    public void setView(ResultAskDetailsBean bean) {


        String id = "23232323";
        String url = Urls.URL_SHARED_ASK + questionId;
        title.setActivityParameters(url, id, detailsBean.getAppQuestion().getTitle(), "问题描述：" + detailsBean.getAppQuestion().getDescript());

        tv_askdetails_title.setText(bean.getAppQuestion().getTitle());
        ImageLoader.getInstance().displayImage(bean.getAppQuestion().getUserPhoto(), iv_ask_detatils_manager, displayImageOptions);
        tv_ask_details_manager_name.setText(bean.getAppQuestion().getUserName());
        tv_ask_details_time.setText(bean.getAppQuestion().getTime());
        tv_ask_details_content.setText(bean.getAppQuestion().getDescript());

    }


    private void setHeaderView(RecyclerView view) {
        View header = LayoutInflater.from(this).inflate(R.layout.activity_training_ask_details_top, view, false);

        ll_ask_details_sort = (LinearLayout) header.findViewById(R.id.ll_ask_details_sort);

        tv_ask_detais_sort = (TextView) header.findViewById(R.id.tv_ask_detais_sort);
        iv__ask_detais_sort = (ImageView) header.findViewById(R.id.iv__ask_detais_sort);
        tv_askdetails_title = (TextView) header.findViewById(R.id.tv_askdetails_title);
        iv_ask_detatils_manager = (CircularImage) header.findViewById(R.id.iv_ask_detatils_manager);
        tv_ask_details_manager_name = (TextView) header.findViewById(R.id.tv_ask_details_manager_name);
        tv_ask_details_time = (TextView) header.findViewById(R.id.tv_ask_details_time);
        tv_ask_details_content = (TextView) header.findViewById(R.id.tv_ask_details_content);
        tv_ask_details_ask_count = (TextView) header.findViewById(R.id.tv_ask_details_ask_count);

        ll_ask_details_sort.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                showPopupMenu(v);
                showPopupWindow(v);
//                initTabMenu(v);
//                initDialog(v);
            }
        });


        adapter.setmHeaderView(header);
        lvAskDetails.getItemAnimator().setChangeDuration(0);
    }


    public void showPopupWindow(View view) {

        LayoutInflater inflater = LayoutInflater.from(this);
        View itemView = inflater.inflate(R.layout.pw_sort, null);
        TextView tv_sort_default = (TextView) itemView.findViewById(R.id.tv_sort_default);
        TextView tv_sort_times = (TextView) itemView.findViewById(R.id.tv_sort_times);

        tv_sort_default.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                tv_ask_detais_sort.setText("默认排序");
//                Toast.makeText(getApplicationContext(), "默认排序", Toast.LENGTH_SHORT).show();
                sortType = "default";
                list.clear();
                page = 1;
                requestAnswerList();
                popupWindow.dismiss();
            }
        });

        tv_sort_times.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                tv_ask_detais_sort.setText("最新排序");
//                Toast.makeText(getApplicationContext(), "最新排序", Toast.LENGTH_SHORT).show();
                list.clear();
                page = 1;
                sortType = "new";
                requestAnswerList();
                popupWindow.dismiss();
            }
        });


        popupWindow = new PopupWindow(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        popupWindow.setContentView(itemView);

        //点击空白区域PopupWindow消失，这里必须先设置setBackgroundDrawable，否则点击无反应
        popupWindow.setBackgroundDrawable(new ColorDrawable(0x00000000));
        popupWindow.setOutsideTouchable(true);

        popupWindow.setFocusable(true);
        popupWindow.setTouchable(true);

        //设置是否允许PopupWindow的范围超过屏幕范围
        popupWindow.setClippingEnabled(true);

        popupWindow.setAnimationStyle(R.style.Theme_PopupMenu);


        //设置PopupWindow消失监听
        popupWindow.setOnDismissListener(new PopupWindow.OnDismissListener() {
            @Override
            public void onDismiss() {

                iv__ask_detais_sort.setImageResource(R.mipmap.img_sort_down);

            }
        });

        iv__ask_detais_sort.setImageResource(R.mipmap.img_sort_up);
        popupWindow.showAsDropDown(view);

    }


    private void initTopTitle() {
        title = (TitleBar) findViewById(R.id.rl_title);
        title.showLeftImg(true);
        title.setFromActivity("1000");
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.training_ask_details)).showMore(false).setTitleRightButton(R.drawable.ic_share_title)
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

    @OnClick(R.id.tv_ask_details_answer)
    public void onClick(View view) {

        switch (view.getId()) {

            case R.id.tv_ask_details_answer:

                if (!PreferenceUtil.isLogin()) {

                    HashMap<String, Object> map = new HashMap<>();
                    RlbActivityManager.toLoginActivity(this, map, false);

                } else {
                    if (!PreferenceUtil.getCheckStatus().equals("success")) {
                        ViewUtils.showToSaleCertificationDialog(this, "您还未认证，是否去认证");

                    } else {

                        HashMap<String, Object> map = new HashMap<>();
                        if (detailsBean != null) {
                            map.put("questionId", questionId);
                            map.put("title", detailsBean.getAppQuestion().getTitle());
                            RlbActivityManager.toTrainingAnswerActivity(this, map, false);
                        }


                    }
                }


                break;

            default:

                break;

        }

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

}
