package com.rulaibao.adapter;

import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.support.v4.app.FragmentActivity;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.activity.PolicyBookingDetailActivity;
import com.rulaibao.activity.PolicyBookingListActivity;
import com.rulaibao.bean.PolicyBookingList2B;
import com.rulaibao.fragment.PolicyBookingFragment;
import com.rulaibao.network.types.MouldList;


/**
 * 预约列表  RecyclerView的 Adapter 类
 */
public class PolicyBookingAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private final MouldList<PolicyBookingList2B> list;
    private final PolicyBookingFragment fragment;
    private final FragmentActivity activity;
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
    private PolicyBookingFragment policyBookingFragment;


    public PolicyBookingAdapter(PolicyBookingFragment fragment, MouldList<PolicyBookingList2B> list) {
        this.fragment = fragment;
        this.list = list;
        mInflater = LayoutInflater.from(fragment.getContext());

        activity = fragment.getActivity();
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        if (viewType == TYPE_ITEM) { // 加载预约列表 item 布局
            View itemView = mInflater.inflate(R.layout.item_policy_booking, parent, false);

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
            itemViewHolder.tv_insurance_name.setText(list.get(position).getProductName());
            String status = list.get(position).getAuditStatus();
            if ("confirming".equals(status)) {
                itemViewHolder.tv_status.setText("待确认");
            } else if ("confirmed".equals(status)) {
                itemViewHolder.tv_status.setText("已确认");
            } else if ("refuse".equals(status)) {
                itemViewHolder.tv_status.setText("已驳回");
            } else if ("canceled".equals(status)) {
                itemViewHolder.tv_status.setText("已取消");
            }
            itemViewHolder.tv_insurance_premiums.setText(list.get(position).getInsuranceAmount());

            initListener(itemViewHolder.itemView, position);

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
        return list == null ? 0 : list.size() + 1;
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
        private final TextView tv_status; // 状态
        private final TextView tv_insurance_premiums; // 保费

        public ItemViewHolder(View itemView) {
            super(itemView);
            tv_insurance_name = (TextView) itemView.findViewById(R.id.tv_insurance_name);
            tv_status = (TextView) itemView.findViewById(R.id.tv_status);
            tv_insurance_premiums = (TextView) itemView.findViewById(R.id.tv_insurance_premiums);
        }
    }

    /**
     * item 点击监听
     *
     * @param itemView
     */
    public void initListener(View itemView, final int position) {
        itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) { // 跳转到预约详情
                Intent intent = new Intent(fragment.getContext(), PolicyBookingDetailActivity.class);
                intent.putExtra("id", list.get(position).getId());
                activity.startActivityForResult(intent, PolicyBookingListActivity.REQUEST_CODE);
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


    public void AddHeaderItem(MouldList<PolicyBookingList2B> items) {
        list.addAll(0, items);
        notifyDataSetChanged();
    }

    public void AddFooterItem(MouldList<PolicyBookingList2B> items) {
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
