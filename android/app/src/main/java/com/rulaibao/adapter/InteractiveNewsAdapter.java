package com.rulaibao.adapter;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.nostra13.universalimageloader.core.ImageLoader;
import com.rulaibao.R;
import com.rulaibao.activity.TrainingAnswerDetailsActivity;
import com.rulaibao.activity.TrainingAskDetailsActivity;
import com.rulaibao.activity.TrainingClassDetailsActivity;
import com.rulaibao.activity.TrainingTopicDetailsActivity;
import com.rulaibao.bean.InteractiveNewsList2B;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.ImageUtils;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;


/**
 * 互动消息  Adapter 类
 */
public class InteractiveNewsAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private final MouldList<InteractiveNewsList2B> list;
    Context mContext;
    LayoutInflater mInflater;
    private static final int TYPE_ITEM = 0;
    private static final int TYPE_FOOTER = 1;

    //上拉加载更多
    public static final int PULLUP_LOAD_MORE = 0;
    //正在加载中
    public static final int LOADING_MORE = 1;
    //没有加载更多 隐藏
    public static final int NO_LOAD_MORE = 2;

    //上拉加载更多状态-默认为0
    private int mLoadMoreStatus = 0;


    public InteractiveNewsAdapter(Context context, MouldList<InteractiveNewsList2B> list) {
        mContext = context;
        this.list = list;
        mInflater = LayoutInflater.from(context);
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        if (viewType == TYPE_ITEM) { // 加载互动消息的item 布局
            View itemView = mInflater.inflate(R.layout.item_interactive_news, parent, false);

            return new ItemViewHolder(itemView);
        } else if (viewType == TYPE_FOOTER) {
            View itemView = mInflater.inflate(R.layout.load_more_footview_layout, parent, false);

            return new FooterViewHolder(itemView);
        }
        return null;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        if (holder instanceof ItemViewHolder) {
            ItemViewHolder itemViewHolder = (ItemViewHolder) holder;

            // 加载头像
            String replyPhotoUrl = list.get(position).getReplyPhoto();
            if (!TextUtils.isEmpty(replyPhotoUrl)) {
                ImageLoader.getInstance().displayImage(replyPhotoUrl,  itemViewHolder.iv_interactive_news_photo);
            }else {
                itemViewHolder.iv_interactive_news_photo.setImageResource(R.mipmap.ic_ask_photo_default);
            }

            itemViewHolder.tv_interactive_news_name.setText(list.get(position).getReplyName());
            itemViewHolder.tv_interactive_news_date.setText(list.get(position).getCreateTime());
            itemViewHolder.tv_interactive_news_title.setText(list.get(position).getReplyContent());
            itemViewHolder.tv_interactive_news_reply.setText(list.get(position).getThemeContent());

            initListener(itemViewHolder.itemView,list.get(position).getType(),position);
        } else if (holder instanceof FooterViewHolder) {
            FooterViewHolder footerViewHolder = (FooterViewHolder) holder;

            switch (mLoadMoreStatus) {
                case PULLUP_LOAD_MORE:
                    footerViewHolder.tvLoadText.setText("数据加载中...");
                    break;
                case LOADING_MORE:
                    footerViewHolder.tvLoadText.setText("正加载更多...");
                    break;
                case NO_LOAD_MORE:
                    //隐藏加载更多
                    footerViewHolder.loadLayout.setVisibility(View.GONE);
                    break;

            }
        }

    }

    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size()+1;
    }

    @Override
    public int getItemViewType(int position) {

        if (position + 1 == getItemCount()) {
            //最后一个item设置为footerView
            return TYPE_FOOTER;
        } else {
            return TYPE_ITEM;
        }
    }

    public class ItemViewHolder extends RecyclerView.ViewHolder {
        private final ImageView iv_interactive_news_photo; // 回复人的头像
        private final TextView tv_interactive_news_name; // 回复人的姓名
//        private final TextView tv_interactive_news_time; // 时间
        private final TextView tv_interactive_news_date; // 日期
        private final TextView tv_interactive_news_title; // 互动消息标题
        private final TextView tv_interactive_news_reply; // 回复内容

        public ItemViewHolder(View itemView) {
            super(itemView);
            iv_interactive_news_photo = (ImageView) itemView.findViewById(R.id.iv_interactive_news_photo);
            tv_interactive_news_name = (TextView) itemView.findViewById(R.id.tv_interactive_news_name);
//            tv_interactive_news_time = (TextView) itemView.findViewById(R.id.tv_interactive_news_time);
            tv_interactive_news_date = (TextView) itemView.findViewById(R.id.tv_interactive_news_date);
            tv_interactive_news_title = (TextView) itemView.findViewById(R.id.tv_interactive_news_title);
            tv_interactive_news_reply = (TextView) itemView.findViewById(R.id.tv_interactive_news_reply);
        }
    }

    /**
     * item 点击监听
     *  消息类型：question：跳转到提问详情；answer：跳转到回答详情；
                  topic：跳转到话题详情；  course：跳转到课程详情；

     * @param itemView
     */
    private void initListener(View itemView, String type, final int position) {
        itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) { //
                if ("question".equals(list.get(position).getType())) { // 跳转到提问详情
                    Intent intent = new Intent(mContext,TrainingAskDetailsActivity.class);
                    intent.putExtra("questionId", list.get(position).getParam1());
                    mContext.startActivity(intent);
                } else if ("answer".equals(list.get(position).getType())) { //跳转到回答详情
                    Intent intent = new Intent(mContext,TrainingAnswerDetailsActivity.class);
                    intent.putExtra("questionId", list.get(position).getParam1());
                    intent.putExtra("answerId", list.get(position).getParam2());
                    mContext.startActivity(intent);
                }else if ("topic".equals(list.get(position).getType())) { //跳转到话题详情
                    Intent intent = new Intent(mContext,TrainingTopicDetailsActivity.class);
                    intent.putExtra("appTopicId", list.get(position).getParam1());
                    mContext.startActivity(intent);
                }else if ("course".equals(list.get(position).getType())) { //跳转到课程详情
                    Intent intent = new Intent(mContext,TrainingClassDetailsActivity.class);
                    intent.putExtra("id", list.get(position).getParam1());
                    intent.putExtra("speechmakeId", list.get(position).getParam2());
                    intent.putExtra("courseId", list.get(position).getParam1());
                    mContext.startActivity(intent);
                }
            }
        });
    }

    public class FooterViewHolder extends RecyclerView.ViewHolder {

        private final ProgressBar pbLoad;
        private final TextView tvLoadText;
        private final LinearLayout loadLayout;

        public FooterViewHolder(View itemView) {
            super(itemView);

            pbLoad = (ProgressBar) itemView.findViewById(R.id.pbLoad);
            tvLoadText = (TextView) itemView.findViewById(R.id.tvLoadText);
            loadLayout = (LinearLayout) itemView.findViewById(R.id.loadLayout);
        }
    }


    public void AddHeaderItem(MouldList<InteractiveNewsList2B> items) {
        list.addAll(0, items);
        notifyDataSetChanged();
    }

    public void AddFooterItem(MouldList<InteractiveNewsList2B> items) {
        list.addAll(items);
        notifyDataSetChanged();
    }

    /**
     * 更新加载更多状态
     *
     * @param status
     */
    public void changeMoreStatus(int status) {
        mLoadMoreStatus = status;
        notifyDataSetChanged();
    }
}
