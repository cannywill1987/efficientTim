package com.timespeed.time_hello.widgets;

import android.content.Intent;
import android.widget.RemoteViewsService;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.timespeed.time_hello.Params.CONSTANTS;
import com.timespeed.time_hello.util.SharePreferenceUtil;


import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class MyClockInRemoteViewsService2 extends RemoteViewsService {
    private List mData;
    int priority = 1;

    @Override
    public RemoteViewsFactory onGetViewFactory(Intent intent) {
        mData = intent.getParcelableArrayListExtra(CONSTANTS.BROADCAST_DATA1);
        ArrayList array1 = SharePreferenceUtil.getInstance(this).getModelsArray(CONSTANTS.BROADCAST_FLOMO_MODELS);
        for (int i = 0; i < array1.size(); i++) {
            JSONObject item = (JSONObject) array1.get(i);
            long time = item.getLong("time");
            //time毫秒时间戳， 转换成date判断如果是今天
            Date date = new Date(time);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String today = sdf.format(new Date());
            String timestampDate = sdf.format(date);
            if (today.equals(timestampDate)) {
                // The timestamp is from today
                JSONArray jsonArray = (JSONArray) item.get("data");
                return new MyClockInView2Factory(this.getApplicationContext(), jsonArray);
            }

        }
        return new MyClockInView2Factory(this.getApplicationContext(), new JSONArray());

    }
}

