package com.rulaibao.common;

import android.app.Application;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.util.Log;

import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.cache.memory.impl.WeakMemoryCache;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;
import com.rulaibao.R;
import com.rulaibao.network.http.APNManager;
import com.rulaibao.photo_preview.fresco.ImageLoader;
import com.rulaibao.service.PreLoadX5Service;
import com.rulaibao.widget.superfile.ExceptionHandler;
import com.rulaibao.uitls.AuthImageDownloader;
import com.rulaibao.uitls.CityDataHelper;
import com.rulaibao.uitls.ImageLoaderManager;
import com.rulaibao.uitls.NetworkUtils;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.SystemInfo;
import com.mob.MobSDK;
import com.tencent.smtt.export.external.TbsCoreSettings;
import com.tencent.smtt.sdk.QbSdk;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.HashSet;

import static com.rulaibao.activity.RecommendActivity.getSDPath;

public class MyApplication extends Application {
    private static MyApplication instance;
    public static String mAppId;
    public static String mDownloadPath;
    private static final String TAG = "Init";
    private CityDataHelper dataHelper;
    private BroadcastReceiver mReceiver;
    public String netType;
    IntentFilter mFilter;
    HashSet<NetListener> mListeners = new HashSet<NetListener>();


    public static MyApplication getInstance() {
        return instance;
    }


    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
        NetworkUtils.setContext(this);
        PreferenceUtil.initialize(this);
        SystemInfo.initialize(this);
        initNetReceiver();


        //初始化预览ppt控件增加这句话
//        QbSdk.initX5Environment(this,null);

        //回调接口初始化完成接口回调
        QbSdk.PreInitCallback pcb=new QbSdk.PreInitCallback() {
            @Override
            public void onCoreInitFinished() {

            }

            @Override
            public void onViewInitFinished(boolean b) {
                //x5內核初始化完成的回调，为true表示x5内核加载成功，否则表示x5内核加载失败，会自动切换到系统内核。
                Log.e("myApplication", " x5内核加载成功？" + b);
            }
        };

        HashMap map = new HashMap();
        map.put(TbsCoreSettings.TBS_SETTINGS_USE_SPEEDY_CLASSLOADER, true);
        QbSdk.initTbsSettings(map);

        //x5内核预加载，异步初始化x5 webview所需环境
        QbSdk.initX5Environment(getApplicationContext(), pcb);
        ExceptionHandler.getInstance().initConfig(this);




//        initX5();//启动预加载的服务

        //imageLoader初始化
        initImageLoader();
        ImageLoaderManager.initImageLoader(this);
        mAppId = getString(R.string.app_id);
        mDownloadPath = "/" + mAppId + "/download";

        //fresco初始化
        ImageLoader.getInstance().initImageLoader(getResources(), 1);
        APNManager.getInstance().checkNetworkType(this);


        //拷贝数据库文件
        dataHelper = CityDataHelper.getInstance(this);
        InputStream in = this.getResources().openRawResource(R.raw.province);
        dataHelper.copyFile(in, CityDataHelper.DATABASE_NAME, CityDataHelper.DATABASES_DIR);

        //ShareSDK 初始化
//        ShareSDK.initSDK(instance);

        //3.X版本以上含3.X版本，ShareSDK 初始化
        // 通过代码注册你的AppKey和AppSecret
//        MobSDK.init(instance, "1ea86a798f5d6", "69d1ab82675b878c6061887a6ab49279");

        //3.1.4版本 ShareSDK 初始化
        MobSDK.init(this);

        try {
            saveImage(drawableToBitamp(getResources().getDrawable(R.mipmap.ic_share)), "share.png");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void initX5() {
        Intent intent = new Intent(this, PreLoadX5Service.class);
        startService(intent);
    }

    /****
     * 初始化imageloader
     */
    private void initImageLoader() {
        ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(
                getApplicationContext())
                .threadPriority(Thread.NORM_PRIORITY - 2)
                .denyCacheImageMultipleSizesInMemory()
                .discCacheFileNameGenerator(new Md5FileNameGenerator())
                .tasksProcessingOrder(QueueProcessingType.LIFO)
                .memoryCache(new WeakMemoryCache())
                .writeDebugLogs() // Remove for release app
                .imageDownloader(new AuthImageDownloader(this))
                .build();
        // Initialize ImageLoader with configuration.
        com.nostra13.universalimageloader.core.ImageLoader.getInstance().init(config);

    }

    private Bitmap drawableToBitamp(Drawable drawable) {
        BitmapDrawable bd = (BitmapDrawable) drawable;
        return bd.getBitmap();
    }

    /**
     * 保存图片的方法 保存到sdcard
     *
     * @throws Exception
     */
    public  void saveImage(Bitmap bitmap, String imageName)
            throws Exception {
        String filePath = isExistsFilePath();
        FileOutputStream fos = null;
        File file = new File(filePath, imageName);
        try {
            fos = new FileOutputStream(file);
            if (null != fos) {
                bitmap.compress(Bitmap.CompressFormat.PNG, 90, fos);
                fos.flush();
                fos.close();
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取缓存文件夹目录 如果不存在创建 否则则创建文件夹
     *
     * @return filePath
     */
    private static String isExistsFilePath() {
        String filePath = getSDPath() + CACHE;
        File file = new File(filePath);
        if (!file.exists()) {
            file.mkdirs();
        }
        return filePath;
    }
    private final static String CACHE = "/rulaibao/imgs";


    public interface NetListener {
        void onNetWorkChange(String netType);
    }

    /**
     * 加入网络监听
     *
     * @param l
     * @return
     */
    public boolean addNetListener(NetListener l) {
        boolean rst = false;
        if (l != null && mListeners != null) {
            rst = mListeners.add(l);
        }
        return rst;
    }

    /**
     * 移除网络监听
     *
     * @param l
     * @return
     */
    public boolean removeNetListener(NetListener l) {
        return mListeners.remove(l);
    }

    /**
     * 初始化网络监听器
     */
    private void initNetReceiver() {
        mReceiver = new BroadcastReceiver() {

            @Override
            public void onReceive(Context context, Intent intent) {
                String action = intent.getAction();
                if (action.equals(ConnectivityManager.CONNECTIVITY_ACTION)) {
                    ConnectivityManager manager = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
                    NetworkInfo info = manager.getActiveNetworkInfo();
                    if (info != null && info.isConnected()) {
                        netType = info.getTypeName();
                    } else {
                        netType = "";
                    }
                    for (NetListener lis : mListeners) {
                        if (lis != null) {
                            lis.onNetWorkChange(netType);
                        }
                    }
                }
            }
        };
        mFilter = new IntentFilter();
        mFilter.addAction(ConnectivityManager.CONNECTIVITY_ACTION);
    }

    /**
     * 注册网络监听器
     */
    public void registReceiver() {
        try {
            registerReceiver(mReceiver, mFilter);
        } catch (Exception e) {
        }
    }

    /**
     * 注销网络监听器
     */
    public void unRegisterNetListener() {
        if (mListeners != null) {
            mListeners.clear();
        }
        try {
            unregisterReceiver(mReceiver);
        } catch (Exception e) {
            // TODO: handle exception
        }
    }
}
