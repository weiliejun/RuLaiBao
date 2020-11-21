package com.rulaibao.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.adapter.holder.ClassListViewHolder;
import com.rulaibao.adapter.holder.FooterViewHolder;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.ResultClassIndexItemBean;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.RlbActivityManager;

import java.util.HashMap;

import butterknife.BindView;
import butterknife.ButterKnife;

import static com.rulaibao.uitls.ImageUtils.getClassImgIndex;

/**
 * 课程列表
 */

public class TrainingClassListAdapter extends RecyclerBaseAapter<RecyclerView.ViewHolder> {


    private MouldList<ResultClassIndexItemBean> arrayList;
    private LoadMoreData loadMoreData;

    public TrainingClassListAdapter(Context context, MouldList<ResultClassIndexItemBean> arrayList) {
        super(context);
        this.arrayList = arrayList;
    }

    @Override
    public RecyclerView.ViewHolder inflateItemView(ViewGroup parent) {
        View view = layoutInflater.inflate(R.layout.activity_training_class_item, parent, false);
        ClassListViewHolder holder = new ClassListViewHolder(view);
        return holder;
    }

    @Override
    public void initHolderData(RecyclerView.ViewHolder holder, int position) {
        ClassListViewHolder holder1 = (ClassListViewHolder) holder;
        int index = position;
        if (getmHeaderView() != null) {
            index = position - 1;
        }
        holder1.tvTrainingName.setText(arrayList.get(index).getTypeName());
        holder1.tvTrainingClassTime.setText(arrayList.get(index).getCourseTime());
        holder1.ivTrainingRecommend.setImageResource(getClassImgIndex(arrayList.get(index).getCourseLogo()));

        holder1.tvTrainingRecommendManager.setText(arrayList.get(index).getCourseName());
        holder1.tvTrainingRecommendManagerName.setText(arrayList.get(index).getSpeechmakeName() + " " + arrayList.get(position).getPosition());

        final int finalIndex = index;
        holder1.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                HashMap<String, Object> map = new HashMap<>();
                map.put("id", arrayList.get(finalIndex).getCourseId());
                map.put("speechmakeId", arrayList.get(finalIndex).getSpeechmakeId());
                map.put("courseId", arrayList.get(finalIndex).getCourseId());
                RlbActivityManager.toTrainingClassDetailsActivity((BaseActivity) context, map, false);
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

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, final int position) {

        if (holder instanceof ClassListViewHolder) {
            initHolderData(holder, position);
        } else if (holder instanceof FooterViewHolder) {
            initFooterHolderData(holder);
        }

    }

    public interface LoadMoreData {
        public void getMoreData();
    }


}
