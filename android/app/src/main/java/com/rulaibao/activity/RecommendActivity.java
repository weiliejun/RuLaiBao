package com.rulaibao.activity;

import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.os.Bundle;
import android.os.Environment;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.rulaibao.base.BaseActivity;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.rulaibao.R;
import com.rulaibao.bean.Recommend1B;
import com.rulaibao.common.Urls;
import com.rulaibao.dialog.ShareSDKDialog;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.uitls.ShareUtil;
import com.rulaibao.widget.TitleBar;

import java.io.File;
import java.util.HashMap;
import java.util.Hashtable;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.onekeyshare.OnekeyShare;
import cn.sharesdk.onekeyshare.ShareContentCustomizeCallback;

/**
 * 推荐APP给好友
 */
public class RecommendActivity extends BaseActivity implements View.OnClickListener {

    private TextView tv_amount_people; // 邀请好友数量
    private ImageView iv_recommend_invite_code; // 我的邀请二维码
    private TextView tv_recommend_my_code; // 我的推荐码
    private TextView tv_recommend_record; // 推荐记录
    private Button btn_recommend; // 推荐App给朋友

//    private final static String CACHE = "/dafuweng/imgs";
    private int QR_WIDTH = 360, QR_HEIGHT = 360;
    private String recommendCode = "";  //  邀请码(测试的邀请码:2YCV92)

    private Recommend1B bean;
    private Context context;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_recommend);

        initTopTitle();
        initView();
        initData();

//        try {
//            saveImage(drawableToBitamp(getResources().getDrawable(R.mipmap.img_logo_bg_white)), "dafuweng.png");
//        } catch (Exception e) {
//            e.printStackTrace();
//        }

    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
             .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.setting_recommend_title))
             .showMore(false).setOnActionListener(new TitleBar.OnActionListener() {
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

    public void initView() {
        context = this;
        bean = new Recommend1B();

        tv_amount_people = (TextView) findViewById(R.id.tv_amount_people);
        tv_recommend_my_code = (TextView) findViewById(R.id.tv_recommend_my_code);
        tv_recommend_record = (TextView) findViewById(R.id.tv_recommend_record);
        iv_recommend_invite_code = (ImageView) findViewById(R.id.iv_recommend_invite_code);
        btn_recommend = (Button) findViewById(R.id.btn_recommend);

        btn_recommend.setOnClickListener(this);
        tv_recommend_record.setOnClickListener(this);

    }

    public void initData() {
        getRecommendData();
    }

    private void getRecommendData() {
       HashMap<String, Object> param = new  HashMap<>();
        param.put("userId",userId);

        HtmlRequest.getRecommendInfo(RecommendActivity.this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params==null || params.result == null) {
         //           Toast.makeText(RecommendActivity.this, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }

                bean = (Recommend1B) params.result;
                recommendCode = bean.getRecommendCode();
                setView();
            }
        });
    }

    public void setView() {
        tv_amount_people.setText(bean.getTotal()); // 邀请的人数
        tv_recommend_my_code.setText("我的推荐码：" + recommendCode);

        StringBuffer randomNum = new StringBuffer();
        for (int i = 0; i < 6; i++) {
            int t = (int) (Math.random() * 10);
            randomNum.append(t);
        }
        Bitmap bitmap = BitmapFactory.decodeResource(this.getResources(), R.mipmap.icon_recommend_code);
        createQRImage(iv_recommend_invite_code, Urls.URL + "register/" + recommendCode + "/recommend", bitmap);
    }

    @Override
    public void onClick(View view) {

        switch (view.getId()) {
            case R.id.btn_recommend: // 推荐App给朋友
                final String shareTitle = getString(R.string.shared_title);
                final String shareText = getString(R.string.shared_message);
                final String shareUrl = Urls.URL + "register/" + recommendCode + "/recommend";

                ShareSDKDialog dialog = new ShareSDKDialog(mContext, new ShareSDKDialog.OnShare() {
                    @Override
                    public void onConfirm(int position) {
                        ShareUtil.sharedSDK(mContext, position,shareTitle, shareText, shareUrl);
                    }

                    @Override
                    public void onCancel() {

                    }
                });
                dialog.show();
                break;
            case R.id.tv_recommend_record: // 邀请记录
                Intent intent = new Intent(this, RecommendRecordActivity.class);
                intent.putExtra("recommendCode", recommendCode);
                startActivity(intent);
                break;

            default:
                break;
        }
    }


    // 要转换的地址或字符串,可以是中文
    public void createQRImage(ImageView img, String url, Bitmap logoBm) {
        try {
            // 判断URL合法性
            if (url == null || "".equals(url) || url.length() < 1) {
                return;
            }
            Hashtable<EncodeHintType, String> hints = new Hashtable<EncodeHintType, String>();
            hints.put(EncodeHintType.CHARACTER_SET, "utf-8");

            // 图像数据转换，使用了矩阵转换
            BitMatrix bitMatrix = new QRCodeWriter().encode(url, BarcodeFormat.QR_CODE, QR_WIDTH, QR_HEIGHT, hints);
//            bitMatrix = deleteWhite(bitMatrix);//删除白边
            bitMatrix = updateBit(bitMatrix, 10);  //生成新的bitMatrix

            QR_WIDTH = bitMatrix.getWidth();
            QR_HEIGHT = bitMatrix.getHeight();

            int[] pixels = new int[QR_WIDTH * QR_HEIGHT];
            // 下面这里按照二维码的算法，逐个生成二维码的图片，
            // 两个for循环是图片横列扫描的结果
            for (int y = 0; y < QR_HEIGHT; y++) {
                for (int x = 0; x < QR_WIDTH; x++) {
                    if (bitMatrix.get(x, y)) {
                        pixels[y * QR_WIDTH + x] = 0xff000000;
                    } else {
                        pixels[y * QR_WIDTH + x] = 0xffffffff;
                    }
                }
            }
            // 生成二维码图片的格式，使用ARGB_8888
            Bitmap bitmap = Bitmap.createBitmap(QR_WIDTH, QR_HEIGHT, Bitmap.Config.ARGB_8888);

            bitmap.setPixels(pixels, 0, QR_WIDTH, 0, 0, QR_WIDTH, QR_HEIGHT);

            if (logoBm != null) {
                bitmap = addLogo(bitmap, logoBm);
            }

            // 显示到一个ImageView上面
            img.setImageBitmap(bitmap);
        } catch (WriterException e) {
            e.printStackTrace();
        }
    }

    private static BitMatrix deleteWhite(BitMatrix matrix) {
        int[] rec = matrix.getEnclosingRectangle();
        int resWidth = rec[2] + 1;
        int resHeight = rec[3] + 1;

        BitMatrix resMatrix = new BitMatrix(resWidth, resHeight);
        resMatrix.clear();
        for (int i = 0; i < resWidth; i++) {
            for (int j = 0; j < resHeight; j++) {
                if (matrix.get(i + rec[0], j + rec[1])) resMatrix.set(i, j);
            }
        }
        return resMatrix;
    }

    private BitMatrix updateBit(BitMatrix matrix, int margin) {
        int tempM = margin * 2;
        int[] rec = matrix.getEnclosingRectangle();  // 获取二维码图案的属性
        int resWidth = rec[2] + tempM;
        int resHeight = rec[3] + tempM;
        BitMatrix resMatrix = new BitMatrix(resWidth, resHeight); // 按照自定义边框生成新的BitMatrix
        resMatrix.clear();

        for (int i = margin; i < resWidth - margin; i++) {  // 循环，将二维码图案绘制到新的bitMatrix中
            for (int j = margin; j < resHeight - margin; j++) {
                if (matrix.get(i - margin + rec[0], j - margin + rec[1])) {
                    resMatrix.set(i, j);
                }
            }
        }
        return resMatrix;
    }

    /**
     * 图片放大缩小
     */

