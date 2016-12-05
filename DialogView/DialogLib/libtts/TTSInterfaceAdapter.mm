//
//  TTSInterfaceAdapter.m
//  TTSAudioDemo
//
//  Created by yanminli on 16/4/19.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "TTSInterfaceAdapter.h"
#include "TTSInterface.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MCSimpleAudioPlayer/MCAudioOutputQueue.h"

#define NUMPACKET 50
#define QUEUE_BUFFER_SIZE 4 //队列缓冲个数
#define MIN_SIZE_PER_FRAME 1024*(NUMPACKET+50) //每帧最小数据长度

@interface TTSInterfaceAdapter(){
    TTSInterface* ttsInterface;
    MCAudioOutputQueue *_audioQueue;
}

@property(assign ,nonatomic)int productNum;
@property(strong ,nonatomic)NSCondition *cond;
@property (nonatomic,strong) NSMutableData *arrayData;
@property (assign,nonatomic) BOOL stopAudio;
@property (retain,nonatomic) NSThread *customerThread;
 


@end



@implementation TTSInterfaceAdapter
-(id)init{
    if (self = [super init]) {
        ttsInterface= new TTSInterface();
        
        NSString *tmp = [[NSBundle mainBundle] pathForResource:@"wordpinyin" ofType:@"txt"];
        NSString* path  = [tmp stringByReplacingOccurrencesOfString:@"wordpinyin.txt" withString:@""];//获得当前资源文件的路径
        NSString* voiceName = @"olavoice_zhennizhang.htsvoice";
        const char* tmpChar1 = [path UTF8String];
        char* filename = new char[strlen(tmpChar1)+1];
        strcpy(filename, tmpChar1);
        
        std::string pathSS;
        pathSS = tmpChar1;
        
        
        const char* tmpChar2 = [voiceName UTF8String];
        char* filename1 = new char[strlen(tmpChar2)+1];
        strcpy(filename1, tmpChar2);
        
        std::string voiceNameSS;
        voiceNameSS = tmpChar2;
        
        ttsInterface->Init(pathSS, voiceNameSS);
        ttsInterface->SetCallBack(ttsInterfaceCallBack, (__bridge void*)(self));
        
        _arrayData = [[NSMutableData alloc] init];
        
        self.productNum = 0;
        self.cond = [[NSCondition alloc]init];
       
        
    }
    return self;
}

-(void)Syn:(NSString *)input{
    std::wstring wstr = (wchar_t*)[input cStringUsingEncoding:NSUTF32StringEncoding];
    ttsInterface->Syn(wstr);
}

-(void)SynUTF8:(NSString *)input{
    const char* tmpChar = [input UTF8String];
    
    char* content = new char[strlen(tmpChar)+1];
    strcpy(content, tmpChar);
    
    std::string ss;
    ss = tmpChar;
    ttsInterface->Syn(ss);

}

//如果返回FALSE，就继续解码，否则结束解码
bool ttsInterfaceCallBack(void *data, int len, short *wavedata){
     
    TTSInterfaceAdapter* tts = (__bridge TTSInterfaceAdapter*)data;
    
//    if (len > 0) {
//          [tts.arrayData appendBytes:wavedata length:len*2];
//     }else{
//         NSLog(@"arrayData len is %lu",(unsigned long)[tts.arrayData length]);
//        [tts playAudioQueue:tts.arrayData];
//        //[tts playAudio];
//
//        return true;
//    }
    
    
    if (!tts.isPlayDone) {
        if (len > 0 ) {
            
            [tts.cond lock];
            if ([tts.arrayData length] > NUMPACKET*1024) {
                [tts.cond signal];
                //NSLog(@"ttsInterfaceCallBack send");
                [tts.cond unlock];
                sleep(1);
            }else {
                [tts.cond unlock];
            }
            
            [tts.cond lock];
            [tts.arrayData appendBytes:wavedata length:len*2];
            [tts.cond unlock];
            
        }else{
            [tts.cond signal];
            [tts stop:NO];
            tts.isPlayDone = YES;
            return true;
        }

    }else{
       return true;
    }
   
    return false;
}

-(void)customerHandle {
    while (1) {
        [self.cond lock];
        if ([_arrayData length] == 0) {
            [self.cond wait];
        }
        
        if (self.isPlayDone) {
            if (_arrayData.length > 0 && _audioQueue.isRunning ) {
                [self stop:NO];
            }
        }
        [self playAudioQueue:_arrayData];
        [self.cond unlock];
        
    }
}

-(void)SaveData:(NSString*) filePath{
    const char* path = [filePath UTF8String];
    string  str = path;
    ttsInterface->saveFile(str);
 
}

-(BOOL)playSound:(NSString*)text{
    if (text.length == 0) {
        return NO;
    }

    self.customerThread = [[NSThread alloc]initWithTarget:self selector:@selector(customerHandle) object:nil];
    [self.customerThread start];
    _isPlayDone = NO;
    [self Syn:text];
    return YES;
}


-(BOOL)stopSound{
    return [self stop:YES];
}

-(BOOL)stop:(BOOL)immediately{
    if (_audioQueue) {
        [_audioQueue stop:immediately];
        _isPlayDone = YES;
        return YES;
    }
    
    return NO;
}


#pragma mark - create Audio
-(void)createAudioQueue{
    AudioStreamBasicDescription audioDescription1;
    ///设置音频参数
    audioDescription1.mSampleRate = 16000;//采样率
    audioDescription1.mFormatID = kAudioFormatLinearPCM;
    audioDescription1.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    audioDescription1.mChannelsPerFrame = 1;///单声道
    audioDescription1.mFramesPerPacket = 1;//每一个packet一侦数据
    audioDescription1.mBitsPerChannel = 16;//每个采样点16bit量化
    audioDescription1.mBytesPerFrame = (audioDescription1.mBitsPerChannel/8) * audioDescription1.mChannelsPerFrame;
    audioDescription1.mBytesPerPacket = audioDescription1.mBytesPerFrame ;
    
    _audioQueue = [[MCAudioOutputQueue alloc] initWithFormat:audioDescription1 bufferSize:MIN_SIZE_PER_FRAME];

}

-(void)playAudioQueue:(NSData*)data{
    if (!_audioQueue) {
        [self createAudioQueue];
    }
    [_audioQueue playData:data];
    [_arrayData resetBytesInRange:NSMakeRange(0, _arrayData.length)];//清空缓冲区
    [_arrayData setLength:0];
    
}







@end
