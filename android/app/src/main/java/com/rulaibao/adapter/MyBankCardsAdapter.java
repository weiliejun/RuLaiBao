package com.rulaibao.adapter;

import android.content.Context;
import android.graphics.Color;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.bean.BankCardList2B;
import com.rulaibao.network.types.MouldList;
import com.rulaibao.uitls.StringUtil;


/**
 * 我的银行卡  Adapter 类
 * Created by hong on 2018/11/14.
 */
public class MyBankCardsAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private final MouldList<BankCardList2B> list;
    Context mContext;
    LayoutInflater mInflater;
    private static final int TYPE_ITEM = 0;
    private static final int TYPE_FOOTER = 1;

    //上拉加载更多
    public static final int PULLUP_LOAD_MORE = 0;
    //正在加载中
    public static final int LOADING_MORE = 1;
    //没有加载更多 隐藏
    public static final int NO_LOAD_MORE = 2;

    //上拉加载更多状态-默认为0
    private int mLoadMoreStatus = 0;


    public MyBankCardsAdapter(Context context, MouldList<BankCardList2B> list) {
        mContext = context;
        this.list = list;
        mInflater = LayoutInflater.from(context);
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        if (viewType == TYPE_ITEM) { // 加载我的银行卡item布局

            View itemView = mInflater.inflate(R.layout.item_my_bank_card, parent, false);

            return new ItemViewHolder(itemView);
        } else if (viewType == TYPE_FOOTER) {
            View itemView = mInflater.inflate(R.layout.load_more_footview_layout, parent, false);

            return new FooterViewHolder(itemView);
        }
        return null;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, final int position) {
        if (holder instanceof ItemViewHolder) {
            final ItemViewHolder itemViewHolder = (ItemViewHolder) holder;
            itemViewHolder.tv_bank_name.setText(list.get(position).getBank());
            itemViewHolder.tv_bank_card_num.setText(StringUtil.replaceSubStringBankCard(list.get(position).getBankcardNo()));

            // 工资卡设置状态
            if (list.get(position).getIsWageCard().equals("1")) {
                itemViewHolder.tv_payroll.setTextColor(Color.parseColor("#5fabef"));
                itemViewHolder.iv_make_payroll.setBackgroundResource(R.mipmap.icon_selected);
                itemViewHolder.rl_set_up_salary_card.setClickable(false);
            } else {
                itemViewHolder.tv_payroll.setTextColor(Color.parseColor("#666666"));
                itemViewHolder.iv_make_payroll.setBackgroundResource(R.mipmap.icon_unselected);
                itemViewHolder.rl_set_up_salary_card.setClickable(true);
            }

            // 设置银行logo
            if (list.get(position).getBank().equals("中国银行")) {
                itemViewHolder.iv_bank_logo.setBackgroundResource(R.mipmap.icon_zhonghang);
            } else if (list.get(position).getBank().equals("农业银行")) {
                itemViewHolder.iv_bank_logo.setBackgroundResource(R.mipmap.icon_nonghang);
            } else if (list.get(position).getBank().equals("工商银行")) {
                itemViewHolder.iv_bank_logo.setBackgroundResource(R.mipmap.icon_gongshang);
            } else if (list.get(position).getBank().equals("建设银行")) {
                itemViewHolder.iv_bank_logo.setBackgroundResource(R.mipmap.icon_jianhang);
            } else if (list.get(position).getBank().equals("交通银行")) {
                itemViewHolder.iv_bank_logo.setBackgroundResource(R.mipmap.icon_jiaohang);
            } else if (list.get(position).getBank().equals("招商银行")) {
                itemViewHolder.iv_bank_logo.setBackgroundResource(R.mipmap.icon_zhaohang);
            } else if (list.get(position).getBank().equals("广发银行")) {
                itemViewHolder.iv_bank_logo.setBackgroundResource(R.mipmap.icon_guangfa);
            } else if (list.get(position).getBank().equals("华夏银行")) {
                itemViewHolder.iv_bank_logo.setBackgroundResource(R.mipmap.icon_huaxia);
            } else if (list.get(position).getBank().equals("浦发银行")) {
                itemViewHolder.iv_bank_logo.setBackgroundResource(R.mipmap.icon_pufa);
            } else {
                itemViewHolder.iv_bank_logo.setBackgroundResource(R.mipmap.icon_bank_empty_logo);
            }

            // 银行卡删除
            itemViewHolder.rl_delete.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    listener.onDeleteClick(position);
                }
            });

            // 设置工资卡
            itemViewHolder.rl_set_up_salary_card.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (list.get(position).getIsWageCard().equals("1")) {
                        listener.setUpSalaryCard(position, "1");
                        itemViewHolder.rl_set_up_salary_card.setClickable(false);
                    }else {
                        listener.setUpSalaryCard(position, "0");
                        itemViewHolder.rl_set_up_salary_card.setClickable(true);
                    }
                }
            });

        } else if (holder instanceof FooterViewHolder) {
            FooterViewHolder footerViewHolder = (FooterViewHolder) holder;

            switch (mLoadMoreStatus) {
                case PULLUP_LOAD_MORE:
                    footerViewHolder.tvLoadText.setText("数据加载中...");
                    break;
                case LOADING_MORE:
                    footerViewHolder.tvLoadText.setText("正加载更多...");
                    break;
                case NO_LOAD_MORE:
                    //隐藏加载更多
                    footerViewHolder.loadLayout.setVisibility(View.GONE);
                    break;

            }
        }

    }

    private OnBankCardDeleteClickListener listener;

    public interface OnBankCardDeleteClickListener {
        void onDeleteClick(int position);

        void setUpSalaryCard(int position, String isWageCard);
    }

    public void setBankCardDeleteClickListener(OnBankCardDeleteClickListener listener) {
        this.listener = listener;
    }

    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size() + 1;
    }

    @Override
    public int getItemViewType(int position) {

        if (position + 1 == getItemCount()) {
            //最后一个item设置为footerView
            return TYPE_FOOTER;
        } else {
            return TYPE_ITEM;
        }
    }

    public class ItemViewHolder extends RecyclerView.ViewHolder {
        private final ImageView iv_bank_logo; // 银行Logo
        private final TextView tv_bank_name; // 银行名称
        private final TextView tv_bank_card_num; // 银行卡号
        private final TextView tv_payroll; // 设为工资卡
        private final RelativeLayout rl_delete; // 删除当前银行卡
        private final RelativeLayout rl_set_up_salary_card; // （是否）设为工资卡
        private final ImageView iv_make_payroll; //

        public ItemViewHolder(View itemView) {
            super(itemView);
            iv_bank_logo = (ImageView) itemView.findViewById(R.id.iv_bank_logo);
            iv_make_payroll = (ImageView) itemView.findViewById(R.id.iv_make_payroll);

            tv_bank_name = (TextView) itemView.findViewById(R.id.tv_bank_name);
            tv_bank_card_num = (TextView) itemView.findViewById(R.id.tv_bank_card_num);
            tv_payroll = (TextView) itemView.findViewById(R.id.tv_payroll);

            rl_delete = (RelativeLayout) itemView.findViewById(R.id.rl_delete);
            rl_set_up_salary_card = (RelativeLayout) itemView.findViewById(R.id.rl_set_up_salary_card);
        }

    }

    public class FooterViewHolder extends RecyclerView.ViewHolder {

        private final ProgressBar pbLoad;
        private final TextView tvLoadText;
        private final LinearLayout loadLayout;

        public FooterViewHolder(View itemView) {
            super(itemView);

            pbLoad = (ProgressBar) itemView.findViewById(R.id.pbLoad);
            tvLoadText = (TextView) itemView.findViewById(R.id.tvLoadText);
            loadLayout = (LinearLayout) itemView.findViewById(R.id.loadLayout);
        }
    }


    public void AddHeaderItem(MouldList<BankCardList2B> items) {
        list.addAll(0, items);
        notifyDataSetChanged();
    }

    public void AddFooterItem(MouldList<BankCardList2B> items) {
        list.addAll(items);
        notifyDataSetChanged();
    }

    /**
     * 更新加载更多状态
     *
     * @param status
     */
    public void changeMoreStatus(int status) {
        mLoadMoreStatus = status;
        notifyDataSetChanged();
    }
}
