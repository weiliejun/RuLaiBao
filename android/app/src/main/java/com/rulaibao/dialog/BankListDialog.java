package com.rulaibao.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager.LayoutParams;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.adapter.AbstractWheelTextAdapter;
import com.rulaibao.widget.OnWheelChangedListener;
import com.rulaibao.widget.OnWheelScrollListener;
import com.rulaibao.widget.WheelView;

import java.util.ArrayList;

/**
 * 银行列表 对话框
 */
public class BankListDialog extends Dialog implements DialogInterface.OnCancelListener, DialogInterface.OnDismissListener {

    private Context mContext;
    private LayoutParams lp;
    private int percentageH = 4;
    private int percentageW = 8;
    private TextView txtConfirm = null;
    private TextView txtCancel = null;
//    private String info = null;
    private TextView txtInfo = null;
    private RelativeLayout rl_cancel;

    private ArrayList<String> bankList = new ArrayList<String>();

    ArrayList<OnCancelListener> m_arrCancelListeners = new ArrayList<OnCancelListener>();
    ArrayList<OnDismissListener> m_arrDismissListeners = new ArrayList<OnDismissListener>();
    private IsCancel onChanged = null;
    private String strConfirm = "确定";
    private WheelView mDateWheelView;
    private BankListAdapter bankListAdapter;
    private String bankChoose;

    public BankListDialog(Context context, IsCancel onChanged) {
        super(context, R.style.Dialog);
        this.mContext = context;
        this.onChanged = onChanged;

        LayoutInflater inflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View mView = inflater.inflate(R.layout.dialog_bank_choose, null);
        setContentView(mView);
        // 设置window属性
        lp = getWindow().getAttributes();
        lp.gravity = Gravity.CENTER;
        lp.dimAmount = 0.6f; // 去背景遮盖
        lp.alpha = 1.0f;
        int[] wh = initWithScreenWidthAndHeight(mContext);
        lp.width = wh[0] - wh[0] / percentageW;
        lp.height = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
        getWindow().setAttributes(lp);
        setCanceledOnTouchOutside(false);
        setOnDismissListener(this);
        setOnCancelListener(this);
        initView(mView);
    }

