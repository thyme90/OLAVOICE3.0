#pragma once
#include <fstream>
#include <string>
#include <iostream>
#include <cstdio>
#include <algorithm>
#include <map>
#include <set>
#include  <stdlib.h>
#include <vector>
#include "define.h"

#include "SegmenterManager.h"
#include "Segmenter.h"
#include "csr_utils.h"
#include "WordToPinyin.h"


using namespace std;
using namespace css;

class TTSLang
{
public:
    TTSLang(void);
    ~TTSLang(void);
    int Init(std::string path);
#ifdef ANDROID_NDK_
int InitData(const char* pDataUni, int uniLen, const char *pPinyin, int pinyinLen);
#endif

    std::string GenLabelUTF8(std::string input);
    std::string GenLabel(std::wstring input);
    std::string GetTrace();


private:
    std::vector<std::wstring> GenSeg(std::string input);
    //std::vector<std::wstring> ProcessNumber(std::vector<std::wstring> &input);
    std::string ProcessDataTime(std::string);
    std::string ProcessDash(std::string);
	std::vector<std::wstring> ProcessNumber(std::vector<std::wstring> &input, std::vector<int>* pvectNumLabel = 0);
    std::vector<std::wstring> GenPhone(std::wstring input);
	std::wstring removeUserLabel(std::wstring winput, std::vector<int>& vectNumLabel);

    void PatchYi(std::vector<std::wstring> &input);
    void PatchYe(std::vector<std::wstring> &input);
    void PatchBu(std::vector<std::wstring> &input);
	void PatchSymbol(std::vector<std::wstring> &input);



    std::wstring GenPinyin(std::vector<std::wstring> input);
    std::wstring GenUtt(std::vector<std::wstring> input);
    std::wstring GenLabel(std::wstring utt, std::wstring pinyin);

    std::wstring remove_unknown_Symbol(std::wstring srcString, std::wstring &UnknowSymbol);
    void GenUttByPos(std::vector<std::wstring> &pos,std::vector<int> &utt);

    int GetUttDecision(std::vector<std::string> &Atts);

	std::wstring findWordPinyin(std::wstring &s, int index);

    SegmenterManager* m_segmgr;
    std::map<std::wstring, std::wstring> WordPinyinMap;
    std::map<wchar_t, std::wstring> DefaultPinyin;
    std::map<std::wstring, std::wstring> Pinyin2PhoneMap;
    std::set<wchar_t> ValidChar;

    std::wstring Trace;

	WordToPinyin mWordToPinyin;
};

#undef ELEMENT_TYPE