package com.rulaibao.photo_preview.fresco;

import android.content.Context;
import android.content.res.Resources;
import android.net.Uri;
import android.support.annotation.DrawableRes;
import android.text.TextUtils;
import android.widget.ImageView;

import com.facebook.drawee.controller.AbstractDraweeController;
import com.facebook.drawee.drawable.ScalingUtils;
import com.facebook.drawee.view.DraweeView;
import com.facebook.drawee.view.SimpleDraweeView;
import com.rulaibao.uitls.StringUtil;

import java.io.File;

/**
 *  （Fresco）图片加载封装类
 */

public class ImageLoader {
    private static ImageLoader instance;

    private ImageLoader() {

    }

    public static ImageLoader getInstance() {
        if (instance == null) {
            synchronized (ImageLoader.class) {
                instance = new ImageLoader();
            }
        }
        return instance;
    }

    /**
     * 初始化图片加载框架
     *
     * @param resources
     * @param id
     */
    public void initImageLoader(final Resources resources, int id) {
//        FrescoUtil.getInstance().initDefaultPic(resources, id);
        FrescoUtil.getInstance().initFresco();
    }

    /**
     * 自动加载网络或本地图片
     *
     * @param iv
     * @param url
     */
    public void loadImageLocalOrNet(ImageView iv, String url) {
        if (TextUtils.isEmpty(url) || iv == null) {
            return;
        }
        if (StringUtil.fromNet(url)) {
            loadImageFromNet(iv, url);
        } else {
            loadImageFromLocal(iv, "file://" + url);
        }
    }

    /**
     * 从网络加载图片
     *
     * @param iv
     * @param url
     */
    public void loadImageFromNet(ImageView iv, String url) {
        AbstractDraweeController draweeController = FrescoUtil.getInstance().frescoController(url);
//        ((SimpleDraweeView) iv).setController(draweeController);
        loadImage((SimpleDraweeView) iv, draweeController, -1, null);
    }

    public void loadImageFromNet(ImageView iv, String url, @DrawableRes int defaultDrawable) {
        AbstractDraweeController draweeController = FrescoUtil.getInstance().frescoController(url);
        loadImage((SimpleDraweeView) iv, draweeController, defaultDrawable, null);
    }

    public void loadImageFromNet(ImageView iv, String url, @DrawableRes int defaultDrawable, ScalingUtils.ScaleType type) {
        AbstractDraweeController draweeController = FrescoUtil.getInstance().frescoController(url);
        loadImage((SimpleDraweeView) iv, draweeController, defaultDrawable, type);
    }

    public void loadImageFromNet(ImageView iv, String url, int width, int height) {
        AbstractDraweeController draweeController = FrescoUtil.getInstance().frescoResizeController(url, width, height);
        loadImage((SimpleDraweeView) iv, draweeController, -1, null);
    }

    public void loadImageFromNet(ImageView iv, Uri uri, int width, int height) {
        AbstractDraweeController draweeController = FrescoUtil.getInstance().frescoResizeController(uri, width, height);
        loadImage((SimpleDraweeView) iv, draweeController, -1, null);
    }

    public void loadImageFromNet(ImageView iv, Uri uri) {
        AbstractDraweeController draweeController = FrescoUtil.getInstance().frescoResizeController(uri);
        loadImage((SimpleDraweeView) iv, draweeController, -1, null);
    }

    public void loadImageFromNet(DraweeView iv, Uri uri) {
        AbstractDraweeController draweeController = FrescoUtil.getInstance().frescoResizeController(uri);
        loadImage((DraweeView) iv, draweeController);
    }

    public void loadImageLocalOrNet(String url, OnBitmapGetListener listener) {
        if (TextUtils.isEmpty(url)) {
            return;
        }
        if (StringUtil.fromNet(url)) {
            FrescoUtil.getInstance().getBitmapFromFresco(url, listener);
        } else {
            FrescoUtil.getInstance().getBitmapFromFresco(url, true, listener);
        }
    }

    public void loadImageFromNet(String url, OnBitmapGetListener listener) {
        FrescoUtil.getInstance().getBitmapFromFresco(url, listener);
    }

    public void loadImageFromLocal(String url, OnBitmapGetListener listener) {
        FrescoUtil.getInstance().getBitmapFromFresco(url, true, listener);
    }

