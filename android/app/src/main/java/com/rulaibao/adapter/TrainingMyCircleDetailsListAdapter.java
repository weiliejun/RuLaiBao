package com.rulaibao.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.rulaibao.R;
import com.rulaibao.adapter.holder.CircleDetailsViewHolder;
import com.rulaibao.adapter.holder.FooterViewHolder;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.ResultCircleDetailsTopicItemBean;
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
 * 圈子详情--话题列表 adapter
 */

public class TrainingMyCircleDetailsListAdapter extends RecyclerBaseAapter<RecyclerView.ViewHolder> {
    private MouldList<ResultCircleDetailsTopicItemBean> arrayList;
    private String circleId = "";
    private DisplayImageOptions displayImageOptions = ImageLoaderManager.initDisplayImageOptions(R.mipmap.img_default_photo, R.mipmap.img_default_photo, R.mipmap.img_default_photo);
    private String userId = null;
    private boolean isJoin = false;

    public void setJoin(boolean join) {
        isJoin = join;
    }

    public TrainingMyCircleDetailsListAdapter(Context context, MouldList<ResultCircleDetailsTopicItemBean> arrayList, String circleId, boolean isJoin) {
        super(context);
        this.arrayList = arrayList;
        this.circleId = circleId;
        this.isJoin = isJoin;
        layoutInflater = LayoutInflater.from(context);
    }

    @Override
    public long getItemId(int position) {
        return position;
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
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        if (holder instanceof CircleDetailsViewHolder) {
            initHolderData(holder, position);
        } else if (holder instanceof FooterViewHolder) {
            initFooterHolderData(holder);
        }
    }

    @Override
    public RecyclerView.ViewHolder inflateItemView(ViewGroup parent) {
        View view = layoutInflater.inflate(R.layout.activity_my_circle_details_item, parent, false);
        CircleDetailsViewHolder holder = new CircleDetailsViewHolder(view);
        return holder;
    }

    @Override
    public void initHolderData(RecyclerView.ViewHolder holder, int position) {
        final CircleDetailsViewHolder holder1 = (CircleDetailsViewHolder) holder;
        int index = position;
        if (getmHeaderView() != null) {
            index = position - 1;
        }
        ImageLoader.getInstance().displayImage(arrayList.get(index).getCreatorPhoto(), holder1.ivTrainingCircleDetailsManager, displayImageOptions);
        holder1.tvTrainingCircleDetailsManagerName.setText(arrayList.get(index).getCreatorName());
        holder1.tvCircleDetailsContent.setText(arrayList.get(index).getTopicContent());
        holder1.tvCircleDetailsTime.setText(arrayList.get(index).getCreateTime());
        holder1.tvCircleDetailsMessageCount.setText(arrayList.get(index).getCommentCount());
        holder1.tvCircleDetailsZanCount.setText(arrayList.get(index).getLikeCount());
        final int finalIndex = index;
        holder1.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                HashMap<String, Object> map = new HashMap<String, Object>();
                if (arrayList != null && arrayList.size() != 0) {
                    map.put("appTopicId", arrayList.get(finalIndex).getTopicId());

                    RlbActivityManager.toTrainingTopicDetailsActivity((BaseActivity) context, map, false);
                }

            }
        });

        if(!TextUtils.isEmpty(arrayList.get(index).getLikeStatus())){
            if (arrayList.get(index).getLikeStatus().equals("yes")) {
                holder1.ivCircleDetailsZan.setImageResource(R.mipmap.img_zaned_icon);
            } else {
                holder1.ivCircleDetailsZan.setImageResource(R.mipmap.img_zan_icon);
            }
        }

        final int finalIndex1 = index;
        holder1.llCircleDetailsZan.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!PreferenceUtil.isLogin()) {
                    HashMap<String, Object> map = new HashMap<>();
                    RlbActivityManager.toLoginActivity((BaseActivity) context, map, false);
                } else {
                    if (!PreferenceUtil.getCheckStatus().equals("success")) {
                        ViewUtils.showToSaleCertificationDialog(context, "您还未认证，是否去认证");
                    } else {
                        if (!TextUtils.isEmpty(arrayList.get(finalIndex).getLikeStatus())) {
                            if (arrayList.get(finalIndex).getLikeStatus().equals("no")) {
                                if (isJoin) {
                                    Toast.makeText(context, "请您加入该圈子后再进行相关操作", Toast.LENGTH_SHORT).show();
                                } else {
                                    requestLikeData(arrayList.get(finalIndex).getTopicId(), finalIndex);
                                    holder1.llCircleDetailsZan.setClickable(false);
                                }
                            }
                        }

                    }
                }
            }
        });
    }

    //点赞
    public void requestLikeData(String appTopicId, final int index) {
        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
        try {
            userId = DESUtil.decrypt(PreferenceUtil.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        map.put("appTopicId", appTopicId);      //  话题id
        map.put("userId", userId);
        HtmlRequest.getTrainingCircleZan(context, map, new BaseRequester.OnRequestListener() {
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
}
