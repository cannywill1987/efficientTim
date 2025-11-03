package com.timespeed.time_hello.util;/*
 * Copyright 2000-2020 YGSoft.Inc All Rights Reserved.
 */

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.RandomAccessFile;

/**
 * 基本使用的是JAVA IO的方法进行文件的操作 .<br>
 * @version 1.0.0 2012-8-2<br>
 * @see
 * @since JDK 1.4.2.6
 */
public final class JFileUtil {
 
	/**
	 * FileUtil . <br>
	 */
	private JFileUtil() {
	}

	/**
	 * 把字符串数据写入到指定的完整目录文件上 . <br>
	 * @param data 数据内容
	 * @param path 完整路径
	 * @param unio 编码"utf-8"之类的
	 * @param append 是否追加
	 * @throws IOException IO错误
	 */
	public static void writeDataToFile(final String data, final String path, final String unio, final boolean append)
			throws IOException {
		OutputStreamWriter osw;
		final File file = new File(path);
		if (!append) {
			delFile(path);
		}
		if (!checkFileExists(path)) {
			file.createNewFile();
		}
		osw = new OutputStreamWriter(new FileOutputStream(file, append), unio);
		osw.write(data);
		osw.close();

	}
	
	/**
	 * 写文本内容到文件. <br>
	 * @param fileName 文件全路径.
	 * @param context 待写入的文本.
	 */
	public static boolean writeTextFile(final String fileName, final String context) {
		final File file = new File(fileName);
		/*try {
			final BufferedWriter output = new BufferedWriter(new FileWriter(file));
			output.write(context);
			output.close();
		} catch (Exception e) {
			e.printStackTrace();
		}*/
		RandomAccessFile randomAccessFile = null;
		try {
			// 文件存在
			if (file.exists()) {
				randomAccessFile = new RandomAccessFile(file, "rw");
			} else { // 文件不存在

				// 判断父目录是否存在
				final File p = file.getParentFile();
				boolean isOk = false;
				if (p != null && !p.exists()) { // 目录不存在创建

					isOk = p.mkdirs();
				} else if (p != null && p.exists()) { // 目录存在

					isOk = true;
				}
				if (isOk) {
					final boolean isSucess = file.createNewFile();
					if (isSucess) {
						randomAccessFile = new RandomAccessFile(file, "rw");
					}
				}
			}
			if (null != randomAccessFile) {
				long len = randomAccessFile.length();
				if(len > 262144) { //256K 大于256K 删除文件
					file.delete();
					randomAccessFile = new RandomAccessFile(file, "rw");
					len = 0;
				}
				randomAccessFile.seek(len);
				randomAccessFile.write(context.getBytes());
				randomAccessFile.close();
				return true;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return false;
	}
	
	/**
	 * 多线程读写的时候需要注意，外部的方法需要同步 . <br>
	 * @param fileFullPath 写入的文件路径
	 * @param pBuf 写入文件的缓存
	 * @return 如果文件及路径不存在将创建文件
	 */
	public static boolean write(final String fileFullPath, final byte[] pBuf) {
		return write(fileFullPath, pBuf, 0, pBuf.length, 0);
	}

	/**
	 * 多线程读写的时候需要注意，外部的方法需要同步. <br>
	 * @param fileFullPath 写入的文件路径
	 * @param pBuf 写入文件的缓存
	 * @param pos 缓存起始位置
	 * @param size 写入字节数
	 * @param skip 文件跳跃字节数
	 * @return 如果文件及路径不存在将创建文件
	 */
	public static boolean write(final String fileFullPath, final byte[] pBuf, final int pos, final int size,
			final int skip) {
		final File file = new File(fileFullPath);
		RandomAccessFile randomAccessFile = null;
		try {
			// 文件存在
			if (file.exists()) {
				randomAccessFile = new RandomAccessFile(file, "rw");
			} else { // 文件不存在

				// 判断父目录是否存在
				final File p = file.getParentFile();
				boolean isOk = false;
				if (p != null && !p.exists()) { // 目录不存在创建

					isOk = p.mkdirs();
				} else if (p != null && p.exists()) { // 目录存在

					isOk = true;
				}
				if (isOk) {
					final boolean isSucess = file.createNewFile();
					if (isSucess) {
						randomAccessFile = new RandomAccessFile(file, "rw");
					}
				}
			}
			if (null != randomAccessFile) {
				randomAccessFile.seek(skip);
				randomAccessFile.write(pBuf, pos, size);
				randomAccessFile.close();
				return true;
			}
		} catch (Exception ex) {
		}
		return false;
	}

	/**
	 * 一行一行的读取,注意如果文本较大的时候要小心使用. <br>
	 * @param path 完整路径
	 * @param unio 编码
	 * @return 读取的字符串
	 * @throws IOException IO错误
	 */
	public static String readFileData(final String path, final String unio) throws IOException {
		final InputStreamReader isr = new InputStreamReader(new FileInputStream(path), unio);
		final BufferedReader br = new BufferedReader(isr);
		final StringBuilder str = new StringBuilder();
		while (br.ready()) {
			str.append(br.readLine());
		}
		br.close();
		isr.close();
		return str.toString();

	}

	/**
	 * 以流的方式,读取一个文件的字节 . <br>
	 * @param fileFullPath 读取文件路径
	 * @return 返回整个文件数据 流
	 */
	public static byte[] readFilebyte(final String fileFullPath) {
		final File file = getFileObject(fileFullPath);
		if (file != null && file.exists()) {
			try {
				FileInputStream fis = new FileInputStream(file);
				final int readSize = fis.available();
				final byte[] buff = new byte[readSize];
				fis.read(buff);
				fis.close();
				fis = null;
				return buff;
			} catch (Exception ex) {
			}
		}
		return null;
	}

	
	/**
	 * 删除文件 . <br>
	 * @param path 完整路径
	 * @return 是否删除成功
	 */
	public static boolean delFile(final String path) {
		if (path != null && !"".equals(path)) {
			final File f = new File(path);
			if (f != null && f.isFile()) {
				return f.delete();
			}
		}
		return false;
	}

	/**
	 * 判断指定文件是否存在 . <br>
	 * @param filePath 文件路径
	 * @return 文件是否存在
	 */
	public static Boolean checkFileExists(final String filePath) {
		File f = getFileObject(filePath);
		try {
			if (f != null && f.exists() && f.isFile()) {
				return true;
			} else {
				return false;
			}
		} finally {
			f = null;
		}
	}

	/**
	 * 返回文件对像 . <br>
	 * @param filePath 要创建文件的文件路径
	 * @return File 文件对像
	 */
	public static File getFileObject(final String filePath) {
		if (filePath == null || filePath.length() <= 0) {
			return null;
		}
		return new File(filePath);
	}




 
}
