package com.timespeed.time_hello.customInterface;

public interface OnResultListener {
    public void onComplete(Object data);
    public void onCancel();
//    public void onFailure();
    public void onFailure(Object msg);
}
