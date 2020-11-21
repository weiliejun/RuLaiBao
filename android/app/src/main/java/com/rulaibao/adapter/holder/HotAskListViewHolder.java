package com.rulaibao.adapter.holder;

import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.TextView;

import com.rulaibao.R;

import butterknife.BindView;
import butterknife.ButterKnife;

public class HotAskListViewHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.tv_hot_title)
    public TextView tvHotTitle;
    @BindView(R.id.tv_hot_content)
    public TextView tvHotContent;
    @BindView(R.id.tv_hot_name)
    public TextView tvHotName;
    @BindView(R.id.tv_hot_ask_leave)
    public TextView tvHotAskLeave;
    @BindView(R.id.tv_hot_ask_leave_count)
    public TextView tvHotAskLeaveCount;

    public HotAskListViewHolder(View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);

    }
}
