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

public class PromotionMoneyViewHolder extends RecyclerView.ViewHolder {
    @BindView(R.id.tv_promotionMoney)
    public TextView tv_promotionMoney;

    public PromotionMoneyViewHolder(View view) {
        super(view);
        ButterKnife.bind(this, view);

    }


}
