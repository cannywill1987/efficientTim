package com.timespeed.time_hello.widgets;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.timespeed.time_hello.R;
import com.timespeed.time_hello.model.MissionModel;

import java.text.SimpleDateFormat;
import java.util.List;

/**
 * lzb
 * 优惠券
 */

class MyQuadrantAdapter extends BaseAdapter implements View.OnClickListener {
    List<MissionModel> dataList;
    Context context;
    LayoutInflater mLayoutInflater;

    public MyQuadrantAdapter(Context context, List<MissionModel> dataList) {
        super();
        this.dataList = dataList;
        this.context = context;
        mLayoutInflater = LayoutInflater.from(context);
    }

    @Override
    public int getCount() {
        // TODO Auto-generated method stub
        //			return dataList.size();
        return dataList.size();
    }

    @Override
    public Object getItem(int position) {
        // TODO Auto-generated method stub
        return position;
    }

    @Override
    public long getItemId(int position) {
        // TODO Auto-generated method stub
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        // TODO Auto-generated method stub
        ViewHolder viewHolder = null;
        if (convertView == null) {
            convertView = mLayoutInflater.inflate(R.layout.item_listview_quadrant, null);
            viewHolder = new ViewHolder();
            viewHolder.mRelativeLayoutItem = (RelativeLayout) convertView.findViewById(R.id.relativelayout_container);
            viewHolder.textViewTitle = (TextView) convertView.findViewById(R.id.textView_title);
//            viewHolder.textViewNum1 = (TextView) convertView.findViewById(R.id.textview_num1);
//            viewHolder.textViewNum2 = (TextView) convertView.findViewById(R.id.textview_num2);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
//			MissionModel MissionModel = dataList.get(position);
//			viewHolder.mRelativeLayoutItem.setOnClickListener(this);
//			viewHolder.mRelativeLayoutItem.setTag(MissionModel);
//			viewHolder.textViewTitle.setText("帐号" + MissionModel.getEventType() + "");
//			viewHolder.textViewSubTitle.setText("密码" +MissionModel.getSceneType() + "");
//			viewHolder.textViewDate.setText(" 登录于" + MissionModel.getNetworkType() + "环境");
        return convertView;
    }


    public List<MissionModel> getDataList() {
        return dataList;
    }

    //
    public void setDataList(List<MissionModel> dataList) {
        this.dataList = dataList;
    }

    @Override
    public void onClick(View v) {
        // TODO Auto-generated method stub
    }

    static class ViewHolder {
        RelativeLayout mRelativeLayoutItem;
        TextView textViewTitle;
        TextView textViewNum1;
        TextView textViewNum2;
    }

}


