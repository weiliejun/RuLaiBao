package com.rulaibao.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.rulaibao.R;
import com.rulaibao.activity.TrainingCircleActivity;
import com.rulaibao.adapter.holder.CircleListViewHolder;
import com.rulaibao.adapter.holder.PromotionMoneyViewHolder;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.ResultCircleIndexItemBean;
import com.rulaibao.bean.ResultInfoBean;
import com.rulaibao.bean.ResultPromotionMoneyItemBean;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.ImageLoaderManager;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.RlbActivityManager;
import com.rulaibao.uitls.ViewUtils;

import java.util.HashMap;
import java.util.LinkedHashMap;

/**
 * 推广费adapter
 */

public class PromotionMoneyListAdapter extends BaseAdapter {
    private Context context;
    private MouldList<ResultPromotionMoneyItemBean> arrayList;
    private LayoutInflater layoutInflater;

    public PromotionMoneyListAdapter(Context context, MouldList<ResultPromotionMoneyItemBean> arrayList) {
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
    public View getView(final int position, View convertView, ViewGroup parent) {
        PromotionMoneyViewHolder holder = null;
        if (convertView == null) {
            convertView = layoutInflater.inflate(R.layout.activity_promotion_money_item, null);
            holder = new PromotionMoneyViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (PromotionMoneyViewHolder) convertView.getTag();
        }
        holder.tv_promotionMoney.setText(arrayList.get(position).getPromotionMoney());
        return convertView;
    }

}
