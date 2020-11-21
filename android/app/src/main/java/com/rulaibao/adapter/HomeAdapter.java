package com.rulaibao.adapter;

import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.bean.HomeViewPager2B;
import com.rulaibao.dialog.DeleteHistoryDialog;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.StringUtil;

import java.util.ArrayList;

public class HomeAdapter extends PagerAdapter {

    private ArrayList<View> viewList;
    private callBack callBack = null;
    MouldList<HomeViewPager2B> homeVpList;
    private Context context;

    public HomeAdapter(Context context, ArrayList<View> list, MouldList<HomeViewPager2B> homeVpList, callBack callBack) {
        viewList = list;
        this.callBack = callBack;
        this.homeVpList = homeVpList;
        this.context = context;
    }

    @Override
    public Object instantiateItem(ViewGroup collection, final int position) {
        HomeViewPager2B bean = homeVpList.get(position);
        View view = viewList.get(position);
        String checkStatus = bean.getCheckStatus();
        String promotionMoney = bean.getPromotionMoney();
        TextView tv_home_promotionMoney = (TextView) view.findViewById(R.id.tv_home_promotionMoney);
        TextView tv_home_promotionMoney_no = (TextView) view.findViewById(R.id.tv_home_promotionMoney_no);
        TextView tv_home_name = (TextView) view.findViewById(R.id.tv_home_name);
        TextView tv_home_recommendations = (TextView) view.findViewById(R.id.tv_home_recommendations);
        if ("success".equals(checkStatus)) {
            tv_home_promotionMoney_no.setVisibility(View.GONE);
            tv_home_promotionMoney.setVisibility(View.VISIBLE);
            if (!TextUtils.isEmpty(promotionMoney)) {
                tv_home_promotionMoney.setText(setTextStyle(context, promotionMoney));
            } else {
                tv_home_promotionMoney.setText("--");
            }

        } else {
            tv_home_promotionMoney_no.setVisibility(View.VISIBLE);
            tv_home_promotionMoney.setVisibility(View.GONE);
        }
        tv_home_name.setText(bean.getName());
        tv_home_recommendations.setText(bean.getRecommendations());
        view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                callBack.callBack(position);
            }
        });
        collection.addView(view);
        return view;
    }

    @Override
    public void destroyItem(ViewGroup collection, int position, Object view) {
        collection.removeView((View) view);
    }

    @Override
    public int getCount() {
        return viewList == null ? 0 : viewList.size();
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == object;
    }

    public interface callBack {
        public void callBack(int position);
    }

    private static SpannableStringBuilder setTextStyle(Context context, String str) {
        SpannableStringBuilder ssb;
        if (!str.contains(".")) {
            String str1 = str;
            String str2 = str1;
            String str3 = str2 + "%";
           ssb = StringUtil.setTextStyle(context, str1, str2, str3, R.color.main_color_yellow, R.color.main_color_yellow, R.color.main_color_yellow, 30, 18, 18, 0, 0, 0);
        } else {
            String str1 = str.substring(0, str.indexOf("."));
            String str2 = str1 + str.substring(str.indexOf("."), str.length());
            String str3 = str2 + "%";
            ssb = StringUtil.setTextStyle(context, str1, str2, str3, R.color.main_color_yellow, R.color.main_color_yellow, R.color.main_color_yellow, 30, 18, 18, 0, 0, 0);
        }
        return ssb;
    }
}