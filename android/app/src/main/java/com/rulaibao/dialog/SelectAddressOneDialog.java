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
import android.view.WindowManager.LayoutParams;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.adapter.ProvinceAdapter;
import com.rulaibao.bean.ProvinceModel;
import com.rulaibao.widget.OnWheelChangedListener;
import com.rulaibao.widget.WheelView;

import java.util.ArrayList;
import java.util.List;

/**
 *  事业合伙人认证页--- 选择地区 Dialog
 */
public class SelectAddressOneDialog extends Dialog implements DialogInterface.OnCancelListener, DialogInterface.OnDismissListener, OnWheelChangedListener {

    private Context mContext;
    private LayoutInflater inflater;
    private LayoutParams lp;
    private int percentageH = 4;
    private int percentageW = 8;
    private TextView txtConfim = null;
    private TextView txtCancel = null;

    ArrayList<OnCancelListener> m_arrCancelListeners = new ArrayList<OnCancelListener>();
    ArrayList<OnDismissListener> m_arrDismissListeners = new ArrayList<OnDismissListener>();
    private OnExitChanged onExitChanged = null;

    private WheelView provinceView;
    private List<ProvinceModel> provinceDatas = new ArrayList<>();
    private String mCurrentProvince;
    private ProvinceAdapter provinceAdapter;
    private final int TEXTSIZE = 15;//选择器的字体大小

    public SelectAddressOneDialog(Context context, OnExitChanged onChanged) {
        super(context, R.style.Dialog);
        this.mContext = context;
        this.onExitChanged = onChanged;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        inflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View mView = inflater.inflate(R.layout.dialog_select_address_one, null);
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


        provinceView = (WheelView) findViewById(R.id.provinceView);
        // 设置可见条目数量
        provinceView.setVisibleItems(4);

        // 添加change事件
        provinceView.addChangingListener(this);

        initData();
    }

    private void initView(View mView) {

        txtConfim = (TextView) mView.findViewById(R.id.dialog_btn_confim);
        txtCancel = (TextView) mView.findViewById(R.id.dialog_btn_cancel);
        txtConfim.setOnClickListener(confimListener);
        txtCancel.setOnClickListener(cancelListener);
    }

    private View.OnClickListener confimListener = new View.OnClickListener() {

        @Override
        public void onClick(View v) {
            onExitChanged.onConfim(mCurrentProvince);
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

    public interface OnExitChanged {
        void onConfim(String selectText);

        void onCancel();

    }

    private void initData() {
        //初始化数据
        ArrayList<ProvinceModel> provinceList=new ArrayList<>();
        ProvinceModel provinceModel =new ProvinceModel();
        provinceModel.setNAME("北京");
        ProvinceModel provinceMode2 =new ProvinceModel();
        provinceMode2.setNAME("内蒙");
        ProvinceModel provinceMode3 =new ProvinceModel();
        provinceMode3.setNAME("河北");
        ProvinceModel provinceMode4 =new ProvinceModel();
        provinceMode4.setNAME("贵州");
        provinceList.add(provinceModel);
        provinceList.add(provinceMode2);
        provinceList.add(provinceMode3);
        provinceList.add(provinceMode4);

        provinceDatas = provinceList;
        provinceAdapter = new ProvinceAdapter(mContext, provinceDatas);
        provinceAdapter.setTextSize(TEXTSIZE);//设置字体大小
        provinceView.setViewAdapter(provinceAdapter);
        mCurrentProvince = provinceDatas.get(provinceView.getCurrentItem()).NAME;
    }

    @Override
    public void onChanged(WheelView wheel, int oldValue, int newValue) {
        if (wheel == provinceView) {
            mCurrentProvince = provinceDatas.get(newValue).NAME;
        }
    }

}