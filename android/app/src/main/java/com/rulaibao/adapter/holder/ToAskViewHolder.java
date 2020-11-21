package com.rulaibao.adapter.holder;

import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.GridView;
import android.widget.TextView;

import com.rulaibao.R;

import butterknife.BindView;
import butterknife.ButterKnife;

public class ToAskViewHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.tv_training_toask)
    public TextView tvTrainingToask;
    @BindView(R.id.tv_training_toask_black)
    public TextView tvTrainingToaskBlack;

    public ToAskViewHolder(View view) {
        super(view);
        ButterKnife.bind(this, view);
    }

    public void update(final GridView gvTrainingToask) {
        // 精确计算GridView的item高度
        tvTrainingToaskBlack.getViewTreeObserver().addOnGlobalLayoutListener(
                new ViewTreeObserver.OnGlobalLayoutListener() {
                    public void onGlobalLayout() {
                        int position = (Integer) tvTrainingToaskBlack.getTag();
                        if (position > 0) {
                            int height1 = 0;
                            int height2 = 0;
                            int height3 = 0;
                            View v1 = null;
                            View v2 = null;
                            View v3 = null;

                            if (position % 3 == 1) {
                                try {
                                    v2 = (View) tvTrainingToask.getTag();
                                    height2 = v2.getHeight();
                                    v1 = gvTrainingToask.getChildAt(position - 1);
                                    height1 = v1.getHeight();

                                    if (height1 > height2) {
                                        v2.setLayoutParams(new GridView.LayoutParams(
                                                GridView.LayoutParams.MATCH_PARENT,
                                                height1));
                                    } else {
                                        v1.setLayoutParams(new GridView.LayoutParams(
                                                GridView.LayoutParams.MATCH_PARENT,
                                                height2));
                                    }
                                }catch (Exception e){
                                    e.printStackTrace();
                                }


                            }else if (position % 3 == 2) {
                                try {
                                    v3 = (View) tvTrainingToask.getTag();
                                    height3 = v3.getHeight();
                                    v1 = gvTrainingToask.getChildAt(position - 2);
                                    height1 = v1.getHeight();
                                    v2 = gvTrainingToask.getChildAt(position - 1);
                                    height2 = v2.getHeight();

                                    if (height1 > height2) {
                                        if (height2 > height3) {        //  v1
                                            v2.setLayoutParams(new GridView.LayoutParams(
                                                    GridView.LayoutParams.MATCH_PARENT,
                                                    height1));
                                            v3.setLayoutParams(new GridView.LayoutParams(
                                                    GridView.LayoutParams.MATCH_PARENT,
                                                    height1));
                                        } else {
                                            if (height1 > height3) {        //  v1
                                                v2.setLayoutParams(new GridView.LayoutParams(
                                                        GridView.LayoutParams.MATCH_PARENT,
                                                        height1));
                                                v3.setLayoutParams(new GridView.LayoutParams(
                                                        GridView.LayoutParams.MATCH_PARENT,
                                                        height1));
                                            } else {            //  v3
                                                v1.setLayoutParams(new GridView.LayoutParams(
                                                        GridView.LayoutParams.MATCH_PARENT,
                                                        height3));
                                                v2.setLayoutParams(new GridView.LayoutParams(
                                                        GridView.LayoutParams.MATCH_PARENT,
                                                        height3));
                                            }
                                        }
                                    } else {
                                        if (height1 > height3) {        //v2
                                            v1.setLayoutParams(new GridView.LayoutParams(
                                                    GridView.LayoutParams.MATCH_PARENT,
                                                    height2));
                                            v3.setLayoutParams(new GridView.LayoutParams(
                                                    GridView.LayoutParams.MATCH_PARENT,
                                                    height2));
                                        } else {
                                            if (height2 > height3) {        //  v2
                                                v1.setLayoutParams(new GridView.LayoutParams(
                                                        GridView.LayoutParams.MATCH_PARENT,
                                                        height2));
                                                v3.setLayoutParams(new GridView.LayoutParams(
                                                        GridView.LayoutParams.MATCH_PARENT,
                                                        height2));
                                            } else {                // v3
                                                v1.setLayoutParams(new GridView.LayoutParams(
                                                        GridView.LayoutParams.MATCH_PARENT,
                                                        height3));
                                                v2.setLayoutParams(new GridView.LayoutParams(
                                                        GridView.LayoutParams.MATCH_PARENT,
                                                        height3));
                                            }
                                        }
                                    }

                                }catch (Exception e){
                                    e.printStackTrace();
                                }


                            }

                        }


                    }
                });
    }


}
