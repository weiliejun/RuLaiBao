package calendar.views;

import android.content.Context;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.HorizontalScrollView;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.handmark.pulltorefresh.library.R;

import calendar.component.ADCircleMonthView;
import calendar.component.MonthView;
import calendar.component.WeekView;
import calendar.entity.CalendarInfo;
import calendar.theme.IDayTheme;
import calendar.theme.IWeekTheme;

import java.util.ArrayList;
import java.util.List;

/**
 * 日历
 * Created by Administrator on 2016/8/7.
 */
public class ADCircleCalendarView extends LinearLayout implements View.OnClickListener {
    private WeekView weekView;
    private ADCircleMonthView circleMonthView;
    //    private TextView textViewYear,textViewMonth;
    private View view;
    private ViewGroup mViewGroup;
    private Context context;
    private int mPreSelectItem;
    private int currentYear;        //   当前年
    private int currentMonth;       //  当前月
    private int currentDay;         // 当前日
    private boolean[] months;       // 选中月份


    public ADCircleCalendarView(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.context = context;
        setOrientation(LinearLayout.VERTICAL);
        LayoutParams llParams =
                new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);

        LayoutParams llParams_week =
                new LayoutParams(LayoutParams.MATCH_PARENT, 60);

        LayoutParams llParams_month =
                new LayoutParams(LayoutParams.MATCH_PARENT, 350);
//        view = LayoutInflater.from(context).inflate(R.layout.display_grid_date,null);
        view = LayoutInflater.from(context).inflate(R.layout.display_horizontal_date, null);

        weekView = new WeekView(context, null);
        circleMonthView = new ADCircleMonthView(context, null);
        addView(view, llParams);
        addView(weekView, llParams_week);
        addView(circleMonthView, llParams_month);

        mViewGroup = (ViewGroup) view.findViewById(R.id.ll_display_horizontal);


//        view.findViewById(R.id.left).setOnClickListener(this);
//        view.findViewById(R.id.right).setOnClickListener(this);

//        textViewYear = (TextView) view.findViewById(R.id.year);
//        textViewMonth = (TextView) view.findViewById(R.id.month);

