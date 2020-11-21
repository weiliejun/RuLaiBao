package com.rulaibao.network;

import android.content.Context;

public class BaseRequester<T> {
    private static TaskManager sTaskManager;
//    private static ArrayList<String> sTaskIdList = new ArrayList<>(20);
//    private static Object lock = new Object();

    public interface OnRequestListener<T> {
        void onRequestFinished(BaseParams<T> params);
    }

    public static TaskManager getTaskManager() {
        if (sTaskManager == null) {
            sTaskManager = new TaskManager();
        }
        return sTaskManager;
    }

//    public static void cancelTaskByType(String type) {
//        getTaskManager().cancelTask(type);
//    }
//
//    public static String buildUrl(String url, int from, int size) {
//        if (url != null) {
//            url = url.replace("($from)", String.valueOf(from));
//            url = url.replace("($size)", String.valueOf(size));
//        }
//        return url;
//    }
//
//    public static int getUserId() {
//        // int uid =
//        // PreferenceUtil.getUserIdPrefer().getInt(PreferenceUtil.CMS_USER_ID,
//        // 0);
//        int uid = 123456789;
//        // if (DEBUG) {
//        // Log.d(TAG, "getuserid=" + uid);
//        // }
//        return uid;
//    }

    // public static String getFuid(){
    // String fid = PreferenceUtil.getUserId() + "";
    // return fid;
    // }

//    public static String registerId(String taskType, String url) {
//        return registerId(taskType, url, 0, 0);
//    }
//
//    /**
//     * @param taskType
//     * @param url
//     * @param from
//     * @param size
//     * @return
//     */
//    public static String registerId(String taskType, String url, int from, int size) {
//        if (url == null) {
//            return null;
//        }
//        synchronized (lock) {
//            String md5 = StringUtil.MD5Encode(url);
//            String id = taskType.concat(":").concat(md5);
//            if (sTaskIdList.contains(id)) {
//                return null;
//            } else {
//                sTaskIdList.add(id);
//            }
//            return id;
//        }
//    }
//
//    public static void unRegisterId(String id) {
//        synchronized (lock) {
//            if (id != null) {
//                sTaskIdList.remove(id);
//            }
//        }
//    }

    public static BaseParams buildParams(Context context, OnRequestListener listener, String url) {
        BaseParams p = new BaseParams();
        p.context = context;
        p.requestListener = listener;
        p.url = url;
        return p;
    }
}
