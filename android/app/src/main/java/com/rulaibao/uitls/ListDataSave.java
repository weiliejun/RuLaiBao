package com.rulaibao.uitls;

import android.content.Context;
import android.content.SharedPreferences;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.util.ArrayList;
import java.util.List;

/**
 */

public class ListDataSave {
    private SharedPreferences preferences;
    private SharedPreferences.Editor editor;
    private String strJson;

    public ListDataSave(Context mContext, String preferenceName) {
        preferences = mContext.getSharedPreferences(preferenceName, Context.MODE_PRIVATE);
        editor = preferences.edit();
    }

    /**
     * 保存List(保险产品搜索、计划书)
     *
     * @param tag
     * @param dataList
     */
    public <T> void setDataList(String tag, List<T> dataList) {
        if (null == dataList || dataList.size() <= 0) return;

        Gson gson = new Gson();
        //转换成json数据，再保存
        String strJsonSet = gson.toJson(dataList);
        editor.clear();
        editor.putString(tag, strJsonSet);
        editor.commit();

    }

    /**
     * 获取List(保险产品搜索、计划书)
     *
     * @param tag
     * @return
     */
    public <T> List<T> getDataList(String tag, boolean isDelete) {
        List<T> dataList = new ArrayList<T>();
        strJson = preferences.getString(tag, null);
        if (isDelete) {
            strJson = null;
            Gson gson = new Gson();
            //转换成json数据，再保存
            String strJsonSet = gson.toJson(dataList);
            editor.clear();
            editor.putString(tag, strJsonSet);
            editor.commit();
        }
        if (null == strJson) {
            return dataList;
        }
        Gson gson = new Gson();
        dataList = gson.fromJson(strJson, new TypeToken<List<T>>() {
        }.getType());
        return dataList;

    }
}