    /**
     * 从本地路径加载图片
     *
     * @param iv
     * @param path
     */
    public void loadImageFromLocal(ImageView iv, String path) {
        AbstractDraweeController draweeController = FrescoUtil.getInstance().frescoController(path);
//        ((SimpleDraweeView) iv).setController(draweeController);
        loadImage((SimpleDraweeView) iv, draweeController, -1, null);
    }

    public void loadImageFromLocal(ImageView iv, String path, @DrawableRes int defaultDrawable) {
        AbstractDraweeController draweeController = FrescoUtil.getInstance().frescoController(path);
        loadImage((SimpleDraweeView) iv, draweeController, defaultDrawable, null);
    }

    public void loadImageFromLocal(ImageView iv, String path, @DrawableRes int defaultDrawable, ScalingUtils.ScaleType type) {
        AbstractDraweeController draweeController = FrescoUtil.getInstance().frescoController(path);
        loadImage((SimpleDraweeView) iv, draweeController, defaultDrawable, type);
    }

    /**
     * 加载file图片
     *
     * @param iv
     * @param file
     */
    public void loadImageFromFile(ImageView iv, File file) {
        AbstractDraweeController draweeController = FrescoUtil.getInstance().frescoFromFileController(file);
//        ((SimpleDraweeView) iv).setController(draweeController);
        loadImage((SimpleDraweeView) iv, draweeController, -1, null);
    }

    public void loadImageFromFile(ImageView iv, File file, @DrawableRes int defaultDrawable) {
        AbstractDraweeController draweeController = FrescoUtil.getInstance().frescoFromFileController(file);
        loadImage((SimpleDraweeView) iv, draweeController, defaultDrawable, null);
    }

    public void loadImageFromFile(ImageView iv, File file, @DrawableRes int defaultDrawable, ScalingUtils.ScaleType type) {
        AbstractDraweeController draweeController = FrescoUtil.getInstance().frescoFromFileController(file);
        loadImage((SimpleDraweeView) iv, draweeController, defaultDrawable, type);
    }

    /**
     * 加载res资源图片
     *
     * @param iv
     * @param resourceId
     */
    public void loadImageFromRes(ImageView iv, @DrawableRes int resourceId) {
        AbstractDraweeController draweeController = FrescoUtil.getInstance().frescoFromResourceController(resourceId);
//        ((SimpleDraweeView) iv).setController(draweeController);
        loadImage((SimpleDraweeView) iv, draweeController, -1, null);
    }

    public void loadImageFromRes(ImageView iv, @DrawableRes int resourceId, @DrawableRes int defaultDrawable) {
        AbstractDraweeController draweeController = FrescoUtil.getInstance().frescoFromResourceController(resourceId);
        loadImage((SimpleDraweeView) iv, draweeController, defaultDrawable, null);
    }

    public void loadImageFromRes(ImageView iv, @DrawableRes int resourceId, @DrawableRes int defaultDrawable, ScalingUtils.ScaleType type) {
        AbstractDraweeController draweeController = FrescoUtil.getInstance().frescoFromResourceController(resourceId);
        loadImage((SimpleDraweeView) iv, draweeController, defaultDrawable, type);
    }

    /**
     * 图片加载
     *
     * @param iv
     * @param controller
     * @param defaultDrawable
     * @param type
     */
    public void loadImage(SimpleDraweeView iv, AbstractDraweeController controller, @DrawableRes int defaultDrawable, ScalingUtils.ScaleType type) {
        if (defaultDrawable != -1) {
            if (type != null) {
                FrescoUtil.getInstance().frescoHierarchyController(iv, type, defaultDrawable);
            } else {
                FrescoUtil.getInstance().frescoHierarchyController(iv, ScalingUtils.ScaleType.FIT_XY, defaultDrawable);
            }
        }
        iv.setController(controller);
    }

    public void loadImage(DraweeView iv, AbstractDraweeController controller) {
        iv.setController(controller);
    }

    /**
     * 创造图像组件
     *
     * @param context
     * @return
     */
    public ImageView createImageView(Context context) {
        SimpleDraweeView simpleDraweeView = new SimpleDraweeView(context);
        return simpleDraweeView;
    }
}
