#include "WordToPinyin.h"
#include "stdlib.h"
#include "string.h"

WordToPinyin::WordToPinyin(void)
{
	 mpWord1 = 0;
	 mpPinyin1 = 0;
	 mpWord2 = 0;
	 mpPinyin2 = 0;
	 mpContent = 0;
}


WordToPinyin::~WordToPinyin(void)
{
	if(mpWord1)
		free(mpWord1);
	if(mpPinyin1)
		free(mpPinyin1);

	if(mpWord2)
		free(mpWord2);
	if(mpPinyin2)
		free(mpPinyin2);

	if(mpContent)
		free((char *)mpContent);
}


void WordToPinyin::init(char const *pContent, int len)
{
	memcpy(&mnCount1, pContent, 4);
	memcpy(&mnCount2, pContent + 4, 4);
	mpContent = (char *)malloc(len - 8);
	memcpy((char *)mpContent, pContent + 8, len - 8);
	mpWord1 = (char **)malloc(mnCount1 * 4);
	mpPinyin1 = (char **)malloc(mnCount1 * 4);
	mpWord2 = (char **)malloc(mnCount2 * 4);
	mpPinyin2 = (char **)malloc(mnCount2 * 4);

	int index = 0;
	char *pTemp = (char *)mpContent;
	while(index < mnCount1)
	{
		mpWord1[index] = pTemp;
		while(*pTemp++);
		mpPinyin1[index] = pTemp;
		while(*pTemp++);
		index++;
	}

	index = 0;
	while(index < mnCount2)
	{
		mpWord2[index] = pTemp;
		while(*pTemp++);
		mpPinyin2[index] = pTemp;
		while(*pTemp++);
		index++;
	}
}

const char *WordToPinyin::findWordsPinyin(const char *szWord)
{
	const char *ret = 0;
	int compare = 0;
	
	int start = 0;
	int mid = 0;
	int end = mnCount2 - 1;
	while(start <= end)
	{
		mid = (start + end) / 2;
		compare = strcmp(szWord, mpWord2[mid]);
		
		if(compare == 0)
		{
			ret = mpPinyin2[mid];
			break;
		}
		else if(compare < 0)
		{
			end = mid - 1;
		}
		else
		{
			start = mid + 1;
		}
	}

	return ret;
}


const char *WordToPinyin::findWordPinyin(const char *szWord)
{
	const char *ret = 0;
	int compare = 0;
	
	int start = 0;
	int mid = 0;
	int end = mnCount1 - 1;
	while(start <= end)
	{
		mid = (start + end) / 2;
		compare = strcmp(szWord, mpWord1[mid]);
		
		if(compare == 0)
		{
			ret = mpPinyin1[mid];
			break;
		}
		else if(compare < 0)
		{
			end = mid - 1;
		}
		else
		{
			start = mid + 1;
		}
	}

	return ret;
}

int WordToPinyin::getValidChars(const char ***pValidChar)
{
	*pValidChar = (const char **)mpWord1;
	return mnCount1;
}


