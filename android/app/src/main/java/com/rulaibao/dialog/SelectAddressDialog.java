package com.rulaibao.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager.LayoutParams;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.adapter.AreaAdapter;
import com.rulaibao.adapter.CitysAdapter;
import com.rulaibao.adapter.ProvinceAdapter;
import com.rulaibao.bean.CityModel;
import com.rulaibao.bean.DistrictModel;
import com.rulaibao.bean.ProvinceModel;
import com.rulaibao.uitls.CityDataHelper;
import com.rulaibao.widget.OnWheelChangedListener;
import com.rulaibao.widget.WheelView;

import java.util.ArrayList;
import java.util.List;

/**
 *  事业合伙人认证页--- 选择地区 Dialog
 */
public class SelectAddressDialog extends Dialog implements DialogInterface.OnCancelListener, DialogInterface.OnDismissListener, OnWheelChangedListener {

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
    private WheelView cityView;
//    private WheelView districtView;
    private List<ProvinceModel> provinceDatas = new ArrayList<>();
    private List<CityModel> cityDatas = new ArrayList<>();
//    private List<DistrictModel> districtDatas = new ArrayList<>();
    private String mCurrentProvince;
    private String mCurrentCity;
    private String mCurrentDistrict;
    private ProvinceAdapter provinceAdapter;
    private CitysAdapter citysAdapter;
    private AreaAdapter areaAdapter;
    private SQLiteDatabase db;
    private CityDataHelper dataHelper;
    private final int TEXTSIZE = 15;//选择器的字体大小

    public SelectAddressDialog(Context context, OnExitChanged onChanged) {
        super(context, R.style.Dialog);
        this.mContext = context;
        this.onExitChanged = onChanged;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        inflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View mView = inflater.inflate(R.layout.dialog_select_address, null);
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
        cityView = (WheelView) findViewById(R.id.cityView);
//        districtView = (WheelView) findViewById(R.id.districtView);
        // 设置可见条目数量
        provinceView.setVisibleItems(7);
        cityView.setVisibleItems(7);
//        districtView.setVisibleItems(7);

        // 添加change事件
        provinceView.addChangingListener(this);
        cityView.addChangingListener(this);
//        districtView.addChangingListener(this);

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
            onExitChanged.onConfim(mCurrentProvince + "-" + mCurrentCity);
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
        dataHelper = CityDataHelper.getInstance(mContext);
        db = dataHelper.openDataBase();
        provinceDatas = dataHelper.getProvice(db);
        if (provinceDatas.size() > 0) {
            mCurrentProvince = provinceDatas.get(0).NAME;
            cityDatas = dataHelper.getCityByParentId(db, provinceDatas.get(0).CODE);
        }
//        if (cityDatas.size() > 0) {
//            districtDatas = dataHelper.getDistrictById(db, cityDatas.get(0).CODE);
//        }
        provinceAdapter = new ProvinceAdapter(mContext, provinceDatas);
        provinceAdapter.setTextSize(TEXTSIZE);//设置字体大小
        provinceView.setViewAdapter(provinceAdapter);
        mCurrentProvince = provinceDatas.get(provinceView.getCurrentItem()).NAME;
        mCurrentCity = cityDatas.get(cityView.getCurrentItem()).NAME;
//        mCurrentDistrict = districtDatas.get(districtView.getCurrentItem()).NAME;
        updateCitys();
        updateAreas();
    }

    @Override
    public void onChanged(WheelView wheel, int oldValue, int newValue) {
        if (wheel == provinceView) {
            mCurrentProvince = provinceDatas.get(newValue).NAME;
            updateCitys();
        }
        if (wheel == cityView) {
            mCurrentCity = cityDatas.get(newValue).NAME;
            updateAreas();
        }
//        if (wheel == districtView) {
//            mCurrentDistrict = districtDatas.get(newValue).NAME;
//        }
    }

    private void updateAreas() {
        int cCurrent = cityView.getCurrentItem();
//        if (cityDatas.size() > 0) {
//            districtDatas = dataHelper.getDistrictById(db, cityDatas.get(cCurrent).CODE);
//        } else {
//            districtDatas.clear();
//        }
//        areaAdapter = new AreaAdapter(mContext, districtDatas);
//        areaAdapter.setTextSize(TEXTSIZE);
//        districtView.setViewAdapter(areaAdapter);
//        if (districtDatas.size() > 0) {
//            mCurrentDistrict = districtDatas.get(0).NAME;
//            districtView.setCurrentItem(0);
//        } else {
//            mCurrentDistrict = "";
//        }
    }

    private void updateCitys() {
        int pCurrent = provinceView.getCurrentItem();
        if (provinceDatas.size() > 0) {
            cityDatas = dataHelper.getCityByParentId(db, provinceDatas.get(pCurrent).CODE);
        } else {
            cityDatas.clear();
        }
        citysAdapter = new CitysAdapter(mContext, cityDatas);
        citysAdapter.setTextSize(TEXTSIZE);
        cityView.setViewAdapter(citysAdapter);
        if (cityDatas.size() > 0) {
            cityView.setCurrentItem(0);
            mCurrentCity = cityDatas.get(0).NAME;
        } else {
            mCurrentCity = "";
        }
        updateAreas();
    }


}