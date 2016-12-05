//
//  ViaVoice.h
//  ViaVoice
//
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义音频输入的方式，目前有两种
typedef NS_OPTIONS(NSUInteger, SourceInput){
    MicInputSource,//麦克风
    audioStreamInputSource//音频流
};


#pragma mark --代理

@protocol ViaVoiceDelegate<NSObject>

@optional


/**
 *   错误信息的回调
 *
 *  @param type  错误类型 目前只定义了一个类型 VIAVOICE_TTS_ERROR
 *  @param error 错误
 */

- (void)onError:(int)type error:(NSString *)error;

//音量回调函数,值为0~30
- (void) onVolumeChanged: (int)volume;

////音量回调函数,值为0~100
-(void)onPowerChanged:(int)volume;

-(void)onResult:(NSString *) result;//语音识别结果回调接口

-(void)OnSemanticResult:(NSData *)semanticResult;//语义回调接口

-(void)connectServerError:(NSError *)connectionError;//连接语义服务器超时

//取消识别回调
- (void) onCancel;

/*
 *得到当前的位置信息
 */
-(NSDictionary*)getLocaion;


//上传/修改/删除联系人回调
-(void)onDataUploaded:(NSData*)result;

/*!
 *  开始录音回调
 *   当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。
 *  如果发生错误则回调onError:函数
 */
- (void) onBeginOfSpeech;

/*!
 *  停止录音回调
 *   当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。
 *  如果发生错误则回调onError:函数
 */
- (void) onEndOfSpeech;



@end

@interface ViaVoice : NSObject
-(id)initWithAppID:(NSString*)appid;
//代理
@property (nonatomic,assign) id<ViaVoiceDelegate> delegate;
//开始语音识别
- (BOOL)start:(SourceInput)type;

//结束录音，停止本次语音识别
- (void)stop;

//取消本次语音识别,停止所有相关回调
- (void)cancel;

//恢复默认值
-(void)reset;

//发送字符串到服务器进行语义识别
-(void)sendKeyWordToServer:(NSString*)str;

//设置CUSID
-(void)setCUSID:(NSString*)cusid;

//设置是语音输入还是文字输入 0:语音输入 1：文字输入
-(void)setInputType:(int)intputType;

//设置服务器地址
-(void)setServer:(NSString*)server;

//设置appid
-(void)setAppID:(NSString*)appID;

//设置VAD前端点超时范围 int 0~10000 (ms)
-(void)setVADTimeoutFrontSIL:(NSString*)value;

//设置VAD后端点超时范围 int 0-10000 (ms)
-(void)setVADTimeoutBackSIL:(NSString*)value;


//是否正在识别
-(BOOL)isListening;







@end
