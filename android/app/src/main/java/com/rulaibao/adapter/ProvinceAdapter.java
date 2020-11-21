package com.rulaibao.adapter;

import android.content.Context;

import com.rulaibao.bean.ProvinceModel;

import java.util.List;


/**
 * Created by xuan on 16/1/7.
 */
public class ProvinceAdapter extends AbstractWheelTextAdapter {
    public List<ProvinceModel> mList;
    private Context mContext;
    public ProvinceAdapter(Context context, List<ProvinceModel> list) {
        super(context);
        mList=list;
        mContext=context;
    }

    @Override
    protected CharSequence getItemText(int index) {
        ProvinceModel provinceModel=mList.get(index);
        return provinceModel.NAME;
    }

    @Override
    public int getItemsCount() {
        return mList.size();
    }
}
