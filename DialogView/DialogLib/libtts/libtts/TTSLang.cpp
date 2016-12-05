#include <fstream>
#include <string>
#include <iostream>
#include  <sstream>
#include <cstdio>
#include <algorithm>
#include <map>
#include <stdlib.h>
#include "pcrecpp.h"
#include "pcrecpparg.h"
#include "pcre_stringpiece.h"
#include "define.h"
#include "TTSPhone.h"
#include "TTSLang.h"
#include "CodeConvert.h"
#include <mm_malloc.h>

using namespace std;
using namespace pcrecpp;


//#if !defined(WIN32)
//#include <android/log.h>
//#define LOGD(text) __android_log_write(ANDROID_LOG_DEBUG,"TtsServiceJni",text)
//#else
//#define LOGD(text)
//#endif

#define LOGD(text)

#define TRUE 1
#define FALSE 0


//#if defined(_WIN32) || defined(WIN32)
//
//#include <windows.h>
//
//std::wstring UTF8_To_Unicode(const char* str)
//{
//    if (str == NULL) return L"";
//    int nwLen = MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, str, -1, NULL, 0); 
//
//    if(nwLen == 0) return L"";
//
//    wchar_t* pwBuf = new wchar_t[nwLen + 1];
//    memset(pwBuf, 0, nwLen * 2 + 2); 
//    MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, str, -1, pwBuf, nwLen); 
//    std::wstring retStr = pwBuf;
//    delete []pwBuf; 
//    pwBuf = NULL; 
//    return retStr; 
//}
//
//std::string Unicode_To_UTF8(const std::wstring &str )
//{
//	const wchar_t * s = str.c_str();
//    if (s == NULL) return "";
//    int ansiLen = ::WideCharToMultiByte(CP_UTF8, NULL, s, -1, NULL, 0, NULL, NULL);
//    char* szAnsi = new char[ansiLen + 1];
//    memset(szAnsi, 0, ansiLen + 1);
//    ::WideCharToMultiByte(CP_UTF8, NULL, s, -1, szAnsi, ansiLen, NULL, NULL);
//    std::string retStr = szAnsi;
//    delete []szAnsi; 
//    szAnsi = NULL; 
//    return retStr; 
//}
//
//
//#else
//std::wstring UTF8_To_Unicode(const char* utf8)
//{
//	std::wstring wret;
//	if(strlen(utf8) > 0)
//	{
//		int utf16Bytes = 4 * (strlen(utf8) + 1);
//		wchar_t *utf16 = (wchar_t *)malloc(utf16Bytes);
//		if(utf16)
//		{
//			if(CodeConvert::UTF8Str_To_UTF32Str((unsigned const char *)utf8, (unsigned long *)utf16) > 0)
//				wret = utf16;
//			free(utf16);
//		}
//	}
//
//	return wret;
//}
//
//
//std::string Unicode_To_UTF8(const std::wstring &str16)
//{
//	std:;string ret = "";
//	if(str16.length() > 0)
//	{
//		int utf8Bytes = 4 * str16.length();
//		char *utf8 = (char *)malloc(utf8Bytes);
//		if(utf8)
//		{
//			if(CodeConvert::UTF32Str_To_UTF8Str((unsigned long *)str16.c_str(), (unsigned char *)utf8) > 0)
//				ret = utf8;
//			free(utf8);
//		}
//	}
//
//	return ret;
//}
//
//#define TRUE 1
//#define FALSE 0
//
//#endif

std::wstring UTF8_To_Unicode(const char* utf8)
{
    std::wstring wret;
    if(strlen(utf8) > 0)
    {
        
        unsigned long utf16Bytes = 4 * (strlen(utf8) + 1);
        int num = sizeof(long);
        //wchar_t *utf16 = (wchar_t *)malloc(utf16Bytes);
        wchar_t *utf16 = new wchar_t[utf16Bytes];
        
        if(utf16)
        {
            if(CodeConvert::UTF8Str_To_UTF32Str((unsigned const char *)utf8, utf16) > 0)
                wret = utf16;
            //free(utf16);
            delete utf16;
            utf16 = NULL;
            
            
            
        }
    }
    
    return wret;
}






std::string Unicode_To_UTF8(const std::wstring &str16)
{
    std::string ret = "";
    if(str16.length() > 0)
    {
        long int utf8Bytes = 4 * str16.length();
        //char *utf8 = (char *)malloc(utf8Bytes);
        char *utf8 = new char[utf8Bytes];
        if(utf8)
        {
//            for(int i = 0; i < str16.length(); i++) {
//                printf("%ld",(DWORD)str16[i]);
//            }
            
            if(CodeConvert::UTF32Str_To_UTF8Str(str16.c_str(), (unsigned char *)utf8) > 0)
                ret = utf8;
            //free(utf8);
            delete  utf8;
            utf8 = NULL;
            
        }
    }
    
    return ret;
}


static bool isAnsiString(std::wstring &ws)
{
	bool ret = false;

	for(int i = 0; i < ws.length(); i++)
	{

		if(!((ws.at(i) >= L'a' && ws.at(i) <= L'z') || (ws.at(i) >= L'A' && ws.at(i) <= L'Z')))
		{
			return false;;
		}

	}
	return true;
}


static bool isNumString(std::wstring &ws, bool allowPoint)
{
	bool ret = false;
	int pointCount = 0;
	int notNumCount = 0;
	for(int i = 0; i < ws.length(); i++)
	{
		if(ws.at(i) == L'.' && allowPoint)
		{
			pointCount++;
			continue;
		}
		else if(ws.at(i) >= L'0' && ws.at(i) <= L'9')
		{
			continue;
		}
		else
		{
			notNumCount++;
			break;
		}
	}

	if(notNumCount == 0 && pointCount <= 1)
		ret = true;

	return ret;
}

static bool Unicode_ToDouble(std::wstring &ws, double *pValue)
{
	bool ret = false;
	if(isNumString(ws, true))
	{
		std::string stds = Unicode_To_UTF8(ws);
		const char *s = stds.c_str();
		double value = atof(s);
		if(value != 0)
		{
			if(pValue)
				*pValue = value;
			ret = true;
		}
	}
	return ret;
}


static bool Unicode_To_Int64(std::wstring& ws, long long *pValue)
{
	bool ret = false;
	if(isNumString(ws, false))
	{
		std::string stds = Unicode_To_UTF8(ws);
		const char *s = stds.c_str();
//	#if defined(_WIN32) || defined(WIN32)
//		long long value = _atoi64(s);
//	#else
//		long long value = atoll(s);
//	#endif

        long long value = atoll(s);
		if(pValue)
			*pValue = value;
		ret = true;
	}
	return ret;
}



std::wstring& string_replace( std::wstring &strBig, const std::wstring &strsrc, const std::wstring &strdst )
{
    std::wstring::size_type pos = 0;
    std::wstring::size_type srclen = strsrc.size();
    std::wstring::size_type dstlen = strdst.size();

    while( (pos=strBig.find(strsrc, pos)) != std::string::npos )
    {
        strBig.replace( pos, srclen, strdst );
        pos += dstlen;
    }

    return strBig;
}

void split(const std::wstring& s, const std::wstring delim,std::vector< std::wstring >& ret)
{
    size_t last = 0;
    size_t index=s.find_first_of(delim,last);
    while (index!=std::string::npos)
    {
        ret.push_back(s.substr(last,index-last));
        last=index+1;
        index=s.find_first_of(delim,last);
    }
    if (index-last>0 && last<s.length())
    {
        ret.push_back(s.substr(last,index-last));
    }
}

