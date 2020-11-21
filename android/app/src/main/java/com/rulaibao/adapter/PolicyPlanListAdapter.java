package com.rulaibao.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.rulaibao.R;
import com.rulaibao.activity.PolicyRecordDetailActivity;
import com.rulaibao.adapter.holder.FooterViewHolder;
import com.rulaibao.bean.PolicyPlan3B;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.ImageLoaderManager;

import butterknife.BindView;
import butterknife.ButterKnife;


public class PolicyPlanListAdapter extends RecyclerBaseAapter<RecyclerView.ViewHolder> {


    private MouldList<PolicyPlan3B> arrayList;
    private LoadMoreData loadMoreData;
    private DisplayImageOptions displayImageOptions= ImageLoaderManager.initDisplayImageOptions
            (R.mipmap.ic_plan_default, R.mipmap.ic_plan_default, R.mipmap.ic_plan_default);

    public PolicyPlanListAdapter(Context context, MouldList<PolicyPlan3B> arrayList) {
        super(context);
        this.context = context;
        this.arrayList = arrayList;
        layoutInflater = LayoutInflater.from(context);
    }

    @Override
    public RecyclerView.ViewHolder inflateItemView(ViewGroup parent) {
        View view = layoutInflater.inflate(R.layout.activity_policy_plan_item, parent,false);
        ViewHolder holder = new ViewHolder(view);
        return holder;
    }

    @Override
    public void initHolderData(RecyclerView.ViewHolder holder, int position) {
        ViewHolder holder1 = (ViewHolder) holder;
        int index = position;
        String name = arrayList.get(index).getCustomerName();
        String url = arrayList.get(index).getCompanyLogo();
        String title = arrayList.get(index).getInsuranceName();
        String amount = arrayList.get(index).getPaymentedPremiums();
        String limit = arrayList.get(index).getInsurancePeriod();

        if (!TextUtils.isEmpty(url)) {
            // ImageLoader 加载图片
            ImageLoader.getInstance().displayImage(url, holder1.iv_plan, displayImageOptions);
        } else {
        }
        if (!TextUtils.isEmpty(title)) {
            holder1.tv_title.setText(title);
        } else {
            holder1.tv_title.setText("--");
        }
        if (!TextUtils.isEmpty(amount)) {
            holder1.tv_amount.setText(amount+"元");
        } else {
            holder1.tv_amount.setText("--");
        }
        if (!TextUtils.isEmpty(limit)) {
            holder1.tv_limit.setText(limit);
        } else {
            holder1.tv_limit.setText("--");
        }
        if (!TextUtils.isEmpty(name)) {
            holder1.tv_name.setText(name);
        } else {
            holder1.tv_name.setText("--");
        }
        final int finalIndex = index;
        holder1.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(context, PolicyRecordDetailActivity.class);
                intent.putExtra("orderId", arrayList.get(finalIndex).getOrderId());
                context.startActivity(intent);
            }
        });
    }

    @Override
    public int getItem() {
        if(mHeaderView!=null){
            return arrayList.size() + 2;
        }else{
            return arrayList.size() + 1;
        }
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, final int position) {

        if (holder instanceof ViewHolder) {
            initHolderData(holder, position);
        } else if (holder instanceof FooterViewHolder) {
            FooterViewHolder footerViewHolder = (FooterViewHolder) holder;
            switch (mLoadMoreStatus) {
                case PULLUP_LOAD_MORE:
                    footerViewHolder.tvFooterMore.setText("数据加载中...");
                    break;
                case LOADING_MORE:
                    footerViewHolder.tvFooterMore.setText("正加载更多...");
                    break;
                case NO_LOAD_MORE:
                    //隐藏加载更多
                    footerViewHolder.tvFooterMore.setVisibility(View.GONE);
                    break;
            }
        }

    }

    class ViewHolder extends RecyclerView.ViewHolder {

        @BindView(R.id.iv_policy_plan)
        ImageView iv_plan;
        @BindView(R.id.tv_title)
        TextView tv_title;
        @BindView(R.id.tv_policy_plan_name)
        TextView tv_name;
        @BindView(R.id.tv_amount)
        TextView tv_amount;
        @BindView(R.id.tv_limit)
        TextView tv_limit;


        public ViewHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);

        }
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

    /**
     * 更新加载更多状态
     *
     * @param status
     */
    public void changeMoreStatus(int status) {
        mLoadMoreStatus = status;
        notifyDataSetChanged();
    }

    public interface LoadMoreData {
        public void getMoreData();
    }


}
