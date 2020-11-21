package com.rulaibao.fragment;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.ProgressDialog;
import android.os.Bundle;
import android.os.Environment;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.adapter.RecyclerBaseAapter;
import com.rulaibao.adapter.TrainingClassPPTAdapter;
import com.rulaibao.adapter.TrainingHotAskListAdapter;
import com.rulaibao.bean.ResultClassDetailsPPTBean;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.widget.superfile.LoadFileModel;
import com.rulaibao.uitls.Md5Tool;
import com.rulaibao.widget.ViewPagerForScrollView;
import com.rulaibao.widget.superfile.SuperFileView2;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.LinkedHashMap;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import okhttp3.ResponseBody;
import pub.devrel.easypermissions.EasyPermissions;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * 课程详情 PPT 栏
 */

@SuppressLint("ValidFragment")
public class TrainingDetailsPPT_2Fragment extends BaseFragment {
    @BindView(R.id.lv_ppt)
    RecyclerView lvPpt;
    @BindView(R.id.tv_ppt)
    TextView tvPpt;
    @BindView(R.id.mSuperFileView)
    SuperFileView2 mSuperFileView;

    private ArrayList arrayList = new ArrayList();

    private String string = "";
    private TrainingClassPPTAdapter adapter;
    private String courseId = "";

    private ArrayList<String> pptImgs;

    private ViewPagerForScrollView vp;

    private String TAG = "FileDisplayActivity";

    public TrainingDetailsPPT_2Fragment(ViewPagerForScrollView vp) {
        this.vp = vp;
    }

    public TrainingDetailsPPT_2Fragment() {
    }

