package com.rulaibao.activity;

import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.rulaibao.R;
import com.rulaibao.adapter.RecyclerBaseAapter;
import com.rulaibao.adapter.TrainingAnswerDetailsListAdapter;
import com.rulaibao.adapter.TrainingHotAskListAdapter;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.ResultAnswerDetailsBean;
import com.rulaibao.bean.ResultCircleDetailsTopicCommentItemBean;
import com.rulaibao.bean.ResultCircleDetailsTopicCommentListBean;
import com.rulaibao.bean.ResultCircleDetailsTopicCommentReplyItemBean;
import com.rulaibao.bean.ResultInfoBean;
import com.rulaibao.bean.TestBean;
import com.rulaibao.common.Urls;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.ImageLoaderManager;
import com.rulaibao.uitls.InputMethodUtils;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.RlbActivityManager;
import com.rulaibao.uitls.ViewUtils;
import com.rulaibao.uitls.encrypt.DESUtil;
import com.rulaibao.widget.CircularImage;
import com.rulaibao.widget.MyRecyclerView;
import com.rulaibao.widget.TitleBar;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.concurrent.atomic.AtomicBoolean;

import butterknife.BindView;
import butterknife.OnClick;
import butterknife.OnTouch;

/**
 * 回答详情
 */

public class TrainingAnswerDetailsActivity extends BaseActivity implements TrainingAnswerDetailsListAdapter.Reply, MyRecyclerView.OnResizeListener {


    @BindView(R.id.lv_answer_details)
    MyRecyclerView lvAnswerDetails;
    @BindView(R.id.btn_answer_details)
    Button btnAnswerDetails;
    @BindView(R.id.et_answer_details)
    EditText etAnswerDetails;
    @BindView(R.id.fl_answer_details)
    FrameLayout flAnswerDetails;

    private DisplayImageOptions displayImageOptions = ImageLoaderManager.initDisplayImageOptions(R.mipmap.ic_ask_photo_default, R.mipmap.ic_ask_photo_default, R.mipmap.ic_ask_photo_default);

    private TextView tv_answer_details_title;       //  标题
    private CircularImage iv_answer_detatils_manager;       //  头像
    private TextView tv_answer_details_manager_name;        //
    private TextView tv_answer_details_time;
    private TextView tv_answer_details_content;
    private ImageView iv_answer_detailas_zan;
    private TextView tv_answer_details_comment_count;       //

    private ArrayList<TestBean> arrayList = new ArrayList<TestBean>();
    private String string = "";
    private TrainingAnswerDetailsListAdapter adapter;
    private MouldList<ResultCircleDetailsTopicCommentItemBean> commentItemBeans;
    private String questionId = "";
    private String answerId = "";
    private int page = 1;

    private String commentId = "";
    private String toUserId = "";
    private String replyToName = "";
    private int index = 0;      //  当前item的位置
    private ResultAnswerDetailsBean detailsBean;

