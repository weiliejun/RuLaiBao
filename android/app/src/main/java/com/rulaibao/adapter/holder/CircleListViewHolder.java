package com.rulaibao.adapter.holder;

import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.widget.CircularImage;

import butterknife.BindView;
import butterknife.ButterKnife;

public class CircleListViewHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.iv_mycircle_sign)
    public CircularImage ivMycircleSign;
    @BindView(R.id.tv_mycircle_name)
    public TextView tvMycircleName;
    @BindView(R.id.tv_mycircle_description)
    public TextView tvMycircleDescription;
    @BindView(R.id.tv_circle_join)
    public TextView tvCircleJoin;

    public CircleListViewHolder(View view) {
        super(view);
        ButterKnife.bind(this, view);
    }


}
