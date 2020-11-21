package com.rulaibao.adapter.holder;

import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.widget.CircularImage;

import butterknife.BindView;
import butterknife.ButterKnife;

public class AskViewHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.tv_training_ask_title)
    public TextView tvTrainingAskTitle;
    @BindView(R.id.tv_training_ask_count)
    public TextView tvTrainingAskCount;
    @BindView(R.id.tv_training_ask_time)
    public TextView tvTrainingAskTime;
    @BindView(R.id.iv_training_ask)
    public CircularImage ivTrainingAsk;
    @BindView(R.id.tv_training_ask_manager)
    public TextView tvTrainingAskManager;
    @BindView(R.id.tv_training_ask_answer)
    public TextView tvTrainingAskAnswer;

    public AskViewHolder(View view) {
        super(view);
        ButterKnife.bind(this, view);

    }

}
