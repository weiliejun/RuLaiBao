package com.rulaibao.activity;

import android.Manifest;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Environment;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.ResultCheckVersionContentBean;
import com.rulaibao.common.MyApplication;
import com.rulaibao.dialog.CheckVersionDialog;
import com.rulaibao.fragment.HomeFragment;
import com.rulaibao.fragment.MineFragment;
import com.rulaibao.fragment.PolicyPlanFragment;
import com.rulaibao.fragment.TrainingFragment;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.service.AppUpgradeService;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.RlbActivityManager;
import com.rulaibao.uitls.SystemInfo;
import com.rulaibao.widget.TitleBar;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

import pub.devrel.easypermissions.EasyPermissions;

import static com.rulaibao.activity.RecommendActivity.getSDPath;

public class MainActivity extends BaseActivity implements View.OnClickListener{
    private ViewPager mViewPager;
    private FragmentPagerAdapter mAdapter;
    private TitleBar title;

    private LinearLayout ll_tab_home;    // 首页
    private LinearLayout ll_tab_training;    // 研修
    private LinearLayout ll_tab_plan;    // 规划
    private LinearLayout ll_tab_mine; // 我的

    private ImageView iv_home;
    private ImageView iv_training;
    private ImageView iv_plan;
    private ImageView iv_mine;

    private TextView tv_home;
    private TextView tv_training;
    private TextView tv_plan;
    private TextView tv_mine;

    private HomeFragment tab_home; //首页
    private TrainingFragment tab_training; // 研修
    private PolicyPlanFragment tab_plan; // 规划
    private MineFragment tab_mine; // 我的
    private List<Fragment> mFragments;

    private int selectPage;

    private String type = "";  // answer：回答问题详情页  question：问题详情;  course:课程详情;  product:产品详情
    private String id = "";  //
    private String questionId = "";  // 问题id
    private String answerId = "";   // 回答id
    private String speechmakeId = "";  // 演讲id

