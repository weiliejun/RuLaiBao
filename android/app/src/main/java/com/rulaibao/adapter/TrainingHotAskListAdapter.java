package com.rulaibao.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.adapter.holder.FooterViewHolder;
import com.rulaibao.adapter.holder.HotAskListViewHolder;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.ResultHotAskItemBean;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.RlbActivityManager;

import java.util.HashMap;

import butterknife.BindView;
import butterknife.ButterKnife;


/**
 * 热门问答列表  adapter
 */

public class TrainingHotAskListAdapter extends RecyclerBaseAapter<RecyclerView.ViewHolder> {

    private MouldList<ResultHotAskItemBean> arrayList;
    private LoadMoreData loadMoreData;

    public void setNoDataMessage(String noDataMessage) {
        this.noDataMessage = noDataMessage;
    }

    public TrainingHotAskListAdapter(Context context, MouldList<ResultHotAskItemBean> arrayList, LoadMoreData loadMoreData) {
        super(context);
        this.context = context;
        this.arrayList = arrayList;
        layoutInflater = LayoutInflater.from(context);
        this.loadMoreData = loadMoreData;
    }

    @Override
    public RecyclerView.ViewHolder inflateItemView(ViewGroup parent) {
        View view = layoutInflater.inflate(R.layout.activity_training_hot_ask_item, parent, false);
        HotAskListViewHolder holder = new HotAskListViewHolder(view);
        return holder;
    }

    @Override
    public void initHolderData(RecyclerView.ViewHolder holder, final int position) {
        HotAskListViewHolder itemViewHolder = (HotAskListViewHolder) holder;
        itemViewHolder.tvHotTitle.setText(arrayList.get(position).getTitle());
        itemViewHolder.tvHotContent.setText(arrayList.get(position).getDescript());
        itemViewHolder.tvHotName.setText(arrayList.get(position).getUserName());
        itemViewHolder.tvHotAskLeaveCount.setText(arrayList.get(position).getAnswerCount());
        itemViewHolder.itemView.setOnClickListener(new View.OnClickListener() {
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
        if (mHeaderView != null) {
            return arrayList.size() + 2;
        } else {
            return arrayList.size() + 1;
        }
    }

    // 填充onCreateViewHolder方法返回的holder中的控件
    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, final int position) {
        if (holder instanceof HotAskListViewHolder) {
            initHolderData(holder, position);

        } else if (holder instanceof FooterViewHolder) {
            initFooterHolderData(holder);
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

    public interface LoadMoreData {
        public void getMoreData();
    }
}
