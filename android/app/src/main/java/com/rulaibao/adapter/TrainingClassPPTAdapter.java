package com.rulaibao.adapter;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Matrix;
import android.graphics.PointF;
import android.support.v7.app.AlertDialog;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.assist.ImageLoadingListener;
import com.nostra13.universalimageloader.core.assist.ImageLoadingProgressListener;
import com.rulaibao.R;
import com.rulaibao.adapter.holder.FooterViewHolder;
import com.rulaibao.bean.ResultPPTFileBean;
import com.rulaibao.activity.FileDisplayActivity;
import com.rulaibao.uitls.ImageLoaderManager;
import com.rulaibao.uitls.TouchListener;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.ButterKnife;
import pub.devrel.easypermissions.EasyPermissions;


/**
 * 课程详情 --- PPT adapter
 */

public class TrainingClassPPTAdapter extends RecyclerBaseAapter<RecyclerView.ViewHolder> {

    private Context context;

    private ArrayList<String> arrayList;
    private LayoutInflater layoutInflater;

    private static final int TYPE_ITEM = 0;     // item布局
    private static final int TYPE_FOOTER = 1;   //  footer布局

    private View itemview;
    private ImageView imageView;

    private DisplayImageOptions displayImageOptions = ImageLoaderManager.initDisplayImageOptions(R.mipmap.img_traffining_recommend, R.mipmap.img_traffining_recommend, R.mipmap.img_traffining_recommend);

    private ResultPPTFileBean attachmentFile;

    public TrainingClassPPTAdapter(Context context, ArrayList<String> arrayList) {
        super(context);
        this.context = context;
        this.arrayList = arrayList;
        layoutInflater = LayoutInflater.from(context);
        attachmentFile = new ResultPPTFileBean();
    }

    public ResultPPTFileBean getAttachmentFile() {
        return attachmentFile;
    }

    public void setAttachmentFile(ResultPPTFileBean attachmentFile) {
        this.attachmentFile = attachmentFile;
    }

    @Override
    public RecyclerView.ViewHolder inflateItemView(ViewGroup parent) {
        View view = layoutInflater.inflate(R.layout.activity_training_class_ppt_item, parent, false);
        ViewHolder holder = new ViewHolder(view);
        return holder;
    }

    @Override
    public void initHolderData(RecyclerView.ViewHolder holder, int position) {
        final ViewHolder holder1 = (ViewHolder) holder;

        int index = position;
        if (getmHeaderView() != null) {
            index = position - 1;
        }

        ImageLoader.getInstance().displayImage(arrayList.get(position), holder1.ivPpt);

        final int finalIndex = index;
        holder1.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {


                imageView = new ImageView(context);
                imageView.setOnTouchListener(new TouchListener(imageView));

                ImageLoader.getInstance().displayImage(arrayList.get(finalIndex), imageView, displayImageOptions, new ImageLoadingListener() {
                    @Override
                    public void onLoadingStarted(String s, View view) {

                    }

                    @Override
                    public void onLoadingFailed(String s, View view, FailReason failReason) {

                    }

                    @Override
                    public void onLoadingComplete(String s, View view, Bitmap bitmap) {

                    }

                    @Override
                    public void onLoadingCancelled(String s, View view) {

                    }
                }, new ImageLoadingProgressListener() {
                    @Override
                    public void onProgressUpdate(String s, View view, int i, int i1) {

                    }
                });

                AlertDialog.Builder builder = new AlertDialog.Builder(context);
                builder.setView(imageView);
                builder.show();
//                    AlertDialog alert = builder.create();
            }
        });

    }

    @Override
    public void getDownload() {
        super.getDownload();
        String[] perms = new String[]{Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE};

//                filePath = getFilePath(position);

//        String filePath = "http://video.ch9.ms/build/2011/slides/TOOL-532T_Sutter.pptx";
        if (getAttachmentFile() != null) {
            String filePath = attachmentFile.getCourseFilePath();
            if (!TextUtils.isEmpty(filePath)) {
                if (!EasyPermissions.hasPermissions(context, perms)) {
                    EasyPermissions.requestPermissions((Activity) context, "需要访问手机存储权限！", 10086, perms);
                } else {
                    FileDisplayActivity.show(context, filePath);
                }

            }

        }

    }

    @Override
    public int getItem() {
        if (mHeaderView != null) {
            return arrayList.size() + 2;
        } else {
            return arrayList.size() + 1;
        }

//        return 5;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, final int position) {

        if (holder instanceof ViewHolder) {
            initHolderData(holder, position);
        } else if (holder instanceof FooterViewHolder) {
            initFooterHolderData(holder);
        }

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

    static class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R.id.iv_ppt)
        ImageView ivPpt;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
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

    public interface LoadMoreData {
        public void getMoreData();
    }


}
