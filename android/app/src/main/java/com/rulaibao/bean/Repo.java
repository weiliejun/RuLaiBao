package com.rulaibao.bean;


/**
 * Repo.java
 * 所有接口统一的数据返回类
 * Created by dell on 2018-4-9.
 */
public class Repo<T> {

    private String check;
    private String code;
    private T data;
    private String msg;

    public String getCheck() {
        return check;
    }

    public void setCheck(String check) {
        this.check = check;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
