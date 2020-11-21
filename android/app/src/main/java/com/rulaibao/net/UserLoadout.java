package com.rulaibao.net;

import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

import com.rulaibao.activity.MainActivity;
import com.rulaibao.bean.OK2B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.uitls.PreferenceUtil;

import java.util.LinkedHashMap;


public class UserLoadout {

	private Context context;
	private String userId;

	public UserLoadout(Context context,String userId) {
		this.context = context;
		this.userId = userId;
	}

	public void requestData() {
		LinkedHashMap<String, Object> param = new LinkedHashMap<>();
		param.put("userId", userId);
		HtmlRequest.loginOff(context,param, new BaseRequester.OnRequestListener() {

			@Override
			public void onRequestFinished(BaseParams params) {
				OK2B b = (OK2B) params.result;
				// if (b != null) {
				// if (Boolean.parseBoolean(b.getFlag())) {
				PreferenceUtil.setAutoLoginPwd("");
				PreferenceUtil.setLogin(false);
//				PreferenceUtil.setPhone("");
				PreferenceUtil.setUserId("");
				PreferenceUtil.setCookie("");
				PreferenceUtil.setToken("");
				Intent tent = new Intent("rulaibaoexit");// 广播的标签，一定要和需要接受的一致。
				tent.putExtra("result", "exit");
				context.sendBroadcast(tent);// 发送广播
				Toast.makeText(context, "退出成功", Toast.LENGTH_LONG).show();
				Intent i_account = new Intent();
				i_account.setClass(context, MainActivity.class);
				i_account.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
				i_account.putExtra("selectIndex", 3);
				context.startActivity(i_account);
			}
		});
	}
}