    private int oldPosition = 0;
    private int bottomOffset = 0;
    private int position;
    private TitleBar title = null;
    private String linkId = "";
    private boolean noDataFlag = true;      //  控制无数据不加载

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_training_answer_details);
        initTopTitle();

        initView();

    }

    public void initData() {
        commentItemBeans.clear();
        page = 1;
        noDataFlag = true;
        request();

    }

    public void initView() {
        questionId = getIntent().getStringExtra("questionId");
        answerId = getIntent().getStringExtra("answerId");
        detailsBean = new ResultAnswerDetailsBean();
        commentItemBeans = new MouldList<ResultCircleDetailsTopicCommentItemBean>();
        setRereshEnable(true);
        initRecyclerView();

    }

    public void initRecyclerView() {

        lvAnswerDetails.setLayoutManager(new LinearLayoutManager(this));
        adapter = new TrainingAnswerDetailsListAdapter(this, commentItemBeans, TrainingAnswerDetailsActivity.this);
//        adapter = new TrainingClassListAdapter(getActivity(),arrayList);
        lvAnswerDetails.setOnResizeListener(this);

        lvAnswerDetails.setAdapter(adapter);

        //为RecyclerView添加HeaderView和FooterView
        setHeaderView(lvAnswerDetails);
//        setFooterView(lvAskDetails);

        lvAnswerDetails.setOnScrollListener(new RecyclerView.OnScrollListener() {
            int lastVisibleItem;

            @Override
            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
                if (newState == RecyclerView.SCROLL_STATE_IDLE && lastVisibleItem + 1 == adapter.getItemCount()) {

                    if (!(lastVisibleItem == 1 && page == 1)) {
                        if (noDataFlag) {
                            adapter.changeMoreStatus(TrainingHotAskListAdapter.LOADING_MORE);
                            page++;
                            requestComment();
                        }

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

    //获取回答详情数据
    public void request() {

        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
        map.put("questionId", questionId);
        map.put("answerId", answerId);
        map.put("userId", userId);

        HtmlRequest.getTrainingAnswerDetails(this, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {

                if (params.result != null) {
                    detailsBean = (ResultAnswerDetailsBean) params.result;
                    if (detailsBean.getFlag().equals("true")) {
                        setView();
                        requestComment();


                    } else {
                        if (detailsBean.getCode().equals("6011")) {      //  参数错误


                            ViewUtils.showDeleteDialog(TrainingAnswerDetailsActivity.this, detailsBean.getMessage());

                        } else if (detailsBean.getCode().equals("6012")) {        //  该回答已删除

                            ViewUtils.showDeleteDialog(TrainingAnswerDetailsActivity.this, detailsBean.getMessage());
                        } else {
                            Toast.makeText(TrainingAnswerDetailsActivity.this, detailsBean.getMessage(), Toast.LENGTH_SHORT).show();
                        }
                    }

                } else {

                }

            }
        });
    }

    //获取回答详情评论列表
    public void requestComment() {

        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
        map.put("page", page + "");
        map.put("userId", userId);
        map.put("answerId", answerId);
        HtmlRequest.getTrainingDetailsAnswerConmment(this, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params.result != null) {
                    ResultCircleDetailsTopicCommentListBean bean = (ResultCircleDetailsTopicCommentListBean) params.result;
                    if (bean.getList().size() == 0) {
                        if (page != 1) {
                            page--;
                            adapter.changeMoreStatus(RecyclerBaseAapter.NO_LOAD_MORE);
                        } else {
                            adapter.setNoDataMessage("暂无评论");
                            adapter.changeMoreStatus(RecyclerBaseAapter.NO_DATA_WRAP_CONTENT);
                            noDataFlag = false;
                            tv_answer_details_comment_count.setVisibility(View.GONE);
                        }
                    } else {
                        tv_answer_details_comment_count.setVisibility(View.VISIBLE);
                        tv_answer_details_comment_count.setText(bean.getTotal() + "评论");
                        commentItemBeans.addAll(bean.getList());
                        if (commentItemBeans.size() % 10 == 0) {
                            adapter.changeMoreStatus(RecyclerBaseAapter.PULLUP_LOAD_MORE);
                        } else {
                            adapter.changeMoreStatus(RecyclerBaseAapter.NO_LOAD_MORE);
                        }
                    }
                    adapter.notifyDataSetChanged();

                } else {

                }
                swipe.setRefreshing(false);
            }
        });
    }


    private void setHeaderView(RecyclerView view) {

        View header = LayoutInflater.from(this).inflate(R.layout.activity_training_answer_details_top, view, false);

        tv_answer_details_title = (TextView) header.findViewById(R.id.tv_answer_details_title);
        iv_answer_detatils_manager = (CircularImage) header.findViewById(R.id.iv_answer_detatils_manager);
        tv_answer_details_manager_name = (TextView) header.findViewById(R.id.tv_answer_details_manager_name);
        tv_answer_details_time = (TextView) header.findViewById(R.id.tv_answer_details_time);
        tv_answer_details_content = (TextView) header.findViewById(R.id.tv_answer_details_content);
        iv_answer_detailas_zan = (ImageView) header.findViewById(R.id.iv_answer_detailas_zan);
        tv_answer_details_comment_count = (TextView) header.findViewById(R.id.tv_answer_details_comment_count);


        iv_answer_detailas_zan.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (detailsBean.getAppAnswer().getLikeStatus().equals("no")) {


                    if (!PreferenceUtil.isLogin()) {
                        HashMap<String, Object> map = new HashMap<>();
                        RlbActivityManager.toLoginActivity(TrainingAnswerDetailsActivity.this, map, false);

                    } else {
                        if (!PreferenceUtil.getCheckStatus().equals("success")) {

                            ViewUtils.showToSaleCertificationDialog(TrainingAnswerDetailsActivity.this, "您还未认证，是否去认证");
                        } else {

                            requestLikeData();

                        }
                    }


                } else {
//                    requestLikeData();
                }
            }
        });


        adapter.setmHeaderView(header);

    }

    public void setView() {


        String id = "23232323";
        String url = Urls.URL_SHARED_ANSWER + questionId + "/" + answerId;
        title.setActivityParameters(url, id, detailsBean.getAppAnswer().getTitle(), "回答描述：" + detailsBean.getAppAnswer().getAnswerContent());

        tv_answer_details_title.setText(detailsBean.getAppAnswer().getTitle());
        ImageLoader.getInstance().displayImage(detailsBean.getAppAnswer().getAnswerPhoto(), iv_answer_detatils_manager, displayImageOptions);
        tv_answer_details_manager_name.setText(detailsBean.getAppAnswer().getAnswerName());
        tv_answer_details_time.setText(detailsBean.getAppAnswer().getAnswerTime());
        tv_answer_details_content.setText(detailsBean.getAppAnswer().getAnswerContent());

        if (detailsBean.getAppAnswer().getLikeStatus().equals("yes")) {

            iv_answer_detailas_zan.setImageResource(R.mipmap.img_answer_zan);

        } else {

            iv_answer_detailas_zan.setImageResource(R.mipmap.img_answer_zaned);

        }


    }


    private void initTopTitle() {
        title = (TitleBar) findViewById(R.id.rl_title);
        title.showLeftImg(true);
        title.setFromActivity("1000");
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false).setIndicator(R.mipmap.icon_back)
             .setCenterText(getResources().getString(R.string.training_answer_details))
             .showMore(false).setTitleRightButton(R.drawable.ic_share_title).showMore(false)
             .setOnActionListener(new TitleBar.OnActionListener() {
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


    //点赞
    public void requestLikeData() {

        iv_answer_detailas_zan.setClickable(false);
        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();

        map.put("answerId", answerId);      //  话题id
        map.put("userId", userId);

        HtmlRequest.getTrainingAnswerZan(this, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {

                if (params.result != null) {

                    ResultInfoBean bean = (ResultInfoBean) params.result;
                    if (bean.getFlag().equals("true")) {

                        iv_answer_detailas_zan.setImageResource(R.mipmap.img_answer_zan);
                        detailsBean.getAppAnswer().setLikeStatus("yes");

                    } else {
                        Toast.makeText(TrainingAnswerDetailsActivity.this, bean.getMessage(), Toast.LENGTH_SHORT).show();
                    }


                } else {

                }
                iv_answer_detailas_zan.setClickable(true);
            }
        });
    }

    @OnClick(R.id.btn_answer_details)
    public void onClick() {
        String commentContent = etAnswerDetails.getText().toString();

        if (!PreferenceUtil.isLogin()) {
            HashMap<String, Object> map = new HashMap<>();
            RlbActivityManager.toLoginActivity(TrainingAnswerDetailsActivity.this, map, false);
        } else {
            if (!PreferenceUtil.getCheckStatus().equals("success")) {
                ViewUtils.showToSaleCertificationDialog(this, "您还未认证，是否去认证");
            } else {
                if (TextUtils.isEmpty(commentId)) {  // 评论
                    requestReplyData(commentContent);
                    hiddenInputLayout();
                } else {  // 回复
                    requestReplyData(commentContent);
                    hiddenInputLayout();
                }
            }
        }
    }

    //回复评论  或者  评论
    public void requestReplyData(final String commentContent) {

//        ArrayMap<String,Object> map = new ArrayMap<String,Object>();
        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
        if (TextUtils.isEmpty(commentId)) { //评论id
            map.put("answerId", answerId); //回答id
            map.put("commentContent", commentContent);
            map.put("userId", userId);
            map.put("linkId", linkId);
        } else {
            map.put("commentId", commentId);  //话题id和
            map.put("answerId", answerId);
            map.put("commentContent", commentContent);
            map.put("toUserId", toUserId);  //被回复人id
            map.put("userId", userId);
            map.put("linkId", linkId);
        }

        HtmlRequest.getTrainingAnswerReply(this, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params.result != null) {
                    ResultInfoBean bean = (ResultInfoBean) params.result;
                    if (bean.getFlag().equals("true")) {
//                        fyTrainingTopicDetails.setVisibility(View.GONE);
                        if (!TextUtils.isEmpty(commentId)) { //回复
                            ResultCircleDetailsTopicCommentReplyItemBean itemBean = new ResultCircleDetailsTopicCommentReplyItemBean();
                            itemBean.setReplyContent(commentContent);
                            itemBean.setReplyId(userId); //回复人id
                            itemBean.setReplyToId(toUserId); // 被回复人id
                            String realName = "";
                            try {
                                realName = DESUtil.decrypt(PreferenceUtil.getUserRealName());
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            itemBean.setReplyName(realName); //回复人姓名
                            itemBean.setReplyToName(replyToName); //被回复人姓名
                            itemBean.setRid(bean.getReplyId());
                            commentItemBeans.get(index).getReplys().add(itemBean);

                            commentId = "";
                            adapter.notifyDataSetChanged();
                        } else {  // 评论
                            page = 1;
                            commentItemBeans.clear();
                            requestComment();
                        }
                    } else {
                        Toast.makeText(TrainingAnswerDetailsActivity.this, bean.getMessage(), Toast.LENGTH_SHORT).show();
                    }
                } else {
                }
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
    public void reply(String commentId, String toUserId, String replyToName, int index, String linkId) {
        this.commentId = commentId;
        this.toUserId = toUserId;
        this.replyToName = replyToName;
        this.index = index;
        this.linkId = linkId;
        etAnswerDetails.setHint("回复" + replyToName + "：");

        setBottomOffset(index);
    }

    /**
     *  弹出键盘
     * @param position
     */
    public void setBottomOffset(int position) {
        LinearLayoutManager layoutManager = (LinearLayoutManager) lvAnswerDetails.getLayoutManager();
        int index = layoutManager.findFirstVisibleItemPosition();
        try {
            if (index > position) {
                index = position;
                if (isShowComment.get()) {
                    bottomOffset = lvAnswerDetails.getChildAt(position - index).getBottom();
                } else {
                    bottomOffset = lvAnswerDetails.getChildAt(index - position).getBottom() - lvAnswerDetails.getChildAt(index - position).getHeight();
                }
            } else {
                bottomOffset = lvAnswerDetails.getChildAt(position - index).getBottom();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (!deal(position)) showInputLayout();
    }

    private AtomicBoolean isShowComment = new AtomicBoolean(false);

    private boolean deal(int position) {
        if (isShowComment.get()) {
            if (oldPosition != position) {
                int height = lvAnswerDetails.getHeight();
                int offset = -(height - bottomOffset);
                putOffset(offset);
            }
            return true;
        }
        return false;
    }

    @OnTouch(R.id.lv_answer_details)
    boolean onTouch(View v, MotionEvent event) {
        if (MotionEvent.ACTION_MOVE == event.getAction()) {
            commentId = "";
            hiddenInputLayout();
        }
        return false;
    }


    private void showInputLayout() {
        isShowComment.set(true);
        InputMethodUtils.showSoftKeyboard(etAnswerDetails);
    }

    private void putOffset(int offset) {
        try {
            lvAnswerDetails.smoothScrollBy(0, offset);
            oldPosition = index;
        } catch (Exception e) {
            e.printStackTrace();
        }

    }


    /**
     * 隐藏键盘
     */
    private void hiddenInputLayout() {
        isShowComment.set(false);
        etAnswerDetails.setText("");
        etAnswerDetails.setHint(getString(R.string.training_class_details_discuss_comment_hint));

//        flAnswerDetails.setVisibility(View.GONE);
        InputMethodUtils.hiddenSoftKeyboard(this);
    }

    public int getItemHeight() {
        LinearLayoutManager layoutManager = (LinearLayoutManager) lvAnswerDetails.getLayoutManager();
        int position = layoutManager.findFirstVisibleItemPosition() - 1;
//        int index = layoutManager.findFirstCompletelyVisibleItemPosition();
        if (position > index) {
            position = index;
        }
        int set = 0;
        try {
            set = lvAnswerDetails.getChildAt(index - position).getHeight();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return set;
    }

    @Override
    public void OnResize(int w, int h, int oldw, int oldh) {
        if (oldh > h) {
            int offset = (oldh - h + getItemHeight()) - (oldh - bottomOffset);
            putOffset(offset);
        }
    }

}
