package com.timespeed.time_hello.model;

import android.os.Parcel;
import android.os.Parcelable;

import androidx.annotation.NonNull;

public class MissionModel implements Parcelable {
    String folder_id; //folderModel的ObjectId
    //博客作者
    String title = ""; //标题

    int indexSearchingStart = -1; //不存储 用于搜索

    int indexSearchingEnd = -1; //不存储 用于搜索

    String device_id; //设备Id

    String tagNames; //通过逗号,分割

    String tagIds; //通过逗号,分割

    String background_url; //背景url

    int no_tomotoes_finished = 0; //完成番茄的数量

    int total_tomotoes; //总番茄数

    int tomato_duration = 0; //每个任务的默认番茄时间 默认25分钟 单位ms 来着sharepreference

    int order_index; //顺序，好像用不上

    int end_time_before_finished; //不用了 isFinish=false为空 true则为完成任务前end_time设置的时间 end_time变成真实时间 方便initCalendar计算end_time值，这个则是方便用来展示任务完成时了解到的预置时间

    int end_time; //设置的预期完成时间 默认空是0 isFinished = false 计划到期日 isFinished = true 实际到期日

    int finish_time; //最后完成任务的真实事件

    int alert_time; //通知推送时间 年 月 日 时 分 秒

    int time_finished = 0; // 已经完成的时间 用于statistic 的时间统计

    int dateStatus; // 0 今天 1 明天 2 7天后 3待定

    int priorityStatus; //3 无优先级  2 低优先级 1 中优先级 0 高优先级

    int daily_start_time; //每日开始时间

    int daily_end_time; //每日结束时间

    String message;
    //是否完成
    boolean isFinished = false;
    //是否延期
    boolean isDelayed = false; // repetiveType 0 为0时是否有延期完成任务

    int repetiveType = 0; // 0关闭重复 1 按天重复 2 按周重复 3 按月重复 4 按年重复 如果0 关闭 end_time不会作用 重复拥有更高优先级
    int repetiveValue = 0; //天 月 年
//    List repetiveWeekDay = [false, false, false, false, false, false, false, ];
    String uid;
    
    Boolean shouldShowRedFocusStatus;

    protected MissionModel(Parcel in) {
        folder_id = in.readString();
        title = in.readString();
        indexSearchingStart = in.readInt();
        indexSearchingEnd = in.readInt();
        device_id = in.readString();
        tagNames = in.readString();
        tagIds = in.readString();
        background_url = in.readString();
        no_tomotoes_finished = in.readInt();
        total_tomotoes = in.readInt();
        tomato_duration = in.readInt();
        order_index = in.readInt();
        end_time_before_finished = in.readInt();
        end_time = in.readInt();
        finish_time = in.readInt();
        alert_time = in.readInt();
        time_finished = in.readInt();
        dateStatus = in.readInt();
        priorityStatus = in.readInt();
        daily_start_time = in.readInt();
        daily_end_time = in.readInt();
        message = in.readString();
        isFinished = in.readByte() != 0;
        isDelayed = in.readByte() != 0;
        repetiveType = in.readInt();
        repetiveValue = in.readInt();
        uid = in.readString();
        byte tmpShouldShowRedFocusStatus = in.readByte();
        shouldShowRedFocusStatus = tmpShouldShowRedFocusStatus == 0 ? null : tmpShouldShowRedFocusStatus == 1;
    }

    public static final Creator<MissionModel> CREATOR = new Creator<MissionModel>() {
        @Override
        public MissionModel createFromParcel(Parcel in) {
            return new MissionModel(in);
        }

        @Override
        public MissionModel[] newArray(int size) {
            return new MissionModel[size];
        }
    };

    public String getFolder_id() {
        return folder_id;
    }

