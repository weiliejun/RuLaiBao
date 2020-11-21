package com.rulaibao.widget;

import android.content.Context;
import android.os.Environment;

import java.io.File;

public class FileManager {
    public static final String FILE_NAME = "haidehui";


    /**
     * 获取应用的路径
     *
     * @return
     */
    public static String getBaseDir(Context context) {
        String baseDir = null;
        if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
            baseDir = Environment.getExternalStorageDirectory() + "/" + FILE_NAME + "/";
        } else {
            baseDir = context.getCacheDir().getAbsolutePath() + "/" + FILE_NAME + "/";
        }
        File basedir = new File(baseDir);
        if (!basedir.exists()) {
            basedir.mkdirs();
        }
        return baseDir;
    }

    /**
     * 获取二级目录
     *
     * @param context
     * @return
     */
    public static String getSecondDir(Context context, String dirname) {
        String basedir = getBaseDir(context);
        String dir = basedir + dirname;
        File dirFile = new File(dir);
        if (!dirFile.exists()) {
            dirFile.mkdirs();
        }
        return dir;
    }


}
