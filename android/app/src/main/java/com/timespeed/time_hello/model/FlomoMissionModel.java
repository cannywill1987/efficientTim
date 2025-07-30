package com.timespeed.time_hello.model;

import android.os.Parcel;
import android.os.Parcelable;

import androidx.annotation.NonNull;

class FlomoMissionModel  implements Parcelable  {
   String id; //folderModel的ObjectId
   //博客作者
   String title = ""; //标题

   int color = 0; //不存储 用于搜索

   boolean isFinished = false;

   double percent = 0; //不存储 用于搜索

   protected FlomoMissionModel(Parcel in) {
      id = in.readString();
      title = in.readString();
      color = in.readInt();
      isFinished = in.readByte() != 0;
      percent = in.readFloat();
   }

   public static final Parcelable.Creator<FlomoMissionModel> CREATOR = new Parcelable.Creator<FlomoMissionModel>() {
      @Override
      public FlomoMissionModel createFromParcel(Parcel in) {
         return new FlomoMissionModel(in);
      }

      @Override
      public FlomoMissionModel[] newArray(int size) {
         return new FlomoMissionModel[size];
      }
   };

   public String getId() {
      return id;
   }

   public void setId(String id) {
      this.id = id;
   }

   public String getTitle() {
      return title;
   }

   public void setTitle(String title) {
      this.title = title;
   }

   public Boolean getIsFinished() {
      return isFinished;
   }

   public void setIsFinished(Boolean IsFinished) {
      this.isFinished = IsFinished;
   }

   @Override
   public int describeContents() {
      return 0;
   }

   @Override
   public void writeToParcel(@NonNull Parcel dest, int flags) {
      dest.writeString(id);
      int color = 0; //不存储 用于搜索
      dest.writeString(title);
      dest.writeInt(color);
      dest.writeByte((byte) (isFinished ? 1 : 0));
      dest.writeDouble(percent);
   }
}
