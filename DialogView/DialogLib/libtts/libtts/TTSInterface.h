#pragma once
#include <fstream>
#include <string>
#include <iostream>
#include <cstdio>
#include <algorithm>
#include <map>
#include <stdlib.h>
#include <vector>
#include "define.h"
using namespace std;
#include "TTSAudio.h"
#include "TTSLang.h"

#ifdef ANDROID_NDK_
#include <android/asset_manager.h>
#endif

typedef bool (*CALLBACKFUN)(void *data, int length, short *wavedata); 



class TTSInterface
{
friend int AudioDataCallBack(void *data, int length, short *wavedata);
public:
    TTSInterface(void);
    ~TTSInterface(void);
#ifndef ANDROID_NDK_
	void Init(std::string path,std::string voicename, int BufferSize=1024);
#endif
    void Syn(std::wstring input);
	void Syn(std::string inputUtf8);
    void SetCallBack(CALLBACKFUN fun, void *callbackdata);

	void setVol(int percent);
	int getVol();
    
    void saveFile(string filePath);

#ifdef ANDROID_NDK_
	void InitData(std::string resFile, AAssetManager *pAssetManager=0, int BufferSize=1024);
#endif

public:
    TTSLang     m_lang;
    TTSAudio    m_audio;

    CALLBACKFUN m_cb;
    void       *m_cbdata;
    long        m_StartTime;
    int         m_TotalDataSize;
    bool        m_bBreak;
	char		*mpUserData;
};