    public BankListDialog(Context context, IsCancel onChanged, String strConfirm) {
        super(context, R.style.Dialog);
        this.strConfirm = strConfirm;
        this.mContext = context;
        this.onChanged = onChanged;

        LayoutInflater inflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View mView = inflater.inflate(R.layout.dialog_cancel_normal, null);
        setContentView(mView);
        // 设置window属性
        lp = getWindow().getAttributes();
        lp.gravity = Gravity.CENTER;
        lp.dimAmount = 0.6f; // 去背景遮盖
        lp.alpha = 1.0f;
        int[] wh = initWithScreenWidthAndHeight(mContext);
        lp.width = wh[0] - wh[0] / percentageW;
        lp.height = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
        getWindow().setAttributes(lp);
        setCanceledOnTouchOutside(false);
        setOnDismissListener(this);
        setOnCancelListener(this);
        initView(mView);
        initData();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    private void initView(View mView) {
        mDateWheelView = (WheelView) mView.findViewById(R.id.date_wv);
        txtConfirm = (TextView) mView.findViewById(R.id.dialog_btn_confirm);
        txtCancel = (TextView) mView.findViewById(R.id.dialog_btn_cancel);
        txtInfo = (TextView) mView.findViewById(R.id.dialog_btn_info);

        rl_cancel = (RelativeLayout) mView.findViewById(R.id.rl_cancel);

        txtConfirm.setText(strConfirm);
//        txtInfo.setText(info);
        txtConfirm.setOnClickListener(confirmListener);
        txtCancel.setOnClickListener(cancelListener);
//        if (!TextUtils.isEmpty(forcedUpgrade)) {
//            if (forcedUpgrade.equals("false")) {
//                rl_check_version_cancel.setVisibility(View.VISIBLE);
//            } else if (forcedUpgrade.equals("true")) {
//                rl_check_version_cancel.setVisibility(View.GONE);
//            } else {
//                rl_check_version_cancel.setVisibility(View.VISIBLE);
//            }
//        } else {
//            rl_check_version_cancel.setVisibility(View.VISIBLE);
//        }

    }

    private void initData() {
        initBankList();
        initListener();
    }
    private void initBankList() {
        bankList.add("中国银行");
        bankList.add("农业银行");
        bankList.add("工商银行");
        bankList.add("建设银行");
        bankList.add("交通银行");
        bankList.add("招商银行");
        bankList.add("广发银行");
        bankList.add("华夏银行");
        bankList.add("浦发银行");

        bankListAdapter = new BankListAdapter(mContext, bankList, 0, 18, 16);
        mDateWheelView.setVisibleItems(5);
        mDateWheelView.setViewAdapter(bankListAdapter);
        mDateWheelView.setCurrentItem(0);

        bankChoose = bankList.get(0);
        setTextViewStyle(bankChoose, bankListAdapter);
    }

    private void initListener() {

        //日期********************
        mDateWheelView.addChangingListener(new OnWheelChangedListener() {

            @Override
            public void onChanged(WheelView wheel, int oldValue, int newValue) {
                String currentText = (String) bankListAdapter.getItemText(wheel.getCurrentItem());
                setTextViewStyle(currentText, bankListAdapter);
                bankChoose = bankList.get(wheel.getCurrentItem());
            }
        });

        mDateWheelView.addScrollingListener(new OnWheelScrollListener() {

            @Override
            public void onScrollingStarted(WheelView wheel) {

            }

            @Override
            public void onScrollingFinished(WheelView wheel) {
                String currentText = (String) bankListAdapter.getItemText(wheel.getCurrentItem());
                setTextViewStyle(currentText, bankListAdapter);
            }
        });
    }

    public void setTextViewStyle(String currentItemText, BankListAdapter adapter) {
        ArrayList<View> arrayList = adapter.getTestViews();
        int size = arrayList.size();
        String currentText;
        for (int i = 0; i < size; i++) {
            TextView textView = (TextView) arrayList.get(i);
            currentText = textView.getText().toString();
            if (currentItemText.equals(currentText)) {
                textView.setTextSize(18);
                //已修改 滚动时修改文字颜色
//                textView.setTextColor(mContext.getResources().getColor(R.color.text_10));
            } else {
                textView.setTextSize(16);
                //已修改 滚动时修改文字颜色
//                textView.setTextColor(mContext.getResources().getColor(R.color.text_11));
            }
        }
    }

    public void setTitle(String title) {
        txtInfo.setText(title);
    }

    private View.OnClickListener confirmListener = new View.OnClickListener() {

        @Override
        public void onClick(View v) {
            onChanged.onConfirm();
            onDismiss();
        }

    };

    private View.OnClickListener cancelListener = new View.OnClickListener() {

        @Override
        public void onClick(View v) {
            onDismiss();
        }
    };

    private void ondismiss() {
    }

    private class BankListAdapter extends AbstractWheelTextAdapter {
        ArrayList<String> list;

        protected BankListAdapter(Context context, ArrayList<String> list, int currentItem, int maxsize, int minsize) {
            super(context, R.layout.item_textview, R.id.tv_temp, currentItem, maxsize, minsize);
            this.list = list;
        }

        @Override
        public View getItem(int index, View cachedView, ViewGroup parent) {
            View view = super.getItem(index, cachedView, parent);
            return view;
        }

        @Override
        public int getItemsCount() {
            return list.size();
        }

        @Override
        protected CharSequence getItemText(int index) {
            String str = list.get(index) + "";
            return str;
        }
    }

    @Override
    public void onDismiss(DialogInterface dialog) {
        if (m_arrDismissListeners != null) {
            for (int x = 0; x < m_arrDismissListeners.size(); x++)
                m_arrDismissListeners.get(x).onDismiss(dialog);
        }
        ondismiss();
    }

    @Override
    public void onCancel(DialogInterface dialog) {
        if (m_arrCancelListeners != null) {
            for (int x = 0; x < m_arrDismissListeners.size(); x++)
                m_arrCancelListeners.get(x).onCancel(dialog);
        }
    }

    public void addListeners(OnCancelListener c, OnDismissListener d) {
        m_arrDismissListeners.add(d);
        m_arrCancelListeners.add(c);
    }

    public void removeListeners(OnCancelListener c, OnDismissListener d) {
        m_arrDismissListeners.remove(d);
        m_arrCancelListeners.remove(c);
    }

    private void onDismiss() {
        if (this.isShowing()) {
            this.dismiss();
        }

    }

    /**
     * 获取当前window width,height
     *
     * @param context
     * @return
     */
    private static int[] initWithScreenWidthAndHeight(Context context) {
        int[] wh = new int[2];
        DisplayMetrics dm = new DisplayMetrics();
        ((Activity) context).getWindowManager().getDefaultDisplay().getMetrics(dm);
        wh[0] = dm.widthPixels;
        wh[1] = dm.heightPixels;
        return wh;
    }

    public interface IsCancel {
        public void onConfirm();

        public void onCancel();

    }

}