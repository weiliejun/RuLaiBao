package com.rulaibao.adapter.holder;

import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.rulaibao.R;

import butterknife.BindView;
import butterknife.ButterKnife;

public class FooterViewHolder extends RecyclerView.ViewHolder

{

    public TextView tvFooterMore;
    public ImageView ivHotAskFooter;
    public TextView tv_footer_more_download;

    public FooterViewHolder(View itemView) {
        super(itemView);
        tv_footer_more_download = (TextView) itemView.findViewById(R.id.tv_footer_more_download);
        tvFooterMore = (TextView) itemView.findViewById(R.id.tv_footer_more);
        ivHotAskFooter = (ImageView) itemView.findViewById(R.id.iv_hot_ask_footer);
        ButterKnife.bind(this, itemView);
        itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                    loadMoreData.getMoreData();

            }
        });
    }

}
