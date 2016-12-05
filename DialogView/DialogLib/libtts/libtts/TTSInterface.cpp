#include "TTSInterface.h"
#include "time.h"
//#if !defined(WIN32)
//#ifdef ANDROID_NDK_
//#include "ResourceData.h"
//#endif
//#else
//#include <windows.h>
//#endif


//#if !defined(WIN32)
//#include <android/log.h>
//#define LOGD(text) __android_log_write(ANDROID_LOG_DEBUG,"TtsServiceJni",text)
//#else
//#define LOGD(text)
//#endif

#define LOGD(text)


#pragma execution_character_set("utf-8")
void split(const std::wstring& s, const std::wstring delim,std::vector< std::wstring >& ret);
std::wstring UTF8_To_Unicode(const char* utf8);


TTSInterface::TTSInterface(void)
{
    m_cb = NULL;
}

TTSInterface::~TTSInterface(void)
{
}


int AudioDataCallBack(void *data, int length, short *wavedata)
{
	//return 1;
    TTSInterface *This = (TTSInterface*)data;

    if(This->m_cb == NULL) return 1;

    /*
    if(This->m_StartTime==0)
    {
        This->m_StartTime = clock();
    }

    long current;
    double elapse;
    double elapse1;
    do
    {
		current = clock();
		elapse1 = (current * 1.0 - This->m_StartTime) / CLOCKS_PER_SEC;
		elapse = This->m_TotalDataSize / 16000.0 - elapse1;

		if(elapse >= 0.2)
		{
			//LOGD("sleep");
			char szMsg[100];

			sprintf(szMsg, "sleep: %d %f %f", current, elapse, elapse1);
			LOGD(szMsg);
			#if defined(WIN32)
				Sleep((int)(10));
			#else
				usleep((int)(10000));
			#endif
		}
		else
		{
			break;
		}
    }while(1);

    */

    This->m_bBreak = This->m_cb(This->m_cbdata,length,wavedata);

	//LOGD("caca");

    This->m_TotalDataSize+=length;

    if(This->m_bBreak) return 0;
    return 1;
}

#ifndef ANDROID_NDK_
void TTSInterface::Init(std::string path,std::string voicename,int BufferSize)
{
    m_lang.Init(path);
#ifdef WIN32
    m_audio.Init(path+"\\"+voicename, BufferSize);
#else
	m_audio.Init(path+voicename, BufferSize);
#endif

    m_audio.SetCallBack(AudioDataCallBack,this);
}
#endif

#ifdef ANDROID_NDK_
void TTSInterface::InitData(std::string resFile, AAssetManager *pAssetManager, int BufferSize)
{
	ResourceData resource;
	resource.setDataFile(resFile.c_str(), pAssetManager);
	unsigned char *pDataPinyin;
	int pinyinLen;
	unsigned char *pDataUniLib;
	int uniLibLen;
	unsigned char *pDataVoice;
	int voiceLen;

	pinyinLen = resource.getData(DATA_TYPE_PINYIN, &pDataPinyin);
	uniLibLen = resource.getData(DATA_TYPE_UNILIB, &pDataUniLib);
	m_lang.InitData((const char *)pDataUniLib, uniLibLen, (const char *)pDataPinyin, pinyinLen);
	resource.freeData(DATA_TYPE_PINYIN);
	resource.freeData(DATA_TYPE_UNILIB);

	voiceLen = resource.getData(DATA_TYPE_VOICE, &pDataVoice);
	m_audio.InitData((const char *)pDataVoice, voiceLen, BufferSize);
	resource.freeData(DATA_TYPE_VOICE);

	m_audio.SetCallBack(AudioDataCallBack,this);
}
#endif


void TTSInterface::Syn(std::wstring input){
    m_StartTime = 0;
    m_TotalDataSize = 0;
    m_bBreak = FALSE;

    std::vector< std::wstring > Sentences;
    split(input,L"\n。,，",Sentences);

    for(int i=0; i<Sentences.size();i++)
    {
        std::string label = m_lang.GenLabel(Sentences.at(i));
		if(label.length() > 0)
		{

			if(label.find("\n")!=string::npos)
			{
				label = label.substr(label.find("\n")+1);
			}

			m_audio.Syn(label);

#if 0
			char filename[100];
			sprintf(filename, "/storage/sdcard0/sss%d.wav", i);
			m_audio.WriteWave(filename);
#endif
            
            
		}



       if(m_bBreak) break;

    }

    if(m_cb)
    {
        m_cb(m_cbdata,0,0);
    }
}

void TTSInterface::saveFile(string filePath){
    m_audio.WriteWave(filePath);
}

void TTSInterface::Syn(std::string inputUtf8)
{
	std::wstring input = UTF8_To_Unicode(inputUtf8.c_str());
	Syn(input);
}

void TTSInterface::SetCallBack(CALLBACKFUN fun, void *callbackdata)
{
    m_cb = fun;
    m_cbdata = callbackdata;
}

void TTSInterface::setVol(int percent)
{
	m_audio.setVol(percent);
}

int TTSInterface::getVol()
{
	return m_audio.getVol();
}
