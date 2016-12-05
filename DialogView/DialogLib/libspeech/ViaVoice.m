//
//  ViaVoice.m
//  ViaVoice
//
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "ViaVoice.h"
#import <iflyMSC/iflyMSC.h>





@interface ViaVoice()<IFlySpeechRecognizerDelegate,IFlyPcmRecorderDelegate>
@property (nonatomic,copy) NSMutableString *mStr;
@property (nonatomic,assign) int input_type;
@property (nonatomic,strong) NSString *cusid;
@property (nonatomic,strong) NSString *urlStr;
@property (nonatomic,strong) NSString *appID;
@property (nonatomic,strong) NSString *frontsilVal;
@property (nonatomic,strong) NSString *backsilVal;
@property (nonatomic, strong) NSString * result;
@property (nonatomic, assign) BOOL isCanceled;



@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;//录音器，用于音频流识别的数据传入

@end

@implementation ViaVoice


-(id)initWithAppID:(NSString*)appid{
    _appID = appid;
    [self initData];
    [self initRecognizer];
    return self;
}

-(BOOL)start:(SourceInput)type{
    _input_type = 0;
    if (type == MicInputSource) {
        return [self micInput];
    }else if (type == audioStreamInputSource){
        return [self audioStreamInput];
    }
    
    return NO;
}


-(void)cancel{
    [_iFlySpeechRecognizer cancel];
}


-(void)stop{
    [_iFlySpeechRecognizer stopListening];
}


-(void)reset{
    [self.mStr setString:@""];
}

-(void)setInputType:(int)intputType{
    _input_type = intputType;
}

-(void)setCUSID:(NSString *)cusid{
    _cusid = cusid;
}



-(void)setServer:(NSString *)server{
    _urlStr = server;
}

-(void)setAppID:(NSString *)appID{
    _appID = appID;
}

-(void)setVADTimeoutFrontSIL:(NSString *)value{
    [_iFlySpeechRecognizer setParameter:value forKey:@"vad_bos"];
}

-(void)setVADTimeoutBackSIL:(NSString *)value{
    [_iFlySpeechRecognizer setParameter:value forKey:@"vad_eos"];
}

-(BOOL)isListening{
    return [_iFlySpeechRecognizer isListening];
}

#pragma mark -- initData
-(void)initData{
    _mStr = [[NSMutableString alloc] init];
    _cusid = @"test0001";
    _urlStr = @"http://api.olavoice.com/haobaibohao/olaweb/webvoice/api/ask";
    _frontsilVal = @"5000";
    _backsilVal = @"1800";
    _result = @"";
    
    //[self createJSON];
    //NSString *str = @"打电话给张三";
    //    NSString *bStr = (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
    //                                                                                 (CFStringRef)str,
    //                                                                                 NULL,
    //                                                                                 CFSTR(":/?#[]@!$&’()*+,;="),
    //                                                                                 kCFStringEncodingUTF8);
    //
    //[self sendKeyWordToServer:str];
    //    NSMutableArray *arry = [[NSMutableArray alloc] init];
    //    for(int i=0; i<1; i++){
    //        Contact *con = [[Contact alloc] init];
    //        NSString *test = @"test";
    //        NSString *num = [NSString stringWithFormat:@"%d",i];
    //        con.DisplayName = [test stringByAppendingString:num];
    //        [arry addObject:con];
    //    }
    //
    //    NSString *str = [self createContactJsonDatas:arry];
    //
    //    [self sendContactRequest:str];
}


#pragma mark --发送查询数据请求
-(void)sendKeyWordToServer:(NSString*)str{
    NSString *urlStr = [NSString stringWithFormat:@"%@",_urlStr];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //创建请求
    NSMutableURLRequest *requestM=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:5.0f];
    [requestM addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [requestM setHTTPMethod:@"POST"];//设置位post请求
    
    //创建post参数
    NSString *jsonStr = [self createJSON:str];
    
    NSString *bodyDataStr=[NSString stringWithFormat:@"appid=%@&cusid=%@&rq=%@",_appID,_cusid,jsonStr];
    NSData *bodyData=[bodyDataStr dataUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"bodyData = %@",[[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding]);
    [requestM setHTTPBody:bodyData];
    
    //发送一个异步请求
    [NSURLConnection sendAsynchronousRequest:requestM queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            //NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@"jsonStr:%@",jsonStr);
            [self.delegate OnSemanticResult:data];
            
        }else{
            [self.delegate connectServerError:connectionError];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            }];
        }
    }];
}


