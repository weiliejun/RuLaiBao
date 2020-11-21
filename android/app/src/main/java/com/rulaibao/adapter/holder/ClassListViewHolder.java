package com.rulaibao.adapter.holder;

import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.rulaibao.R;

import butterknife.BindView;
import butterknife.ButterKnife;

public class ClassListViewHolder extends RecyclerView.ViewHolder {


    @BindView(R.id.tv_training_name)
    public TextView tvTrainingName;
    @BindView(R.id.tv_training_class_time)
    public TextView tvTrainingClassTime;
    @BindView(R.id.iv_training_recommend)
    public ImageView ivTrainingRecommend;
    @BindView(R.id.tv_training_recommend_manager)
    public TextView tvTrainingRecommendManager;
    @BindView(R.id.tv_training_recommend_manager_name)
    public TextView tvTrainingRecommendManagerName;
    @BindView(R.id.rsv_fragment_training)
    public FrameLayout rsvFragmentTraining;


    public ClassListViewHolder(View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
//            tv_training_name = (TextView) itemView.findViewById(R.id.tv_training_name);

    }
}
