/*
 * CodeConvert.h
 *
 *  Created on: 2014-4-25
 *      Author: ppp
 */

#ifndef CODECONVERT_H_
#define CODECONVERT_H_

typedef unsigned long       DWORD;
typedef int                 INT;
typedef unsigned char       BYTE;
typedef unsigned short      WORD;


class CodeConvert {
public:
	CodeConvert();
	virtual ~CodeConvert();
public:
	/*
	功能：将UCS4编码转换成UTF8编码
	参数：
		dwUCS4：要转换的UCS4编码
		pbUTF8：用于存储转换后的UTF8编码。设为NULL，可以获取长度信息（字节数）
	返回值：
		  0：无效的UCS4编码
		1-6：UTF8编码的有效长度
	*/
	static INT UCS4_To_UTF8( DWORD dwUCS4, BYTE* pbUTF8 );

	/*
	功能：将UTF8编码转换成UCS4编码
	参数：
		pbUTF8：要转换的UTF8编码
		dwUCS4：存储转换后的UCS4编码
	返回值：
		  0：参数错误或无效的UTF8编码
		1-6：UTF8编码的有效长度
	*/
	static INT UTF8_To_UCS4( const BYTE* pbUTF8, DWORD& dwUCS4 );

	/*
	功能：将UCS4编码转换成UTF16编码
	参数：
		dwUCS4：要转换的UCS4编码
		pwUTF16：用于存储转换后的UTF16编码。设为NULL，可以获取长度信息（字符数）
	返回值：
		0：无效的UCS4编码
		1：转换成1个UTF16编码
		2：转换成2个UTF16编码
	*/
	static INT UCS4_To_UTF16( DWORD dwUCS4, WORD* pwUTF16 );

	/*
	功能：将UTF16编码转换成UCS4编码
	参数：
		pwUTF16：需要转换的UTF16编码
		dwUCS4：存储转换后的UCS4编码
	返回值：
		0：参数错误或无效的UTF16编码
		1：1个UTF16编码被转换
		2：2个UTF16编码被转换
	*/
	static INT UTF16_To_UCS4( const WORD* pwUTF16, DWORD& dwUCS4 );

	/*
	功能：将UTF8字符串转换成UTF16字符串
	参数：
		pbszUTF8Str：需要转换的UTF8字符串
		pwszUTF16Str：存储转换后的UTF16字符串。设为NULL，可以获取所需长度信息（字符数）
	返回值：
		 0：转换失败
		>0：UTF16字符串长度
	*/
	static INT UTF8Str_To_UTF16Str( const BYTE* pbszUTF8Str, WORD* pwszUTF16Str );
	static INT UTF8Str_To_UTF32Str( const BYTE* pbszUTF8Str, wchar_t* pwszUTF32Str );
    
    

	/*
	功能：将UTF16字符串转换成UTF8字符串
	参数：
		pwszUTF16Str：需要转换的UTF16字符串
		pbszUTF8Str：存储转换后的UTF8字符串。设为NULL，可以获取所需长度信息（字节数）
	返回值：
		 0：转换失败
		>0：UTF8字符串长度（不包括NULL字符）
	*/
	static INT UTF16Str_To_UTF8Str( const WORD* pwszUTF16Str, BYTE* pbszUTF8Str );

	static INT UTF32Str_To_UTF8Str( const wchar_t* pwszUTF16Str, BYTE* pbszUTF8Str );
};

#endif /* CODECONVERT_H_ */
