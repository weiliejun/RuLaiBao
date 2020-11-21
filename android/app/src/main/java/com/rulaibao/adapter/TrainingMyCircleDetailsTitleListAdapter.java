package com.rulaibao.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.bean.ResultCircleDetailsTopItemBean;
import com.rulaibao.network.types.MouldList;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * 圈子详情置顶话题列表adapter
 *
 */

public class TrainingMyCircleDetailsTitleListAdapter extends BaseAdapter {

    private Context context;

    private MouldList<ResultCircleDetailsTopItemBean> arrayList;
    private LayoutInflater layoutInflater;
    private String type = "";

    public TrainingMyCircleDetailsTitleListAdapter(Context context, MouldList<ResultCircleDetailsTopItemBean> arrayList) {
        this.context = context;
        this.arrayList = arrayList;
        this.type = type;
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
        ViewHolder holder = null;

        if (convertView == null) {

            convertView = layoutInflater.inflate(R.layout.activity_my_circle_details_title_item, null);
            holder = new ViewHolder(convertView);

            convertView.setTag(holder);
        } else {

            holder = (ViewHolder) convertView.getTag();

        }

        holder.tvMyCicileDetailsTitle.setText(arrayList.get(position).getTopicContent());


        return convertView;
    }


    static class ViewHolder {
        @BindView(R.id.tv_my_cicile_details_title)
        TextView tvMyCicileDetailsTitle;

        ViewHolder(View view) {
            ButterKnife.bind(this, view);
        }
    }
}
