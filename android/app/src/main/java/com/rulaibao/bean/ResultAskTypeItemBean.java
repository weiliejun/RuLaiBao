package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

import java.io.Serializable;

public class ResultAskTypeItemBean implements IMouldType,Serializable {

    private String typeCode; // 问题类型编码
    private String typeName;  //问题类型名称
    private boolean flag; // 当前是否被点击  （适用于我要提问）

    public boolean getFlag() {
        return flag;
    }

    public void setFlag(boolean flag) {
        this.flag = flag;
    }

    public String getTypeCode() {
        return typeCode;
    }

    public void setTypeCode(String typeCode) {
        this.typeCode = typeCode;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }
}
