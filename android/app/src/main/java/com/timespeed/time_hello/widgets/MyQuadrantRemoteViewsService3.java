package com.timespeed.time_hello.widgets;

import android.content.Intent;
import android.widget.RemoteViewsService;

import com.timespeed.time_hello.Params.CONSTANTS;

import java.util.List;

public class MyQuadrantRemoteViewsService3 extends RemoteViewsService {
    private List mData;
    int priority = 1;

    @Override
    public RemoteViewsFactory onGetViewFactory(Intent intent) {
        mData = intent.getParcelableArrayListExtra(CONSTANTS.BROADCAST_DATA1);
        priority = intent.getIntExtra(CONSTANTS.BROADCAST_PRIORIY, 1);
        return new MyRemoteViewsFactory(this.getApplicationContext(), mData, priority);
    }
}

