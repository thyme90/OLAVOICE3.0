#pragma once
class WordToPinyin
{
protected:
	char** mpWord1;
	char** mpPinyin1;
	int mnCount1;
	char** mpWord2;
	char** mpPinyin2;
	int mnCount2;
	char const * mpContent;
public:
	WordToPinyin(void);
	~WordToPinyin(void);

	void init(char const *pContent, int len);
	const char *findWordsPinyin(const char *szWord);
	const char *findWordPinyin(const char *szWord);
	int getValidChars(const char ***pValidChar);
};

