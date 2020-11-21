/*
 * Copyright (C) 2010 The MobileSecurePay Project
 * All right reserved.
 * author: shiqun.shi@alipay.com
 */

package com.rulaibao.uitls;

import android.content.ClipboardManager;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Environment;
import android.view.View;
import android.widget.Toast;

import com.rulaibao.R;

import java.util.HashMap;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.onekeyshare.OnekeyShare;
import cn.sharesdk.onekeyshare.ShareContentCustomizeCallback;
import cn.sharesdk.system.text.ShortMessage;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.tencent.qzone.QZone;
import cn.sharesdk.wechat.friends.Wechat;
import cn.sharesdk.wechat.moments.WechatMoments;

/**
 * 分享时调用的方法
 */
public final class ShareUtil {
    public static void sharedSDK(final Context context, final int position, final String title, final String text, final String url) {

        final OnekeyShare oks = new OnekeyShare();
        oks.disableSSOWhenAuthorize();// 关闭sso授权
        if (position == 0) { // 微信朋友圈
//            Toast.makeText(context, "该功能暂未开放", Toast.LENGTH_SHORT).show();
            oks.setText(text);
            oks.setTitleUrl(url);
            oks.setTitle(title);
//            oks.setImagePath(Environment.getExternalStorageDirectory() + "/rulaibao/imgs/share.png");
            oks.setImageData(drawableToBitamp(context.getResources().getDrawable(R.mipmap.ic_share)));
            oks.setUrl(url);
            oks.setPlatform(WechatMoments.NAME);
//            return;
        } else if (position == 1) { // 微信好友
//            Toast.makeText(context, "该功能暂未开放", Toast.LENGTH_SHORT).show();
            oks.setText(text);
            oks.setTitle(title);
            oks.setTitleUrl(url);
            oks.setUrl(url);
//            oks.setImagePath(Environment.getExternalStorageDirectory() + "/rulaibao/imgs/share.png");
            oks.setImageData(drawableToBitamp(context.getResources().getDrawable(R.mipmap.ic_share)));
            oks.setPlatform(Wechat.NAME);
//            return;
        } else if (position == 2) {
            oks.setTitle(title);
            oks.setText(text);
            oks.setTitleUrl(url);
            oks.setUrl(url);
//            oks.setImagePath(Environment.getExternalStorageDirectory() + "/rulaibao/imgs/share.png");

            oks.setImageData(drawableToBitamp(context.getResources().getDrawable(R.mipmap.ic_share)));

            oks.setSite(context.getString(R.string.app_name));
            oks.setPlatform(QQ.NAME);
        } else if (position == 3) {
            oks.setTitle(title);
            oks.setText(text);
            oks.setTitleUrl(url);
            oks.setUrl(url);
            oks.setImagePath(Environment.getExternalStorageDirectory() + "/rulaibao/imgs/rulaibao.png");
//            oks.setImageData(drawableToBitamp(context.getResources().getDrawable(R.mipmap.ic_share)));
            // 从网络获取图片
//            oks.setImageUrl("https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3208696326,3417130916&fm=173&s=2FE67A221AB13BAB5634185B0100C060&w=343&h=345&img.JPG");
            oks.setPlatform(QZone.NAME);
        } else if (position == 4) {
            oks.setText(title + "\n" + text + "\n" + url);
            oks.setTitleUrl(url);
            oks.setUrl(url);
            oks.setPlatform(ShortMessage.NAME);
        } else if (position == 5) {
            StringBuffer randomNum = new StringBuffer();
            for (int i = 0; i < 6; i++) {
                int t = (int) (Math.random() * 10);
                randomNum.append(t);
            }
            ClipboardManager cm = (ClipboardManager) context.getSystemService(Context.CLIPBOARD_SERVICE);
            cm.setText(url);
            Toast.makeText(context, "复制成功", Toast.LENGTH_SHORT).show();
            return;
        }
        oks.setCallback(new PlatformActionListener() {
            @Override
            public void onComplete(Platform platform, int i, HashMap<String, Object> hashMap) {

                if (platform.getName().equals("WechatMoments")) {
                    Toast.makeText(context, "分享成功", Toast.LENGTH_SHORT).show();

                } else if (platform.getName().equals("Wechat")) {
//                    Toast.makeText(context, "weixin share", Toast.LENGTH_SHORT).show();
                    Toast.makeText(context, "分享成功", Toast.LENGTH_SHORT).show();
                } else if (platform.getName().equals("QZone")) {
                    Toast.makeText(context, "分享成功", Toast.LENGTH_SHORT).show();
                } else if (platform.getName().equals("SinaWeibo")) {


                } else if (platform.getName().equals("ShortMessage")) {

                } else if (platform.getName().equals("QQ")) {
                    Toast.makeText(context, "分享成功", Toast.LENGTH_SHORT).show();
                }
            }

            @Override
            public void onError(Platform platform, int i, Throwable throwable) {
            }

            @Override
            public void onCancel(Platform platform, int i) {

            }
        });

        // 启动分享GUI
        oks.show(context);
    }

    private static Bitmap drawableToBitamp(Drawable drawable) {
        BitmapDrawable bd = (BitmapDrawable) drawable;
        return bd.getBitmap();
    }
}
