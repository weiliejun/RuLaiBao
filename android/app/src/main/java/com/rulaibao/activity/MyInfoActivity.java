package com.rulaibao.activity;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.rulaibao.base.BaseActivity;
import com.rulaibao.R;
import com.rulaibao.bean.UserInfo2B;
import com.rulaibao.common.Urls;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.network.http.AsyncHttpClient;
import com.rulaibao.network.http.AsyncHttpResponseHandler;
import com.rulaibao.network.http.RequestParams;
import com.rulaibao.uitls.ImageUtils;
import com.rulaibao.uitls.PhotoUtils;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.StringUtil;
import com.rulaibao.uitls.encrypt.DESUtil;
import com.rulaibao.widget.SelectPhotoDialog;
import com.rulaibao.widget.TitleBar;

import org.apache.http.Header;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;


/**
 * 我的 --- 个人信息
 */
public class MyInfoActivity extends BaseActivity implements View.OnClickListener {
    private RelativeLayout rl_layout_photo; // 头像布局
    private RelativeLayout rl_layout_sales_certification; // 销售认证

    private ImageView img_photo;
    private ImageView iv_certified_flag;

    private TextView tv_phone; // 电话
    private TextView tv_address_personal; // 所在省/市
    private TextView tv_status; // 销售认证 状态

    private String realName;
    private String headPhoto;
    private String status;

    //表示选择的是相册--2
    private static int GALLERY_REQUEST_CODE = 2;
    //表示选择的是裁剪--3
    private static int CROP_REQUEST_CODE = 3;
   //销售认证界面返回
    private static int SALES_RETURN = 4;
    private Bitmap newZoomImage;

    //图片保存SD卡位置
    private final static String IMG_PATH = Environment.getExternalStorageDirectory() + "/rulaibao/imgs/";
   //图片保存SD卡位置
    private final static String IMG_PATH_TWO = Environment.getExternalStorageDirectory() + "/rulaibao/imgs2/";

  //使用照相机拍照获取图片
    public static final int SELECT_PIC_BY_TACK_PHOTO = 1;
   //使用相册中的图片
    public static final int SELECT_PIC_BY_PICK_PHOTO = 2;

   //获取到的图片路径
    private String picPath;
    private Uri photoUri;

