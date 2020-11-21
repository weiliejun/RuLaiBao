package com.rulaibao.adapter;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.bean.MyTopicList2B;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.RlbActivityManager;

import java.util.HashMap;


/**
 * 我的话题列表 Adapter 类
 */
public class MyTopicAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private final MouldList<MyTopicList2B> list;
    Activity mContext;
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


    public MyTopicAdapter(Activity activity, MouldList<MyTopicList2B> list) {
        mContext = activity;
        this.list = list;
        mInflater = LayoutInflater.from(mContext);
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        if (viewType == TYPE_ITEM) { // 加载话题item布局
            View itemView = mInflater.inflate(R.layout.item_my_topic, parent, false);

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
            itemViewHolder.tv_circle_name.setText(list.get(position).getCircleName());
//            itemViewHolder.tv_group_name.setText(list.get(position).getGroupName());
            itemViewHolder.tv_topic_title.setText(list.get(position).getTopicContent());
            itemViewHolder.tv_zan_number.setText(list.get(position).getLikeCount());
            itemViewHolder.tv_comment_number.setText(list.get(position).getCommentCount());

            initListener( itemViewHolder.itemView,list.get(position).getTopicId());
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
        private final TextView tv_circle_name; // 圈子名
        //        private final TextView tv_group_name; // 小组名
        private final TextView tv_topic_title; // 话题标题
        private final TextView tv_zan_number; // 点赞数
        private final TextView tv_comment_number; // 评论数

        public ItemViewHolder(View itemView) {
            super(itemView);
            tv_circle_name = (TextView) itemView.findViewById(R.id.tv_circle_name);
//            tv_group_name = (TextView) itemView.findViewById(R.id.tv_group_name);
            tv_topic_title = (TextView) itemView.findViewById(R.id.tv_topic_title);
            tv_zan_number = (TextView) itemView.findViewById(R.id.tv_zan_number);
            tv_comment_number = (TextView) itemView.findViewById(R.id.tv_comment_number);

        }
    }

    /**
     * item 点击监听
     *
     * @param itemView
     */
    private void initListener(View itemView,final String id) {
        itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) { // 跳转到话题详情
//                    Toast.makeText(mContext, "poistion " + getAdapterPosition(), Toast.LENGTH_SHORT).show();

                HashMap<String, Object> map = new HashMap<String, Object>();
                map.put("appTopicId", id);
                RlbActivityManager.toTrainingTopicDetailsActivity(mContext, map, false);
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


    public void AddHeaderItem(MouldList<MyTopicList2B> items) {
        list.addAll(0, items);
        notifyDataSetChanged();
    }

    public void AddFooterItem(MouldList<MyTopicList2B> items) {
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
