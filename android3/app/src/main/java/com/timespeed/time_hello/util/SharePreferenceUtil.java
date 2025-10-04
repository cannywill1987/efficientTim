package com.timespeed.time_hello.util;


import android.content.Context;
import android.content.SharedPreferences;


import com.alibaba.fastjson.JSON;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;


/**
 * 配置文件的相关操作
 *
 * @author
 */
public class SharePreferenceUtil {
    private static SharePreferenceUtil mSaveConfiguration = new SharePreferenceUtil();

    // 保存配置文件的路径
    private static final String mSavePath = File.separator + "smy"
            + File.separator + "info";
    // 配置文件的名字
    private static String mConfigurationName = "SettingInfo";
    private static SharedPreferences mSharedPreferences;

    public static synchronized SharePreferenceUtil getInstance(Context mContext) {
        if (mSharedPreferences == null) {
            mSharedPreferences = mContext.getSharedPreferences(mConfigurationName, Context.MODE_PRIVATE);
        }
        return mSaveConfiguration;
    }

    /**
     * 获取优先级
     * @return
     */
    public String getPriorityTitle(String priority) {
        return mSharedPreferences.getString(priority, "");
    }

    /**
     * 设置优先级
     * @return
     */
    public boolean setPriorityTitle(String priority, String val) {
        return mSharedPreferences.edit().putString(priority, val).commit();
    }

    public boolean setHashMap(String priority, HashMap val) {
        String json = JSON.toJSONString(val);
        return mSharedPreferences.edit().putString(priority, json).commit();
    }

    public HashMap getHashMap(String priority) {
        String json = mSharedPreferences.getString(priority, "");
        return JSON.parseObject(json, HashMap.class);
    }

    /**
     * 保存models
     * @return
     */
    public boolean setModelsArray(String priority, ArrayList val) {
        String json = JSON.toJSONString(val);
        return mSharedPreferences.edit().putString(priority, json).commit();
    }

    public ArrayList getModelsArray(String priority) {
        String json = mSharedPreferences.getString(priority, "");
        return JSON.parseObject(json, ArrayList.class);
    }

    public boolean setBoolean(String key, boolean val) {
        return mSharedPreferences.edit().putBoolean(key, val).commit();
    }

    public boolean getBoolean(String key, boolean defValue) {
        return mSharedPreferences.getBoolean(key, defValue);
    }

    /**
     * 设置优先级
     * @return
     */
    public boolean setPriorityArray(String priority, ArrayList val) {
        String json = JSON.toJSONString(val);
        return mSharedPreferences.edit().putString(priority, json).commit();
    }

    public ArrayList getPriorityArray(String priority) {
        String json = mSharedPreferences.getString(priority, "");
        return JSON.parseObject(json, ArrayList.class);
    }

}