    private static final String TAG = "MyInfoActivity";
    private UserInfo2B data;


    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_info);

        initTopTitle();
        initView();
        requestUserInfo();
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.showLeftImg(true);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false).setIndicator(R.mipmap.icon_back)
                .setCenterText(getResources().getString(R.string.title_my_info)).showMore(false).setOnActionListener(new TitleBar.OnActionListener() {

            @Override
            public void onMenu(int id) {
            }

            @Override
            public void onBack() {
                finish();
            }

            @Override
            public void onAction(int id) {

            }
        });
    }

    private void initView() {

        rl_layout_photo = (RelativeLayout) findViewById(R.id.rl_layout_photo);
        rl_layout_sales_certification = (RelativeLayout) findViewById(R.id.rl_layout_sales_certification);
        img_photo = (ImageView) findViewById(R.id.img_photo);
        tv_phone = (TextView) findViewById(R.id.tv_phone);
        tv_address_personal = (TextView) findViewById(R.id.tv_address_personal);
        tv_status = (TextView) findViewById(R.id.tv_status);
        iv_certified_flag = (ImageView) findViewById(R.id.iv_certified_flag);

        if (!TextUtils.isEmpty(headPhoto)) {
            File file = new File(IMG_PATH);

            if (file.exists()) {
                Bitmap bitmap = BitmapFactory.decodeFile(IMG_PATH + "Test.png");
                img_photo.setImageBitmap(bitmap);
            } else {
                new ImageViewService().execute(headPhoto);
            }
        } else {
            img_photo.setImageDrawable(getResources().getDrawable(R.mipmap.img_default_photo));
        }

        rl_layout_photo.setOnClickListener(this);
        rl_layout_sales_certification.setOnClickListener(this);
    }

    /**
     * 获取网落图片资源
     *
     * @return
     */
    class ImageViewService extends AsyncTask<String, Void, Bitmap> {

        @Override
        protected Bitmap doInBackground(String... params) {
            Bitmap data = getImageBitmap(params[0]);
            return data;
        }

        @Override
        protected void onPostExecute(Bitmap result) {
            super.onPostExecute(result);

            if (result != null) {
                img_photo.setImageBitmap(result);
                saveBitmap2(result);
            } else {
                img_photo.setImageDrawable(getResources().getDrawable(R.mipmap.img_default_photo));
            }
        }

    }

    private Bitmap getImageBitmap(String url) {
        URL imgUrl = null;
        Bitmap bitmap = null;
        try {
            imgUrl = new URL(url);
            HttpURLConnection conn = (HttpURLConnection) imgUrl.openConnection();
            conn.setDoInput(true);
            conn.connect();
            InputStream is = conn.getInputStream();
            bitmap = BitmapFactory.decodeStream(is);
            bitmap = ImageUtils.toRoundBitmap(bitmap); // 把图片处理成圆形
            is.close();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return bitmap;
    }

    private Uri saveBitmap2(Bitmap bm) {
        File tmpDir = new File(IMG_PATH);
        if (!tmpDir.exists()) {
            tmpDir.mkdirs();
        }
        File img = new File(IMG_PATH + "Test.png");
        try {
            FileOutputStream fos = new FileOutputStream(img);
            bm.compress(Bitmap.CompressFormat.PNG, 70, fos);
            fos.flush();
            fos.close();
            return Uri.fromFile(img);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return null;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }

    }

    /**
     * 获取个人信息
     */
    private void requestUserInfo() {
        try {
//            checkStatus = DESUtil.decrypt(PreferenceUtil.getCheckStatus());
            userId = DESUtil.decrypt(PreferenceUtil.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
        }

        HashMap<String, Object> param = new HashMap<>();
        param.put("userId", userId);

        HtmlRequest.getAppUserInfoData(this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params == null || params.result == null) {
                  //  Toast.makeText(MyInfoActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }
                data = (UserInfo2B) params.result;
                if (data != null) {
                    setData(data);
                }
            }
        });
    }

    private void setData(UserInfo2B data) {
        if (data.getMobile() != null) {  // 设置手机号
            tv_phone.setText(StringUtil.replaceSubString(data.getMobile()));
        }
        String area = data.getArea();
        if (area != null) {  // 设置省市
            if ("beijing".equals(area)) {
                tv_address_personal.setText("北京");
            } else if ("hebei".equals(area)) {
                tv_address_personal.setText("河北");
            } else if ("neimeng".equals(area)) {
                tv_address_personal.setText("内蒙");
            } else if ("guizhou".equals(area)) {
                tv_address_personal.setText("贵州");
            }else {
                tv_address_personal.setText("--");
            }
        }

        String url = data.getHeadPhoto();
        if (!TextUtils.isEmpty(url)) {
            new MyInfoActivity.ImageViewService().execute(url);
        } else {
            img_photo.setImageDrawable(getResources().getDrawable(R.mipmap.img_default_photo));
        }

        // 判断用户是否认证
        if (data.getCheckStatus() != null) {
            status = data.getCheckStatus();
        }
        if ("init".equals(status)) {
            tv_status.setText("未认证");
        } else if ("submit".equals(status)) {
            tv_status.setText("待认证");
        } else if ("success".equals(status)) {
            tv_status.setText("认证成功");
        } else {
            tv_status.setText("认证失败");
        }

        if ("success".equals(status)) {
            iv_certified_flag.setImageResource(R.mipmap.icon_certified);
        } else {
            iv_certified_flag.setImageResource(R.mipmap.icon_uncertified);
        }

    }

    private void selectPhoto() {
        SelectPhotoDialog mDialog = new SelectPhotoDialog(this, new SelectPhotoDialog.OnSelectPhotoChanged() {
            @Override
            public void onAlbum() { // 相册
                pickPhoto();
            }

            @Override
            public void onCamera() { // 相机
                takePhoto();
            }

        });
        mDialog.show();
    }

    /***
     *   从相册选取图片
     */
    private void pickPhoto() {
        Intent intent = new Intent();
        intent.setType("image/*");
        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(intent, GALLERY_REQUEST_CODE);
    }

    /**
     * 拍照获取图片
     */
    private void takePhoto() {
        //执行拍照前，应该先判断SD卡是否存在
        String sdState = Environment.getExternalStorageState();
        if (sdState.equals(Environment.MEDIA_MOUNTED)) {

            Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);//"android.media.action.IMAGE_CAPTURE"
            /***
             * 需要说明一下，以下操作使用照相机拍照，拍照后的图片会存放在相册中的
             * 这里使用的这种方式有一个好处就是获取的图片是拍照后的原图
             * 如果不使用ContentValues存放照片路径的话，拍照后获取的图片为缩略图不清晰
             */
            /*//设置图片的保存路径,作为全局变量
            String imageFilePath = Environment.getExternalStorageDirectory().getAbsolutePath()+"/filename.jpg";
			File temp = new File(imageFilePath);
			photoUri = Uri.fromFile(temp);//获取文件的Uri*/
            ContentValues values = new ContentValues();
            photoUri = this.getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
            Log.i("aa", "photoUri: -- " + photoUri);
            // 例：（三星手机）photoUri = content://media/external/images/media/27388
            // 例：（华为手机）photoUri = content://media/external/images/media/539797

            intent.putExtra(MediaStore.EXTRA_OUTPUT, photoUri);
            startActivityForResult(intent, SELECT_PIC_BY_TACK_PHOTO);
        } else {
            Toast.makeText(this, "内存卡不存在", Toast.LENGTH_LONG).show();
        }
    }

    /**
     * 通过Uri获取文件
     * @param ac
     * @param uri
     * @return
     */
    public static File getFileFromMediaUri(Context ac, Uri uri) {
        if(uri.getScheme().toString().compareTo("content") == 0){
            ContentResolver cr = ac.getContentResolver();
            Cursor cursor = cr.query(uri, null, null, null, null);// 根据Uri从数据库中找
            if (cursor != null) {
                cursor.moveToFirst();
                String filePath = cursor.getString(cursor.getColumnIndex("_data"));// 获取图片路径
                cursor.close();
                if (filePath != null) {
                    return new File(filePath);
                }
            }
        }else if(uri.getScheme().toString().compareTo("file") == 0){
            return new File(uri.toString().replace("file://",""));
        }
        return null;
    }

    /**
     * 根据用户选择，返回图片资源
     * @param requestCode
     * @param resultCode
     * @param data
     */
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
//			doPhoto(requestCode, data);
        if (requestCode == SELECT_PIC_BY_TACK_PHOTO) {  // 表示用的相机
            Bitmap photoBmp = null;
            File file = null;
            file = getFileFromMediaUri(this, photoUri);

            if (photoUri != null) {
                try {
                    photoBmp = getBitmapFormUri(MyInfoActivity.this, Uri.fromFile(file));
                    int degree = PhotoUtils.readPictureDegree(file.getAbsolutePath());
//                    Log.i("aaa", "degree:  " + degree);
                    // 把图片旋转为正的方向
                    Bitmap newbitmap = PhotoUtils.rotateBitmap(photoBmp, degree);
                    if (newbitmap != null) {
                        dialog.setmLoadingTip("正在上传照片，请稍后……");
                        startLoading();
                    }

                    newZoomImage = newbitmap;
                    sendImage(newbitmap);
                } catch (IOException e) {
                    e.printStackTrace();
                }

            }
        } else if (requestCode == GALLERY_REQUEST_CODE) {  // 表示用的相册
            if (data == null) {
                return;
            }
            dialog.setmLoadingTip("正在上传照片，请稍后……");
            startLoading();
            Uri mImageCaptureUri = data.getData();

            Bitmap photoBmp = null;

            if (mImageCaptureUri != null) {
                try {
                    photoBmp = getBitmapFormUri(MyInfoActivity.this, mImageCaptureUri);
                    newZoomImage = photoBmp;
                    sendImage(photoBmp);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        } else if (requestCode == CROP_REQUEST_CODE) {
            if (data == null) {
                return;
            }
            Bundle extras = data.getExtras();
            if (extras == null) {
                return;
            }
            Bitmap bm = extras.getParcelable("data");
            newZoomImage = zoomImage(bm, 600, 300);
//			sendImage(newZoomImage);
        } else if (requestCode == SALES_RETURN) {
            //销售认证界面返回，刷新数据
            requestUserInfo();
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    /**
     * 通过uri获取图片并进行压缩
     *
     * @param uri
     */
    public static Bitmap getBitmapFormUri(Activity ac, Uri uri) throws FileNotFoundException, IOException {
        InputStream input = ac.getContentResolver().openInputStream(uri);
        BitmapFactory.Options onlyBoundsOptions = new BitmapFactory.Options();
        onlyBoundsOptions.inJustDecodeBounds = true;
        onlyBoundsOptions.inDither = true;//optional
        onlyBoundsOptions.inPreferredConfig = Bitmap.Config.ARGB_8888;//optional
        BitmapFactory.decodeStream(input, null, onlyBoundsOptions);
        input.close();
        int originalWidth = onlyBoundsOptions.outWidth;
        int originalHeight = onlyBoundsOptions.outHeight;
        if ((originalWidth == -1) || (originalHeight == -1)) return null;
        //图片分辨率以480x800为标准
        float hh = 800f;//这里设置高度为800f
        float ww = 480f;//这里设置宽度为480f
        //缩放比。由于是固定比例缩放，只用高或者宽其中一个数据进行计算即可
        int be = 1;//be=1表示不缩放
        if (originalWidth > originalHeight && originalWidth > ww) {//如果宽度大的话根据宽度固定大小缩放
            be = (int) (originalWidth / ww);
        } else if (originalWidth < originalHeight && originalHeight > hh) {//如果高度高的话根据宽度固定大小缩放
            be = (int) (originalHeight / hh);
        }
        if (be <= 0) be = 1;
        //比例压缩
        BitmapFactory.Options bitmapOptions = new BitmapFactory.Options();
        bitmapOptions.inSampleSize = be;//设置缩放比例
        bitmapOptions.inDither = true;//optional
        bitmapOptions.inPreferredConfig = Bitmap.Config.ARGB_8888;//optional
        input = ac.getContentResolver().openInputStream(uri);
        Bitmap bitmap = BitmapFactory.decodeStream(input, null, bitmapOptions);
        input.close();

        return compressImage(bitmap);//再进行质量压缩
    }

    /**
     * 质量压缩方法
     *
     * @param image
     * @return
     */
    public static Bitmap compressImage(Bitmap image) {

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        image.compress(Bitmap.CompressFormat.JPEG, 100, baos);//质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
        int options = 100;
        while (baos.toByteArray().length / 1024 > 100) {  //循环判断如果压缩后图片是否大于100kb,大于继续压缩
            baos.reset();//重置baos即清空baos
            //第一个参数 ：图片格式 ，第二个参数： 图片质量，100为最高，0为最差  ，第三个参数：保存压缩后的数据的流
            image.compress(Bitmap.CompressFormat.JPEG, options, baos);//这里压缩options%，把压缩后的数据存放到baos中
            options -= 10;//每次都减少10
        }
        ByteArrayInputStream isBm = new ByteArrayInputStream(baos.toByteArray());//把压缩后的数据保存放到ByteArrayInputStream中
        Bitmap bitmap = BitmapFactory.decodeStream(isBm, null, null);//把ByteArrayInputStream数据生成图片
        return bitmap;
    }

    /**
     * 选择图片后，获取图片的路径
     *
     * @param requestCode
     * @param data
     */
    private void doPhoto(int requestCode, Intent data) {
        if (requestCode == SELECT_PIC_BY_PICK_PHOTO)  //从相册取图片，有些手机有异常情况，请注意
        {
            if (data == null) {
                Toast.makeText(this, "选择图片文件出错", Toast.LENGTH_LONG).show();
                return;
            }
            photoUri = data.getData();
            if (photoUri == null) {
                Toast.makeText(this, "选择图片文件出错", Toast.LENGTH_LONG).show();
                return;
            }
        }
        String[] pojo = {MediaStore.Images.Media.DATA};
        ContentResolver cr = getContentResolver();
        Cursor cursor = cr.query(photoUri, pojo, null, null, null);
//		Cursor cursor = managedQuery(photoUri, pojo, null, null,null);
        if (cursor != null) {
            int columnIndex = cursor.getColumnIndexOrThrow(pojo[0]);
            cursor.moveToFirst();
            picPath = cursor.getString(columnIndex);
            cursor.close();
        }
        Log.i(TAG, "imagePath = " + picPath);

        if (picPath != null && (picPath.endsWith(".png") || picPath.endsWith(".PNG") || picPath.endsWith(".jpg") || picPath.endsWith(".JPG"))) {

            Bitmap bm = BitmapFactory.decodeFile(picPath);
            newZoomImage = zoomImage(bm, 600, 300);

//			sendImage(image2byte(picPath));
        } else {
            Toast.makeText(this, "选择图片文件不正确", Toast.LENGTH_LONG).show();
        }

    }

    //图片到byte数组
    public byte[] image2byte(String path) {
        byte[] data = null;
        FileInputStream input = null;
        try {
            input = new FileInputStream(new File(path));
            ByteArrayOutputStream output = new ByteArrayOutputStream();
            byte[] buf = new byte[1024];
            int numBytesRead = 0;
            while ((numBytesRead = input.read(buf)) != -1) {
                output.write(buf, 0, numBytesRead);
            }
            data = output.toByteArray();
            output.close();
            input.close();
        } catch (FileNotFoundException ex1) {
            ex1.printStackTrace();
        } catch (IOException ex1) {
            ex1.printStackTrace();
        }
        return data;
    }

    public static Bitmap zoomImage(Bitmap bgimage, double newWidth, double newHeight) {
        // 获取这个图片的宽和高
        float width = bgimage.getWidth();
        float height = bgimage.getHeight();
        // 创建操作图片用的matrix对象
        Matrix matrix = new Matrix();
        // 计算宽高缩放率
        float scaleWidth = ((float) newWidth) / width;
        float scaleHeight = ((float) newHeight) / height;
        // 缩放图片动作
        matrix.postScale(scaleWidth, scaleHeight);
        Bitmap bitmap = Bitmap.createBitmap(bgimage, 0, 0, (int) width, (int) height, matrix, true);
        return bitmap;
    }

    /**
     * 调接口，上传图片到服务器
     *
     * @param bm
     */
    private void sendImage(Bitmap bm) {
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        bm.compress(Bitmap.CompressFormat.JPEG, 100, stream);
        byte[] bytes = stream.toByteArray();

        String img = new String(Base64.encodeToString(bytes, Base64.DEFAULT));

        try {
            AsyncHttpClient client = new AsyncHttpClient();
            RequestParams params = new RequestParams();
            params.add("photo", img);
            params.add("name", "headPhoto.jpg");
            params.add("id", userId);
            params.add("photoType", "headPhoto");
            String url = Urls.URL_SUBMIT_PHOTO;
            client.post(url, params, new AsyncHttpResponseHandler() {
                @Override
                public void onSuccess(int statusCode, Header[] headers, String content) {
                    super.onSuccess(statusCode, headers, content);
                    stopLoading();
                    newZoomImage = ImageUtils.toRoundBitmap(newZoomImage); // 把图片处理成圆形
                    img_photo.setImageBitmap(newZoomImage);
                }

                @Override
                public void onFailure(Throwable error, String content) {
                    super.onFailure(error, content);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Uri saveBitmap(Bitmap bm) {
        if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
            File tmpDir = new File(IMG_PATH);
            if (!tmpDir.exists()) {
                tmpDir.mkdirs();
            }
            File img = new File(IMG_PATH + "Test.png");
            try {
                FileOutputStream fos = new FileOutputStream(img);
                bm.compress(Bitmap.CompressFormat.PNG, 100, fos);
                fos.flush();
                fos.close();
                return Uri.fromFile(img);
            } catch (FileNotFoundException e) {
                e.printStackTrace();
                return null;
            } catch (IOException e) {
                e.printStackTrace();
                return null;
            }
        } else {
            return null;
        }

    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.rl_layout_photo: // 上传头像
                selectPhoto();
                break;
            case R.id.rl_layout_sales_certification: // 销售认证
                Intent intent = new Intent(MyInfoActivity.this, SalesCertificationActivity.class);
//                intent.putExtra("realName", data.getRealName());
//                intent.putExtra("idNo", data.getIdNo());
//                intent.putExtra("post", data.getPosition());
//                intent.putExtra("status", data.getCheckStatus());
//                intent.putExtra("businessCard", data.getBusiCardPhoto());
                startActivityForResult(intent, SALES_RETURN);
                break;
//            case R.id.layout_name:
//                Intent intent = new Intent(this, MyInfoForNameActivity.class);
//                intent.putExtra("realName", realName);
//                startActivityForResult(intent, 1000);
//                break;
        }
    }
}
