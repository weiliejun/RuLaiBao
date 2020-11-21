package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;

public class ResultPhotoContentBean implements IMouldType {
	private String flag;
	private String imgCommentUrl;
	private String userId;

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}


    public String getImgCommentUrl() {
        return imgCommentUrl;
    }

    public void setImgCommentUrl(String imgCommentUrl) {
        this.imgCommentUrl = imgCommentUrl;
    }

    public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}
}
