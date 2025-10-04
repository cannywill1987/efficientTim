package com.timespeed.time_hello.widgets;

import android.content.Context;
import android.content.Intent;
import android.widget.RemoteViews;
import android.widget.RemoteViewsService;

import com.timespeed.time_hello.Params.CONSTANTS;
import com.timespeed.time_hello.R;
import com.timespeed.time_hello.util.SharePreferenceUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

class MyRemoteViewsFactory implements RemoteViewsService.RemoteViewsFactory {
    private List mData;
    private Context mContext;
    int priority = 1;

    public MyRemoteViewsFactory(Context context, List<String> mData, int priority) {
        this.mContext = context;
        this.mData = mData;
        this.priority = priority;
    }

    public MyRemoteViewsFactory(Context context) {
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

    @Override
    public RemoteViews getViewAt(int position) {
        RemoteViews rv;
        try {
            if (this.priority == 1) {
                rv = new RemoteViews(mContext.getPackageName(), R.layout.item_listview_quadrant1);
            } else if (this.priority == 2) {
                rv = new RemoteViews(mContext.getPackageName(), R.layout.item_listview_quadrant2);
            } else if (this.priority == 3) {
                rv = new RemoteViews(mContext.getPackageName(), R.layout.item_listview_quadrant3);
            } else {
                rv = new RemoteViews(mContext.getPackageName(), R.layout.item_listview_quadrant4);
            }
//            HashMap hashMap = (HashMap) mData.get(position);
            rv.setTextViewText(R.id.textView_title, (CharSequence) ((HashMap) mData.get(position)).get("title"));
            return rv;
        } catch(Exception e) {

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