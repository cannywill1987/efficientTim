package com.timespeed.time_hello.customInterface;

public interface OnLoginListener {
    public void onComplete(String data);
    public void onFailure();
    public void onCancel();
    public void onOtherLogin();
}
