package com.rulaibao.uitls;

import android.annotation.TargetApi;
import android.content.Context;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.StrictMode;

import com.rulaibao.R;
import com.rulaibao.uitls.Constants.Config;
import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;

/**
 * 图片加载缓存管理
 *
 * @author cxy
 */
public class ImageLoaderManager {

    public static DisplayImageOptions options=ImageLoaderManager.initDisplayImageOptions(R.mipmap.bg_oversea_project_normal, R.mipmap.bg_oversea_project_normal, R.mipmap.bg_oversea_project_normal);;

    @TargetApi(Build.VERSION_CODES.GINGERBREAD)
    @SuppressWarnings("unused")
    public static void initStrictMode() {
        if (Config.DEVELOPER_MODE && Build.VERSION.SDK_INT >= Build.VERSION_CODES.GINGERBREAD) {
            StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder().detectAll().penaltyDialog().build());
            StrictMode.setVmPolicy(new StrictMode.VmPolicy.Builder().detectAll().penaltyDeath().build());
        }

    }

    /**
     * @param context
     */
    public static void initImageLoader(Context context) {
        ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(context)
                .threadPoolSize(5)
                .threadPriority(Thread.NORM_PRIORITY - 2)
                .denyCacheImageMultipleSizesInMemory()
                .discCacheFileNameGenerator(new Md5FileNameGenerator())
                .tasksProcessingOrder(QueueProcessingType.LIFO)
                .writeDebugLogs() // Remove
                .imageDownloader(new AuthImageDownloader(context)) // 用于支持加载https类型图片；
                .build();
        ImageLoader.getInstance().init(config);
    }

    public static DisplayImageOptions initDisplayImageOptions(int onLoadingImg, int forEmptyUriImg, int onFailImg) {
        return new DisplayImageOptions.Builder()
                .showImageOnLoading(onLoadingImg)
                .showImageForEmptyUri(forEmptyUriImg)
                .showImageOnFail(onFailImg)
                .cacheInMemory(true)
                .cacheOnDisc(true)
                .considerExifParams(true)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();
    }
}
