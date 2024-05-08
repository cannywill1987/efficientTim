package com.timespeed.time_hello.model;

import android.os.Parcel;
import android.os.Parcelable;

public class CounterStatusModel implements Parcelable {
    String title;
    String text;
    int status;
    int delay;
    Boolean shouldShowRedFocusStatus;

    public CounterStatusModel(String title, String text, int status, Boolean shouldShowRedFocusStatus) {
        this.title = title;
        this.text = text;
        this.status = status;
        this.shouldShowRedFocusStatus = shouldShowRedFocusStatus;
    }

    public CounterStatusModel(String title, String text, int status, Boolean shouldShowRedFocusStatus, int delay) {
        this.title = title;
        this.text = text;
        this.status = status;
        this.delay = delay;
        this.shouldShowRedFocusStatus = shouldShowRedFocusStatus;
    }

    public CounterStatusModel() {
        this.title = "";
        this.text = "";
        this.status = 0;
        this.delay = 0;
        this.shouldShowRedFocusStatus = true;
    }

    public int getDelay() {
        return delay;
    }

    public void setDelay(int delay) {
        this.delay = delay;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Boolean getShouldShowRedFocusStatus() {
        return shouldShowRedFocusStatus;
    }

    public void setShouldShowRedFocusStatus(Boolean shouldShowRedFocusStatus) {
        this.shouldShowRedFocusStatus = shouldShowRedFocusStatus;
    }

    protected CounterStatusModel(Parcel in) {
        title = in.readString();
        text = in.readString();
        status = in.readInt();
        delay = in.readInt();
        byte tmpShouldShowRedFocusStatus = in.readByte();
        shouldShowRedFocusStatus = tmpShouldShowRedFocusStatus == 0 ? null : tmpShouldShowRedFocusStatus == 1;
    }

    public static final Creator<CounterStatusModel> CREATOR = new Creator<CounterStatusModel>() {
        @Override
        public CounterStatusModel createFromParcel(Parcel in) {
            return new CounterStatusModel(in);
        }

        @Override
        public CounterStatusModel[] newArray(int size) {
            return new CounterStatusModel[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(title);
        dest.writeString(text);
        dest.writeInt(status);
        dest.writeInt(delay);
        dest.writeByte((byte) (shouldShowRedFocusStatus == null ? 0 : shouldShowRedFocusStatus ? 1 : 2));
    }
}