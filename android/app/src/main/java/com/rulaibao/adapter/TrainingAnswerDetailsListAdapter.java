package com.rulaibao.adapter;

import android.content.Context;
import android.graphics.Bitmap;
import android.support.v7.app.AlertDialog;
import android.support.v7.widget.RecyclerView;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.assist.ImageLoadingListener;
import com.nostra13.universalimageloader.core.assist.ImageLoadingProgressListener;
import com.rulaibao.R;
import com.rulaibao.adapter.holder.AnswerDetailsViewHolder;
import com.rulaibao.adapter.holder.FooterViewHolder;
import com.rulaibao.bean.ResultCircleDetailsTopicCommentItemBean;
import com.rulaibao.bean.ResultCircleDetailsTopicCommentReplyItemBean;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.ImageLoaderManager;
import com.rulaibao.uitls.TouchListener;

import butterknife.BindView;
import it.sephiroth.android.library.imagezoom.ImageViewTouch;

/**
 * 话题详情  问题详情 adapter
 */

public class TrainingAnswerDetailsListAdapter extends RecyclerBaseAapter<RecyclerView.ViewHolder> {


    private MouldList<ResultCircleDetailsTopicCommentItemBean> arrayList;
    private Reply reply;
    private ResultCircleDetailsTopicCommentReplyItemBean replyItemBean;
    private ReplyAdapter replyAdapter;
    private DisplayImageOptions displayImageOptions = ImageLoaderManager.initDisplayImageOptions(R.mipmap.img_default_photo, R.mipmap.img_default_photo, R.mipmap.img_default_photo);
    private ImageView imageView;

    private DisplayImageOptions displayImageOptions_img = ImageLoaderManager.initDisplayImageOptions(R.mipmap.img_traffining_recommend, R.mipmap.img_traffining_recommend, R.mipmap.img_traffining_recommend);

    public TrainingAnswerDetailsListAdapter(Context context, MouldList<ResultCircleDetailsTopicCommentItemBean> arrayList, Reply reply) {
        super(context);
        this.context = context;
        this.arrayList = arrayList;

        this.reply = reply;
    }


    @Override
    public RecyclerView.ViewHolder inflateItemView(ViewGroup parent) {
        View view = layoutInflater.inflate(R.layout.activity_training_answer_details_item, parent, false);
        AnswerDetailsViewHolder holder = new AnswerDetailsViewHolder(view);
        return holder;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        if (holder instanceof AnswerDetailsViewHolder) {
            initHolderData(holder, position);
        } else if (holder instanceof FooterViewHolder) {
            initFooterHolderData(holder);
        }
    }