    public void setFolder_id(String folder_id) {
        this.folder_id = folder_id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getIndexSearchingStart() {
        return indexSearchingStart;
    }

    public void setIndexSearchingStart(int indexSearchingStart) {
        this.indexSearchingStart = indexSearchingStart;
    }

    public int getIndexSearchingEnd() {
        return indexSearchingEnd;
    }

    public void setIndexSearchingEnd(int indexSearchingEnd) {
        this.indexSearchingEnd = indexSearchingEnd;
    }

    public String getDevice_id() {
        return device_id;
    }

    public void setDevice_id(String device_id) {
        this.device_id = device_id;
    }

    public String getTagNames() {
        return tagNames;
    }

    public void setTagNames(String tagNames) {
        this.tagNames = tagNames;
    }

    public String getTagIds() {
        return tagIds;
    }

    public void setTagIds(String tagIds) {
        this.tagIds = tagIds;
    }

    public String getBackground_url() {
        return background_url;
    }

    public void setBackground_url(String background_url) {
        this.background_url = background_url;
    }

    public int getNo_tomotoes_finished() {
        return no_tomotoes_finished;
    }

    public void setNo_tomotoes_finished(int no_tomotoes_finished) {
        this.no_tomotoes_finished = no_tomotoes_finished;
    }

    public int getTotal_tomotoes() {
        return total_tomotoes;
    }

    public void setTotal_tomotoes(int total_tomotoes) {
        this.total_tomotoes = total_tomotoes;
    }

    public int getTomato_duration() {
        return tomato_duration;
    }

    public void setTomato_duration(int tomato_duration) {
        this.tomato_duration = tomato_duration;
    }

    public int getOrder_index() {
        return order_index;
    }

    public void setOrder_index(int order_index) {
        this.order_index = order_index;
    }

    public int getEnd_time_before_finished() {
        return end_time_before_finished;
    }

    public void setEnd_time_before_finished(int end_time_before_finished) {
        this.end_time_before_finished = end_time_before_finished;
    }

    public int getEnd_time() {
        return end_time;
    }

    public void setEnd_time(int end_time) {
        this.end_time = end_time;
    }

    public int getFinish_time() {
        return finish_time;
    }

    public void setFinish_time(int finish_time) {
        this.finish_time = finish_time;
    }

    public int getAlert_time() {
        return alert_time;
    }

    public void setAlert_time(int alert_time) {
        this.alert_time = alert_time;
    }

    public int getTime_finished() {
        return time_finished;
    }

    public void setTime_finished(int time_finished) {
        this.time_finished = time_finished;
    }

    public int getDateStatus() {
        return dateStatus;
    }

    public void setDateStatus(int dateStatus) {
        this.dateStatus = dateStatus;
    }

    public int getPriorityStatus() {
        return priorityStatus;
    }

    public void setPriorityStatus(int priorityStatus) {
        this.priorityStatus = priorityStatus;
    }

    public int getDaily_start_time() {
        return daily_start_time;
    }

    public void setDaily_start_time(int daily_start_time) {
        this.daily_start_time = daily_start_time;
    }

    public int getDaily_end_time() {
        return daily_end_time;
    }

    public void setDaily_end_time(int daily_end_time) {
        this.daily_end_time = daily_end_time;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isFinished() {
        return isFinished;
    }

    public void setFinished(boolean finished) {
        isFinished = finished;
    }

    public boolean isDelayed() {
        return isDelayed;
    }

    public void setDelayed(boolean delayed) {
        isDelayed = delayed;
    }

    public int getRepetiveType() {
        return repetiveType;
    }

    public void setRepetiveType(int repetiveType) {
        this.repetiveType = repetiveType;
    }

    public int getRepetiveValue() {
        return repetiveValue;
    }

    public void setRepetiveValue(int repetiveValue) {
        this.repetiveValue = repetiveValue;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public Boolean getShouldShowRedFocusStatus() {
        return shouldShowRedFocusStatus;
    }

    public void setShouldShowRedFocusStatus(Boolean shouldShowRedFocusStatus) {
        this.shouldShowRedFocusStatus = shouldShowRedFocusStatus;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(@NonNull Parcel dest, int flags) {
        dest.writeString(folder_id);
        dest.writeString(title);
        dest.writeInt(indexSearchingStart);
        dest.writeInt(indexSearchingEnd);
        dest.writeString(device_id);
        dest.writeString(tagNames);
        dest.writeString(tagIds);
        dest.writeString(background_url);
        dest.writeInt(no_tomotoes_finished);
        dest.writeInt(total_tomotoes);
        dest.writeInt(tomato_duration);
        dest.writeInt(order_index);
        dest.writeInt(end_time_before_finished);
        dest.writeInt(end_time);
        dest.writeInt(finish_time);
        dest.writeInt(alert_time);
        dest.writeInt(time_finished);
        dest.writeInt(dateStatus);
        dest.writeInt(priorityStatus);
        dest.writeInt(daily_start_time);
        dest.writeInt(daily_end_time);
        dest.writeString(message);
        dest.writeByte((byte) (isFinished ? 1 : 0));
        dest.writeByte((byte) (isDelayed ? 1 : 0));
        dest.writeInt(repetiveType);
        dest.writeInt(repetiveValue);
        dest.writeString(uid);
        dest.writeByte((byte) (shouldShowRedFocusStatus == null ? 0 : shouldShowRedFocusStatus ? 1 : 2));
    }
}