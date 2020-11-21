package com.rulaibao.adapter;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.activity.PlatformBulletinDetailActivity;
import com.rulaibao.activity.WebActivity;
import com.rulaibao.bean.PlatformBulletinList2B;
import com.rulaibao.common.Urls;
import com.rulaibao.network.types.MouldList;


/**
 * 平台公告列表 Adapter 类
 */
public class PlatformBulletinAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private final MouldList<PlatformBulletinList2B> list;
    private final String userId;
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


    public PlatformBulletinAdapter(Context context, String userId, MouldList<PlatformBulletinList2B> list) {
        mContext = context;
        this.userId = userId;
        this.list = list;
        mInflater = LayoutInflater.from(context);
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        if (viewType == TYPE_ITEM) {
            View itemView = mInflater.inflate(R.layout.item_platform_bulletin, parent, false);

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
            String status = list.get(position).getReadState();
            if ("yes".equals(status)) { // 已读状态
                itemViewHolder.tv_bulletin_title.setText(list.get(position).getTopic());
                itemViewHolder.tv_bulletin_time.setText(list.get(position).getPublishTime());
                itemViewHolder.tv_bulletin_content.setText(list.get(position).getDescription());

                itemViewHolder.tv_bulletin_title.setTextColor(mContext.getResources().getColor(R.color.txt_mark_gray));
                itemViewHolder.tv_bulletin_time.setTextColor(mContext.getResources().getColor(R.color.txt_mark_gray));
                itemViewHolder.tv_bulletin_content.setTextColor(mContext.getResources().getColor(R.color.txt_mark_gray));
            } else if ("no".equals(status)) { // 未读状态
                itemViewHolder.tv_bulletin_title.setText(list.get(position).getTopic());
                itemViewHolder.tv_bulletin_time.setText(list.get(position).getPublishTime());
                itemViewHolder.tv_bulletin_content.setText(list.get(position).getDescription());

                itemViewHolder.tv_bulletin_title.setTextColor(mContext.getResources().getColor(R.color.txt_black1));
                itemViewHolder.tv_bulletin_time.setTextColor(mContext.getResources().getColor(R.color.txt_black1));
                itemViewHolder.tv_bulletin_content.setTextColor(mContext.getResources().getColor(R.color.txt_black1));
            }

            initListener(itemViewHolder.itemView, list.get(position).getId(),position);
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
        private final TextView tv_bulletin_time; // 公告时间
        private final TextView tv_bulletin_title; // 公告标题
        private final TextView tv_bulletin_content; // 公告内容

        public ItemViewHolder(View itemView) {
            super(itemView);
            tv_bulletin_time = (TextView) itemView.findViewById(R.id.tv_bulletin_time);
            tv_bulletin_title = (TextView) itemView.findViewById(R.id.tv_bulletin_title);
            tv_bulletin_content = (TextView) itemView.findViewById(R.id.tv_bulletin_content);
        }

    }

    /**
     * item 点击监听
     * @param itemView
     */
    private void initListener(View itemView, final String id, final int position) {
        itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) { // 跳转到公告详情
                Intent intent = new Intent(mContext, WebActivity.class);
                intent.putExtra("type", WebActivity.WEB_TYPE_NOTICE);
                intent.putExtra("title", "公告详情");
                intent.putExtra("url", Urls.URL_BULLETIN_DETAIL + "?id=" + id + "&userId=" + userId);
                mContext.startActivity(intent);
                list.get(position).setReadState("yes");
                notifyDataSetChanged();
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


    public void AddHeaderItem(MouldList<PlatformBulletinList2B> items) {
        list.addAll(0, items);
        notifyDataSetChanged();
    }

    public void AddFooterItem(MouldList<PlatformBulletinList2B> items) {
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