void string_ToLower(std::wstring &SrcString)  
{  
    for (std::wstring::iterator i = SrcString.begin(); i != SrcString.end(); i++)  
    {
        if (*i >= L'A' && *i <= L'Z')
            *i = (*i) + (L'a' - L'A');
        if (*i == L' ')
            *i = L',';
       if (*i == L'\n')
            *i = L',';
    }
}  

void string_ToUpper(std::wstring &SrcString)  
{  
    for (std::wstring::iterator i = SrcString.begin(); i != SrcString.end(); i++)  
        if (*i >= L'a' && *i <= L'z')
            *i = (*i) - (L'a' - L'A');
}

void remove_Chinese_Symbol(std::wstring &SrcString)
{
    for (std::wstring::iterator i = SrcString.begin(); i != SrcString.end(); i++)  
    {
        if (*i == L'　')
            *i = L' ';
        if (*i >= 65281 && *i <= 65374)  
            *i = (*i) - (65248);  
    }
}

void ConvertSpecial_Chinese_Symbol(std::wstring &SrcString)
{
     string_replace(SrcString,L"α",L"阿尔法");
     string_replace(SrcString,L"β",L"贝塔");
     string_replace(SrcString,L"γ",L"伽马");
     string_replace(SrcString,L"δ",L"德尔塔");
     string_replace(SrcString,L"ε",L"伊普西龙");
     string_replace(SrcString,L"ζ",L"截塔");
     string_replace(SrcString,L"η",L"艾塔");
     string_replace(SrcString,L"θ",L"西塔");
     string_replace(SrcString,L"ι",L"约塔");
     string_replace(SrcString,L"κ",L"卡帕");
     string_replace(SrcString,L"λ",L"兰布达");
     string_replace(SrcString,L"μ",L"缪");
     string_replace(SrcString,L"ν",L"纽");
     string_replace(SrcString,L"ξ",L"克西");
     string_replace(SrcString,L"ο",L"奥密克戎");
     string_replace(SrcString,L"π",L"派");
     string_replace(SrcString,L"∏",L"派");

     string_replace(SrcString,L"ρ",L"肉");
     string_replace(SrcString,L"σ",L"西格马");
     string_replace(SrcString,L"Τ",L"套");
     string_replace(SrcString,L"υ",L"宇普西龙");
     string_replace(SrcString,L"φ",L"佛爱");
     string_replace(SrcString,L"χ",L"西");
     string_replace(SrcString,L"ψ",L"普西");
     string_replace(SrcString,L"ω",L"欧米伽");
     
     string_replace(SrcString,L"：",L":");

     string_replace(SrcString,L"=",L"等于");
     string_replace(SrcString,L">",L"大于");
     string_replace(SrcString,L"<",L"小于");
     string_replace(SrcString,L"△",L"三角形");
     string_replace(SrcString,L"∥",L"平行");
     string_replace(SrcString,L"±",L"正负");
     string_replace(SrcString,L"≈",L"约等于");
     string_replace(SrcString,L"⊥",L"垂直");
     string_replace(SrcString,L"≠",L"不等于");

     int lastsign = -2;
     for(int i=0; i<SrcString.size();i++)
     {
         if(SrcString.at(i) == L'~')
         {
             if(i-lastsign==1)
             {
                 SrcString.at(i) = L' ';
                 SrcString.at(lastsign) = L' ';
             }
             lastsign = i;
         }
     }
}

void ConvertUnit(std::wstring &SrcString)
{
    if(SrcString==L"℃") SrcString = L"摄氏度";

    if(SrcString==L"ly") SrcString = L"光年";
    if(SrcString==L"au") SrcString = L"天文单位";
    if(SrcString==L"km") SrcString = L"公里";
    if(SrcString==L"m") SrcString = L"米";
    if(SrcString==L"dm") SrcString = L"分米";
    if(SrcString==L"cm") SrcString = L"厘米";
    if(SrcString==L"mm") SrcString = L"毫米";
    if(SrcString==L"um") SrcString = L"微米";
    if(SrcString==L"nm") SrcString = L"纳米";
    if(SrcString==L"ft") SrcString = L"英尺";
    if(SrcString==L"in") SrcString = L"英寸";
    if(SrcString==L"mi") SrcString = L"英里";


    if(SrcString==L"km²") SrcString = L"平方公里";
    if(SrcString==L"m²") SrcString = L"平方米";
    if(SrcString==L"cm²") SrcString = L"平方厘米";
    if(SrcString==L"mm²") SrcString = L"平方毫米";

    if(SrcString==L"km³") SrcString = L"立方英里";
    if(SrcString==L"m³") SrcString = L"立方米";
    if(SrcString==L"cm³") SrcString = L"立方厘米";
    if(SrcString==L"mm³") SrcString = L"立方毫米";
 

    if(SrcString==L"g") SrcString = L"克";
    if(SrcString==L"kg") SrcString = L"千克";
    if(SrcString==L"t") SrcString = L"吨";
    if(SrcString==L"mg") SrcString = L"毫克";
    if(SrcString==L"ct") SrcString = L"克拉";

    if(SrcString==L"a") SrcString = L"安";
    if(SrcString==L"v") SrcString = L"伏";
    if(SrcString==L"kv") SrcString = L"千伏";
    if(SrcString==L"Ω") SrcString = L"欧";

    if(SrcString==L"$") SrcString = L"美元";
    if(SrcString==L"￥") SrcString = L"元";


    if(SrcString==L"m/s") SrcString = L"米每秒";
    if(SrcString==L"km/h") SrcString = L"公里每小时";
    if(SrcString==L"km/s") SrcString = L"公里每秒";

    if(SrcString==L"w") SrcString = L"瓦";
    if(SrcString==L"kw") SrcString = L"千瓦";

    if(SrcString==L"j") SrcString = L"焦";
    if(SrcString==L"kj") SrcString = L"千焦";

    if(SrcString==L"cal") SrcString = L"卡";
    if(SrcString==L"kcal") SrcString = L"千卡";

    if(SrcString==L"pa") SrcString = L"帕";

    if(SrcString==L"h") SrcString = L"小时";
    if(SrcString==L"min") SrcString = L"分";
    if(SrcString==L"s") SrcString = L"秒";
    if(SrcString==L"ms") SrcString = L"毫秒";

    if(SrcString==L"n") SrcString = L"牛";
    if(SrcString==L"n/kg") SrcString = L"牛每千克";
    if(SrcString==L"n/m") SrcString = L"牛每米";

    if(SrcString==L"l") SrcString = L"升";
    if(SrcString==L"ml") SrcString = L"毫升";
    if(SrcString==L"hz") SrcString = L"赫兹";
    if(SrcString==L"mhz") SrcString = L"兆赫";

    if(SrcString==L"g/l") SrcString = L"克每升";
    if(SrcString==L"g/ml") SrcString = L"克每毫升";
    if(SrcString==L"g/mol") SrcString = L"克每摩尔";
    if(SrcString==L"kg/mol") SrcString = L"千克每摩尔";
    if(SrcString==L"l/mol") SrcString = L"升每摩尔";
    if(SrcString==L"mol/l") SrcString = L"摩尔每升";

}


std::wstring read_file_content(string filename)
{
    std::istream *is;

    is = new std::ifstream(filename.c_str(), ios::in | ios::binary);
	if (! *is) 
		return L"";

	//load data.
	int length;
	is->seekg (0, ios::end);
	length = is->tellg();
	is->seekg (0, ios::beg);
	char* buffer = new char [length+1];
    is->read (buffer,length);
	buffer[length] = 0;
    delete is;
    
    std::wstring result =  UTF8_To_Unicode(buffer);
    delete []buffer;
    
    return result;
}

