package com.rulaibao.uitls;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import com.rulaibao.bean.CityModel;
import com.rulaibao.bean.DistrictModel;
import com.rulaibao.bean.ProvinceModel;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by xuan on 16/1/7.
 */
public class CityDataHelper {
    public static String DATABASES_DIR;//数据库目录路径
    public static String DATABASE_NAME = "province.db";//要复制的数据库名
    private static CityDataHelper dataHelper;

    private CityDataHelper(Context context) {
        DATABASES_DIR = "/data/data/" + context.getPackageName() + "/databases/";
    }

    public static CityDataHelper getInstance(Context context) {
        if (dataHelper == null) {
            dataHelper = new CityDataHelper(context);
        }
        return dataHelper;
    }

    /**
     * @param inStream
     * @param fileNme  文件名
     * @param newPath  要复制到的文件夹路径
     */
    public void copyFile(InputStream inStream, String fileNme, String newPath) {
        try {
            int bytesum = 0;
            int byteread = 0;

            File file = new File(newPath);
            //保证文件夹存在
            if (!file.exists()) {
                file.mkdir();
            }
            //如果文件存在覆盖
            File newFile = new File(newPath + File.separator + fileNme);
            if (newFile.exists()) {
                newFile.delete();
                newFile.createNewFile();
            }
            FileOutputStream fs = new FileOutputStream(newFile);
            byte[] buffer = new byte[1024 * 2];
            int length;
            while ((byteread = inStream.read(buffer)) != -1) {
                bytesum += byteread; //字节数 文件大小
//                System.out.println(bytesum);
                fs.write(buffer, 0, byteread);
            }
            inStream.close();
            fs.close();
        } catch (Exception e) {
            System.out.println("复制文件操作出错");
            e.printStackTrace();

        }
    }

    /**
     * 打开数据库文件
     *
     * @return
     */
    public SQLiteDatabase openDataBase() {
        SQLiteDatabase database = SQLiteDatabase.openOrCreateDatabase(DATABASES_DIR + DATABASE_NAME, null);
        return database;
    }

    /**
     * @param db
     * @return 查询所有的省
     */
    public List<ProvinceModel> getProvice(SQLiteDatabase db) {
        String sql = "SELECT * FROM t_address_province ORDER BY id";
        Cursor cursor = db.rawQuery(sql, null);
        List<ProvinceModel> list = new ArrayList<ProvinceModel>();

        if (cursor != null && cursor.getCount() > 0) {
            while (cursor.moveToNext()) {
                ProvinceModel provinceModel = new ProvinceModel();
                provinceModel.ID = cursor.getString(cursor.getColumnIndex("id"));
                provinceModel.NAME = cursor.getString(cursor.getColumnIndex("name"));
                provinceModel.CODE = cursor.getString(cursor.getColumnIndex("code"));
                list.add(provinceModel);
            }
        }
        return list;
    }

    /**
     * 根据省code查询所有的市
     *
     * @param db
     * @param code
     * @return
     */
    public List<CityModel> getCityByParentId(SQLiteDatabase db, String code) {
        String sql = "SELECT * FROM t_address_city WHERE provinceCode=? ORDER BY id";
        Cursor cursor = db.rawQuery(sql, new String[]{code});
        List<CityModel> list = new ArrayList<CityModel>();

        if (cursor != null && cursor.getCount() > 0) {

            while (cursor.moveToNext()) {
                CityModel cityModel = new CityModel();
                cityModel.ID = cursor.getString(cursor.getColumnIndex("id"));
                cityModel.NAME = cursor.getString(cursor.getColumnIndex("name"));
                cityModel.CODE = cursor.getString(cursor.getColumnIndex("code"));
                list.add(cityModel);
            }
        }
        return list;
    }

    /**
     * 根据市code查询所有的区
     *
     * @param db
     * @param code
     * @return
     */
    public List<DistrictModel> getDistrictById(SQLiteDatabase db, String code) {
        String sql = "SELECT * FROM t_address_town WHERE cityCode=? ORDER BY id ";
        Cursor cursor = db.rawQuery(sql, new String[]{code});
        List<DistrictModel> list = new ArrayList<DistrictModel>();
        if (cursor != null && cursor.getCount() > 0) {
            while (cursor.moveToNext()) {
                DistrictModel districtModel = new DistrictModel();
                districtModel.ID = cursor.getString(cursor.getColumnIndex("id"));
                districtModel.NAME = cursor.getString(cursor.getColumnIndex("name"));
                districtModel.CODE = cursor.getString(cursor.getColumnIndex("code"));
                list.add(districtModel);
            }
        }
        return list;
    }
}
