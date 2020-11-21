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

import com.nostra13.universalimageloader.core.ImageLoader;
import com.rulaibao.R;
import com.rulaibao.activity.PolicyRecordDetailActivity;
import com.rulaibao.bean.CommissionList2B;
import com.rulaibao.network.types.MouldList;


/**
 *  已发佣金 Adapter 类
 */
public class HaveGetCommissionAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private final MouldList<CommissionList2B> list;
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


    public HaveGetCommissionAdapter(Context context, MouldList<CommissionList2B> list) {
        mContext = context;
        this.list = list;
        mInflater = LayoutInflater.from(context);
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        if (viewType == TYPE_ITEM) { // 加载已发佣金 item 布局
            View itemView = mInflater.inflate(R.layout.item_commission_list, parent, false);
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
            itemViewHolder.tv_customer_name.setText(list.get(position).getUserName());
            itemViewHolder.tv_insurance_premiums.setText(list.get(position).getPaymentedPremiums() + "元");
            itemViewHolder.tv_insurance_period.setText(list.get(position).getInsurancePeriod());
            // 加载图片
            ImageLoader.getInstance().displayImage(list.get(position).getCompanyLogo(), itemViewHolder.iv_company_logo);

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
        private final TextView tv_customer_name; // 客户姓名
        private final TextView tv_insurance_premiums; // 已交保费
        private final TextView tv_insurance_period; // 保险期限
        private final ImageView iv_company_logo; // 保险公司logo

        public ItemViewHolder(View itemView) {
            super(itemView);
            tv_insurance_name = (TextView) itemView.findViewById(R.id.tv_insurance_name);
            tv_customer_name = (TextView) itemView.findViewById(R.id.tv_customer_name);
            tv_insurance_premiums = (TextView) itemView.findViewById(R.id.tv_insurance_premiums);
            tv_insurance_period = (TextView) itemView.findViewById(R.id.tv_insurance_period);
            iv_company_logo = (ImageView) itemView.findViewById(R.id.iv_company_logo);
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
            public void onClick(View v) { // 跳转到保单详情
//                    Toast.makeText(mContext, "poistion " + getAdapterPosition(), Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(mContext, PolicyRecordDetailActivity.class);
                intent.putExtra("orderId", list.get(position).getOrderId());
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


    public void AddHeaderItem(MouldList<CommissionList2B> items) {
        list.addAll(0, items);
        notifyDataSetChanged();
    }

    public void AddFooterItem(MouldList<CommissionList2B> items) {
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
