package com.rulaibao.fragment;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.activity.LoginActivity;
import com.rulaibao.activity.MyAskActivity;
import com.rulaibao.activity.MyCollectionActivity;
import com.rulaibao.activity.MyCommissionActivity;
import com.rulaibao.activity.MyInfoActivity;
import com.rulaibao.activity.MyPartakeActivity;
import com.rulaibao.activity.MyTopicActivity;
import com.rulaibao.activity.NewsActivity;
import com.rulaibao.activity.PolicyBookingListActivity;
import com.rulaibao.activity.PolicyRecordListActivity;
import com.rulaibao.activity.RenewalReminderActivity;
import com.rulaibao.activity.SettingActivity;
import com.rulaibao.bean.MineData2B;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.uitls.ImageUtils;
import com.rulaibao.uitls.PreferenceUtil;
import com.rulaibao.uitls.StringUtil;
import com.rulaibao.uitls.encrypt.DESUtil;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;

/**
 * “我的”模块
 * Created by junde on 2018/3/26.
 */

public class MineFragment extends Fragment implements View.OnClickListener {

    private View mView;
    private ImageView iv_settings; // icon_mine_setting
    private ImageView iv_news; // icon_mine_news
    private ImageView iv_user_photo; // 用户头像
    private ImageView iv_status; // 认证状态
    private ImageView iv_show_money; // 显示佣金
    private ImageView iv_commission_right_arrow; // 点击跳转到交易记录

    private LinearLayout ll_user_name; // 登录后显示 的布局
    private RelativeLayout rl_total_commission; // 累计佣金布局
    private RelativeLayout rl_my_policy; // 我的保单
    private RelativeLayout rl_renewal_reminder; // 续保提醒
    private RelativeLayout rl_my_bookings; // 我的预约
    private RelativeLayout rl_my_ask; // 我的提问
    private RelativeLayout rl_my_topic; // 我的话题
    private RelativeLayout rl_my_participation; // 我的参与
    private RelativeLayout rl_my_collection; // 我的收藏

    private TextView tv_message_total; // 消息总数
    private TextView tv_user_name; // 用户姓名
    private TextView tv_user_phone; // 用户手机
    private TextView tv_mine_login; // 登录
    private TextView tv_total_commission; // 累计佣金
    private TextView tv_check_pending; // 待审核
    private TextView tv_underwriting; // 已承保
    private TextView tv_problem_parts; // 问题件
    private TextView tv_return_receipt; // 回执签收
    private TextView tv_renewal_numbers; // 续保提醒 数量
    private Context context;
    private String userId = ""; // 测试userId 18032709463185347077
    private MineData2B data;
    private int messageTotal;