-(NSString*)createJSON:(NSString*)str{
    
    NSString* jsonStr = nil;
    
    //    NSMutableDictionary *dicLoc = [[NSMutableDictionary alloc] init];
    //    [dicLoc setObject:@"0" forKey:@"position_type"];
    //    [dicLoc setObject:@"1" forKey:@"is_last"];
    //    [dicLoc setObject:@"天潼路" forKey:@"street"];
    //    [dicLoc setObject:@"上海市" forKey:@"province"];
    //    [dicLoc setObject:[NSNumber numberWithLong:121481332] forKey:@"longitude"];
    //    [dicLoc setObject:@"619号" forKey:@"number"];
    //    [dicLoc setObject:[NSNumber numberWithLong:31243361] forKey:@"latitude"];
    //    [dicLoc setObject:@"闸北区" forKey:@"district"];
    //    [dicLoc setObject:@"上海市" forKey:@"city"];
    
    NSDictionary *dicLoc = [self.delegate getLocaion];
    
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
    [dicData setObject:str forKey:@"text"];
    if (dicLoc) {
        [dicData setObject:dicLoc forKey:@"location"];
    }
    [dicData setObject:[NSNumber numberWithInt:0] forKey:@"force_slot_replay"];
    [dicData setObject:[NSNumber numberWithInt:_input_type] forKey:@"input_type"];
    
    NSMutableDictionary *rp = [[NSMutableDictionary alloc] init];
    [rp setObject:@"stt" forKey:@"data_type"];
    [rp setObject:dicData forKey:@"data"];
    
    
    if ([NSJSONSerialization isValidJSONObject:rp]) {
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:rp options:0 error:0];
        jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", jsonStr);
    }
    
    
    return  jsonStr;
    
}


//麦克风输入方式
-(BOOL)micInput{
    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer];
    }
    
    [_iFlySpeechRecognizer cancel];
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    return [_iFlySpeechRecognizer startListening];
    
}


//音频流输入方式
-(BOOL)audioStreamInput{
    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer];
    }
    [_iFlySpeechRecognizer cancel];

    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_STREAM forKey:@"audio_source"];    //设置音频数据模式为音频流
    BOOL ret  = [_iFlySpeechRecognizer startListening];
    
    
    if (ret) {
        self.isCanceled = NO; //启动发送数据线程
        //初始化录音环境
        [IFlyAudioSession initRecordingAudioSession];
        
        //启动录音器服务
        BOOL ret = [_pcmRecorder start];
        
        
        //        [NSThread detachNewThreadSelector:@selector(sendAudioThread) toTarget:self withObject:nil];
        NSLog(@"%s[OUT],Success,Recorder ret=%d",__func__,ret);
        
        //        [NSThread sleepForTimeInterval:1];
        //        [IFlyAudioSession initRecordingAudioSession];
        //        _pcmRecorder.delegate = self;
        //        [_pcmRecorder start];

    }
    
    return ret;
}

//设置识别参数
-(void)initRecognizer{
    //单例模式
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iFlySpeechRecognizer.delegate = self;
    
    if (_iFlySpeechRecognizer != nil) {
   
        
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:_backsilVal forKey:@"vad_eos"];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:_frontsilVal forKey:@"vad_bos"];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
    
        [_iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
        
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT]];
        
        [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
       

        
    }
    
    //初始化录音器
    if (_pcmRecorder == nil)
    {
        _pcmRecorder = [IFlyPcmRecorder sharedInstance];
    }
    
    _pcmRecorder.delegate = self;
    
    [_pcmRecorder setSample:@"16000"];
    
    [_pcmRecorder setSaveAudioPath:nil];    //不保存录音文件

}

#pragma mark - IFlySpeechRecognizerDelegate
- (void) onError:(IFlySpeechError *) errorCode{
    if (errorCode.errorCode == 0) {
        if (_result.length != 0) {
            _result = @"";
        }
    }
    [self.delegate onError:errorCode.errorCode error:errorCode.errorDesc];
}

- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    NSString * resultFromJson =  [self stringFromJson:resultString];
    _result = [NSString stringWithFormat:@"%@%@", _result,resultFromJson];
    
}

- (void) onVolumeChanged: (int)volume{
    [self.delegate onVolumeChanged:volume];
}

- (void) onBeginOfSpeech{
    [self.delegate onBeginOfSpeech];
}

- (void) onEndOfSpeech{
    [self.delegate onEndOfSpeech];
    [self.delegate onResult:_result];
     }

- (void) onCancel{
    [self.delegate onCancel];
}


#pragma mark - IFlyPcmRecorderDelegate

- (void) onIFlyRecorderBuffer: (const void *)buffer bufferSize:(int)size{
    
    NSData *audioBuffer = [NSData dataWithBytes:buffer length:size];
    
    int ret = [self.iFlySpeechRecognizer writeAudio:audioBuffer];
    if (!ret)
    {
        [self.iFlySpeechRecognizer stopListening];
        
        
        
    }
}

- (void) onIFlyRecorderError:(IFlyPcmRecorder*)recoder theError:(int) error{
    

}

//power:0-100,注意控件返回的音频值为0-30
- (void) onIFlyRecorderVolumeChanged:(int) power{
    [self.delegate onPowerChanged:power];
         
    
}

- (NSString *)stringFromJson:(NSString*)params
{
    if (params == NULL) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //返回的格式必须为utf8的,否则发生未知错误
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (resultDic!= nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
    }
    return tempStr;
}





@end
