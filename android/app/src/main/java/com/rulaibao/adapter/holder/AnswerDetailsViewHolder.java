package com.rulaibao.adapter.holder;

import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.widget.CircularImage;
import com.rulaibao.widget.MyListView;

import butterknife.BindView;
import butterknife.ButterKnife;

public class AnswerDetailsViewHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.iv_answer_details)
    public CircularImage ivAnswerDetails;
    @BindView(R.id.tv_answer_details_name)
    public TextView tvAnswerDetailsName;
    @BindView(R.id.tv_answer_details_date)
    public TextView tvAnswerDetailsDate;
    @BindView(R.id.tv_answer_details_content)
    public TextView tvAnswerDetailsContent;
    @BindView(R.id.tv_answer_details_reply)
    public TextView tvAnswerDetailsReply;
    @BindView(R.id.lv_answer_details)
    public MyListView lvAnswerDetails;
    @BindView(R.id.tv_answer_detailas_line)
    public TextView tvAnswerDetailasLine;
    @BindView(R.id.tv_answer_detailas_link)
    public TextView tvAnswerDetailasLink;
    @BindView(R.id.iv_answer_detailas)
    public ImageView ivAnswerDetailas;

    public AnswerDetailsViewHolder(View view) {
        super(view);
        ButterKnife.bind(this, view);

    }

}