std::string Int2String2(int input)
{
    ostringstream   s; 
    s<<input;
    return s.str();
}

std::wstring Int2String(int input)
{
   std::string str = Int2String2(input);
   return UTF8_To_Unicode(str.c_str());
}





TTSLang::TTSLang(void)
{

    return;
}

TTSLang::~TTSLang(void)
{
    delete m_segmgr;
}

#ifndef ANDROID_NDK_
int TTSLang::Init(std::string path)
{
    m_segmgr = new SegmenterManager();

    int ret =  m_segmgr->init(path.c_str());
    if(ret!=0) return ret;


    /////////////////////////////////////////
    // read wordpinyin.txt
    /////////////////////////////////////////
    std::wstring content = read_file_content(path + "/wordpinyin.txt");
    //cout<<"wordpinyin.txt"<<endl;
    if(content.length() ==0) return -1;
    int linestart = 0;
    while(linestart<content.size())
    {
        int lineend = content.find('\n',linestart);
        if(lineend == std::wstring::npos) break;
        int wordstart = content.find(' ',linestart);
        std::wstring word = content.substr(linestart,wordstart - linestart);

        int delta = 0;
        if(content.at(lineend-1)=='\r')
        {
            delta = 1;
        }

        std::wstring pinyin = content.substr(wordstart+1,lineend - wordstart -1 - delta);
        if(word.length()>0)
        {
            WordPinyinMap[word] = pinyin;
        }
        linestart = lineend+1;
    }

	

    std::vector<std::wstring> contentline;
    std::vector<std::wstring>::iterator it;





        /////////////////////////////////////////
    // read charpinyin.txt
    /////////////////////////////////////////
    content = read_file_content(path + "/singlepinyin.txt");
    //cout<<"singlepinyin.txt"<<endl;
    if(content.length() ==0) return -1;
    contentline;
    split(content,L"\r\n",contentline);

    it = contentline.begin();
    while(it!= contentline.end())
    {
        if(it->length()>2)
        {
            DefaultPinyin[it->at(0)] = it->substr(2,it->length()-2);
            ValidChar.insert(it->at(0));
        }
        it++;
    }
    contentline.clear();

     
    for(int i=0;i<sizeof(PhoneDict)/sizeof(PhoneDict[0]);i++)
    {
        std::wstring contentl = PhoneDict[i];
        //string_ToLower(contentl);
        std::wstring pinyin = contentl.substr(0,contentl.find(L"\t"));
        std::wstring phones = contentl.substr(contentl.find(L"\t")+1,contentl.length());

        if(phones.length()>0)
        {
            if(phones.at(phones.length()-1)=='\t')
            {
                phones = phones.substr(0,phones.length()-1);
            }
            
            Pinyin2PhoneMap[pinyin] = phones;
        }

    }

	Pinyin2PhoneMap[L"pau"]= L"pau";
	Pinyin2PhoneMap[L"brth"]= L"brth";

 
    std::wstring ValidControlSymbol=L"'()[]{}<>《》“”‘’,.:;\\＼。，、?!%…";
    for(int i=0; i<ValidControlSymbol.length();i++)
    {
        ValidChar.insert(ValidControlSymbol.at(i));
    }

    return 0;
}
#endif

#ifdef ANDROID_NDK_
int TTSLang::InitData(const char* pDataUni, int uniLen, const char *pPinyin, int pinyinLen)
{
	LOGD("aaaa");
    m_segmgr = new SegmenterManager();
    int ret =  m_segmgr->initDataFromBuffer(pDataUni, uniLen);
    if(ret!=0) return ret;

	LOGD("bbbb");
	mWordToPinyin.init(pPinyin, pinyinLen);

	LOGD("dddd");
    std::vector<std::wstring>::iterator it;
	const char** pValidChar;
	int validCharCount = mWordToPinyin.getValidChars(&pValidChar);

	for(int i=0;i<validCharCount;i++)
    {
        std::wstring contentl = UTF8_To_Unicode(pValidChar[i]);
        ValidChar.insert(contentl.at(0));
    }

	LOGD("eeee");
    for(int i=0;i<sizeof(PhoneDict)/sizeof(PhoneDict[0]);i++)
    {
        std::wstring contentl = PhoneDict[i];
        //string_ToLower(contentl);
        std::wstring pinyin = contentl.substr(0,contentl.find(L"\t"));
        std::wstring phones = contentl.substr(contentl.find(L"\t")+1,contentl.length());

        if(phones.length()>0)
        {
            if(phones.at(phones.length()-1)=='\t')
            {
                phones = phones.substr(0,phones.length()-1);
            }
            
            Pinyin2PhoneMap[pinyin] = phones;
        }

    }
	LOGD("ffff");
	Pinyin2PhoneMap[L"pau"]= L"pau";
	Pinyin2PhoneMap[L"brth"]= L"brth";

 
    std::wstring ValidControlSymbol=L"'()[]{}<>《》“”‘’,.:;\\＼。，、?!%";
    for(int i=0; i<ValidControlSymbol.length();i++)
    {
        ValidChar.insert(ValidControlSymbol.at(i));
    }
	LOGD("gggg");
    return 0;
}
#endif

std::wstring TTSLang::remove_unknown_Symbol(std::wstring SrcString, std::wstring &UnknowSymbol)
{
    std::wstring result;
    for (std::wstring::iterator i = SrcString.begin(); i != SrcString.end(); i++)  
    {
        if(ValidChar.find(*i)!=ValidChar.end())
        {
            result.push_back(*i);

        }else
        {
            UnknowSymbol.push_back(*i);
        }
    }
    return result;
}

std::string TTSLang::GenLabel(std::wstring input)
{
    return GenLabelUTF8(Unicode_To_UTF8(input));
}

std::wstring TTSLang::removeUserLabel(std::wstring winput, std::vector<int>& vectNumLabel)
{
	int nValue = 0;
	int count = 0;
	std::wstring ret;
	int i, j;
	for(i = 0; i < winput.length(); i++)
	{
		if(winput.at(i) != L'[')
		{
			ret += winput.at(i);
			vectNumLabel.push_back(nValue);
		}
		else
		{
			int isUserLabel = 0;
			for(j = i + 1; j < winput.length(); j++)
			{
				if(winput.at(j) ==  L']')
				{
					isUserLabel = 1;
					break;
				}
				else if(winput.at(j) > 0x80)
				{
					break;
				}
			}
			if(isUserLabel)
			{
				if(j == i + 3)
				{
					if(winput.at(i + 1) == L'n')
					{
						int tempValue = (int)winput.at(i + 2) - '0';
						if(tempValue >= 0 && tempValue <= 2)
							nValue = tempValue;
					}
				}
				else if(j == i + 2)
				{
					if(winput.at(i + 1) == L'd')
					{
						nValue = 0; 
					}
				}
				i = j;
			}
			else
			{
				ret += winput.at(i);
				vectNumLabel.push_back(nValue);
			}
		}
	}

	return ret;
}

