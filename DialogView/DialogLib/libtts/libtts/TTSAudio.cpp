
#include "TTSAudio.h"
//#include "math.h"
#include <algorithm>
#include <map>


TTSAudio::TTSAudio(void)
{
}

TTSAudio::~TTSAudio(void)
{
    HTS_Engine_refresh(&engine);

   /* free memory */
    HTS_Engine_clear(&engine);
}

int TTSAudio::Init(std::string path, int BufferSize)
{
    /* initialize hts_engine API */
    HTS_Engine_initialize(&engine);

    char * filename = (char *)path.c_str();

    /* load HTS voices */
    if (HTS_Engine_load(&engine, &filename, 1) != TRUE) {
        fprintf(stderr, "Error: HTS voices cannot be loaded.\n");
   
        HTS_Engine_clear(&engine);
        return -1;
    }

    HTS_Engine_set_audio_buff_size(&engine,BufferSize);
    //HTS_Engine_set_volume(&engine,8);
    HTS_Engine_set_speed(&engine,0.9);
    return 0;
}

#ifdef ANDROID_NDK_
int TTSAudio::InitData(const char* pData, int len, int BufferSize)
{
    /* initialize hts_engine API */
    HTS_Engine_initialize(&engine);

    /* load HTS voices */
    if (HTS_Engine_loadFromBuffer(&engine, pData, len) != TRUE) {
        fprintf(stderr, "Error: HTS voices cannot be loaded.\n");
   
        HTS_Engine_clear(&engine);
        return -1;
    }

	HTS_Engine_set_audio_buff_size(&engine,BufferSize);
    //HTS_Engine_set_volume(&engine,8);
    HTS_Engine_set_speed(&engine,0.9);
    return 0;
}
#endif

void split(const std::string& s, const std::string delim,std::vector< std::string >& ret)
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

int TTSAudio::Syn(std::string label)
{
    HTS_Engine_refresh(&engine);
    std::vector< std::string > lines;
    split(label,"\n",lines);
    char **pLines = (char **)malloc(sizeof(char *)*lines.size());
    int index = 0;
    std::vector< std::string >::iterator it = lines.begin();
    while(it != lines.end())
    {
        pLines[index] = (char *)it->c_str();
        it++;
        index++;
    }

    HTS_Engine_synthesize_from_strings(&engine,pLines,index);
    free(pLines);

	//HTS_Engine_refresh(&engine);
    return 0;
}

int TTSAudio::WriteWave(std::string file)
{

    FILE *wavfp = NULL;
    wavfp = fopen(file.c_str(),"wb+");
 
    HTS_Engine_save_riff(&engine, wavfp);

    fclose(wavfp);

    return 0;
}

void TTSAudio::setVol(int percent)
{
	HTS_Engine_set_volume_percent(&engine, percent);
}

int TTSAudio::getVol()
{
	return HTS_Engine_get_volume_percent(&engine);
}

extern "C" size_t HTS_GStreamSet_get_total_nsamples(HTS_GStreamSet * gss);
extern "C" double HTS_GStreamSet_get_speech(HTS_GStreamSet * gss, size_t sample_index);

int TTSAudio::GetSampleLength()
{
    HTS_GStreamSet *gss = &engine.gss;
    return HTS_GStreamSet_get_total_nsamples(gss);
}
int TTSAudio::GetSample(short * sample)
{
    HTS_GStreamSet *gss = &engine.gss;
    size_t i;
    double x;
    short temp;

    for (i = 0; i < HTS_GStreamSet_get_total_nsamples(gss); i++) {
      x = HTS_GStreamSet_get_speech(gss, i);
      if (x > 32767.0)
         temp = 32767;
      else if (x < -32768.0)
         temp = -32768;
      else
         temp = (short) x;
      sample[i]= temp;
    }
    return HTS_GStreamSet_get_total_nsamples(gss);
}

void TTSAudio::SetCallBack(AUDIOCALLBACKFUN fun, void *callbackdata)
{
    HTS_SetAudioCallBack(&engine,fun,callbackdata);
}