        circleMonthView.setMonthLisener(new MonthView.IMonthLisener() {
            @Override
            public void setTextMonth() {
//                textViewYear.setText(circleMonthView.getSelYear()+"年");
//                textViewMonth.setText((circleMonthView.getSelMonth() + 1)+"月");
                if(circleMonthView.getSelYear()==currentYear){
                    moveTitleLabel(circleMonthView.getSelMonth()- currentMonth+1);
                }else{
                    moveTitleLabel(circleMonthView.getSelMonth()- currentMonth +12+1);
                }

            }
        });


    }

    /**
     * 设置默认的时间后十二个月的显示
     *
     * @param year
     * @param month
     */
    protected ArrayList<String> getCurrentMonthShow(int year, int month, int day) {
        ArrayList<String> itemList = new ArrayList<String>();
        for (int i = month; i < 12 + month; i++) {
            String str = "";
            if (i % 12 == 0) {
                str = "12月";
            } else {
                str = i%12 + "月";
            }
            itemList.add(str);
        }

        return itemList;
    }

    /**
     * 设置默认的时间
     *
     * @param year
     * @param month
     */
    public void setCurrentDate(int year, int month, int day) {
        currentYear = year;
        currentMonth = month;
        currentDay = day;
    }

    /**
     * 设置选中月份
     *
     * @param months
     */
    public void setSelectMonth(boolean[] months) {
        if(this.months!=null){
            return;
        }else{
            this.months = months;
            addViewPagerView(getCurrentMonthShow(circleMonthView.getSelYear(), circleMonthView.getSelMonth() + 1, 0),months);
        }

    }

    /**
     * 设置日历点击事件
     *
     * @param dateClick 点击事件
     */
    public void setDateClick(MonthView.IDateClick dateClick) {
        circleMonthView.setDateClick(dateClick);
    }

    /**
     * 设置页面数据变化
     *
     * @param changeClick 变化事件
     */
    public void setDateChange(MonthView.IMouthChange changeClick) {
        circleMonthView.setDateChange(changeClick);
    }


    /**
     * 设置星期的形式
     *
     * @param weekString 默认值	"日","一","二","三","四","五","六"
     */
    public void setWeekString(String[] weekString) {
        weekView.setWeekString(weekString);
    }

    public void setCalendarInfos(List<CalendarInfo> calendarInfos) {
        circleMonthView.setCalendarInfos(calendarInfos);
    }

    /**
     * 是否显示标题栏目
     *
     * @param flag
     */
    public void isShowTop(Boolean flag, int select) {
        if (flag) {
            view.setVisibility(VISIBLE);
        } else {
            view.setVisibility(GONE);
        }
        circleMonthView.setMonthState(select);
//        circleMonthView
    }


    public void setDayTheme(IDayTheme theme) {
        circleMonthView.setTheme(theme);
    }

    public void setWeekTheme(IWeekTheme weekTheme) {
        weekView.setWeekTheme(weekTheme);
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
//        if (id == R.id.left) {
//            circleMonthView.onLeftClick();
//        } else {
//            circleMonthView.onRightClick();
//        }
        // 点击tabbar
        for (int i = 0; i < mViewGroup.getChildCount(); i++) {
            LinearLayout child = (LinearLayout) mViewGroup
                    .getChildAt(i);
            ImageView iv = (ImageView) child.getChildAt(1);

            if (child == v) {
                if(i+currentMonth>12){
                    circleMonthView.setPositionDate(currentYear+1,(currentMonth+i)%12,1);
                }else{
                    circleMonthView.setPositionDate(currentYear,currentMonth+i,1);
                }

                break;
            }
        }
    }

    /*
     * 点击新闻分类的tabbar，使点击的bar居中显示到屏幕中间
     */
    private void moveTitleLabel(int position) {

        // 点击当前按钮所有左边按钮的总宽度
        int visiableWidth = 0;
        // HorizontalScrollView的宽度
        int scrollViewWidth = 0;

        mViewGroup.measure(mViewGroup.getMeasuredWidth(), -1);
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(
                mViewGroup.getMeasuredWidth(), -1);
        params.gravity = Gravity.CENTER_VERTICAL;
        mViewGroup.setLayoutParams(params);
        for (int i = 0; i < mViewGroup.getChildCount(); i++) {

            LinearLayout itemView = (LinearLayout) mViewGroup
                    .getChildAt(i);
            int width = itemView.getMeasuredWidth();
            if (i < position) {
                visiableWidth += width;
            }
            scrollViewWidth += width;
            ImageView iv = (ImageView) itemView.getChildAt(1);
            if (position != i) {
//                itemView.setTextColor(getResources().getColor(R.color.gray_d));
//                itemView.setIsHorizontaline(false);
                iv.setVisibility(GONE);

            } else {
//                itemView.setTextColor(getResources().getColor(R.color.gray_d));
//                itemView.setIsHorizontaline(true);
                iv.setVisibility(VISIBLE);
            }
            if (i == mViewGroup.getChildCount() - 1) {
                break;
            }


//            NewsTitleTextView itemView = (NewsTitleTextView) mViewGroup
//                    .getChildAt(i);
//            int width = itemView.getMeasuredWidth();
//            if (i < position) {
//                visiableWidth += width;
//            }
//            scrollViewWidth += width;
//
//            if (position != i) {
//                itemView.setTextColor(getResources().getColor(R.color.gray_d));
//                itemView.setIsHorizontaline(false);
//            } else {
//                itemView.setTextColor(getResources().getColor(R.color.gray_d));
//                itemView.setIsHorizontaline(true);
//            }
//            if (i == mViewGroup.getChildCount() - 1) {
//                break;
//            }



//            LinearLayout ll_m = new LinearLayout(context);
////            ll_m.setLayoutParams(params_m);
//            ll_m.setOrientation(LinearLayout.VERTICAL);
//
//            LinearLayout ll = new LinearLayout(context);
//            ll.setLayoutParams(params);
//            ll.setOrientation(LinearLayout.HORIZONTAL);
//
//            NewsTitleTextView tv = new NewsTitleTextView(context);
//            int itemWidth = (int) tv.getPaint().measureText(label);
//
//            LayoutParams params_m = new LinearLayout.LayoutParams((itemWidth * 2),
//                    ViewGroup.LayoutParams.WRAP_CONTENT);
////            params_m.gravity = Gravity.CENTER;
//
//            ll_m.setLayoutParams(params_m);
//            ll_m.setGravity(Gravity.CENTER);
//
//            tv.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,
//                    ViewGroup.LayoutParams.WRAP_CONTENT));
//            tv.setTextSize(16);
//            tv.setText(label);
//            tv.setGravity(Gravity.CENTER);
//            tv.setBackgroundResource(R.color.white);
//            tv.setOnClickListener(this);
//
////            tv.setIsVerticalLine(false);
//
//            ImageView iv = new ImageView(context);
//            iv.setImageResource(R.mipmap.img_mentcalendar_month_sign);
//
//            ll.addView(tv);
//            ll.addView(iv);
//
//            ll_m.addView(ll);
//
//            LayoutParams params_line = new LayoutParams(40,2);
//            params_line.gravity = Gravity.CENTER;
//            ImageView line = new ImageView(context);
//            line.setLayoutParams(params_line);
//            line.setImageResource(R.color.blue);





        }
        // 当前点击按钮的宽度
        int titleWidth = mViewGroup.getChildAt(position).getMeasuredWidth();
        int nextTitleWidth = 0;
        if (position > 0) {
            // 当前点击按钮相邻右边按钮的宽度
            nextTitleWidth = position == mViewGroup.getChildCount() - 1 ? 0
                    : mViewGroup.getChildAt(position - 1).getMeasuredWidth();
        }
        DisplayMetrics dm2 = getResources().getDisplayMetrics();
//        int screenWidth = (Activity)context.getWindowManager().getDefaultDisplay().getWidth();
        int screenWidth = dm2.widthPixels;
        final int move = visiableWidth - (screenWidth - titleWidth) / 2;
        if (mPreSelectItem < position) {// 向屏幕右边移动
            if ((visiableWidth + titleWidth + nextTitleWidth) >= (screenWidth / 2)) {
                // new Handler().post(new Runnable() {
                //
                // @Override
                // public void run() {
                ((HorizontalScrollView) mViewGroup.getParent())
                        .setScrollX(move);
                // }
                // });

            }
        } else {// 向屏幕左边移动
            if ((scrollViewWidth - visiableWidth) >= (screenWidth / 2)) {
                ((HorizontalScrollView) mViewGroup.getParent())
                        .setScrollX(move);
            }
        }
        mPreSelectItem = position;


    }

    private void addViewPagerView(ArrayList<String> mTabItems,boolean[] months) {

        for (int i = 0; i < mTabItems.size(); i++) {

            String label = mTabItems.get(i);

            LayoutParams params = new LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,ViewGroup.LayoutParams.WRAP_CONTENT);
            params.setMargins(0,15,0,15);

            LinearLayout ll_m = new LinearLayout(context);
//            ll_m.setLayoutParams(params_m);
            ll_m.setOrientation(LinearLayout.VERTICAL);

            LinearLayout ll = new LinearLayout(context);
            ll.setLayoutParams(params);
            ll.setOrientation(LinearLayout.HORIZONTAL);



            NewsTitleTextView tv = new NewsTitleTextView(context);
            int itemWidth = (int) tv.getPaint().measureText(label);

            LayoutParams params_m = new LayoutParams((itemWidth * 2),
                    ViewGroup.LayoutParams.WRAP_CONTENT);
//            params_m.gravity = Gravity.CENTER;

            ll_m.setLayoutParams(params_m);
            ll_m.setGravity(Gravity.CENTER);

            tv.setLayoutParams(new LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT));
            tv.setTextSize(16);
            tv.setText(label);
            tv.setGravity(Gravity.CENTER);
            tv.setBackgroundResource(R.color.white);
            ll_m.setOnClickListener(this);

//            tv.setIsVerticalLine(false);

            ImageView iv = new ImageView(context);
            iv.setImageResource(R.mipmap.img_mentcalendar_month_sign);

            ll.addView(tv);
            if(months!=null){
                if(months[i]){
                    ll.addView(iv);
                }
            }



            ll_m.addView(ll);

            LayoutParams params_line = new LayoutParams(50,2);
            params_line.gravity = Gravity.CENTER;
            ImageView line = new ImageView(context);
            line.setLayoutParams(params_line);
            line.setImageResource(R.color.blue);
            ll_m.addView(line);
            if (i == 0) {
//                tv.setTextColor(getResources().getColor(R.color.gray_d));
//                tv.setIsHorizontaline(false);
                line.setVisibility(VISIBLE);
            } else {
//                tv.setTextColor(getResources().getColor(R.color.gray_d));
//                tv.setIsHorizontaline(false);
//                ll_m.addView(line);
                line.setVisibility(GONE);
            }

            mViewGroup.addView(ll_m);
        }


    }

}
