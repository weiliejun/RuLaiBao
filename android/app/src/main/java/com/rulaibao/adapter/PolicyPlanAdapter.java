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
import com.rulaibao.bean.PolicyPlan3B;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.ImageLoaderManager;

public class PolicyPlanAdapter extends BaseAdapter {
    private MouldList<PolicyPlan3B> list;
    private Context context;
    private LayoutInflater inflater;
    private DisplayImageOptions displayImageOptions= ImageLoaderManager.initDisplayImageOptions
            (R.mipmap.ic_plan_default, R.mipmap.ic_plan_default, R.mipmap.ic_plan_default);

    public PolicyPlanAdapter(Context context, MouldList<PolicyPlan3B> list) {
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
            convertView = inflater.inflate(R.layout.activity_policy_plan_item, null);
            holder.iv_plan = (ImageView) convertView.findViewById(R.id.iv_policy_plan);
            holder.tv_title = (TextView) convertView.findViewById(R.id.tv_title);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_policy_plan_name);
            holder.tv_amount = (TextView) convertView.findViewById(R.id.tv_amount);
            holder.tv_limit = (TextView) convertView.findViewById(R.id.tv_limit);
            convertView.setTag(holder);
        } else {
            holder = (Holder) convertView.getTag();
        }
        String url = list.get(position).getCompanyLogo();
        String title = list.get(position).getInsuranceName();
        String name = list.get(position).getCustomerName();
        String amount = list.get(position).getPaymentedPremiums();
        String limit = list.get(position).getInsurancePeriod();

        if (!TextUtils.isEmpty(url)) {
            // ImageLoader 加载图片
            ImageLoader.getInstance().displayImage(url, holder.iv_plan, displayImageOptions);
        } else {
        }
        if (!TextUtils.isEmpty(title)) {
            holder.tv_title.setText(title);
        } else {
            holder.tv_title.setText("--");
        }
        if (!TextUtils.isEmpty(name)) {
            holder.tv_name.setText(name);
        } else {
            holder.tv_name.setText("--");
        }
        if (!TextUtils.isEmpty(amount)) {
            holder.tv_amount.setText(amount+"元");
        } else {
            holder.tv_amount.setText("--");
        }
        if (!TextUtils.isEmpty(limit)) {
            holder.tv_limit.setText(limit);
        } else {
            holder.tv_limit.setText("--");
        }

        return convertView;
    }

    class Holder {
        ImageView iv_plan;
        TextView tv_title;
        TextView tv_name;
        TextView tv_amount;
        TextView tv_limit;

    }
}
