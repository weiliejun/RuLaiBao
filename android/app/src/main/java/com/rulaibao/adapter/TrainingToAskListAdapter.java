package com.rulaibao.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.adapter.holder.ToAskViewHolder;
import com.rulaibao.bean.ResultAskTypeItemBean;
import com.rulaibao.widget.MyGridView;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * 我要提问 问题类型adapter
 */

public class TrainingToAskListAdapter extends BaseAdapter {

    private Context context;

    private ArrayList<ResultAskTypeItemBean> arrayList;
    private LayoutInflater layoutInflater;
    private GridView gvTrainingToask;

    public TrainingToAskListAdapter(GridView gvTrainingToask, Context context, ArrayList<ResultAskTypeItemBean> arrayList) {
        this.gvTrainingToask = gvTrainingToask;
        this.context = context;
        this.arrayList = arrayList;
        layoutInflater = LayoutInflater.from(context);
    }

    @Override
    public int getCount() {
        return arrayList.size();
    }

    @Override
    public Object getItem(int position) {
        return arrayList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ToAskViewHolder holder = null;

        if (convertView == null) {

            convertView = layoutInflater.inflate(R.layout.activity_training_toask_item, null);
            holder = new ToAskViewHolder(convertView);
            holder.tvTrainingToask = (TextView) convertView.findViewById(R.id.tv_training_toask);
            convertView.setTag(holder);
            holder.update(gvTrainingToask);
        } else {

            holder = (ToAskViewHolder) convertView.getTag();

        }
        holder.tvTrainingToask.setText(arrayList.get(position).getTypeName());
        if (arrayList.get(position).getFlag()) {

            holder.tvTrainingToask.setBackgroundResource(R.drawable.shape_ring_orange);
            holder.tvTrainingToask.setTextColor(context.getResources().getColor(R.color.txt_orange));
        } else {
            holder.tvTrainingToask.setBackgroundResource(R.drawable.shape_ring_gray);
            holder.tvTrainingToask.setTextColor(context.getResources().getColor(R.color.txt_gray));
        }

        holder.tvTrainingToask.setTag(convertView);
        holder.tvTrainingToaskBlack.setTag(position);

        return convertView;
    }
}