std::string TTSLang::ProcessDataTime(std::string input)
{

    string result[10];;  


    const pcrecpp::RE patterntime("(.*)([0-9]?[0-9]):([0-9]?[0-9]):([0-9]?[0-9])(.*)");

    if(patterntime.FullMatch(input, &result[1],&result[2],&result[3],&result[4],&result[5]))
    {
       if(result[4] =="00" || result[4]=="0")
       {
           if(result[3]=="00" || result[3]=="0")
           {
                input = result[1]+result[2]+Unicode_To_UTF8(L"点")+result[5];

           }else
           {
                input = result[1]+result[2]+Unicode_To_UTF8(L"点") +result[3]+Unicode_To_UTF8(L"分")+result[5];
           }
       }
       else
       {
       input = result[1]+result[2]+Unicode_To_UTF8(L"点") +result[3]+Unicode_To_UTF8(L"分")+result[4]+Unicode_To_UTF8(L"秒")+result[5];
       }
   }

   
   const pcrecpp::RE patterntime2("(.*)([0-9]?[0-9]):([0-9]?[0-9])(.*)");
   if(patterntime2.FullMatch(input, &result[1],&result[2],&result[3],&result[4]))
   {
        if(result[3]=="00" || result[3]=="0")
        {
            input = result[1]+result[2]+Unicode_To_UTF8(L"点")+result[5];

        }else
        {
            input = result[1]+result[2]+Unicode_To_UTF8(L"点") +result[3]+Unicode_To_UTF8(L"分")+result[4];
        }
   }

   const pcrecpp::RE patterndate("(.*)([0-9][0-9][0-9][0-9])-([0-9]?[0-9])-([0-9]?[0-9])(.*)");
   if(patterndate.FullMatch(input, &result[1],&result[2],&result[3],&result[4],&result[5]))
   {
       input = result[1]+result[2]+Unicode_To_UTF8(L"年") +result[3]+Unicode_To_UTF8(L"月")+result[4]+Unicode_To_UTF8(L"日")+result[5];
   }


   const pcrecpp::RE patterndate2("(.*)([0-9][0-9][0-9][0-9])-([0-9]?[0-9])(.*)");
   if(patterndate2.FullMatch(input, &result[1],&result[2],&result[3],&result[4]))
   {
       input = result[1]+result[2]+Unicode_To_UTF8(L"年") +result[3]+Unicode_To_UTF8(L"月")+result[4];
   }
   return input;
}

std::string TTSLang::ProcessDash(std::string input)
{

    string result[10];;  

   const pcrecpp::RE patterndash(Unicode_To_UTF8(L"(.*)([0-9]+)-([0-9]+)(倍|级|等|元|块|分.*)"));
   if(patterndash.FullMatch(input, &result[1],&result[2],&result[3],&result[4]))
   {
       input = result[1]+result[2]+Unicode_To_UTF8(L"到") +result[3]+result[4];
   }

   const pcrecpp::RE patterndash2("(.*)([0-9]+)-([0-9]+)([^0-9\-\+\*\\\/\=].*)");
   if(patterndash2.FullMatch(input, &result[1],&result[2],&result[3],&result[4]))
   {
       input = result[1]+result[2]+Unicode_To_UTF8(L"比") +result[3]+result[4];
   }
   return input;
}



std::string TTSLang::GenLabelUTF8(std::string input)
{
	if(input.length() == 0)
	{
		std::string ret;
		return ret;
	}


    std::wstring winput = UTF8_To_Unicode(input.c_str());
    remove_Chinese_Symbol(winput);
    string_replace(winput,L" 年",L"年");
    string_replace(winput,L"　年",L"年");
    string_ToLower(winput);
    ConvertSpecial_Chinese_Symbol(winput);
    std::wstring unknownSymbol;
    winput = remove_unknown_Symbol(winput,unknownSymbol);

	if(winput.length() == 0)
	{
		std::string ret;
		return ret;
	}

	std::vector<int> vectNumLabel;
	winput = removeUserLabel(winput, vectNumLabel);
	
    std::string  input2 = ProcessDataTime(Unicode_To_UTF8(winput));
    input2 = ProcessDash(input2);

    std::vector<std::wstring> seg_result = GenSeg(input2);
    std::vector<std::wstring> number_result = ProcessNumber(seg_result, &vectNumLabel);

    PatchYi(number_result);
    PatchBu(number_result);
    PatchYe(number_result);
	PatchSymbol(number_result);

    std::wstring pinyin =  GenPinyin(number_result);
    std::wstring utt =  GenUtt(number_result);

	if(pinyin.length() == 0)
	{
		std::string ret;
		return ret;
	}

    std::wstring label = GenLabel(utt,pinyin);

    Trace = L"Unknown Symbol:\n";
    Trace += unknownSymbol+L"\n";

    Trace += L"Seg result:\n";
    for(std::vector<std::wstring>::iterator it = seg_result.begin(); it!=seg_result.end();it++)
    {
        Trace +=*it + L" ";
    }
    Trace+=L"\n\n";

    Trace += L"Number result:\n";
    for(std::vector<std::wstring>::iterator it = number_result.begin(); it!=number_result.end();it++)
    {
        Trace +=*it + L" ";
    }
    Trace+=L"\n\n";


    Trace+=L"Pinyin result:\n";
    Trace+=pinyin+L"\n\n";

    Trace+=L"utt result:\n";
    Trace+=utt+L"\n\n";

    Trace+=L"label result:\n";
    Trace+=label;


    return Unicode_To_UTF8(label);
}



std::string TTSLang::GetTrace()
{
    return Unicode_To_UTF8(Trace);
}

std::wstring ConvertPhone(std::wstring Number)
{
    Number = string_replace(Number,L"1",L"妖");
    return Number;
}

std::wstring ConvertYear(std::wstring Number)
{
    std::wstring NumberPinyin[]={L"零",L"一",L"二",L"三",L"四",L"五",L"六",L"七",L"八",L"九"};

    std::wstring result;

    for(int i=0; i<Number.size();i++)
    {
        result +=NumberPinyin[Number.at(i)-L'0'];
    }

    return result;
}

std::wstring ConvertNumber(__int64 Number)
{
	std::wstring NumberPinyin[]={L"零",L"一",L"二",L"三",L"四",L"五",L"六",L"七",L"八",L"九"};

    std::wstring result;

    if(Number==0)
    {
        result = NumberPinyin[Number];
    }

    if(log10((double)Number)>=8)
    {
        result += ConvertNumber(Number/100000000)+L"亿";
        Number = Number % 100000000;
    }

    if(log10((double)Number)>=4)
    {
        result += ConvertNumber(Number/10000)+L"万";
        Number = Number % 10000;
    }

    
    if(log10((double)Number)>=3)
    {
        result = result+NumberPinyin[Number/1000]+ L"千";
        Number = Number % 1000;
    }

    if(log10((double)Number)>=2)
    {
        result = result+NumberPinyin[Number/100]+ L"百";
        Number = Number % 100;
    }

    if(log10((double)Number)>=1)
    {
        if(Number/10 == 1)
        {
            result = result+L"十";
        }else
        {
            result = result+NumberPinyin[Number/10]+ L"十";
        }
        Number = Number % 10;
    }

     if(Number>0)
    {
        result = result+NumberPinyin[Number];

    }
    
    return result;
}


std::wstring ConvertFloat(double Number)
{
    __int64 IntegerPart = Number;
    std::wstring result = ConvertNumber(IntegerPart);
    double DecimalPart = Number - IntegerPart;
    
    if(DecimalPart!=0)
    {        
		ostringstream ss;
		ss<<DecimalPart;
		std::string str = ss.str();
		str = str.substr(2);

		result+=L"点"+UTF8_To_Unicode(str.c_str());
    }

    return result;
}