    private File destDir = null;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_main);

        getQuestionsAndAnswersId();
        getPermissions();

        initTopTitle();
        initView();
        initVP();
        setSelect(selectPage);
        initData();
    }

    /**
     *  获取 页面需要的一些Id
     */
    private void getQuestionsAndAnswersId() {
        Intent intent = getIntent();
        Uri uri = intent.getData();
        if (uri != null) {
            type = uri.getQueryParameter("type");
            id = uri.getQueryParameter("id");
            questionId = uri.getQueryParameter("questionId");
            answerId = uri.getQueryParameter("answerId");
            speechmakeId = uri.getQueryParameter("speechmakeId");
        }

        // 根据type 打开不同的H5 页面
        if (!TextUtils.isEmpty(type)) {
            openH5();
        }
    }

    public void openH5() {
        if (type.equals("answer")) { // 回答问题详情页
            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("questionId", questionId);
            map.put("answerId", answerId);
            RlbActivityManager.toTrainingAnswerDetailsActivity(this, map, false);
        } else if (type.equals("question")) {  // 问题详情
            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("questionId", id);
            RlbActivityManager.toTrainingAskDetailsActivity(this, map, false);
        } else if (type.equals("course")) { // 课程详情
            HashMap<String, Object> classMap = new HashMap<>();
            classMap.put("id", id);
            classMap.put("speechmakeId", speechmakeId);
            classMap.put("courseId", id);
            RlbActivityManager.toTrainingClassDetailsActivity(this, classMap, false);
        } else if (type.equals("product")) {  // 产品详情
            Intent intent = new Intent(this, InsuranceProductDetailActivity.class);
            intent.putExtra("id", id);
            startActivity(intent);
        } else if (type.equals("topic")) {  // 话题详情

            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("appTopicId", id);
            RlbActivityManager.toTrainingTopicDetailsActivity(this, map, false);
        }
    }

    protected void getPermissions() {
        try {
            String[] perms = new String[]{Manifest.permission.READ_EXTERNAL_STORAGE,
                    Manifest.permission.WRITE_EXTERNAL_STORAGE,Manifest.permission.CAMERA};

            if (!EasyPermissions.hasPermissions(this, perms)) {
                EasyPermissions.requestPermissions(this, "需要访问手机存储权限！", 10086, perms);
            } else {
                saveImage(drawableToBitamp(getResources().getDrawable(R.mipmap.logo)), "rulaibao.png");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 保存图片的方法 保存到sdcard
     * @throws Exception
     */
    public static void saveImage(Bitmap bitmap, String imageName) throws Exception {
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
     * @return filePath
     */

    private final static String CACHE = "/rulaibao/imgs";

    private static String isExistsFilePath() {
        String filePath = getSDPath() + CACHE;
        File file = new File(filePath);
        if (!file.exists()) {
            file.mkdirs();
        }
        return filePath;
    }

    private Bitmap drawableToBitamp(Drawable drawable) {
        BitmapDrawable bd = (BitmapDrawable) drawable;
        return bd.getBitmap();
    }


    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        if (intent != null) {
            selectPage = getIntent().getIntExtra("selectIndex", 0);
            setSelect(selectPage);

//            Intent i_h5 = getIntent();
            Uri uri = intent.getData();
            if (uri != null) {
                type = uri.getQueryParameter("type");
                id = uri.getQueryParameter("id");
                questionId = uri.getQueryParameter("questionId");
                answerId = uri.getQueryParameter("answerId");
                speechmakeId = uri.getQueryParameter("speechmakeId");
            }

            if (!TextUtils.isEmpty(type)) {
                openH5();
            }
        }
    }

    public void initTopTitle() {
        title = (TitleBar) findViewById(R.id.rl_title);
        title.setVisibility(View.GONE);
    }

    private void initView() {
        selectPage = getIntent().getIntExtra("selectIndex", 0);

        mViewPager = (ViewPager) findViewById(R.id.main_viewpager);
        ll_tab_home = (LinearLayout) findViewById(R.id.ll_tab_home);
        ll_tab_training = (LinearLayout) findViewById(R.id.ll_tab_training);
        ll_tab_plan = (LinearLayout) findViewById(R.id.ll_tab_plan);
        ll_tab_mine = (LinearLayout) findViewById(R.id.ll_tab_mine);

        iv_home = (ImageView) findViewById(R.id.iv_home);
        iv_training = (ImageView) findViewById(R.id.iv_training);
        iv_plan = (ImageView) findViewById(R.id.iv_plan);
        iv_mine = (ImageView) findViewById(R.id.iv_mine);

        tv_home = (TextView) findViewById(R.id.tv_home);
        tv_training = (TextView) findViewById(R.id.tv_training);
        tv_plan = (TextView) findViewById(R.id.tv_plan);
        tv_mine = (TextView) findViewById(R.id.tv_mine);

        ll_tab_home.setOnClickListener(this);
        ll_tab_training.setOnClickListener(this);
        ll_tab_plan.setOnClickListener(this);
        ll_tab_mine.setOnClickListener(this);
    }

    private void initVP() {
        mFragments = new ArrayList<>();
        tab_home = new HomeFragment();
        tab_training = new TrainingFragment();
        tab_plan = new PolicyPlanFragment();
        tab_mine = new MineFragment();

        mFragments.add(tab_home);
        mFragments.add(tab_training);
        mFragments.add(tab_plan);
        mFragments.add(tab_mine);

        mAdapter = new FragmentPagerAdapter(getSupportFragmentManager()) {
            @Override
            public int getCount() {
                return mFragments.size();
            }

            @Override
            public Fragment getItem(int position) {
                return mFragments.get(position);
            }
        };

        mViewPager.setAdapter(mAdapter);

        mViewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int i, float v, int i1) {
            }

            @Override
            public void onPageSelected(int i) {
                int currentItem = mViewPager.getCurrentItem();
                setTab(currentItem);
            }

            @Override
            public void onPageScrollStateChanged(int i) {
            }
        });
    }

    public void setSelect(int i) {
        if (PreferenceUtil.isLogin()) {
//            Log.i("hh", this + "判断当前用户是否登录：" + PreferenceUtil.isLogin());
            if (i == 3) {
                tab_mine.requestData();
            }
            if (i==0){
                tab_home.requestAppData();
            }
        }
        setTab(i);
        mViewPager.setCurrentItem(i);
    }

    public void initData() {
        requestData(); //检查版本更新
    }

    private void setTab(int pos) {
        resetTvs();
        resetImages();

        switch (pos) {
            case 0:
                tv_home.setTextColor(getResources().getColor(R.color.main_color_yellow));
                iv_home.setImageResource(R.mipmap.bg_home_pressed);
                break;
            case 1:
                tv_training.setTextColor(getResources().getColor(R.color.main_color_yellow));
                iv_training.setImageResource(R.mipmap.bg_training_pressed);
                break;
            case 2:
                tv_plan.setTextColor(getResources().getColor(R.color.main_color_yellow));
                iv_plan.setImageResource(R.mipmap.bg_plan_pressed);
                break;
            case 3:
                tv_mine.setTextColor(getResources().getColor(R.color.main_color_yellow));
                iv_mine.setImageResource(R.mipmap.bg_mine_pressed);
                break;

        }
    }

    // 改变底部tab文字颜色
    private void resetTvs() {
        tv_home.setTextColor(Color.parseColor("#999999"));
        tv_training.setTextColor(Color.parseColor("#999999"));
        tv_plan.setTextColor(Color.parseColor("#999999"));
        tv_mine.setTextColor(Color.parseColor("#999999"));
    }

    // 给底部tab设置 未选中时的背景图片
    private void resetImages() {
        iv_home.setImageResource(R.mipmap.bg_home_normal);
        iv_training.setImageResource(R.mipmap.bg_training_normal);
        iv_plan.setImageResource(R.mipmap.bg_plan_normal);
        iv_mine.setImageResource(R.mipmap.bg_mine_normal);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ll_tab_home:  // 首页
                setSelect(0);
                break;
            case R.id.ll_tab_training:  // 研修
                setSelect(1);
                break;
            case R.id.ll_tab_plan:  // 规划
                setSelect(2);
                break;
            case R.id.ll_tab_mine:  // 我的
//                PreferenceUtil.setLogin(true);
//                if (PreferenceUtil.isLogin()) {
                setSelect(3);
//                } else {
//                    Intent i_login = new Intent(this, LoginActivity.class);
//                    startActivity(i_login);

//                }

                break;

        }
    }

    private long lastTime;

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            exitBy2Click();
        }
        return false;
    }

    // 双击退出函数
    private void exitBy2Click() {
        long currentTime = System.currentTimeMillis();
        if (currentTime - lastTime < 2000) {
            finish();
        } else {
            Toast.makeText(this, "再按一次退出程序", Toast.LENGTH_SHORT).show();
            lastTime = currentTime;
        }
    }

    //检查版本更新
    private void requestData() {
        LinkedHashMap<String, Object> param = new LinkedHashMap<>();
        param.put("type", "android");
        HtmlRequest.checkVersion(this, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params.result != null) {
                    final ResultCheckVersionContentBean b = (ResultCheckVersionContentBean) params.result;
                    if (!TextUtils.isEmpty(b.getVersion())) {
                        if (!b.getVersion().equals(SystemInfo.sVersionName)) {
//                            String[] perms = new String[]{Manifest.permission.READ_EXTERNAL_STORAGE,
//                                    Manifest.permission.WRITE_EXTERNAL_STORAGE};
//
//                            if (!EasyPermissions.hasPermissions(mContext, perms)) {
//                                EasyPermissions.requestPermissions(mContext, "需要访问手机存储权限！", 10086, perms);
//                            }
                            showDialog(b);
                        } else {
                            if (Environment.getExternalStorageState().equals(android.os.Environment.MEDIA_MOUNTED)) {
                                if (destDir == null) {
                                    destDir = new File(Environment.getExternalStorageDirectory().getPath() + MyApplication.mDownloadPath);
                                }
                            }
                        }

                    }

                }
            }
        });
    }

    public void showDialog(final ResultCheckVersionContentBean b){

        CheckVersionDialog dialog = new CheckVersionDialog(MainActivity.this, new CheckVersionDialog.OnCheckVersion() {
            @Override
            public void onConfim() {
                Intent updateIntent = new Intent(MainActivity.this, AppUpgradeService.class);
                updateIntent.putExtra("titleId", R.string.app_chinesename);
                updateIntent.putExtra("downloadUrl", b.getUrl());
                MainActivity.this.startService(updateIntent);
            }

            @Override
            public void onCancel() {
            }
        }, "发现新版本,是否更新", "false");
        dialog.setCancelable(false);
        dialog.show();


    }



}
