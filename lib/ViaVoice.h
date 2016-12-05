//
//  ViaVoice.h
//  ViaVoice
//
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"


static    const int VIAVOICE_TTS_ERROR = 2301;
/**
 * VIAVOICE onEvent type 开始录音
 */
static    const int VIAVOICE_EVENT_RECORDING_START = 1101;
/**
 * VIAVOICE onEvent type 结束录音
 */
static    const int VIAVOICE_EVENT_RECORDING_STOP = 1102;
/**
 * VIAVOICE onEvent type VAD 超时
 */
static    const int VIAVOICE_EVENT_VAD_TIMEOUT = 1103;
/**
 * VIAVOICE onEvent type 检测到说话
 */
static    const int VIAVOICE_EVENT_SPEECH_DETECTED = 1104;
/**
 * VIAVOICE onEvent type 说话停止
 */
static    const int VIAVOICE_EVENT_SPEECH_END = 1105;

/**
 * VIAVOICE onEvent type 取消
 */
static    const int VIAVOICE_EVENT_CANCEL = 1117;

/**
 *  识别结束
 */
static    const int VIAVOICE_EVENT_END = 1120;

/**
 *  识别超时
 */
static    const int VIAVOICE_EVENT_RECOGNITION_TIMEOUT = 1123;

/**
 * VIAVOICE onEvent type 语义理解结束
 */
static    const int VIAVOICE_EVENT_VOLUMECHANGE = 1122;



#pragma mark --代理

@protocol ViaVoiceDelegate<NSObject>

@optional
/**
 *  事件回调
 *
 *  @param type 事件类型:如SPPEECHSTART,RECORDINGSTART,RECORDINGSTOP
 *
 */
- (void)onEvent:(int)type;


/**
 *   错误信息的回调
 *
 *  @param type  错误类型 目前只定义了一个类型 VIAVOICE_TTS_ERROR
 *  @param error 错误
 */

- (void)onError:(int)type error:(NSError *)error;


-(void)onResult:(NSString*)result;//语音识别结果回调接口


-(void)OnSemanticResult:(NSData *)semanticResult;//语义回调接口

/*
 *得到当前的位置信息
 */
-(NSDictionary*)getLocaion;


//上传/修改/删除联系人回调
-(void)onDataUploaded:(NSData*)result;


@end

@interface ViaVoice : NSObject

//代理
@property (nonatomic,assign) id<ViaVoiceDelegate> delegate;

//APPID必须构造的时候传入,或者使用默认构造函数后，设置APPID
-(id)initWithAppID:(NSString*)appID;

//开始语音识别
- (void)start;

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


//上传或者修改多个联系人信息
-(void)addOrModifyContacts:(NSArray*)contacts;


//上传或者修改单个联系人信息
-(void)addOrModifyContact:(Contact*)contact;

//设置服务器地址
-(void)setServer:(NSString*)server;

//设置appid
-(void)setAppID:(NSString*)appID;

//设置VAD前端点超时范围 int 1000~10000 (ms)
-(void)setVADTimeoutFrontSIL:(NSString*)value;

//设置VAD后端点超时范围 int 300-1000 (ms)
-(void)setVADTimeoutBackSIL:(NSString*)value;





@end