//    public static BufferedImage  zoomInImage(BufferedImage  originalImage, int width, int height){
//        BufferedImage newImage = new BufferedImage(width,height,originalImage.getType());
//        Graphics g = newImage.getGraphics();
//        g.drawImage(originalImage, 0,0,width,height,null);
//        g.dispose();
//        return newImage;
//    }

    /**
     * 在二维码中间添加Logo图案
     */
    private static Bitmap addLogo(Bitmap src, Bitmap logo) {
        if (src == null) {
            return null;
        }

        if (logo == null) {
            return src;
        }

        //获取图片的宽高
        int srcWidth = src.getWidth();
        int srcHeight = src.getHeight();
        int logoWidth = logo.getWidth();
        int logoHeight = logo.getHeight();

        if (srcWidth == 0 || srcHeight == 0) {
            return null;
        }

        if (logoWidth == 0 || logoHeight == 0) {
            return src;
        }

        //logo大小为二维码整体大小的1/5
        float scaleFactor = srcWidth * 1.0f / 7 / logoWidth;
        Bitmap bitmap = Bitmap.createBitmap(srcWidth, srcHeight, Bitmap.Config.ARGB_8888);
        try {
            Canvas canvas = new Canvas(bitmap);
            canvas.drawBitmap(src, 0, 0, null);
            canvas.scale(scaleFactor, scaleFactor, srcWidth / 2, srcHeight / 2);
            canvas.drawBitmap(logo, (srcWidth - logoWidth) / 2, (srcHeight - logoHeight) / 2, null);

            canvas.save(Canvas.ALL_SAVE_FLAG);
            canvas.restore();
        } catch (Exception e) {
            bitmap = null;
            e.getStackTrace();
        }

        return bitmap;
    }


    /**
     * 保存图片的方法 保存到sdcard
     *
     * @throws Exception
     */
//    public static void saveImage(Bitmap bitmap, String imageName) throws Exception {
//        String filePath = isExistsFilePath();
//        FileOutputStream fos = null;
//        File file = new File(filePath, imageName);
//        try {
//            fos = new FileOutputStream(file);
//            if (null != fos) {
//                bitmap.compress(Bitmap.CompressFormat.PNG, 90, fos);
//                fos.flush();
//                fos.close();
//            }
//        } catch (FileNotFoundException e) {
//            e.printStackTrace();
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//    }

    /**
     * 获取sd卡的缓存路径， 一般在卡中sdCard就是这个目录
     *
     * @return SDPath
     */
    public static String getSDPath() {
        File sdDir = null;
        boolean sdCardExist = Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED); // 判断sd卡是否存在
        if (sdCardExist) {
            sdDir = Environment.getExternalStorageDirectory();// 获取根目录
        } else {
            Log.e("ERROR", "没有内存卡");
        }
        return sdDir.toString();
    }

    /**
     * 获取缓存文件夹目录 如果不存在创建 否则则创建文件夹
     *
     * @return filePath
     */
//    private static String isExistsFilePath() {
//        String filePath = getSDPath() + CACHE;
//        File file = new File(filePath);
//        if (!file.exists()) {
//            file.mkdirs();
//        }
//        return filePath;
//    }

//    private Bitmap drawableToBitamp(Drawable drawable) {
//        BitmapDrawable bd = (BitmapDrawable) drawable;
//        return bd.getBitmap();
//    }

}
