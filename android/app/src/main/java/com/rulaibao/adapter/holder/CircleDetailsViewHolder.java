package com.rulaibao.adapter.holder;

import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.widget.CircularImage;

import butterknife.BindView;
import butterknife.ButterKnife;

public class CircleDetailsViewHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.iv_training_circle_details_manager)
    public CircularImage ivTrainingCircleDetailsManager;
    @BindView(R.id.tv_training_circle_details_manager_name)
    public TextView tvTrainingCircleDetailsManagerName;
    @BindView(R.id.tv_circle_details_content)
    public TextView tvCircleDetailsContent;
    @BindView(R.id.tv_circle_details_time)
    public TextView tvCircleDetailsTime;
    @BindView(R.id.tv_circle_details_message_count)
    public TextView tvCircleDetailsMessageCount;
    @BindView(R.id.iv_circle_details_zan)
    public ImageView ivCircleDetailsZan;
    @BindView(R.id.tv_circle_details_zan_count)
    public TextView tvCircleDetailsZanCount;
    @BindView(R.id.ll_circle_details_zan)
    public LinearLayout llCircleDetailsZan;
    public CircleDetailsViewHolder(View view) {
        super(view);
        ButterKnife.bind(this, view);
    }

}
