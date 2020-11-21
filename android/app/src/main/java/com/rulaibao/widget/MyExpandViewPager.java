package com.rulaibao.widget;

import android.content.Context;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.view.View;

/**
 * Created by hong on 2018/1/8.
 * 类简单说明: 动态计算viewpager高度，取到所有子布局的最大高度，赋值给父类
 */

public class MyExpandViewPager extends ViewPager {

    public MyExpandViewPager(Context context) {
        super(context);
    }

    public MyExpandViewPager(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int maxHeight = 0;
        for (int i = 0; i < getChildCount(); i++) {
            View child = getChildAt(i);
            child.measure(widthMeasureSpec, MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED));
            int childHeight = child.getMeasuredHeight();
            //取到子布局中 高度最高的布局的高度
            if (childHeight > maxHeight) {
                maxHeight = childHeight;
            }
        }
        //得到viewpager的精确高度
        heightMeasureSpec = MeasureSpec.makeMeasureSpec(maxHeight, MeasureSpec.EXACTLY);
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    }
}
