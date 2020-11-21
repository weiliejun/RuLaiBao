package com.rulaibao.adapter;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.bean.InsuranceProduct2B;
import com.rulaibao.network.types.MouldList;

public class InsuranceProductAdapter extends BaseAdapter {
    private MouldList<InsuranceProduct2B> list;
    private Context context;
    private LayoutInflater inflater;

    public InsuranceProductAdapter(Context context, MouldList<InsuranceProduct2B> list) {
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
            convertView = inflater.inflate(R.layout.activity_insurance_product_item, null);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            holder.tv_companyName = (TextView) convertView.findViewById(R.id.tv_companyName);
            holder.tv_minimumPremium = (TextView) convertView.findViewById(R.id.tv_minimumPremium);
            holder.tv_promotionMoney = (TextView) convertView.findViewById(R.id.tv_promotionMoney);
            holder.tv_recommendations = (TextView) convertView.findViewById(R.id.tv_recommendations);
            holder.tv_promotionMoney_unlogin = (TextView) convertView.findViewById(R.id.tv_promotionMoney_unlogin);
            convertView.setTag(holder);
        } else {
            holder = (Holder) convertView.getTag();
        }
        String name = list.get(position).getName();
        String companyName = list.get(position).getCompanyName();
        String minimumPremium = list.get(position).getMinimumPremium();
        String promotionMoney = list.get(position).getPromotionMoney();
        String recommendations = list.get(position).getRecommendations();
        String checkStatus = list.get(position).getCheckStatus();

        if (!TextUtils.isEmpty(name)) {
            holder.tv_name.setText(name);
        } else {
            holder.tv_name.setText("--");
        }
        if (!TextUtils.isEmpty(companyName)) {
            holder.tv_companyName.setText(companyName);
        } else {
            holder.tv_companyName.setText("--");
        }
        if (!TextUtils.isEmpty(minimumPremium)) {
            holder.tv_minimumPremium.setText(minimumPremium+"元起");
        } else {
            holder.tv_minimumPremium.setText("--");
        }
        if (!TextUtils.isEmpty(recommendations)) {
            holder.tv_recommendations.setText(recommendations);
        } else {
            holder.tv_recommendations.setText("--");
        }
        if ("success".equals(checkStatus)){
            holder.tv_promotionMoney_unlogin.setVisibility(View.GONE);
            holder.tv_promotionMoney.setVisibility(View.VISIBLE);
            if (!TextUtils.isEmpty(promotionMoney)) {
                holder.tv_promotionMoney.setText(promotionMoney+"%");
            } else {
                holder.tv_promotionMoney.setText("--");
            }

        }else{
            holder.tv_promotionMoney_unlogin.setVisibility(View.VISIBLE);
            holder.tv_promotionMoney.setVisibility(View.GONE);
        }

        return convertView;
    }

    class Holder {
        TextView tv_name;
        TextView tv_companyName;
        TextView tv_minimumPremium;
        TextView tv_promotionMoney;
        TextView tv_recommendations;
        TextView tv_promotionMoney_unlogin;
    }
}