    @Override
    public void initHolderData(RecyclerView.ViewHolder holder, final int position) {
        final AnswerDetailsViewHolder holder1 = (AnswerDetailsViewHolder) holder;
        int index = position;
        if (getmHeaderView() != null) {
            index = position - 1;
        }

        ImageLoader.getInstance().displayImage(arrayList.get(index).getCommentPhoto(), holder1.ivAnswerDetails, displayImageOptions);

        holder1.tvAnswerDetailsName.setText(arrayList.get(index).getCommentName());
        holder1.tvAnswerDetailsDate.setText(arrayList.get(index).getCommentTime());
        holder1.tvAnswerDetailsContent.setText(arrayList.get(index).getCommentContent());
        final int finalIndex = index;
        if (!TextUtils.isEmpty(arrayList.get(index).getImgCommentUrlSmall())) {
            holder1.ivAnswerDetailas.setVisibility(View.VISIBLE);
            ImageLoader.getInstance().displayImage(arrayList.get(index).getImgCommentUrlSmall(), holder1.ivAnswerDetailas, displayImageOptions);

            holder1.ivAnswerDetailas.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {


                    View view = LayoutInflater.from(context).inflate(R.layout.dialog_image, null);
                    ImageViewTouch view1 = (ImageViewTouch) view.findViewById(R.id.iv_dialog);
//                    imageView = new ImageView(context);
//                    view1.setOnTouchListener(new TouchListener(holder1.ivAnswerDetailas));

                    final AlertDialog dialog = new AlertDialog.Builder(context).setView(view).show();
                    if(dialog.getWindow()!=null){
                        dialog.getWindow().setBackgroundDrawableResource(R.color.transparent);
                    }


                    ImageLoader.getInstance().displayImage(arrayList.get(finalIndex).getImgCommentUrlBig(), view1, displayImageOptions_img, new ImageLoadingListener() {
                        @Override
                        public void onLoadingStarted(String s, View view) {

                        }

                        @Override
                        public void onLoadingFailed(String s, View view, FailReason failReason) {

                        }

                        @Override
                        public void onLoadingComplete(String s, View view, Bitmap bitmap) {

                        }

                        @Override
                        public void onLoadingCancelled(String s, View view) {

                        }
                    }, new ImageLoadingProgressListener() {
                        @Override
                        public void onProgressUpdate(String s, View view, int i, int i1) {

                        }
                    });


//                    AlertDialog alert = builder.create();
                }
            });


        } else {
            holder1.ivAnswerDetailas.setVisibility(View.GONE);
        }

        if (!TextUtils.isEmpty(arrayList.get(index).getLinkCommentUrl())) {
            holder1.tvAnswerDetailasLink.setVisibility(View.VISIBLE);
            holder1.tvAnswerDetailasLink.setText(arrayList.get(index).getLinkCommentUrl());
        } else {
            holder1.tvAnswerDetailasLink.setVisibility(View.GONE);
        }

        replyAdapter = new ReplyAdapter(context, index);
        replyAdapter.clearAll();
        replyAdapter.addAll(arrayList.get(index).getReplys());

        if ((index + 1) == arrayList.size()) {
            holder1.tvAnswerDetailasLine.setVisibility(View.INVISIBLE);
        } else {
            holder1.tvAnswerDetailasLine.setVisibility(View.VISIBLE);
        }
        holder1.lvAnswerDetails.setAdapter(replyAdapter);


        //  回复
        holder1.tvAnswerDetailsReply.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                reply.reply(arrayList.get(finalIndex).getCid(), arrayList.get(finalIndex).getCommentId(), arrayList.get(finalIndex).getCommentName(), finalIndex, arrayList.get(finalIndex).getCid());

            }
        });


    }

    @Override
    public int getItem() {
        if (mHeaderView != null) {
            return arrayList.size() + 2;
        } else {
            return arrayList.size() + 1;
        }
    }


    public interface Reply {

        void reply(String commentId, String toUserId, String replyToName, int index, String linkId);

    }

    class ChildViewHolder {

        TextView tvCommit;

    }


    class ReplyAdapter extends BaseAdapter {

        private Context context;
        private MouldList<ResultCircleDetailsTopicCommentReplyItemBean> list;
        private int index = 0;


        public ReplyAdapter(Context context, int index) {
            this.context = context;
            list = new MouldList<ResultCircleDetailsTopicCommentReplyItemBean>();
            this.index = index;
        }

        @Override
        public int getCount() {
            return list.size();
        }

        @Override
        public Object getItem(int position) {
            return null;
        }

        public void addAll(MouldList<ResultCircleDetailsTopicCommentReplyItemBean> list) {
            this.list = list;
            notifyDataSetChanged();
        }

        public void clearAll() {
            this.list.clear();
            notifyDataSetChanged();
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ChildViewHolder holder1 = null;
            if (convertView == null) {
                holder1 = new ChildViewHolder();
                convertView = layoutInflater.inflate(R.layout.activity_training_answer_details_item_child, null);
                holder1.tvCommit = (TextView) convertView.findViewById(R.id.tv_commit);
                convertView.setTag(holder1);
            } else {

                holder1 = (ChildViewHolder) convertView.getTag();

            }

            replyItemBean = list.get(position);
            holder1.tvCommit.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    reply.reply(arrayList.get(index).getCid(), list.get(position).getReplyId(), list.get(position).getReplyName(), index, list.get(position).getRid());
                }
            });

            String str = "";
            if (replyItemBean.getReplyId().equals(replyItemBean.getReplyToId())) {
                str = replyItemBean.getReplyName() + "：" + replyItemBean.getReplyContent();
                String str2 = replyItemBean.getReplyName() + "：";

                SpannableStringBuilder style = new SpannableStringBuilder(str);

                style.setSpan(new ForegroundColorSpan(context.getResources().getColor(R.color.txt_black1)), 0, replyItemBean.getReplyName().length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
                holder1.tvCommit.setText(style);
            } else {
                str = replyItemBean.getReplyName() + " 回复 " + replyItemBean.getReplyToName() + "：" + replyItemBean.getReplyContent();

                String str2 = replyItemBean.getReplyName() + " 回复 ";
                String str3 = str2 + replyItemBean.getReplyToName();

                SpannableStringBuilder style = new SpannableStringBuilder(str);

                style.setSpan(new ForegroundColorSpan(context.getResources().getColor(R.color.txt_black1)), 0, replyItemBean.getReplyName().length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
                style.setSpan(new ForegroundColorSpan(context.getResources().getColor(R.color.txt_black1)), str2.length(), str3.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
                holder1.tvCommit.setText(style);
            }

            return convertView;
        }

    }
}
