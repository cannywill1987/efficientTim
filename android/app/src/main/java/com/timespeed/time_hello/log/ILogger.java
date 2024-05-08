package com.timespeed.time_hello.log;/*
 * Copyright 2000-2013 远光软件股份有限公司 All Rights Reserved.
 */

/**
 * 日志接口，可以通过 {@link LoggerFactory}获取日志接口的实例.<br>
 * 共有6种日志级别，顺序如下:<br>
 * <ol>
 * <li>trace (最低级别)</li>
 * <li>debug</li>
 * <li>info</li>
 * <li>warn</li>
 * <li>error</li>
 * <li>fatal (最高级别)</li>
 * </ol>
 * 为提高性能，避免不必要的性能损耗，推荐在记录日志前判断对应的日志级别是否启用.
 * <p>
 * 举例如下, <code><pre>
 *    if (log.isDebugEnabled()) {
 *        log.debug(theResult);
 *    }
 * </pre></code>
 * </p>
 */
public interface ILogger {

	/**
	 * 打印警告信息 . <br>
	 * @param msg 信息内容
	 */
	void warn(final String msg);

	/**
	 * 打印调试信息 . <br>
	 * @param msg 信息内容
	 */
	void debug(final String msg);

	/**
	 * 打印错误信息 . <br>
	 * @param msg 信息内容
	 */
	void error(final String msg);

	/**
	 * 打印基本信息 . <br>
	 * @param msg 信息内容
	 */
	void info(final String msg);

	/**
	 * 打印信息 . <br>
	 * @param msg 信息内容
	 */
	void verbose(final String msg);

}
