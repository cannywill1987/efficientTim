package com.timespeed.time_hello.log;/*
 * Copyright 2000-2020 YGSoft.Inc All Rights Reserved.
 */

import android.os.Environment;
import android.text.format.DateFormat;
import android.util.Log;

import com.timespeed.time_hello.Params.Params;
import com.timespeed.time_hello.log.ILogger;
import com.timespeed.time_hello.util.FileUtil;
import com.timespeed.time_hello.util.JFileUtil;

import java.io.File;
import java.io.IOException;


/**
 * 日志打印系统 
 * @see
 * @since JDK 1.4.2.6
 */
public final class Logger implements ILogger {

	/**
	 * 当前日志类的名 .
	 */
	String className;

	/**
	 * 是否显示日志.可以在系统XML配置 . <br>
	 */
	public static final boolean WRITE_LOG = Params.isDebug;

	/**
	 * 是否写入日志文件 ,这里应该进行配置. <br>
	 */
	private boolean writeFileLog = false;
	
	private final int VERBOSE = 0;
	
	private final int DEBUG = 1;
	
	private final int INFO = 2;
	
	private final int WARN = 3;
	
	private final int ERROR = 4;
	
	private final int LEVEL = WARN;

	/**
	 * Logger. <br>
	 * @param name 类名
	 */
	public Logger(final String name) {
//		className = name;
		className = "smyapp";
		File file = new File(getLogPath());
		if(file.exists() == false){
			try {
				file.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
	}
	private String getStringTime(){
		String timeStr = null;
		long time = System.currentTimeMillis();
		DateFormat df = new DateFormat();
		timeStr = df.format("yyyy MM dd HH:mm", time).toString() + " ";
		return timeStr;
		
	}
	/**
	 * 只需要路径,最后包含反斜杠,不包含文件名,文件名为默认的smylog.txt. . <br>
	 * @return 返回全路径
	 */
	public String getLogPath() {
		String path = Environment.getExternalStorageDirectory().getAbsolutePath() + "/smyapp/log";
		if (path != null && path.length() > 0) {
			if (path.lastIndexOf("/") != path.length()) {
				path += "/";
			}
		}
		File file = new File(path);
		if(file.exists() == false){
			file.mkdirs();
		}
		return path + "smylog.log";
	}

	/**
	 * 打印警告信息 . <br>
	 * @param msg 信息内容
	 */
	@Override
	public void warn(final String msg) {
		if (WRITE_LOG) {
			Log.w(className, msg);
		}
		writeMessageToFile("warn: " + className, msg,WARN);
	}

	/**
	 * 打印调试信息 . <br>
	 * @param msg 信息内容
	 */
	@Override
	public void debug(final String msg) {
		if(msg == null){
			return;
		}
		if (WRITE_LOG) {
			Log.d(className, msg);
		}
		writeMessageToFile("debug: " + className, msg,DEBUG);
	}

	/**
	 * 打印错误信息 . <br>
	 * @param msg 信息内容
	 */
	@Override
	public void error(final String msg) {
		if(msg == null){
			return;
		}
		if (WRITE_LOG) {
			Log.e(className, msg);
		}
		writeMessageToFile("error: " + className, msg,ERROR);
	}

	/**
	 * 打印基本信息 . <br>
	 * @param msg 信息内容
	 */
	@Override
	public void info(final String msg) {
		if(msg == null){
			return;
		}
		if (WRITE_LOG) {
			Log.i(className, msg);
		}
		writeMessageToFile("info: " + className, msg,INFO);
	}

	/**
	 * 打印信息 . <br>
	 * @param msg 信息内容
	 */
	@Override
	public void verbose(final String msg) {
		if(msg == null){
			return;
		}
		if (WRITE_LOG) {
			Log.v(className, msg);
		}
		writeMessageToFile("verbose: " + className, msg,VERBOSE);
	}

	/**
	 * 判断是否要写日志文件到SD卡 . <br>
	 * @param type 是什么类型的日志文件
	 */
	public void writeMessageToFile(final String type, final String content,int level) {
		if (writeFileLog && level >= LEVEL) {
			JFileUtil.writeTextFile(getLogPath(), "\r\n" + getStringTime() + type + "<" + content + ">\r\n");
		}
	}
	
	public void writeMessageToFile(final String type, final String content) {
		JFileUtil.writeTextFile(getLogPath(), "\r\n" + getStringTime() + type + "<" + content + ">\r\n");
	}

	/**
	 * 获取日志文件 . <br>
	 * @return 返回所有的日志内容
	 */
	public String getMessageFile() {
		try {
			return FileUtil.readFileData(getLogPath(), "utf-8");
		} catch (IOException e) {
			return "";
		}
	}

}