std::vector<std::wstring> TTSLang::ProcessNumber(std::vector<std::wstring> &input_seg, std::vector<int>* pvectNumLabel)
{
    std::vector<std::wstring> input;
	int index = 0;	
	long long intPart = 0;

    //merge dot
    for(int i=0; i<input_seg.size();i++)
    {        
        if(input_seg.at(i)==L".")
        {
            if(i>=1&&i<input_seg.size()-1)
            {
                if(Unicode_To_Int64(input_seg.at(i-1), &intPart)!=0 && Unicode_To_Int64(input_seg.at(i+1), 0)!=0)
                {
                    input.at(input.size() -1) = input_seg.at(i-1)+L"."+input_seg.at(i+1);
                    i++;
                }else
                {
                    input.push_back(input_seg.at(i));
                }
            }else
            {
                input.push_back(input_seg.at(i));
            }
        }else
        {
            input.push_back(input_seg.at(i));
        }

    }

    // process unit
    for(int i=0; i<input.size();i++)
    {
        if(i>=1)
        {
            double temp;
            if(Unicode_ToDouble(input.at(i-1), &temp)!=0 && isAnsiString(input.at(i)))
            {
                if(i<input.size()-2)
                {
                    std::wstring testunit = input.at(i) + input.at(i+1) + input.at(i+2);
                    std::wstring testresult = testunit;
                     ConvertUnit(testunit);
                     if(testunit!=testresult)
                     {
                         input.at(i) = testunit;
                         input.at(i+1) = L" ";
                         input.at(i+2) = L" ";
                     }else
                     {
                         ConvertUnit(input.at(i));
                     }
                }
            }
        }
    }

     // process ansi to number
    for(int i=0; i<input.size();i++)
    {
        if(i>=1)
        {
            if(Unicode_To_Int64(input.at(i-1), &intPart)!=0 && isAnsiString(input.at(i)))
            {
                input.at(i -1) = input.at(i-1)+input.at(i);
                input.at(i) = L" ";
 
            }else if(Unicode_To_Int64(input.at(i), &intPart)!=0 && isAnsiString(input.at(i-1)))
            {
                input.at(i -1) = input.at(i-1)+input.at(i);
                input.at(i) = L" ";
            }if(Unicode_To_Int64(input.at(i), &intPart)!=0 && input.at(i-1) == L"波音")
            {
                input.at(i -1) = input.at(i-1)+input.at(i);
                input.at(i) = L" ";
 
            }
        }
    }

    if(input.at(0)==L"-" && Unicode_To_Int64(input.at(1), 0)!=0)
    {
        input.at(0) = L"负";
    }

    for(int i=0; i<input.size();i++)
    {
       if(input.at(i)==L"-" && i>=1 && i<input.size()-1)
       {
            if(Unicode_To_Int64(input.at(i-1), &intPart)==0 || Unicode_To_Int64(input.at(i+1), 0)==0)
            {
                if(Unicode_To_Int64(input.at(i+1), 0)!=0)
                {
                    input.at(i) = L"负";
                }else
                {
                    input.at(i) = L" ";
                }
            }

            if(Unicode_To_Int64(input.at(i-1), &intPart)!=0 && Unicode_To_Int64(input.at(i+1), 0)!=0)
            {
                if(i>=2 && input.at(i-2) == L"以")
                {
                    input.at(i) = L"比";
                }
                if(i<input.size()-2 && input.at(i+2) == L"倍")
                {
                    input.at(i) = L"到";
                }

                 if(i<input.size()-2 && input.at(i+2) == L"胜")
                {
                    input.at(i) = L"比";
                }
                 if(i<input.size()-2 && input.at(i+2) == L"败")
                {
                    input.at(i) = L"比";
                }
                  
            }

       } 


    }

    for(int i=0; i<input.size();i++)
    {
       if(input.at(i)==L"/" && i>=1 && i<input.size()-1)
       {
            if(!(Unicode_To_Int64(input.at(i-1), &intPart)!=0 && Unicode_To_Int64(input.at(i+1), 0)!=0))
            {
                input.at(i) = L"每";
            }

            if((Unicode_To_Int64(input.at(i-1), &intPart)!=0 && Unicode_To_Int64(input.at(i+1), 0)!=0))
            {
                std::wstring temp = input.at(i+1);
                input.at(i+1) = input.at(i-1);
                input.at(i-1) = temp;
                input.at(i) = L"分之";
            }
       } 
    }



    for(int i=0; i<input.size();i++)
    {
       if(input.at(i)==L"." && i>=1 && i<input.size()-1)
       {
            if(isAnsiString(input.at(i-1)) || isAnsiString(input.at(i+1)))
            {
                input.at(i) = L"点";
            }

       } 
    }
 
    for(int i=0; i<input.size();i++)
    {
       if(input.at(i)==L"www")
       {
            input.at(i) = L"3w";
       } 
    }

    std::vector<std::wstring>::iterator it = input.begin();
    while(it!=input.end())
    {
        if(it->size()==0)
        {
            it = input.erase(it);
            continue;
        }
        it++;
    }




    for(int i=0; i<input.size();i++)
    {
		int userLabeValue = 0;
		if(pvectNumLabel)
		{
			if(pvectNumLabel->size() > index)
				userLabeValue = pvectNumLabel->at(index);

			index += input.at(i).length();
		}

        if(Unicode_To_Int64(input.at(i), 0)!=0)
        {
            if(userLabeValue != 2 && ((i<input.size()-1 && input.at(i+1)==L"年") || input.at(i).size()>3))
            {
                input.at(i) = ConvertYear(input.at(i));
            }
            else
            {
            	long long value = 0;
				bool isPhone = false;
            	Unicode_To_Int64(input.at(i), &value);

				if(userLabeValue == 1)
				{
					isPhone = true;
				}
				else if(value /10000000000 == 1)
            	{
					isPhone = true;
				}
				else if(input.at(i).at(0)==L'0')
				{
					isPhone = true;
				}
				else if(i>=1&&input.at(i-1).at(0)==L'0')
				{
					isPhone = true;
				}
				else if(i>=2&&input.at(i-2).at(0)==L'0')
				{
					isPhone = true;
				}

				if(isPhone && userLabeValue != 2)
					input.at(i) = ConvertPhone(input.at(i));
        	}

        }else
        {
            if(i>=1&&input.at(i-1).at(0)==L'0' && input.at(i)==L"-")
            {
                input.at(i) = L" ";
            }

        }
    }

    for(int i=0; i<input.size();i++)
    {
    	double  value = 0;
		double  value2 = 0;
		bool valueValid = Unicode_ToDouble(input.at(i), &value);


		if(valueValid && value != 0)
        {


            if(i<input.size()-1 && input.at(i+1)==L"%")
            {
                input.at(i) = L"百分之"+ ConvertFloat(value);
                input.at(i+1) = L" ";
                 
            }else
            {
                input.at(i) = ConvertFloat(value);
            }

 
        }
    }

    for(int i=0; i<input.size();i++)
    {
        if(input.at(i)==L"%")
        {
            input.at(i) = L"百分之";
        }


    }


    return input;
}


