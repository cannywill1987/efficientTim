package com.timespeed.time_hello.model;

public class Task {
    private String title;
    private int iconResId;
    private boolean[] status; // 一周的状态
    private int colorResId;

    public Task(String title, int iconResId, boolean[] status, int colorResId) {
        this.title = title;
        this.iconResId = iconResId;
        this.status = status;
        this.colorResId = colorResId;
    }

    public String getTitle() {
        return title;
    }

    public int getIconResId() {
        return iconResId;
    }

    public boolean[] getStatus() {
        return status;
    }

    public int getColorResId() {
        return colorResId;
    }

    public void toggleStatus(int dayIndex) {
        status[dayIndex] = !status[dayIndex];
    }
}
