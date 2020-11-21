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
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

import com.rulaibao.R;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 */
public class ShareSDKDialog extends Dialog implements
		DialogInterface.OnCancelListener, DialogInterface.OnDismissListener{

	private Context mContext;
	private LayoutInflater inflater;
	private LayoutParams lp;
	private int percentageH = 4;
	private int percentageW = 8;
	private TextView txtConfim = null;
	private TextView txtCancel = null;

	private GridView gridView;
	private List<Map<String, Object>> dataList;
	private SimpleAdapter adapter;

	ArrayList<OnCancelListener> m_arrCancelListeners = new ArrayList<OnCancelListener>();
	ArrayList<OnDismissListener> m_arrDismissListeners = new ArrayList<OnDismissListener>();
	private OnShare onChanged = null;

	public ShareSDKDialog(Context context, OnShare onChanged) {
		super(context, R.style.Dialog);
		this.mContext = context;
		this.onChanged = onChanged;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		inflater = (LayoutInflater) mContext
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View mView = inflater.inflate(R.layout.dialog_share, null);
		setContentView(mView);
		// 设置window属性
		lp = getWindow().getAttributes();
		lp.gravity = Gravity.BOTTOM;
		lp.dimAmount = 0.6f; // 去背景遮盖
		lp.alpha = 1.0f;
		int[] wh = initWithScreenWidthAndHeight(mContext);
	//	lp.width = wh[0] - wh[0] / percentageW;
		lp.width = ViewGroup.LayoutParams.MATCH_PARENT;
		lp.height = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
		getWindow().setAttributes(lp);
		setCanceledOnTouchOutside(false);
		setOnDismissListener(this);
		setOnCancelListener(this);
		initView(mView);

	}

	private void initView(View mView) {
		gridView = (GridView) findViewById(R.id.gridview_share);
		initData();
		String[] from={"img","text"};

		int[] to={R.id.img,R.id.text};

		adapter=new SimpleAdapter(mContext, dataList, R.layout.gridview_item, from, to);

		gridView.setAdapter(adapter);

		gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
									long arg3) {
				onChanged.onConfirm(arg2);
				onDismiss();
			}
		});

		txtCancel = (TextView) mView
				.findViewById(R.id.dialog_cancel);
		txtCancel.setOnClickListener(cancelListener);
	}

	void initData() {
		//图标
		int icno[] = {R.mipmap.ssdk_oks_classic_wechatmoments, R.mipmap.ssdk_oks_classic_wechat, R.mipmap.ssdk_oks_classic_qq,
				R.mipmap.ssdk_oks_classic_qzone, R.mipmap.ssdk_oks_classic_shortmessage, R.mipmap.ssdk_logo_lianjie};
		//图标下的文字
		String name[] = {"微信朋友圈", "微信好友", "QQ好友", "QQ空间", "私信好友", "复制链接"};
		dataList = new ArrayList<Map<String, Object>>();
		for (int i = 0; i < icno.length; i++) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("img", icno[i]);
			map.put("text", name[i]);
			dataList.add(map);
		}
	}

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
		((Activity) context).getWindowManager().getDefaultDisplay()
				.getMetrics(dm);
		wh[0] = dm.widthPixels;
		wh[1] = dm.heightPixels;
		return wh;
	}

	public interface OnShare {

		void onConfirm(int arg2);

		void onCancel();
	}

}