std::vector<std::wstring> TTSLang::GenSeg(std::string input)
{
    Segmenter* seg = m_segmgr->getSegmenter();

    std::vector<std::wstring> result;

    seg->setBuffer((u1 *)input.c_str(),input.length());
	u2 len = 0, symlen = 0;
	u2 kwlen = 0, kwsymlen = 0;
	//check 1st token.
	char txtHead[3] = {static_cast<char>(239),static_cast<char>(187),static_cast<char>(191)};
	char* tok = (char*)seg->peekToken(len, symlen);
	seg->popToken(len);
	if(seg->isSentenceEnd()){
		do {
			char* kwtok = (char*)seg->peekToken(kwlen , kwsymlen,1);
			if(kwsymlen)
                result.push_back(UTF8_To_Unicode(((std::string)kwtok).substr(0,kwsymlen).c_str()));

				//printf("[kw]%*.*s/x ",kwsymlen,kwsymlen,kwtok);
		}while(kwsymlen);
	}

	if(len == 3 && memcmp(tok,txtHead,sizeof(char)*3) == 0){
		//check is 0xFEFF
		//do nothing
	}else{
        result.push_back(UTF8_To_Unicode(((std::string)tok).substr(0,symlen).c_str()));
		//printf("%*.*s/x ",symlen,symlen,tok);
	}
	while(1){
		len = 0;
		char* tok = (char*)seg->peekToken(len,symlen);
		if(!tok || !*tok || !len)
			break;
		seg->popToken(len);
		if(seg->isSentenceEnd()){
			do {
				char* kwtok = (char*)seg->peekToken(kwlen , kwsymlen,1);
				if(kwsymlen)
                     result.push_back(UTF8_To_Unicode(((std::string)kwtok).substr(0,kwsymlen).c_str()));

					//printf("[kw]%*.*s/x ",kwsymlen,kwsymlen,kwtok);
			}while(kwsymlen);
		}

		if(*tok == '\r')
			continue;
		if(*tok == '\n'){
			//printf("\n");
			continue;
		}

		//printf("[%d]%*.*s/x ",len,len,len,tok);
//		printf("%*.*s/x ",symlen,symlen,tok);
        result.push_back(UTF8_To_Unicode(((std::string)tok).substr(0,symlen).c_str()));

	}

 

    m_segmgr->clear();
    return result;
}


bool IsPostPause(std::wstring &input)
{
    if(input==L"以") return true;
    if(input==L"把") return true;
    if(input==L"已") return true;
    if(input==L"比") return true;
    if(input==L"又") return true;
    if(input==L"有") return true;
    if(input==L"也") return true;
    if(input==L"占") return true;
    if(input==L"在") return true;
    if(input==L"要") return true;
    if(input==L"却") return true;
    if(input==L"也") return true;
    if(input==L"而") return true;
    if(input==L"被") return true;
    if(input==L"都") return true;
    if(input==L"向") return true;
    if(input==L"达") return true;
    if(input==L"与") return true;
    if(input==L"为") return true;
    if(input==L"将") return true;
    if(input==L"因") return true;
    if(input==L"仍有") return true;
    if(input==L"仍旧") return true;
    if(input==L"仍然") return true;
    if(input==L"既是") return true;
    if(input==L"也是") return true;
    if(input==L"甚至") return true;

    return false;
}


bool IsPostPause2(std::wstring &input)
{
    if(input==L"和") return true;
    if(input==L"他们") return true;
    if(input==L"我们") return true;
    if(input==L"你们") return true;
    if(input==L"她们") return true;
    if(input==L"它们") return true;
    if(input==L"他") return true;
    if(input==L"我") return true;
    if(input==L"你") return true;
    if(input==L"她") return true;
    if(input==L"它") return true;
    if(input==L"他的") return true;
    if(input==L"我的") return true;
    if(input==L"你的") return true;
    if(input==L"她的") return true;
    if(input==L"它的") return true;
    if(input==L"仅有") return true;
    if(input==L"更加") return true;
    if(input==L"还有") return true;
    if(input==L"显得") return true;
    if(input==L"如何") return true;
    if(input==L"怎样") return true;

    return false;
}

bool IsBothPause(std::wstring &input)
{
    if(input==L"防止") return true;
    if(input==L"当前") return true;
    if(input==L"由于") return true;
    if(input==L"有的") return true;
    if(input==L"作为") return true;
    if(input==L"不仅") return true;
    if(input==L"不但") return true;
    if(input==L"而且") return true;
    if(input==L"因为") return true;
    if(input==L"所以") return true;
    if(input==L"可是") return true;
    if(input==L"然而") return true;
    if(input==L"或者") return true;

    return false;
}

bool IsPrePause(std::wstring &input, std::wstring &next)
{
    if(input==L"但") return true;
    if(input==L"时") return true;
    if(input==L"说") return true;
    if(input.at(input.size()-1) == L'的') return true;
    if(input.at(input.size()-1) == L'了') return true;
    if(input.at(input.size()-1) == L'着') return true;
    if(input.at(input.size()-1) == L'出' && next!=L"了") return true;
    return false;
}

int GetNextHardStop(std::vector<std::wstring> &input,int current)
{
    int size =0;
    for(int i=current; i<input.size();i++)
    {
        if(input[i].find_first_of(L",.:;\\＼。，、?!")== string::npos)
        {
            size += input[i].size();
        }else
        {
            break;
        }
    }
    return size;
}


int GetPrevHardStop(std::vector<std::wstring> &input,int current)
{
    int size =0;
    for(int i=current; i>=0;i--)
    {
        if(input[i].find_first_of(L",.:;\\＼。，、?!")== string::npos)
        {
            size += input[i].size();
        }else
        {
            break;
        }
    }
    return size;
}

std::wstring TTSLang::GenUtt(std::vector<std::wstring> input)
{
    std::vector<std::wstring>::iterator it = input.begin();
    std::wstring result;

    int i=0;
    int HardStopIndex=0;
    while(it!= input.end())
    {
        std::wstring next;
        if(i<input.size()-1)
        {
            next = input.at(i+1);
        }
        if(it->find_first_of(L",.:;\\＼。，、?!…")== string::npos)
        {
            if(it->find_first_of(L"\"'()[]{}<>《》“”‘’")== string::npos)
            {
                if(IsBothPause(*it))
                {
                    if(GetPrevHardStop(input,i)>7&& i-HardStopIndex>3 && GetNextHardStop(input,i)>=5)
                    {
                        HardStopIndex=i;
                        result += L"$"+*it + L"|";
                    }else
                    {
                        result += L"|"+*it + L" ";
                    }
                }
                else if(IsPostPause(*it))
                {
                    if(GetPrevHardStop(input,i)>7 && i-HardStopIndex>3 && GetNextHardStop(input,i)>=5)
                    {
                        HardStopIndex=i;
                        result += L"$"+*it + L" ";
                    }else
                    {
                        result += *it + L" ";
                    }
                }else if(IsPostPause2(*it) && GetNextHardStop(input,i)>=3)
                {
                    result += L"|"+*it + L" ";
                }
                else if(IsPrePause(*it,next)&& GetNextHardStop(input,i)>=2)
                {
                    result += *it+L"|";
                }else 
                {
                    result += *it + L" ";
                }
            }else
            {
                result += L"|";
            }
        }else
        {
            HardStopIndex=i;
            result += L"$";
        }
        it++;
        i++;
    }
    result = string_replace(result, L"||", L"|");
    result = string_replace(result, L" |", L"|");
    result = string_replace(result, L" $", L"$");
    result = string_replace(result, L"$$", L"$");
    result = string_replace(result, L"|$", L"$");
    result = string_replace(result, L"$|", L"$");

    if(result.size()>0)
    {
        if(result.at(0)==L'$' || result.at(0)==L'|')
        {
            result = result.substr(1);
        }
    }

    if(result.size()>0)
    {
        if(result.at(result.size()-1)==L'$' || result.at(result.size()-1)==L'|')
        {
            result = result.substr(0,result.size()-1);
        }
    }

    return result;
}

