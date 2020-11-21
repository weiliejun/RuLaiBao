package com.rulaibao.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.rulaibao.R;
import com.rulaibao.adapter.holder.AskViewHolder;
import com.rulaibao.adapter.holder.FooterViewHolder;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.ResultAskIndexItemBean;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.ImageLoaderManager;
import com.rulaibao.uitls.RlbActivityManager;
import com.rulaibao.uitls.ViewUtils;
import com.rulaibao.widget.CircularImage;

import java.util.HashMap;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * 研修--问答adapter
 */

public class TrainingAskListAdapter extends RecyclerBaseAapter<RecyclerView.ViewHolder> {
    private MouldList<ResultAskIndexItemBean> arrayList;
    private DisplayImageOptions displayImageOptions = ImageLoaderManager.initDisplayImageOptions(R.mipmap.img_default_photo, R.mipmap.img_default_photo, R.mipmap.img_default_photo);

    public TrainingAskListAdapter(Context context, MouldList<ResultAskIndexItemBean> arrayList) {
        super(context);
        this.arrayList = arrayList;
        layoutInflater = LayoutInflater.from(context);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        if (holder instanceof AskViewHolder) {
            initHolderData(holder, position);
        } else if (holder instanceof FooterViewHolder) {
            initFooterHolderData(holder);
        }
    }

    public RecyclerView.ViewHolder inflateItemView(ViewGroup parent) {
        View view = layoutInflater.inflate(R.layout.activity_training_ask_item, parent, false);
        AskViewHolder holder = new AskViewHolder(view);
        return holder;
    }

    @Override
    public void initHolderData(RecyclerView.ViewHolder holder, final int position) {

        AskViewHolder holder1 = (AskViewHolder) holder;
        holder1.tvTrainingAskTitle.setText(arrayList.get(position).getTitle());
        holder1.tvTrainingAskCount.setText(arrayList.get(position).getAnswerCount() + "回答");
        holder1.tvTrainingAskTime.setText(arrayList.get(position).getTime());

        if (Integer.parseInt(arrayList.get(position).getAnswerCount()) == 0) {
            holder1.ivTrainingAsk.setVisibility(View.GONE);
            holder1.tvTrainingAskAnswer.setVisibility(View.GONE);
            holder1.tvTrainingAskManager.setVisibility(View.GONE);
        } else {
            holder1.ivTrainingAsk.setVisibility(View.VISIBLE);
            holder1.tvTrainingAskAnswer.setVisibility(View.VISIBLE);
            holder1.tvTrainingAskManager.setVisibility(View.VISIBLE);
            ImageLoader.getInstance().displayImage(arrayList.get(position).getAnswerPhoto(), holder1.ivTrainingAsk, displayImageOptions);


            String str1 = "答:";
            String str2 = str1 + arrayList.get(position).getAnswerContent();
            SpannableStringBuilder style = new SpannableStringBuilder(str2);
            style.setSpan(new ForegroundColorSpan(context.getResources().getColor(R.color.txt_black1)), 0, str1.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
            holder1.tvTrainingAskAnswer.setText(style);


            holder1.tvTrainingAskManager.setText(arrayList.get(position).getAnswerName());
        }

        holder1.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                HashMap<String, Object> map = new HashMap<String, Object>();
                map.put("questionId", arrayList.get(position).getQuestionId());
                RlbActivityManager.toTrainingAskDetailsActivity((BaseActivity) context, map, false);
            }
        });

    }

    @Override
    public int getItem() {
        return arrayList.size() + 1;
    }

}
