package com.rulaibao.adapter;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.rulaibao.R;
import com.rulaibao.bean.Plan3B;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.ImageLoaderManager;

public class PlanAdapter extends BaseAdapter {
    private MouldList<Plan3B> list;
    private Context context;
    private LayoutInflater inflater;
    private DisplayImageOptions displayImageOptions= ImageLoaderManager.initDisplayImageOptions
            (R.mipmap.ic_plan_default, R.mipmap.ic_plan_default, R.mipmap.ic_plan_default);

    public PlanAdapter(Context context, MouldList<Plan3B> list) {
        this.context = context;
        this.list = list;
        inflater = LayoutInflater.from(context);
    }

    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public Object getItem(int arg0) {
        return getItem(arg0);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        Holder holder = null;
        if (convertView == null) {
            holder = new Holder();
            convertView = inflater.inflate(R.layout.activity_plan_item, null);
            holder.iv_plan = (ImageView) convertView.findViewById(R.id.iv_plan);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_plan_name);
            holder.tv_recommendations = (TextView) convertView.findViewById(R.id.tv_info);
            convertView.setTag(holder);
        } else {
            holder = (Holder) convertView.getTag();
        }
        String logo = list.get(position).getLogo();
        String name = list.get(position).getName();
        String recommendations = list.get(position).getRecommendations();

        if (!TextUtils.isEmpty(logo)) {
            // ImageLoader 加载图片
            ImageLoader.getInstance().displayImage(logo, holder.iv_plan, displayImageOptions);
        }
        if (!TextUtils.isEmpty(name)) {
            holder.tv_name.setText(name);
        } else {
            holder.tv_name.setText("--");
        }
        if (!TextUtils.isEmpty(recommendations)) {
            holder.tv_recommendations.setText(recommendations);
        } else {
            holder.tv_recommendations.setText("--");
        }

        return convertView;
    }

    class Holder {
        ImageView iv_plan;
        TextView tv_name;
        TextView tv_recommendations;

    }
}