int GetTone(std::wstring pinyin);


void  TTSLang::PatchYi(std::vector<std::wstring> &input)
{
    for(int i=0; i<input.size()-1;i++)
    {
        if(input.at(i) == L"一")
        {
			std::wstring nextpinyin = findWordPinyin(input.at(i+1), 0);
			if(nextpinyin.length() > 0)
			{
				int nexttone = GetTone(nextpinyin);
				if(nexttone==1 || nexttone==2 || nexttone==3)
				{
					input[i] = L"逸";
				}

				if(nexttone==4)
				{
					input[i] = L"移";
				}
			}
        }
    }
}

void  TTSLang::PatchYe(std::vector<std::wstring> &input)
{
    for(int i=0; i<input.size()-1;i++)
    {
        if(input.at(i) == L"也")
        {
			std::wstring nextpinyin = findWordPinyin(input.at(i+1), 0);
			if(nextpinyin.length() > 0)
			{
				int nexttone = GetTone(nextpinyin);
				if(nexttone==3)
				{
					input[i] = L"爷";
				}
			}
        }
    }
}
       
void  TTSLang::PatchBu(std::vector<std::wstring> &input)
{
    for(int i=0; i<input.size()-1;i++)
    {
        if(input.at(i) == L"不")
        {
        	std::wstring nextpinyin = findWordPinyin(input.at(i+1), 0);
			if(nextpinyin.length() > 0)
			{
                int nexttone = GetTone(nextpinyin);
                if(nexttone==4)
                {
                    input[i] = L"醭";
                }
            }
 
        }
    }
}
       

void TTSLang::PatchSymbol(std::vector<std::wstring> &input)
{
	std::wstring sEqual = L"=";
	std::wstring sWell = L"#";
	for(int i=0; i<input.size();i++)
    {
        if(input.at(i) == sEqual)
        {
            input[i] = L"等于";
        }
		else if(input.at(i) == sWell)
		{
			input[i] = L"井号";
		}
    }
}


std::wstring TTSLang::GenPinyin(std::vector<std::wstring> input)
{
    std::vector<std::wstring>::iterator it = input.begin();
    std::wstring totalresult;
    std::string totalsPinyin;
    while(it!= input.end())
    {
        std::wstring result;
        std::string sPinyin;

#ifdef ANDROID_NDK_
    	std::string word = Unicode_To_UTF8(*it);
    	const char *pinyin = mWordToPinyin.findWordsPinyin(word.c_str());
    	if(pinyin)
    	{
    		sPinyin += pinyin;
    		sPinyin += " ";
    	}
    	else
    	{
    		for(int i=0;i<it->length();i++)
			{
    			std::wstring aa = (*it).substr(i, 1);
    			word = Unicode_To_UTF8(aa);
    			pinyin = mWordToPinyin.findWordPinyin(word.c_str());
				if(pinyin)
				{
					sPinyin += pinyin;
					sPinyin += " ";
				}
			}
    	}


        int lasttone = 0;
        for(int i=sPinyin.length()-1;i>=0;i--)
        {
            if(sPinyin[i]>='0' && sPinyin[i]<='5')
            {
                if(lasttone == 3 && sPinyin[i]=='3')
                {
                    sPinyin[i]='2';
                }
                lasttone = sPinyin[i]-'0';
            }
        }



        totalsPinyin+= sPinyin;
#else
        if(WordPinyinMap.find(*it)!=WordPinyinMap.end())
        {
            result += WordPinyinMap.find(*it)->second + L" ";
        }
        else
        {
            for(int i=0;i<it->length();i++)
            {
            	std::wstring pinyin = findWordPinyin(*it, i);
                if(pinyin.length() > 0)
                    result += pinyin + L" ";
            }
        }


        int lasttone = 0;
        for(int i=result.length()-1;i>=0;i--)
        {
            if(result[i]>='0' && result[i]<='5')
            {
                if(lasttone == 3 && result[i]=='3')
                {
                    result[i]='2';
                }
                lasttone = result[i]-'0';
            }
        }

        totalresult+=result;


#endif



        it++;
    }

#ifdef ANDROID_NDK_
    totalresult += UTF8_To_Unicode(totalsPinyin.c_str());
#endif

    return totalresult;
}


std::wstring InsertLabel(std::wstring utt, std::wstring pinyin)
{
	utt = string_replace(utt, L" ", L"");
    std::vector<std::wstring> Pinyins;
    split( string_replace(pinyin,L"  ",L" "), L" ", Pinyins);
 

	
	int PinyinIndex = 0;
	std::wstring Output = L"pau ";
	for(int i=0; i<utt.length();i++)
	{
        if(utt.at(i)==L'|')
		{
			Output +=L"brth ";
		}else if(utt.at(i)==L'$')
		{
			Output +=L"pau ";
		}else
		{
            Output += Pinyins.at(PinyinIndex) + L" ";
			PinyinIndex++;
		}
	}
	return (Output+L"pau");
}


std::wstring GetContextPhone(int index, std::vector<std::wstring> Phones)
{
	std::wstring PreviousPhone = L"pau";
	std::wstring CurrentPhone = Phones.at(index);
	std::wstring NextPhone = L"pau";

	
	if(index>0) PreviousPhone = Phones.at(index-1);
	if(index<Phones.size()-1) NextPhone = Phones.at(index+1);
	
	return L"^"+PreviousPhone+L"-"+CurrentPhone+L"+"+NextPhone+L"=";
}



std::wstring GetContextTone(int index, std::vector<std::wstring> Phones,int charinwordindex, int wordcount)
{
	std::wstring PreviousPreviousPhone = L"6";
	std::wstring PreviousPhone = L"6";
	std::wstring CurrentPhone = Phones.at(index);
	std::wstring NextPhone = L"6";
	std::wstring NextNextPhone = L"6";
	
	if(index>1) PreviousPreviousPhone = Phones.at(index-2);
	if(index>0) PreviousPhone = Phones.at(index-1);
	if(index<Phones.size()-1) NextPhone = Phones.at(index+1);
	if(index<Phones.size()-3) NextNextPhone = Phones.at(index+3);
	
    if(charinwordindex-1<0) PreviousPhone =L"6";
    if(charinwordindex-2<0) PreviousPreviousPhone =L"6";
		
    if(wordcount-charinwordindex<=1) NextPhone = L"6";
    if(wordcount-charinwordindex<=2) NextNextPhone = L"6";


	return L"/T:"+PreviousPreviousPhone+L"+"+PreviousPhone+L"#"+CurrentPhone+L"^"+NextPhone+L"#"+NextNextPhone;

}
	
int GetTone(std::wstring pinyin)
{
    int tone = 6;
    wchar_t lastchar = pinyin.at(pinyin.length()-1);
    if(lastchar>=L'0'&& lastchar<=L'9')
    {
        tone = lastchar - L'0';
    }

    if(tone==5)tone =0;
		
    return tone;
}

std::wstring RemoveTone(std::wstring pinyin)
{
    wchar_t lastchar = pinyin.at(pinyin.length()-1);
    if(lastchar>=L'0'&& lastchar<=L'9')
    {
        return pinyin.substr(0,pinyin.length()-1);
    }

    return pinyin;
}


bool IsSilent(std::wstring Pinyin)
{
    if(Pinyin == L"pau") return TRUE;
    if(Pinyin == L"brth") return TRUE;

    return FALSE;
}

