package com.rulaibao.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.activity.CommissionDetailActivity;
import com.rulaibao.bean.CommissionDetailList2B;
import com.rulaibao.bean.TrackingList2B;
import com.rulaibao.network.types.MouldList;


/**
 *  佣金明细 Adapter 类
 */
public class CommissionListAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private final MouldList<TrackingList2B> list;
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
    private int mLoadMoreStatus = 2;


    public CommissionListAdapter(Context context, MouldList<TrackingList2B> list) {
        mContext = context;
        this.list = list;
        mInflater = LayoutInflater.from(context);
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        if (viewType == TYPE_ITEM) { // 加载佣金明细列表 item 布局
            View itemView = mInflater.inflate(R.layout.item_transaction_record_commission, parent, false);
            return new ItemViewHolder(itemView);

        } else if (viewType == TYPE_FOOTER) {   // 加载底部布局
            View itemView = mInflater.inflate(R.layout.load_more_footview_layout, parent, false);
            return new FooterViewHolder(itemView);
        }
        return null;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        if (holder instanceof ItemViewHolder) {
            ItemViewHolder itemViewHolder = (ItemViewHolder) holder;
            itemViewHolder.tv_insurance_name.setText(list.get(position).getProductName());
            itemViewHolder.tv_income_date.setText("收益日期："+list.get(position).getCommissionTime());
            itemViewHolder.tv_commission.setText("+"+list.get(position).getCommissionGained());

            initListener(itemViewHolder.itemView,position);
        } else if (holder instanceof FooterViewHolder) {
            FooterViewHolder footerViewHolder = (FooterViewHolder) holder;

            switch (mLoadMoreStatus) {
                case PULLUP_LOAD_MORE:
                    footerViewHolder.tvLoadText.setText("数据加载中...");
                    footerViewHolder.loadLayout.setVisibility(View.VISIBLE);
                    break;
                case LOADING_MORE:
                    footerViewHolder.tvLoadText.setText("正加载更多...");
                    footerViewHolder.loadLayout.setVisibility(View.VISIBLE);
                    break;
                case NO_LOAD_MORE:
                    //隐藏加载更多
//                    footerViewHolder.pbLoad.setVisibility(View.GONE);
//                    footerViewHolder.tvLoadText.setText("已显示全部");
//                    footerViewHolder.tvLoadText.setTextColor(Color.parseColor("#999999"));
//                    footerViewHolder.loadLayout.setVisibility(View.VISIBLE);
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
        private final TextView tv_insurance_name; // 保单名称
        private final TextView tv_income_date; //收益日期
        private final TextView tv_commission; // 佣金收益

        public ItemViewHolder(View itemView) {
            super(itemView);
            tv_insurance_name = (TextView) itemView.findViewById(R.id.tv_insurance_name);
            tv_income_date = (TextView) itemView.findViewById(R.id.tv_income_date);
            tv_commission = (TextView) itemView.findViewById(R.id.tv_commission);
        }
    }

    /**
     * item 点击监听
     *
     * @param itemView
     */
    private void initListener(View itemView,final int position) {
        itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) { // 跳转到佣金详情
//                    Toast.makeText(mContext, "poistion " + getAdapterPosition(), Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(mContext, CommissionDetailActivity.class);
                intent.putExtra("id", list.get(position).getId());
                mContext.startActivity(intent);
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


    public void AddHeaderItem(MouldList<TrackingList2B> items) {
        list.addAll(0, items);
        notifyDataSetChanged();
    }

    public void AddFooterItem(MouldList<TrackingList2B> items) {
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
