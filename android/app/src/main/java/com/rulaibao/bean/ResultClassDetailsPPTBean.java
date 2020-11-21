package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

import java.util.ArrayList;

// 课程详情 PPT
public class ResultClassDetailsPPTBean implements IMouldType {


    private ArrayList<String> pptImgs;      //
    private String flag;
    private String message;
    private ResultPPTFileBean attachmentFile;

    public ResultPPTFileBean getAttachmentFile() {
        return attachmentFile;
    }

    public void setAttachmentFile(ResultPPTFileBean attachmentFile) {
        this.attachmentFile = attachmentFile;
    }

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public ArrayList<String> getPptImgs() {
        return pptImgs;
    }

    public void setPptImgs(ArrayList<String> pptImgs) {
        this.pptImgs = pptImgs;
    }
}