std::vector<std::wstring> TTSLang::GenPhone(std::wstring pinyin)
{
    std::vector<std::wstring> phonelist;
	int tone = GetTone(pinyin);
    pinyin = RemoveTone(pinyin);


    if(Pinyin2PhoneMap.find(pinyin)!=Pinyin2PhoneMap.end())
	{
		
        std::wstring Phone = Pinyin2PhoneMap.find(pinyin)->second;
        if(Phone!=L"pau" && Phone!=L"brth")
		{
            std::wstring lowerpinyin = pinyin;
            string_ToLower(lowerpinyin);
            if(pinyin != lowerpinyin)
            {
                Phone = Phone;
            }else
            {
			    Phone = Phone+Int2String(tone);
            }
        }
		split(Phone,L" ",phonelist);

	}else
	{
    //    wprintf(L"%s\n"),pinyin.c_str());
	}


	return phonelist;

}


std::wstring TTSLang::GenLabel(std::wstring utt, std::wstring pinyin)
{
    std::vector<std::wstring> Phones;
	std::vector<std::wstring> p6;
	std::vector<std::wstring> p7;
	std::vector<std::wstring> b3;

	std::vector<std::wstring> tones;
	std::vector<int> tonesIndexs;
	
	std::vector<int> CharInWordIndex;
	std::vector<int> RevCharInWordIndex;
	std::vector<int> WordCount;

	std::vector<int> CharInPhaseIndex;
	std::vector<int> RevCharInPhaseIndex;
	std::vector<int> PhaseCount;		

	std::vector<int> CharInSentenceIndex;
	std::vector<int> RevCharInSentenceIndex;
	std::vector<int> SentenceCount;	



	std::vector<int> WordList;
    std::vector<int> PhaseList;
	std::vector<int> SentenceList;
    int PhaseLength = 0;
    int SentenceLength = 0;
    int WordLength = 0;

	std::wstring utt1 = utt + L"$";	

    for(int i=0; i<utt1.length();i++)
    {
        wchar_t uttchar = utt1.at(i);
        if(uttchar == L' ' || uttchar == L'|' || uttchar == L'$')
        {
            if(WordLength>0)
            {
                WordList.push_back(WordLength);
                WordLength = 0;
            }
        }else
        {
            WordLength++;
        }

        if(uttchar == L'|' || uttchar == L'$')
        {
            if(PhaseLength>0)
            {
                PhaseList.push_back(PhaseLength);
                PhaseLength = 0;

            }
        }else
        {
            if(!(uttchar == L' '))
            {
                PhaseLength++;
            }
        }

        if(uttchar == L'$')
        {
            if(SentenceLength>0)
            {
                SentenceList.push_back(SentenceLength);
                SentenceLength = 0;
            }
        }else
        {
            if(!(uttchar == L' ' || uttchar == L'|'))
            {
                SentenceLength++;
            }
        }
    }
	

	utt = string_replace(utt, L" ", L"");
    pinyin = InsertLabel(utt,pinyin);

	std::vector<std::wstring> Pinyins;
    split(pinyin,L" ", Pinyins);
	
	int toneindex = 0;
	int CharIndex = 0;
    for(std::vector<std::wstring>::iterator k=Pinyins.begin();k!=Pinyins.end();k++)
	{
		if(k->length()==0)continue;
		
        std::vector<std::wstring> phonelist = GenPhone(*k);
		int tone = GetTone(*k);
		tones.push_back(Int2String(tone));
		int i=0;
        for(std::vector<std::wstring>::iterator j=phonelist.begin();j!=phonelist.end();j++)
		{
			Phones.push_back(*j);
			p6.push_back(Int2String(i));
			p7.push_back(Int2String(phonelist.size()-i));
			b3.push_back(Int2String(phonelist.size()));
			tonesIndexs.push_back(toneindex);
			i++;
			if(IsSilent(*k))
			{
				WordCount.push_back(0);
				CharInWordIndex.push_back(0);
				RevCharInWordIndex.push_back(0);

				PhaseCount.push_back(0);
				CharInPhaseIndex.push_back(0);
				RevCharInPhaseIndex.push_back(0);
				
				SentenceCount.push_back(0);
				CharInSentenceIndex.push_back(0);
				RevCharInSentenceIndex.push_back(0);

			}else
			{
				int temp = CharIndex;
                for(std::vector<int>::iterator t=WordList.begin();t!=WordList.end();t++)
				{
					if(temp>=*t)
					{
						temp -=*t;
					}else
					{
						WordCount.push_back(*t);
						CharInWordIndex.push_back(temp);
						RevCharInWordIndex.push_back(*t-temp);
						break;
					}
				}


				temp = CharIndex;
				for(std::vector<int>::iterator t=PhaseList.begin();t!=PhaseList.end();t++)
				{
					if(temp>=*t)
					{
						temp -=*t;
					}else
					{
						PhaseCount.push_back(*t);
						CharInPhaseIndex.push_back(temp);
						RevCharInPhaseIndex.push_back(*t-temp);
						break;
					}
				}
					
					
				temp = CharIndex;
				for(std::vector<int>::iterator t=SentenceList.begin();t!=SentenceList.end();t++)
				{
					if(temp>=*t)
					{
						temp -=*t;
					}else
					{
						SentenceCount.push_back(*t);
						CharInSentenceIndex.push_back(temp);
						RevCharInSentenceIndex.push_back(*t-temp);
						break;
					}
				}

			}
		}
		
		if(!IsSilent(*k))
		{
			CharIndex++;
		}
		
		toneindex++;

	}
	
	
	std::wstring j = L"/J:"+Int2String(utt.length())+L"+"+Int2String(WordList.size())+L"-"+Int2String(PhaseList.size())+L"@"+Int2String(SentenceList.size());

    std::wstring output;
	
	for(int i=0; i<Phones.size();i++)
	{
		std::wstring A = L"/A:"+p6.at(i)+L"_"+p7.at(i)+L"_"+b3.at(i);
		std::wstring B = L"/B:"+Int2String(CharInWordIndex.at(i))+L"-"+Int2String(RevCharInWordIndex.at(i))+L"-"+Int2String(WordCount.at(i));
		std::wstring C = L"/C:"+Int2String(CharInPhaseIndex.at(i))+L"+"+Int2String(RevCharInPhaseIndex.at(i))+L"+"+Int2String(PhaseCount.at(i));
		std::wstring D = L"/D:"+Int2String(CharInSentenceIndex.at(i))+L"+"+Int2String(RevCharInSentenceIndex.at(i))+L"@"+Int2String(SentenceCount.at(i));

        std::wstring T = GetContextTone(tonesIndexs.at(i),tones,CharInWordIndex.at(i), WordCount.at(i));
		output += GetContextPhone(i,Phones)+A+B+C+D+T+j + L"\n";
	}
	return output;
}

std::wstring TTSLang::findWordPinyin(std::wstring &s, int index)
{
	std::wstring ret;
	std::wstring input = s.substr(index, 1);

#ifdef ANDROID_NDK_
	std::string word = Unicode_To_UTF8(input);
	const char *pinyin = mWordToPinyin.findWordPinyin(word.c_str());
	if(pinyin)
	{
		ret = UTF8_To_Unicode(pinyin);
	}
#else
	wchar_t nextchar = s.at(index);
	if(DefaultPinyin.find(nextchar)!= DefaultPinyin.end())
	{
		ret = DefaultPinyin.find(nextchar)->second;
	}
#endif

	return ret;
}

