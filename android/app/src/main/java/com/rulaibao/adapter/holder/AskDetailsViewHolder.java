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

public class AskDetailsViewHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.iv_training_ask_details_manager)
    public CircularImage ivTrainingAskDetailsManager;
    @BindView(R.id.tv_training_ask_details_manager_name)
    public TextView tvTrainingAskDetailsManagerName;
    @BindView(R.id.tv_ask_details_content)
    public TextView tvAskDetailsContent;
    @BindView(R.id.tv_ask_details_time)
    public TextView tvAskDetailsTime;
    @BindView(R.id.tv_ask_details_message_count)
    public TextView tvAskDetailsMessageCount;
    @BindView(R.id.iv_ask_details_zan)
    public ImageView ivAskDetailsZan;
    @BindView(R.id.tv_ask_details_zan_count)
    public TextView tvAskDetailsZanCount;
    @BindView(R.id.ll_ask_details_message)
    public LinearLayout llAskDetailsMessage;
    @BindView(R.id.ll_ask_details_zan)
    public LinearLayout llAskDetailsZan;

    public AskDetailsViewHolder(View view) {
        super(view);
        ButterKnife.bind(this, view);

    }


}