    private final static String IMG_PATH = Environment.getExternalStorageDirectory() + "/rlb/imgs/";  // 图片保存SD卡位置
    private int insuranceWarning;
    private String totalCommission;


    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            if (context != null) {
                if (!PreferenceUtil.isLogin()) { // 未登录 状态
                    tv_mine_login.setVisibility(View.VISIBLE);
                    ll_user_name.setVisibility(View.GONE);
                    rl_total_commission.setVisibility(View.GONE);
                    iv_user_photo.setImageResource(R.mipmap.icon_user_photo);

                    // 未登录时，消息数和续保消息数都不可见
                    tv_message_total.setVisibility(View.GONE);
                    tv_renewal_numbers.setVisibility(View.GONE);
                } else { // 已登录 状态
                    ll_user_name.setVisibility(View.VISIBLE);
                    rl_total_commission.setVisibility(View.VISIBLE);
                    tv_mine_login.setVisibility(View.GONE);
                    requestData();
                    isShowTotalCommission();

                }
            }

        }
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        this.context = context;
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        if (mView == null) {
            mView = inflater.inflate(R.layout.fragment_mine, container, false);
            try {
                initView(mView);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            if (mView.getParent() != null) {
                ((ViewGroup) mView.getParent()).removeView(mView);
            }
        }

        return mView;
    }

    private void initView(View mView) {
        iv_settings = (ImageView) mView.findViewById(R.id.iv_settings);
        iv_news = (ImageView) mView.findViewById(R.id.iv_news);
        iv_user_photo = (ImageView) mView.findViewById(R.id.iv_user_photo);
        iv_status = (ImageView) mView.findViewById(R.id.iv_status);
        iv_show_money = (ImageView) mView.findViewById(R.id.iv_show_money);
        iv_commission_right_arrow = (ImageView) mView.findViewById(R.id.iv_commission_right_arrow);

        ll_user_name = (LinearLayout) mView.findViewById(R.id.ll_user_name);
        rl_total_commission = (RelativeLayout) mView.findViewById(R.id.rl_total_commission);
        rl_my_policy = (RelativeLayout) mView.findViewById(R.id.rl_my_policy);
        rl_renewal_reminder = (RelativeLayout) mView.findViewById(R.id.rl_renewal_reminder);
        rl_my_bookings = (RelativeLayout) mView.findViewById(R.id.rl_my_bookings);
        rl_my_ask = (RelativeLayout) mView.findViewById(R.id.rl_my_ask);
        rl_my_topic = (RelativeLayout) mView.findViewById(R.id.rl_my_topic);
        rl_my_participation = (RelativeLayout) mView.findViewById(R.id.rl_my_participation);
        rl_my_collection = (RelativeLayout) mView.findViewById(R.id.rl_my_collection);

        tv_message_total = (TextView) mView.findViewById(R.id.tv_message_total);
        tv_user_name = (TextView) mView.findViewById(R.id.tv_user_name);
        tv_user_phone = (TextView) mView.findViewById(R.id.tv_user_phone);
        tv_mine_login = (TextView) mView.findViewById(R.id.tv_mine_login);
        tv_total_commission = (TextView) mView.findViewById(R.id.tv_total_commission);
        tv_renewal_numbers = (TextView) mView.findViewById(R.id.tv_renewal_numbers);
        tv_check_pending = (TextView) mView.findViewById(R.id.tv_check_pending);
        tv_underwriting = (TextView) mView.findViewById(R.id.tv_underwriting);
        tv_problem_parts = (TextView) mView.findViewById(R.id.tv_problem_parts);
        tv_return_receipt = (TextView) mView.findViewById(R.id.tv_return_receipt);

        iv_settings.setOnClickListener(this); // icon_mine_setting
        iv_news.setOnClickListener(this); // icon_mine_news

        tv_mine_login.setOnClickListener(this); // 登录
        iv_user_photo.setOnClickListener(this);  // 用户头像
        iv_show_money.setOnClickListener(this);
        iv_commission_right_arrow.setOnClickListener(this);  // 累计佣金
        rl_my_policy.setOnClickListener(this); // 我的保单

        tv_check_pending.setOnClickListener(this); // 待审核
        tv_underwriting.setOnClickListener(this); // 已承保
        tv_problem_parts.setOnClickListener(this); // 问题件
        tv_return_receipt.setOnClickListener(this); // 回执签收

        rl_renewal_reminder.setOnClickListener(this); // 续保提醒
        rl_my_bookings.setOnClickListener(this); // 我的预约
        rl_my_ask.setOnClickListener(this); // 我的提问
        rl_my_topic.setOnClickListener(this); // 我的话题
        rl_my_participation.setOnClickListener(this); // 我的参与
        rl_my_collection.setOnClickListener(this); // 我的收藏

    }

    @Override
    public void onResume() {
        super.onResume();

        if (!PreferenceUtil.isLogin()) { // 未登录 状态
            tv_mine_login.setVisibility(View.VISIBLE);
            ll_user_name.setVisibility(View.GONE);
            rl_total_commission.setVisibility(View.GONE);
            iv_user_photo.setImageResource(R.mipmap.icon_user_photo);

            // 未登录时，消息数和续保消息数都不可见
            tv_message_total.setVisibility(View.GONE);
            tv_renewal_numbers.setVisibility(View.GONE);
        } else { // 已登录 状态
            ll_user_name.setVisibility(View.VISIBLE);
            rl_total_commission.setVisibility(View.VISIBLE);
            tv_mine_login.setVisibility(View.GONE);
            requestData();
            isShowTotalCommission();

        }
    }

    /**
     *  设置 佣金的显示与隐藏
     */
    private void isShowTotalCommission() {
        if (PreferenceUtil.isShowMyCommission()) {
            iv_show_money.setImageResource(R.mipmap.icon_open_password);
            if (!TextUtils.isEmpty(totalCommission)) {
                tv_total_commission.setText(totalCommission);
            }
        } else {
            iv_show_money.setImageResource(R.mipmap.icon_hide_password);
            tv_total_commission.setText("****");
        }
    }


    //我的主页面数据
    public void requestData() {

        try {
//            checkStatus = DESUtil.decrypt(PreferenceUtil.getCheckStatus());
            userId = DESUtil.decrypt(PreferenceUtil.getUserId());
//            Log.i("hh", "当前登录用户的userId --- " + userId);

        } catch (Exception e) {
            e.printStackTrace();
        }

        HashMap<String, Object> param = new HashMap<>();
        param.put("userId", userId);

        HtmlRequest.getMineData(context, param, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {
                if (params == null || params.result == null) {
                    //        Toast.makeText(context, "加载失败，请确认网络通畅", Toast.LENGTH_LONG).show();
                    return;
                }
                data = (MineData2B) params.result;

                // 认证成功后就有用户身份证号了，所以进入到我的页面时就要把认证状态和身份证号都保存到sp,后面跳新增银行卡页面时要用身份证号
                if (!TextUtils.isEmpty(data.getCheckStatus())) {
                    try {
                        PreferenceUtil.setCheckStatus(data.getCheckStatus());
//                        Log.i("hh"," 认证状态: checkStatus = " + data.getCheckStatus());
                        PreferenceUtil.setIdNo(DESUtil.encrypt(data.getIdNo()));
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                if (data != null) {
                    setData(data);
                }
            }
        });
    }

    private void setData(MineData2B data) {
        // 获取消息总数
        if (data.getMessageTotal() != null) {
            messageTotal = Integer.parseInt(data.getMessageTotal());
        }
        if (messageTotal > 9) {
            tv_message_total.setVisibility(View.VISIBLE);
            tv_message_total.setText("9+");
            tv_message_total.setTextSize(10f);
        } else {
            if (messageTotal == 0) {
                tv_message_total.setVisibility(View.GONE);
            } else {
                tv_message_total.setVisibility(View.VISIBLE);
                tv_message_total.setText(data.getMessageTotal());
            }
        }
        // 获取续保提醒总数
        if (data.getInsuranceWarning() != null) {
            insuranceWarning = Integer.parseInt(data.getInsuranceWarning());
        }
        if (insuranceWarning > 9) {
            tv_renewal_numbers.setVisibility(View.VISIBLE);
            tv_renewal_numbers.setText("9+");
            tv_renewal_numbers.setTextSize(10f);
        } else {
            if (insuranceWarning == 0) {
                tv_renewal_numbers.setVisibility(View.GONE);
            } else {
                tv_renewal_numbers.setVisibility(View.VISIBLE);
                tv_renewal_numbers.setText(data.getInsuranceWarning());
            }
        }

        // 获取用户姓名、手机号、佣金总额
        tv_user_name.setText(data.getRealName());
        tv_user_phone.setText(StringUtil.replaceSubString(data.getMobile()));

        totalCommission = data.getTotalCommission();
        isShowTotalCommission();

        String url = data.getHeadPhoto();
        if (!TextUtils.isEmpty(url)) {
            new ImageViewService().execute(url);
        } else {
            iv_user_photo.setImageDrawable(getResources().getDrawable(R.mipmap.icon_user_photo));
        }

        // 判断用户是否认证
        String status = data.getCheckStatus();
        if ("success".equals(status)) {
            iv_status.setImageResource(R.mipmap.icon_certified);
        } else {
            iv_status.setImageResource(R.mipmap.icon_uncertified);
        }
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
                iv_user_photo.setImageBitmap(result);
                saveBitmap(result);
            } else {
                iv_user_photo.setImageDrawable(getResources().getDrawable(R.mipmap.icon_user_photo));
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

    private Uri saveBitmap(Bitmap bm) {
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

    @Override
    public void onClick(View v) {
        Intent intent;
        switch (v.getId()) {
            case R.id.iv_settings:  // 设置
                intent = new Intent(context, SettingActivity.class);
                startActivity(intent);
                break;
            case R.id.iv_news:  // 消息
                toWhichActivity(NewsActivity.class);
                break;
            case R.id.iv_user_photo: // 用户头像（跳转到个人信息页）
                toWhichActivity(MyInfoActivity.class);
                break;
            case R.id.iv_show_money: // 显示佣金金额
                if (PreferenceUtil.isShowMyCommission()) {
                    iv_show_money.setImageResource(R.mipmap.icon_hide_password);
                    tv_total_commission.setText("****");
                    PreferenceUtil.setShowMyCommission(false);
                } else {
                    iv_show_money.setImageResource(R.mipmap.icon_open_password);
                    PreferenceUtil.setShowMyCommission(true);
                    if (!TextUtils.isEmpty(totalCommission)) {
                        tv_total_commission.setText(totalCommission);
                    }
                }

                break;
            case R.id.iv_commission_right_arrow: // 点累计佣金跳转到交易记录页
//                intent = new Intent(context, TransactionRecordActivity.class);
//                intent.putExtra("totalCommission", data.getTotalCommission());
//                startActivity(intent);
                // 新需求是跳转到我的佣金页面
                intent = new Intent(context, MyCommissionActivity.class);
                startActivity(intent);
                break;
            case R.id.tv_mine_login: // 登录
                intent = new Intent(context, LoginActivity.class);
                startActivity(intent);
                break;
            case R.id.rl_my_policy: // 我的保单
                toWhichActivity(PolicyRecordListActivity.class);

                break;
            case R.id.tv_check_pending: // 待审核
                needPositionToWhichActivity(PolicyRecordListActivity.class, 1);

                break;
            case R.id.tv_underwriting: // 已承保
                needPositionToWhichActivity(PolicyRecordListActivity.class, 2);
                break;
            case R.id.tv_problem_parts: // 问题件
                needPositionToWhichActivity(PolicyRecordListActivity.class, 3);
                break;
            case R.id.tv_return_receipt: // 回执签收
                needPositionToWhichActivity(PolicyRecordListActivity.class, 4);
                break;
            case R.id.rl_renewal_reminder: // 续保提醒
                toWhichActivity(RenewalReminderActivity.class);
                break;
            case R.id.rl_my_bookings: // 我的预约
                toWhichActivity(PolicyBookingListActivity.class);
                break;
            case R.id.rl_my_ask: // 我的提问
                toWhichActivity(MyAskActivity.class);
                break;
            case R.id.rl_my_topic: // 我的话题
                toWhichActivity(MyTopicActivity.class);
                break;
            case R.id.rl_my_participation: // 我参与的
                toWhichActivity(MyPartakeActivity.class);
                break;
            case R.id.rl_my_collection: // 我的收藏
                toWhichActivity(MyCollectionActivity.class);

                break;
        }
    }

    /**
     * 未登录时跳转页面调此方法
     *
     * @param cls
     */
    private void toWhichActivity(Class cls) {
        Intent intent;
        if (PreferenceUtil.isLogin()) {
            intent = new Intent(context, cls);
            startActivity(intent);
        } else {
            Toast.makeText(context, "您还没登录，请先登录", Toast.LENGTH_LONG).show();
            intent = new Intent(context, LoginActivity.class);
            startActivity(intent);
        }
    }

    /**
     * 未登录时，跳转需要传位置时调此方法
     *
     * @param cls
     * @param pos
     */
    private void needPositionToWhichActivity(Class cls, int pos) {
        Intent intent;
        if (PreferenceUtil.isLogin()) {
            intent = new Intent(context, cls);
            intent.putExtra("position", pos);
            startActivity(intent);
        } else {
            Toast.makeText(context, "您还没登录，请先登录", Toast.LENGTH_LONG).show();
            intent = new Intent(context, LoginActivity.class);
            startActivity(intent);
        }
    }

}
