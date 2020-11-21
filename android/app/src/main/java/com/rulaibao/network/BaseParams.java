package com.rulaibao.network;

import android.content.Context;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.rulaibao.bean.Repo;

import java.util.HashMap;

public class BaseParams<T> {
    public Context context;
    public BaseRequester.OnRequestListener<T> requestListener;
//    public int from;
    public String url;
    private HashMap<String, Object> mMap = new HashMap<>();
    public T result;

    public void sendResult() {
        context = null;
        if (requestListener != null) {
            requestListener.onRequestFinished(this);
        }
    }

    public BaseParams put(String key, Object value) {
        if (key != null) {
            mMap.put(key, value);
        }
        return this;
    }

    public Object get(String key) {
        return mMap.get(key);
    }

    public T getResult(String data){

        Gson json = new Gson();
        try {

            Repo<T> b = json.fromJson(data, new TypeToken<Repo<T>>() {
            }.getType());

            return b.getData();
//            this.result = b.getData();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

}
