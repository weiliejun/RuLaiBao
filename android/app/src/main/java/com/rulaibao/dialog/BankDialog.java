package com.rulaibao.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Looper;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.widget.bankwheel.OnWheelChangedListener;
import com.rulaibao.widget.bankwheel.OnWheelScrollListener;
import com.rulaibao.widget.bankwheel.WheelView;
import com.rulaibao.widget.bankwheel.adapters.AbstractWheelTextAdapter;

import java.util.ArrayList;

public class BankDialog extends Dialog implements View.OnClickListener {
    //控件
    private WheelView mWheelView;
    private CalendarTextAdapter mAdapter;
    private TextView tv_sure;
    private TextView tv_cancel;

    private ArrayList<String> banks = new ArrayList<String>();
    private String mSelectedBank;

    private Context mContext;
    private BankChooseInterface bankChooseInterface;

    public BankDialog(Context context, BankChooseInterface dateChooseInterface) {
        super(context, R.style.BottomDialogStyle);
        this.mContext = context;
        this.bankChooseInterface = dateChooseInterface;

        initLocation();
        initView();
        initData();
    }

    private void initLocation() {
        Window window = getWindow();
        window.getDecorView().setPadding(0, 0, 0, 0);
        WindowManager.LayoutParams attributes = window.getAttributes();
        attributes.width = WindowManager.LayoutParams.MATCH_PARENT;
        attributes.gravity = Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL;
        window.setAttributes(attributes);
    }

    private void initView() {
        View view = LayoutInflater.from(mContext).inflate(R.layout.dialog_bank_choose, null);
        setContentView(view);
        mWheelView = (WheelView) view.findViewById(R.id.date_wv);
        tv_sure = (TextView) view.findViewById(R.id.tv_sure);
        tv_cancel = (TextView) view.findViewById(R.id.tv_cancel);

        tv_sure.setOnClickListener(this);
        tv_cancel.setOnClickListener(this);
    }

    private void initData() {
        initDate();
        initListener();
    }

    private void initListener() {
        mWheelView.addChangingListener(new OnWheelChangedListener() {

            @Override
            public void onChanged(WheelView wheel, int oldValue, int newValue) {
                String currentText = (String) mAdapter.getItemText(wheel.getCurrentItem());
                setTextViewStyle(currentText, mAdapter);
                mSelectedBank = banks.get(wheel.getCurrentItem());
            }
        });

        mWheelView.addScrollingListener(new OnWheelScrollListener() {

            @Override
            public void onScrollingStarted(WheelView wheel) {

            }

            @Override
            public void onScrollingFinished(WheelView wheel) {
                String currentText = (String) mAdapter.getItemText(wheel.getCurrentItem());
                setTextViewStyle(currentText, mAdapter);
            }
        });
    }

    private void initDate() {
        banks.add("中国银行");
        banks.add("农业银行");
        banks.add("工商银行");
        banks.add("建设银行");
        banks.add("交通银行");
        banks.add("招商银行");
        banks.add("广发银行");
        banks.add("华夏银行");
        banks.add("浦发银行");
        mAdapter = new CalendarTextAdapter(mContext, banks, 0, 18, 16);
        mWheelView.setVisibleItems(5);
        mWheelView.setViewAdapter(mAdapter);
        mWheelView.setCurrentItem(0);

        mSelectedBank = banks.get(0);
        setTextViewStyle(mSelectedBank, mAdapter);
    }


    public void setTextViewStyle(String currentItemText, CalendarTextAdapter adapter) {
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

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_sure://确定选择按钮监听
                bankChooseInterface.getBankName(mSelectedBank);
                dismissBankListDialog();
                break;
            case R.id.tv_cancel://取消
                dismissBankListDialog();
                break;
        }
    }

    public void setCancelOutside(boolean canCancel) {
        setCanceledOnTouchOutside(canCancel);
    }

    public void showDialog() {
        if (Looper.myLooper() != Looper.getMainLooper()) {
            // 不在主线程
            return;
        }
        if (null == mContext || ((Activity) mContext).isFinishing()) {
            // 界面已被销毁
            return;
        }
        show();
    }

    public void dismissBankListDialog() {
        if (Looper.myLooper() != Looper.getMainLooper()) {
            return;
        }
        if (!isShowing() || null == mContext || ((Activity) mContext).isFinishing()) {
            return;
        }
        dismiss();
    }

    private class CalendarTextAdapter extends AbstractWheelTextAdapter {
        ArrayList<String> list;

        protected CalendarTextAdapter(Context context, ArrayList<String> list, int currentItem, int maxsize, int minsize) {
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

    public interface BankChooseInterface {
        /**
         * @param name  银行名称
         */
        void getBankName(String name);
    }

}
