package com.rulaibao.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.rulaibao.R;
import com.rulaibao.adapter.holder.AskDetailsViewHolder;
import com.rulaibao.adapter.holder.FooterViewHolder;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.ResultAskDetailsAnswerItemBean;
import com.rulaibao.bean.ResultInfoBean;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.ImageLoaderManager;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.RlbActivityManager;
import com.rulaibao.uitls.ViewUtils;
import com.rulaibao.uitls.encrypt.DESUtil;
import com.rulaibao.widget.CircularImage;

import java.util.HashMap;
import java.util.LinkedHashMap;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * 问题详情 adapter
 */
public class TrainingAskDetailsListAdapter extends RecyclerBaseAapter<RecyclerView.ViewHolder> {
    private MouldList<ResultAskDetailsAnswerItemBean> arrayList;
    private String questionId = "";
    private DisplayImageOptions displayImageOptions = ImageLoaderManager.initDisplayImageOptions(R.mipmap.img_default_photo, R.mipmap.img_default_photo, R.mipmap.img_default_photo);
    private String userId = null;

    public TrainingAskDetailsListAdapter(Context context, MouldList<ResultAskDetailsAnswerItemBean> arrayList, String questionId) {
        super(context);
        this.arrayList = arrayList;
        this.questionId = questionId;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        if (holder instanceof AskDetailsViewHolder) {
            initHolderData(holder, position);
        } else if (holder instanceof FooterViewHolder) {
            initFooterHolderData(holder);
        }
    }

    public RecyclerView.ViewHolder inflateItemView(ViewGroup parent) {
        View view = layoutInflater.inflate(R.layout.activity_training_ask_details_item, parent, false);
        AskDetailsViewHolder holder = new AskDetailsViewHolder(view);
        return holder;
    }

    @Override
    public void initHolderData(RecyclerView.ViewHolder holder, final int position) {
        final AskDetailsViewHolder holder1 = (AskDetailsViewHolder) holder;
        int index = position;
        if (getmHeaderView() != null) {
            index = position - 1;
        }
        holder1.tvTrainingAskDetailsManagerName.setText(arrayList.get(index).getAnswerName());
        ImageLoader.getInstance().displayImage(arrayList.get(index).getAnswerPhoto(), holder1.ivTrainingAskDetailsManager, displayImageOptions);
        holder1.tvAskDetailsContent.setText(arrayList.get(index).getAnswerContent());
        holder1.tvAskDetailsTime.setText(arrayList.get(index).getAnswerTime());
        holder1.tvAskDetailsMessageCount.setText(arrayList.get(index).getCommentCount());
        holder1.tvAskDetailsZanCount.setText(arrayList.get(index).getLikeCount());
        if (arrayList.get(index).getLikeStatus().equals("yes")) {
            holder1.ivAskDetailsZan.setImageResource(R.mipmap.img_zaned_icon);
        } else {
            holder1.ivAskDetailsZan.setImageResource(R.mipmap.img_zan_icon);
        }
        final int finalIndex = index;
        holder1.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                HashMap<String, Object> map = new HashMap<>();
                if (arrayList != null && arrayList.size() != 0) {
                    map.put("questionId", questionId);
                    map.put("answerId", arrayList.get(finalIndex).getAnswerId());
                    RlbActivityManager.toTrainingAnswerDetailsActivity((BaseActivity) context, map, false);
                }

            }
        });
        holder1.llAskDetailsZan.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!PreferenceUtil.isLogin()) {
                    HashMap<String, Object> map = new HashMap<>();
                    RlbActivityManager.toLoginActivity((BaseActivity) context, map, false);
                } else {
                    if (!PreferenceUtil.getCheckStatus().equals("success")) {
                        ViewUtils.showToSaleCertificationDialog(context, "您还未认证，是否去认证");
                    } else {

                        if (arrayList.get(finalIndex).getLikeStatus().equals("no")) {
                            requestLikeData(arrayList.get(finalIndex).getAnswerId(), finalIndex);
                            holder1.llAskDetailsZan.setClickable(false);
                        }
                    }
                }
            }
        });
    }

    //点赞
    public void requestLikeData(String answerId, final int index) {
//        ArrayMap<String,Object> map = new ArrayMap<String,Object>();
        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
        try {
            userId = DESUtil.decrypt(PreferenceUtil.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        map.put("answerId", answerId);      //  问题id
        map.put("userId", userId);
//        map.put("likeStatus", likeStatus);
        HtmlRequest.getTrainingAnswerZan(context, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params.result != null) {
                    ResultInfoBean bean = (ResultInfoBean) params.result;
                    if (bean.getFlag().equals("true")) {
                        arrayList.get(index).setLikeStatus("yes");
                        int count = Integer.parseInt(arrayList.get(index).getLikeCount());
                        arrayList.get(index).setLikeCount((count + 1) + "");
                        notifyDataSetChanged();
                    } else {
                        Toast.makeText(context, bean.getMessage(), Toast.LENGTH_SHORT).show();
                    }

                } else {

                }
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
}