    @Override
    protected View attachLayoutRes(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {


        if (mView == null) {
            mView = inflater.inflate(R.layout.fragment_training_details_ppt_2, container, false);
//            vp.setObjectForPosition(mView,3);
        } else {
            if (mView.getParent() != null) {
                ((ViewGroup) mView.getParent()).removeView(mView);
            }
        }
        return mView;
    }

    @Override
    protected void initViews() {
        courseId = getArguments().getString("courseId");
        pptImgs = new ArrayList<String>();
        initRecyclerView();
        requestData();

        mSuperFileView.setOnGetFilePathListener(new SuperFileView2.OnGetFilePathListener() {
            @Override
            public void onGetFilePath(SuperFileView2 mSuperFileView2) {
//                getFilePathAndShowFile(mSuperFileView2);



            }
        });


//        if (!TextUtils.isEmpty(path)) {
//            Log.d(TAG, "文件path:" + path);
//            setFilePath(path);
//        }



    }

    public void initRecyclerView() {

        LinearLayoutManager layoutManager = new LinearLayoutManager(context) {
            @Override
            public boolean canScrollVertically() {
                // 直接禁止垂直滑动
//                return false;
                return true;
            }
        };

        lvPpt.setLayoutManager(layoutManager);
        adapter = new TrainingClassPPTAdapter(getActivity(), pptImgs);
        lvPpt.setAdapter(adapter);


        lvPpt.setOnScrollListener(new RecyclerView.OnScrollListener() {
            int lastVisibleItem;

            @Override
            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
                if (newState == RecyclerView.SCROLL_STATE_IDLE && lastVisibleItem + 1 == adapter.getItemCount()) {

                }

            }

            @Override
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                LinearLayoutManager layoutManager = (LinearLayoutManager) recyclerView.getLayoutManager();
                //最后一个可见的ITEM
                lastVisibleItem = layoutManager.findLastVisibleItemPosition();


            }
        });


    }

    String filePath = "http://video.ch9.ms/build/2011/slides/TOOL-532T_Sutter.pptx";


    @OnClick(R.id.tv_ppt)
    public void onclick() {

        String[] perms = new String[]{Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE};

        if (!EasyPermissions.hasPermissions(getActivity(), perms)) {
            EasyPermissions.requestPermissions(getActivity(), "需要访问手机存储权限！", 10086, perms);
        } else {

//            FileDisplayActivity.show(getActivity(), filePath);

            if (getCacheFile(filePath).exists()&&getFileName(filePath).equals(filePath)) {
//                FileDisplayActivity.show(getActivity(), getCacheFile(filePath).getAbsolutePath());

                mSuperFileView.displayFile(getCacheFile(filePath),"");

            } else {
                downLoadFromNet(filePath,mSuperFileView);
            }
//            downLoadFromNet(filePath,mSuperFileView);

        }


    }


    private void downLoadFromNet(final String url, final SuperFileView2 mSuperFileView2) {

        //1.网络下载、存储路径、
        File cacheFile = getCacheFile(url);
        if (cacheFile.exists()) {
            if (cacheFile.length() <= 0) {
                Log.d(TAG, "删除空文件！！");
                cacheFile.delete();
                return;
            }
        }
        final ProgressDialog bar = new ProgressDialog(getActivity());
        bar.setMessage("文件正在下载...");
        bar.show();


        LoadFileModel.loadPdfFile(url, new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                Log.d(TAG, "下载文件-->onResponse");
                boolean flag;
                InputStream is = null;
                byte[] buf = new byte[2048];
                int len = 0;
                FileOutputStream fos = null;
                try {
                    ResponseBody responseBody = response.body();
                    is = responseBody.byteStream();
                    long total = responseBody.contentLength();

                    File file1 = getCacheDir(url);
                    if (!file1.exists()) {
                        file1.mkdirs();
                        Log.d(TAG, "创建缓存目录： " + file1.toString());
                    }

                    //fileN : /storage/emulated/0/pdf/kauibao20170821040512.pdf
                    File fileN = getCacheFile(url);//new File(getCacheDir(url), getFileName(url))

                    Log.d(TAG, "创建缓存文件： " + fileN.toString());
                    if (!fileN.exists()) {
                        boolean mkdir = fileN.createNewFile();
                    }
                    fos = new FileOutputStream(fileN);
                    long sum = 0;
                    while ((len = is.read(buf)) != -1) {
                        fos.write(buf, 0, len);
                        sum += len;
                        int progress = (int) (sum * 1.0f / total * 100);
                        Log.d(TAG, "写入缓存文件" + fileN.getName() + "进度: " + progress);
                        bar.setProgress(progress);
                    }
                    fos.flush();
                    Log.d(TAG, "文件下载成功,准备展示文件。");
                    //2.ACache记录文件的有效期
                    bar.dismiss();
                    tvPpt.setText("点击打开文件");

                    mSuperFileView2.displayFile(fileN,"");

//                    FileDisplayActivity.show(getActivity(), getCacheFile(url).getAbsolutePath());

                    mSuperFileView.show();
                } catch (Exception e) {
                    Log.d(TAG, "文件下载异常 = " + e.toString());
                } finally {
                    try {
                        if (is != null)
                            is.close();
                    } catch (IOException e) {
                    }
                    try {
                        if (fos != null)
                            fos.close();
                    } catch (IOException e) {
                    }
                }
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                Log.d(TAG, "文件下载失败");
                File file = getCacheFile(url);
                if (!file.exists()) {
                    Log.d(TAG, "删除下载失败文件");
                    file.delete();
                }
            }
        });


    }

    /***
     * 获取缓存目录
     *
     * @param url
     * @return
     */
    private File getCacheDir(String url) {

        return new File(Environment.getExternalStorageDirectory().getAbsolutePath() + "/007/");

    }

    /***
     * 绝对路径获取缓存文件
     *
     * @param url
     * @return
     */
    private File getCacheFile(String url) {
        File cacheFile = new File(Environment.getExternalStorageDirectory().getAbsolutePath() + "/007/"
                + getFileName(url));
        Log.d(TAG, "缓存文件 = " + cacheFile.toString());
        return cacheFile;
    }

    /***
     * 根据链接获取文件名（带类型的），具有唯一性
     *
     * @param url
     * @return
     */
    private String getFileName(String url) {
        String fileName = Md5Tool.hashKey(url) + "." + getFileType(url);
        return fileName;
    }

    /***
     * 获取文件类型
     *
     * @param paramString
     * @return
     */
    private String getFileType(String paramString) {
        String str = "";

        if (TextUtils.isEmpty(paramString)) {
            Log.d(TAG, "paramString---->null");
            return str;
        }
        Log.d(TAG, "paramString:" + paramString);
        int i = paramString.lastIndexOf('.');
        if (i <= -1) {
            Log.d(TAG, "i <= -1");
            return str;
        }


        str = paramString.substring(i + 1);
        Log.d(TAG, "paramString.substring(i + 1)------>" + str);
        return str;
    }


    public void requestData() {

        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();

        map.put("id", courseId);      //

        HtmlRequest.getClassDetailsPPT(context, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {

                if (params.result != null) {

                    ResultClassDetailsPPTBean bean = (ResultClassDetailsPPTBean) params.result;

                    if (bean.getPptImgs() != null) {
                        if (bean.getPptImgs().size() == 0) {
                            adapter.setNoDataMessage("暂无PPT信息");
                            adapter.changeMoreStatus(RecyclerBaseAapter.NO_DATA_WRAP_CONTENT);
                        } else {
                            adapter.changeMoreStatus(TrainingHotAskListAdapter.NO_LOAD_MORE);
                            pptImgs.addAll(bean.getPptImgs());
                            adapter.notifyDataSetChanged();
                        }
                    }

                } else {

                }
            }
        });
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // TODO: inflate a fragment view
        View rootView = super.onCreateView(inflater, container, savedInstanceState);
        ButterKnife.bind(this, rootView);
        return rootView;
    }
}
