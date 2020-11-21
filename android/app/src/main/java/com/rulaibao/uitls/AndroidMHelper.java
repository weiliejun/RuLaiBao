package com.rulaibao.uitls;

import android.app.Activity;
import android.graphics.Color;
import android.os.Build;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import com.lzy.imagepicker.view.SystemBarTintManager;

import java.lang.reflect.Field;

public class AndroidMHelper implements IHelper{

	/**
	 * @return if version is lager than M
	 */
	@Override
	public boolean setStatusBarLightMode(Activity activity, boolean isFontColorDark) {
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
			if (isFontColorDark) {
				// 沉浸式
				//                activity.getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
				//非沉浸式
				activity.getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
			} else {
				//非沉浸式
				activity.getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE);
			}
			return true;
		}
		Window window =activity.getWindow();
		// 沉浸式状态栏
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
			//5.0以上使用原生方法
			window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
			window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
			window.setStatusBarColor(Color.parseColor("#A9A9A9"));
		} else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
			//4.4-5.0使用三方工具类，有些4.4的手机有问题，这里为演示方便，不使用沉浸式
			window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
			SystemBarTintManager tintManager = new SystemBarTintManager(activity);
			tintManager.setStatusBarTintEnabled(true);
			tintManager.setStatusBarTintColor(Color.parseColor("#A9A9A9"));
		}
		return false;
	}

}