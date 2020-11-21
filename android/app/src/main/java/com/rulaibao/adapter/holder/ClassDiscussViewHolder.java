package com.rulaibao.adapter.holder;

import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.widget.CircularImage;

import butterknife.BindView;
import butterknife.ButterKnife;

public class ClassDiscussViewHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.iv_training_discuss)
    public CircularImage ivTrainingDiscuss;
    @BindView(R.id.tv_training_discuss_name)
    public TextView tvTrainingDiscussName;
    @BindView(R.id.tv_training_discuss_date)
    public TextView tvTrainingDiscussDate;
    @BindView(R.id.tv_training_discuss_content)
    public TextView tvTrainingDiscussContent;
    @BindView(R.id.tv_discuss_reply)
    public TextView tvDiscussReply;
    @BindView(R.id.tv_training_discuss_repay_content)
    public TextView tvTrainingDiscussRepayContent;

    public ClassDiscussViewHolder(View view) {
        super(view);
        ButterKnife.bind(this, view);
    }

}
