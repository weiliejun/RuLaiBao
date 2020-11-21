package com.rulaibao.network;

import com.google.gson.Gson;
import com.rulaibao.bean.CheckVersionBean;
import com.rulaibao.uitls.encrypt.DESUtil;
import com.rulaibao.uitls.encrypt.MD5;

public class HtmlLoadUtil {

    private static String getResult(Object data) {
        Gson gson = new Gson();
        String md5 = MD5.stringToMD5(gson.toJson(data));
        String result = null;
        try {
            EcryptBean b = new EcryptBean(md5, data);
            String encrypt = gson.toJson(b);
            result = DESUtil.encrypt(encrypt);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    private static String getResultNoEncrypt(Object data) {
        Gson gson = new Gson();
        String md5 = MD5.stringToMD5(gson.toJson(data));
        String result = null;
        try {
            EcryptBean b = new EcryptBean(md5, data);
            result = gson.toJson(b);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 检查版本
     *
     * @param type
     * @return
     */
    public static String checkVersion(String type) {
        CheckVersionBean b = new CheckVersionBean(type);
        return getResult(b);
    }
}
