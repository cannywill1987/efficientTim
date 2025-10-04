package com.timespeed.time_hello.log;


public class Logs {
	
	public static void v(String tag,String msg){
		Logger logger = new Logger(tag);
		logger.verbose(msg);
	}
	
	public static void d(String tag,String msg){
		Logger logger = new Logger(tag);
		logger.debug(msg);
	}
	public static void i(String tag,String msg){
		Logger logger = new Logger(tag);
		logger.info(msg);
	}
	public static void w(String tag,String msg){
		Logger logger = new Logger(tag);
		logger.warn(msg);
	}
	public static void e(String tag,String msg){
		Logger logger = new Logger(tag);
		logger.error(msg);
	}
}
