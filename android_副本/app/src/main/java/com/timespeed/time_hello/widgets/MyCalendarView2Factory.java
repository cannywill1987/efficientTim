package com.timespeed.time_hello.widgets;

import android.content.Context;
import android.os.Build;
import android.widget.RemoteViews;
import android.widget.RemoteViewsService;

import com.alibaba.fastjson.JSONArray;
import com.timespeed.time_hello.R;

import androidx.annotation.RequiresApi;

class MyCalendarView2Factory implements RemoteViewsService.RemoteViewsFactory {
    private JSONArray mData;
    private Context mContext;
//    int priority = 1;

    public MyCalendarView2Factory(Context context, JSONArray mData) {
        this.mContext = context;
        this.mData = mData;
//        this.priority = priority;
    }

    public MyCalendarView2Factory(Context context) {
        mContext = context;
    }

    @Override
    public void onCreate() {
        // Initialize data
//        mData = new ArrayList<>();

//        mData.add("Item 1");
//        mData.add("Item 2");
//        mData.add("Item 3");
    }

    @Override
    public void onDataSetChanged() {
        // Update data if necessary
    }

    @Override
    public void onDestroy() {
        // Clean up any resources
    }

    @Override
    public int getCount() {
        return mData.size();
    }

    @RequiresApi(api = Build.VERSION_CODES.S)
    @Override
    public RemoteViews getViewAt(int position) {
        RemoteViews rv;
        try {
//            if (this.priority == 1) {
//                rv = new RemoteViews(mContext.getPackageName(), R.layout.item_listview_quadrant1);
//            } else if (this.priority == 2) {
//                rv = new RemoteViews(mContext.getPackageName(), R.layout.item_listview_quadrant2);
//            } else if (this.priority == 3) {
//                rv = new RemoteViews(mContext.getPackageName(), R.layout.item_listview_quadrant3);
//            } else {
            rv = new RemoteViews(mContext.getPackageName(), R.layout.item_listview_clockin);
//            }
//            HashMap hashMap = (HashMap) mData.get(position);
            com.alibaba.fastjson.JSONObject json = (com.alibaba.fastjson.JSONObject) mData.get(position);
            // Set the width of the screen as a percentage
//            double percent = (json).getDouble("percent");
//            int screenWidth = mContext.getResources().getDisplayMetrics().widthPixels;
//            int newWidth = (int) (screenWidth * percent); // 80% of screen width
//            rv.setViewLayoutWidth(R.id.image_bg, newWidth, TypedValue.COMPLEX_UNIT_PX);
            switch (Long.toHexString((json).getLong("color"))) {
                case "ffed7573":
                    if ((json).getBoolean("isFinished") == true) {
                        rv.setImageViewResource(R.id.image_select, R.drawable.bg_ed7573_corner);
                    }
                    rv.setImageViewResource(R.id.image_bg, R.drawable.bg_ed7573_corner_light);
                    break;
                case "fff1a068":
                    if ((json).getBoolean("isFinished") == true) {
                        rv.setImageViewResource(R.id.image_select, R.drawable.bg_f1a068_corner);
                    }
                    rv.setImageViewResource(R.id.image_bg, R.drawable.bg_f1a068_corner_light);
                    break;
                case "fff1bf6b":
                    if ((json).getBoolean("isFinished") == true) {
                        rv.setImageViewResource(R.id.image_select, R.drawable.bg_f1bf6b_corner);
                    }
                    rv.setImageViewResource(R.id.image_bg, R.drawable.bg_f1bf6b_corner_light);
                    break;
                case "ffc9e478":
                    if ((json).getBoolean("isFinished") == true) {
                        rv.setImageViewResource(R.id.image_select, R.drawable.bg_c9e478_corner);
                    }
                    rv.setImageViewResource(R.id.image_bg, R.drawable.bg_c9e478_corner_light);
                    break;
                case "ff7bd497":
                    if ((json).getBoolean("isFinished") == true) {
                        rv.setImageViewResource(R.id.image_select, R.drawable.bg_7bd497_corner);
                    }
                    rv.setImageViewResource(R.id.image_bg, R.drawable.bg_7bd497_corner_light);
                    break;
                case "ffff88ff":
                    if ((json).getBoolean("isFinished") == true) {
                        rv.setImageViewResource(R.id.image_select, R.drawable.bg_ff88ff_corner);
                    }
                    rv.setImageViewResource(R.id.image_bg, R.drawable.bg_ff88ff_corner_light);
                    break;
                case "ff6083f6":
                    if ((json).getBoolean("isFinished") == true) {
                        rv.setImageViewResource(R.id.image_select, R.drawable.bg_6083f6_corner);
                    }
                    rv.setImageViewResource(R.id.image_bg, R.drawable.bg_6083f6_corner_light);
                    break;

            }
            rv.setTextViewText(R.id.textView_title, (json).getString("title"));
            rv.setImageViewResource(R.id.imageview, (json).getBoolean("isFinished") == true ? R.drawable.btn_checked : R.drawable.btn_unchecked);
            return rv;
        } catch (Exception e) {

        }
        return new RemoteViews(mContext.getPackageName(), R.layout.item_listview_quadrant1);
    }

    @Override
    public RemoteViews getLoadingView() {
        // Return a loading view if necessary
        return null;
    }

    @Override
    public int getViewTypeCount() {
        // Return the number of view types
        return 1;
    }

    @Override
    public long getItemId(int position) {
        // Return the ID for the given position
        return position;
    }

    @Override
    public boolean hasStableIds() {
        // Return whether the IDs are stable
        return true;
    }
}