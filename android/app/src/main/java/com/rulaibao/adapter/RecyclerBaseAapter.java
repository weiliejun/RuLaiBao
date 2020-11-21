package com.rulaibao.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.rulaibao.R;
import com.rulaibao.adapter.holder.FooterViewHolder;
import com.rulaibao.adapter.holder.HeaderViewHolder;
import com.rulaibao.uitls.ViewUtils;


/**
 * RecyclerView 的adapter基类
 */

public abstract class RecyclerBaseAapter<T> extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    protected Context context;

    protected LayoutInflater layoutInflater;

    protected static final int TYPE_ITEM = 0;     // item布局
    protected static final int TYPE_FOOTER = 1;   //  footer布局
    protected static final int TYPE_HEADER = 2;   //  header布局

    //上拉加载更多
    public static final int PULLUP_LOAD_MORE = 0;
    //正在加载中
    public static final int LOADING_MORE = 1;
    //没有加载更多 隐藏
    public static final int NO_LOAD_MORE = 2;

    //没有加载更多 留空白布局
    public static final int NO_LOAD_BLACK = 3;

    //没有数据
    public static final int NO_DATA_MATCH_PARENT = 4;
    //没有数据
    public static final int NO_DATA_WRAP_CONTENT = 5;

    public static final int NO_DATA_NO_PICTURE = 6;

    //  更多数据（含下载）
    public static final int NO_DATA_DOWNLOAD = 7;

    //上拉加载更多状态-默认为2
    protected int mLoadMoreStatus = 2;

    protected String noDataMessage = "";

    protected String pdfName = "";


    public View mHeaderView;
    public View mFooterView;


    public String getPdfName() {
        return pdfName;
    }

    public void setPdfName(String pdfName) {
        this.pdfName = pdfName;
    }

    public View getmHeaderView() {
        return mHeaderView;
    }

    public void setNoDataMessage(String noDataMessage) {
        this.noDataMessage = noDataMessage;
    }

    public void setmHeaderView(View mHeaderView) {
        this.mHeaderView = mHeaderView;
        notifyItemInserted(0);

//        notifyDataSetChanged();
    }

    public View getmFooterView() {
        return mFooterView;
    }

    public void setmFooterView(View mFooterView) {
        this.mFooterView = mFooterView;
        notifyItemInserted(getItemCount() - 1);
    }


    public RecyclerBaseAapter(Context context) {
        this.context = context;
        layoutInflater = LayoutInflater.from(context);
    }

    @Override
    public long getItemId(int position) {
        return position;

    }

    @Override
    public int getItemCount() {
//        if(mHeaderView!=null){
//            return getItem()+1;
//        }else{
//            return getItem();
//        }
        return getItem();

    }


    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        if (viewType == TYPE_ITEM) {
            // 填充布局
            return inflateItemView(parent);

        } else if (viewType == TYPE_FOOTER) {
            View view = layoutInflater.inflate(R.layout.activity_training_hot_ask_footer, parent, false);
            FooterViewHolder holder = new FooterViewHolder(view);
            return holder;
        } else if (viewType == TYPE_HEADER) {
            HeaderViewHolder headerHolder = new HeaderViewHolder(mHeaderView);
            return headerHolder;
        }

        return null;
    }


    public abstract RecyclerView.ViewHolder inflateItemView(ViewGroup parent);


    public abstract void initHolderData(RecyclerView.ViewHolder holder, int position);

    public void initFooterHolderData(RecyclerView.ViewHolder holder) {
        FooterViewHolder footerViewHolder = (FooterViewHolder) holder;
        switch (mLoadMoreStatus) {
            case PULLUP_LOAD_MORE:
                ViewGroup.LayoutParams params1 = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                footerViewHolder.itemView.setLayoutParams(params1);
                footerViewHolder.ivHotAskFooter.setVisibility(View.GONE);
                footerViewHolder.tv_footer_more_download.setVisibility(View.GONE);
                footerViewHolder.tvFooterMore.setText("上拉加载更多...");
                break;
            case LOADING_MORE:
                ViewGroup.LayoutParams params2 = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                footerViewHolder.itemView.setLayoutParams(params2);
                footerViewHolder.ivHotAskFooter.setVisibility(View.GONE);
                footerViewHolder.tv_footer_more_download.setVisibility(View.GONE);
                footerViewHolder.tvFooterMore.setText("正加载更多...");
                break;
            case NO_LOAD_MORE:
                ViewGroup.LayoutParams params3 = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                footerViewHolder.itemView.setLayoutParams(params3);
                //隐藏加载更多
                footerViewHolder.ivHotAskFooter.setVisibility(View.GONE);
                footerViewHolder.tv_footer_more_download.setVisibility(View.GONE);
                footerViewHolder.tvFooterMore.setVisibility(View.GONE);
                break;
            case NO_LOAD_BLACK:
                ViewGroup.LayoutParams params4 = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                footerViewHolder.itemView.setLayoutParams(params4);
                //隐藏加载更多  留空白
                footerViewHolder.tvFooterMore.setText("");
                footerViewHolder.ivHotAskFooter.setVisibility(View.GONE);
                footerViewHolder.tv_footer_more_download.setVisibility(View.GONE);
                ViewGroup.LayoutParams lp = footerViewHolder.tvFooterMore.getLayoutParams();
                lp.width = ViewGroup.LayoutParams.WRAP_CONTENT;
                lp.height = ViewUtils.dip2px(context, 40);//lp.height=LayoutParams.WRAP_CONTENT;
                footerViewHolder.tvFooterMore.setLayoutParams(lp);
//                    footerViewHolder.tvFooterMore.setVisibility(View.GONE);
                break;

            case NO_DATA_MATCH_PARENT:
                ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
                footerViewHolder.itemView.setLayoutParams(params);

                //没有数据
                footerViewHolder.tvFooterMore.setVisibility(View.VISIBLE);
                footerViewHolder.tv_footer_more_download.setVisibility(View.GONE);
                footerViewHolder.ivHotAskFooter.setVisibility(View.VISIBLE);
                footerViewHolder.tvFooterMore.setText(noDataMessage);
                break;
            case NO_DATA_WRAP_CONTENT:
                ViewGroup.LayoutParams params_wrap = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                footerViewHolder.itemView.setPadding(0, 50, 0, 0);
                footerViewHolder.itemView.setLayoutParams(params_wrap);

                //没有数据
                footerViewHolder.tvFooterMore.setVisibility(View.VISIBLE);
                footerViewHolder.tv_footer_more_download.setVisibility(View.GONE);
                footerViewHolder.ivHotAskFooter.setVisibility(View.VISIBLE);
                footerViewHolder.tvFooterMore.setText(noDataMessage);
                break;
            case NO_DATA_NO_PICTURE:
                //没有数据
                footerViewHolder.tvFooterMore.setVisibility(View.VISIBLE);
                footerViewHolder.ivHotAskFooter.setVisibility(View.GONE);
                footerViewHolder.tv_footer_more_download.setVisibility(View.GONE);
                footerViewHolder.tvFooterMore.setText(noDataMessage);
                break;
            case NO_DATA_DOWNLOAD:
                footerViewHolder.tvFooterMore.setVisibility(View.VISIBLE);
                footerViewHolder.ivHotAskFooter.setVisibility(View.GONE);
                footerViewHolder.tv_footer_more_download.setVisibility(View.VISIBLE);
                footerViewHolder.tvFooterMore.setText(noDataMessage);
                footerViewHolder.tv_footer_more_download.setText(pdfName);
                footerViewHolder.tv_footer_more_download.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        getDownload();
                    }
                });
                break;
            default:

                break;
        }
    }



    public abstract int getItem();
    public void getDownload(){
    }

    @Override
    public int getItemViewType(int position) {

        if (mHeaderView != null) {
            if (position == 0) {
                return TYPE_HEADER;
            } else {
                if (position + 1 == getItemCount()) {
                    //最后一个item设置为footerView
                    return TYPE_FOOTER;
                } else {
                    return TYPE_ITEM;
                }
            }

        } else {
            if (position + 1 == getItemCount()) {
                //最后一个item设置为footerView
                return TYPE_FOOTER;
            } else {
                return TYPE_ITEM;
            }
        }

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
