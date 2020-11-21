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
import com.rulaibao.adapter.holder.ClassDiscussViewHolder;
import com.rulaibao.adapter.holder.FooterViewHolder;
import com.rulaibao.bean.ResultClassDetailsDiscussItemBean;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.ImageLoaderManager;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.encrypt.DESUtil;
import com.rulaibao.widget.CircularImage;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * 课程详情--研讨列表adapter
 */

public class TrainingClassDiscussAdapter extends RecyclerBaseAapter<RecyclerView.ViewHolder> {
    private Context context;
    private MouldList<ResultClassDetailsDiscussItemBean> arrayList;
    private LayoutInflater layoutInflater;
    private static final int TYPE_ITEM = 0;     // item布局
    private static final int TYPE_FOOTER = 1;   //  footer布局
    private DisplayImageOptions displayImageOptions = ImageLoaderManager.initDisplayImageOptions(R.mipmap.img_default_photo, R.mipmap.img_default_photo, R.mipmap.img_default_photo);
    private DiscussReply discussReply;
    private String speechmakeId = "";
    private String userId = "";

    public TrainingClassDiscussAdapter(Context context, MouldList<ResultClassDetailsDiscussItemBean> arrayList, DiscussReply discussReply, String speechmakeId) {
        super(context);
        this.context = context;
        this.arrayList = arrayList;
        layoutInflater = LayoutInflater.from(context);
        this.discussReply = discussReply;
        this.speechmakeId = speechmakeId;
    }

    @Override
    public RecyclerView.ViewHolder inflateItemView(ViewGroup parent) {
        View view = layoutInflater.inflate(R.layout.activity_training_class_discuss_item, parent, false);
        ClassDiscussViewHolder holder = new ClassDiscussViewHolder(view);
        return holder;
    }

    @Override
    public void initHolderData(RecyclerView.ViewHolder holder, int position) {
        ClassDiscussViewHolder holder1 = (ClassDiscussViewHolder) holder;
        int index = position;
        if (getmHeaderView() != null) {
            index = position - 1;
        }
        holder1.tvTrainingDiscussName.setText(arrayList.get(index).getCommentName());
        ImageLoader.getInstance().displayImage(arrayList.get(index).getCommentPhoto(), holder1.ivTrainingDiscuss, displayImageOptions);
        holder1.tvTrainingDiscussDate.setText(arrayList.get(index).getCommentTime());
        holder1.tvTrainingDiscussContent.setText(arrayList.get(index).getCommentContent());
        try {
            userId = DESUtil.decrypt(PreferenceUtil.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (arrayList.get(index).getReplys().size() == 0) {
            holder1.tvTrainingDiscussRepayContent.setVisibility(View.GONE);
            if (speechmakeId.equals(userId)) {
                holder1.tvDiscussReply.setVisibility(View.VISIBLE);
                final int finalIndex = index;
                holder1.tvDiscussReply.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        discussReply.reply(arrayList.get(finalIndex).getCommentId(), arrayList.get(finalIndex).getCid(), arrayList.get(finalIndex).getCommentName(), finalIndex, arrayList.get(finalIndex).getCid());
                    }
                });
            } else {
                holder1.tvDiscussReply.setVisibility(View.GONE);
            }
        } else {
            holder1.tvDiscussReply.setVisibility(View.GONE);
            holder1.tvTrainingDiscussRepayContent.setVisibility(View.VISIBLE);
            String str = arrayList.get(index).getReplys().get(0).getReplyName() + " 回复: " + arrayList.get(index).getReplys().get(0).getReplyContent();
            SpannableStringBuilder style = new SpannableStringBuilder(str);
            style.setSpan(new ForegroundColorSpan(context.getResources().getColor(R.color.txt_black1)), 0, arrayList.get(index).getReplys().get(0).getReplyName().length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
            holder1.tvTrainingDiscussRepayContent.setText(style);
        }
    }

    @Override
    public int getItem() {
        if (mHeaderView != null) {
            return arrayList.size() + 2;
        } else {
            return arrayList.size() + 1;
        }
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, final int position) {
        if (holder instanceof ClassDiscussViewHolder) {
            initHolderData(holder, position);
        } else if (holder instanceof FooterViewHolder) {
            initFooterHolderData(holder);
        }
    }


    public interface DiscussReply {
        public void reply(String toUserId, String commentId, String commentName, int index, String linkId);

        public void refresh();
    }

    @Override
    public int getItemViewType(int position) {

        if (position + 1 == getItemCount()) {
            //最后一个item设置为footerView
            return TYPE_FOOTER;
        } else {
            return TYPE_ITEM;
        }
    }

    /**
     * 更新加载更多状态
     *
     * @param status
     */
    public void changeMoreStatus(int status) {
        mLoadMoreStatus = status;
        notifyDataSetChanged();
    }
}
