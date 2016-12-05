#pragma once

#include <fstream>
#include <string>
#include <iostream>
#include <cstdio>
#include <algorithm>
#include <map>
#include <stdlib.h>
#include <vector>
using namespace std;



#include "HTS_engine.h"

class TTSAudio
{

public:
    TTSAudio(void);
    ~TTSAudio(void);
     int Init(std::string path, int BufferSize=8192);
#ifdef ANDROID_NDK_
	int InitData(const char* pData, int len, int BufferSize=8192);
#endif
     int Syn(std::string label);
     void SetCallBack(AUDIOCALLBACKFUN fun, void *callbackdata);
     int GetSampleLength();
     int GetSample(short *);
     int WriteWave(std::string file);

	 void setVol(int percent);
	 int getVol();
private:
    HTS_Engine engine;
};
