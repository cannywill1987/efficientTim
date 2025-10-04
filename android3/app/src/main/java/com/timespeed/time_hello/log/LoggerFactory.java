package com.timespeed.time_hello.log;/*
 * Copyright 2000-2020 YGSoft.Inc All Rights Reserved.
 */

/**
 * 日志工厂类.<br>
 * 本工厂类通过getLog方法获取日志接口.
 */

public final class LoggerFactory {
	/**
	 *LoggerFactory  . <br>
	 */
	private LoggerFactory() {
	}

 
	
	/**
	 * 获取默认日志处理的方法 . <br>
	 * @return ILogger
	 */
	public static ILogger getLog() {
		return new Logger("log");
	}
	
	/**
	 * 根据名称获取日志接口.
	 * @param name 类名,不能使用class.getName,要自己在类上定义一个TAG变量,并赋值为类名如本类,传入"LoggerFactory"
	 * @return 日志接口
	 */
	public static ILogger getLog(final String name) {
		return new Logger(name);
	}
}
