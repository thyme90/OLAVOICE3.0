//
//  VoiceView.m
//  DialogDemo
//
//  Created by yanminli on 2016/10/21.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "VoiceView.h"
#import "DialogView.h"
#import "SDAutoLayout.h"
#import "ViaVoice.h"
#import "commonHeader.h"
#import "QuestionModel.h"
#import "WeatherModel.h"
#import "BaikeiModel.h"
#import "PersonBaikeModel.h"
#import "NewsModel.h"
#import "NewsContentModel.h"
#import "AnswerModel.h"
#import "YMWaterWaveView.h"
#import "YSCVoiceWaveView.h"
#import "NSString+Extension.h"
#import "TTSInterfaceAdapter.h"
#import "SelectionBaikeModel.h"
#import "FunctionModel.h"
#import <iflyMSC/iflyMSC.h>

#define APPID_VALUE           @"583bd19f"

@interface VoiceView()<ViaVoiceDelegate,DialogViewDelegate,CAAnimationDelegate,YSCVoiceWaveViewDeleagte>
@property (nonatomic,strong) ViaVoice               *viaVoiceSDK;//语音转文字的接口

@property (nonatomic,strong) NSString               *ttsText;//tts播放的文本
@property (nonatomic,strong) NSString               *ttsStr;//语音转换后的字符串
@property (nonatomic,strong) YSCVoiceWaveView       *voiceWaveView;//水波纹
@property (nonatomic,assign) BOOL                   isAnotherTopic;//如果不是新闻，百科和天气，就为true;
@property (nonatomic,strong) TTSInterfaceAdapter    *ttsInterface;//语音播放的接口
@property (nonatomic,strong) UIButton               *centerButton;//话筒
@property (nonatomic,assign) int volPower;
@end

@implementation VoiceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //UIImage *bgImage = [UIImage imageNamed:@"background"];
    //self.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    //self.backgroundColor = [UIColor redColor];

    
}*/


-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
        [self initVoiceData];
    }
    
    return self;
}


-(void)setupView{
    
    _DlgView = [[DialogView alloc] init];
    _DlgView.delegate = self;
    [self addSubview:_DlgView];
    
    _DlgView.sd_layout.leftSpaceToView(self,0)
    .topSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .heightRatioToView(self,0.88);
    
    
    _voiceWaveView = [[YSCVoiceWaveView alloc] init];
    _voiceWaveView.delegate = self;
    //_voiceWaveView.backgroundColor = [UIColor blueColor];
    _voiceWaveView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 110);
    [self.voiceWaveView startVoiceWave];
    [self addSubview:_voiceWaveView];

    
    _centerButton = [[UIButton alloc] init];
    [_centerButton setImage:[UIImage imageNamed:@"icnMicrophon"] forState:UIControlStateNormal];
    [_centerButton setImage:[UIImage imageNamed:@"icnMicrophon"] forState:UIControlStateHighlighted];
    [_centerButton setImage:[UIImage imageNamed:@"icnMicrophon"] forState:UIControlStateSelected];
    [_centerButton setImage:[UIImage imageNamed:@"icnMicrophon"] forState:UIControlStateSelected | UIControlStateHighlighted];
    _centerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _centerButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_centerButton];
    [self setButtonShadow:YES];
    [_centerButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _centerButton.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(_DlgView, 0)
    .widthIs(24)
    .heightIs(36);
}


-(void)buttonClick{
    [self setButtonShadow:NO];
    
    [_ttsInterface stopSound];
    [_viaVoiceSDK reset];
    [_viaVoiceSDK start:MicInputSource];
    
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"voiceClick" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}

#pragma mark --初始化信息
-(void)initVoiceData{
    _ttsInterface = [[TTSInterfaceAdapter alloc] init];
    [self iflyInit];
    _viaVoiceSDK = [[ViaVoice alloc] initWithAppID:OLAAPPID];
    [_viaVoiceSDK setServer:@"http://api.olavoice.com:8000/olaweb/webvoice/api/ask?tts=1"];
    [_viaVoiceSDK setCUSID:OLAAPPID];
    _viaVoiceSDK.delegate = self;
    }


//################# VIAVOICE的代理的实现#####################################################

#pragma mark--语音识别返回的结果
-(void)onResult:(NSString*)result{
    //NSSLog(@"enter onResult");
    _ttsStr = result;
    //如果什么都没说，不生成question模块
    if (![_ttsStr isEmpty]) {
        QuestionModel   *model = [[QuestionModel alloc] init];
        model.sendText = result;
        
        [_DlgView.dataArray addObject:model];
        [_DlgView.modeTypeArray addObject:@"question"];
        
        //[_DlgView.tableView reloadData];
            unsigned long num = self.DlgView.dataArray.count;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:num-1  inSection:0];
            [self.DlgView.tableView insertRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
            [self.DlgView.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];


    }
    
    [_viaVoiceSDK sendKeyWordToServer:_ttsStr];
    //水波纹开始下降
    [self waterDownAnimation];
    
}

#pragma mark--从服务器返回的语义理解的结果
-(void)OnSemanticResult:(NSData *)semanticResult{
    //NSSLog(@"enter OnSemanticResult");
    //间隔0.5秒删除Button发光的动画
    [self performSelector:@selector(removeButtonAnimation) withObject:nil afterDelay:0.5];
    
    NSError *err;
    NSArray *dicArry = [NSJSONSerialization JSONObjectWithData:semanticResult
                                                       options:NSJSONReadingMutableContainers
                                                         error:&err];
    NSString *jsonStr=[[NSString alloc]initWithData:semanticResult encoding:NSUTF8StringEncoding];
    NSSLog(@"jsonStr is %@",jsonStr);
    if (err) {
        NSSLog(@"从服务器获得的字符串解析出错，错误信息%@",err);
        return;
    }

    //type的值，说明目前是那个APP
    NSDictionary    *dic = [dicArry objectAtIndex:0];
    NSString *appType = [dic objectForKey:@"type"];
    
    //求desc_obj的值
    NSDictionary    *descDic = [dic objectForKey:@"desc_obj"];
    NSString *desctype = [descDic objectForKey:@"type"];
    

    
    _isAnotherTopic = NO;
    /*
     weather:天气
     baike:百科
     person_baike：人物百科 例如问：中国历任国家主席是谁
     news:新闻
     newscontent：新闻的详细内容
    */
    
    if([appType isEqualToString:@"weather"]){
        WeatherModel    *model = [[WeatherModel alloc] initWithData:dic];
        model.modelType = appType;
        [_DlgView.dataArray addObject:model];
        [_DlgView.modeTypeArray addObject:model.modelType];
        
    }else if([appType isEqualToString:@"baike"]){
        BaikeiModel *model =[[BaikeiModel alloc] initWithData:dic];
        [_DlgView.dataArray addObject:model];
        [_DlgView.modeTypeArray addObject:@"baike"];
                
    }else if([appType isEqualToString:@"selection"] && [desctype isEqualToString:@"person_baike"]){
        PersonBaikeModel    *model = [[PersonBaikeModel alloc] initWithData:dic];
        [_DlgView.dataArray addObject:model];
        [_DlgView.modeTypeArray addObject:@"person_baike"];
    }else if([desctype isEqualToString:@"news"]){
        NewsModel    *model = [[NewsModel alloc] initWithData:dic];
        [_DlgView.dataArray addObject:model];
        [_DlgView.modeTypeArray addObject:@"news"];
    }else if([appType isEqualToString:@"news"]){
        NewsContentModel    *model = [[NewsContentModel alloc] initWithData:dic];
        [_DlgView.dataArray addObject:model];
        [_DlgView.modeTypeArray addObject:@"newscontent"];
    }else if([appType isEqualToString:@"nonsense"] || [appType isEqualToString:@"question"] || [appType isEqualToString:@"unknown"]){
        AnswerModel     *model = [[AnswerModel alloc] initWithData:dic];
        [_DlgView.dataArray addObject:model];
        [_DlgView.modeTypeArray addObject:@"answer"];
    }else if([appType isEqualToString:@"selection"] && [desctype isEqualToString:@"baike"]){
        SelectionBaikeModel    *model = [[SelectionBaikeModel alloc] initWithData:dic];
        [_DlgView.dataArray addObject:model];
        [_DlgView.modeTypeArray addObject:@"selectionbaike"];
    }else {
        AnswerModel     *model = [[AnswerModel alloc] init];
        [_DlgView.dataArray addObject:model];
        [_DlgView.modeTypeArray addObject:@"answer"];
        _isAnotherTopic = YES;
       
    }

    
    //[_DlgView.tableView reloadData];
    if (_isAnotherTopic) {
         _ttsText = @"目前只支持百科，新闻和天气，请换个话题";
    }else{
        _ttsText = [descDic objectForKey:@"tts"];

    }
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSSLog(@"playSound");
        [_ttsInterface playSound:_ttsText];
    });
    
    //给tableView插入新的cell
    unsigned long num = self.DlgView.dataArray.count;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:num-1  inSection:0];
    [self.DlgView.tableView insertRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
    [self.DlgView.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];

    
}

-(void)onBeginOfSpeech{
    [self waterUpAnimation];//水波纹开始上
}

-(void)onEndOfSpeech{
    
}


-(void)onError:(int)type error:(NSString *)error{
    //NSSLog(@"onError type is %d",type);

    if (error) {
        NSSLog(@"error is %@",error);
    }
    
}

-(NSDictionary*)getLocaion{
    return nil;
}

-(void)connectServerError:(NSError *)connectionError{
    NSLog(@"connect sever error is %@",connectionError.localizedDescription);
    [self removeButtonAnimation];
}

-(void)onPowerChanged:(int)volume{
    
}

#pragma mark --声音变化的值
-(void)onVolumeChanged:(int)volume{
    //范围是1~30
    _volPower = volume;
//    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
//    NSLog(@"vol is %@",vol);

}

#pragma mark--取消的回调函数
-(void)onCancel{
    
}

//############################################################################################


//手动输入文字或者点击item，向服务器发送请求.例如点击新闻的某一项
-(void)sendMessageToServer:(NSString *)message{
    [_ttsInterface stopSound];
    [self performSelector:@selector(delaySendText:) withObject:message afterDelay:0.5];
    
}

-(void)delaySendText:(NSString*)message{
    [_viaVoiceSDK sendKeyWordToServer:message];
}

#pragma mark-- 设置button的阴影
-(void)setButtonShadow:(BOOL)isShadow{
    if (isShadow) {
        _centerButton.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        _centerButton.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _centerButton.layer.shadowOpacity = 1;//阴影透明度，默认0
        _centerButton.layer.shadowRadius = 15;//阴影半径，默认3
        
    }else{
        _centerButton.layer.shadowOpacity = 0;
    }
}

#pragma mark-- 音量波纹的回调函数
-(float)volNum{
    float num = 0.0f;
    float vol = _volPower;
    num = vol/90;
    //NSSLog(@"num is %f",num);
    return num;
}




#pragma mark--话筒发光的动画
- (CABasicAnimation *)ImgViewShadowOpacity:(CGFloat)fromVal toVal:(CGFloat)toVal duration:(CGFloat)duration {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:fromVal];
    anim.toValue =[NSNumber numberWithFloat:toVal];
    anim.duration = duration;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.delegate = self;
    return anim;
}

#pragma mark--动画结束时调用的回调函数,实现话筒发光的效果
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([_centerButton.layer animationForKey:@"myShadowOpacity0"] == anim) {
        
        [_centerButton.layer removeAllAnimations];
        [_centerButton.layer addAnimation:[self ImgViewShadowOpacity:0.7 toVal:1 duration:0.01] forKey:@"myShadowOpacity1"];
        
        
    }else if ([_centerButton.layer animationForKey:@"myShadowOpacity1"] == anim) {
        
        [_centerButton.layer removeAllAnimations];
        [_centerButton.layer addAnimation:[self ImgViewShadowOpacity:1 toVal:0.3 duration:0.4] forKey:@"myShadowOpacity2"];
        
        
    }else if ([_centerButton.layer animationForKey:@"myShadowOpacity2"] == anim) {
        
        [_centerButton.layer removeAllAnimations];
        [_centerButton.layer addAnimation:[self ImgViewShadowOpacity:0.5 toVal:1 duration:0.4] forKey:@"myShadowOpacity0"];
        
        
    }
    
}

#pragma makr--waterWave animation
-(void)waterUpAnimation{ //水波纹上升的动画
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        _voiceWaveView.frame = CGRectMake(0, self.frame.size.height-110, self.frame.size.width, 110);
    }completion:^(BOOL finished){
        //NSLog(@"waterAnimatino done!");
    }];
}

#pragma mark-- 水波纹下降的动画
-(void)waterDownAnimation{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        _voiceWaveView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 220);
    }completion:^(BOOL finished){
        //水波纹下降以后，话筒开始发光
        _centerButton.layer.shadowColor = [UIColor whiteColor].CGColor;
        _centerButton.layer.shadowOpacity = 1;
        [_centerButton.layer addAnimation:[self ImgViewShadowOpacity:1 toVal:0.7 duration:0.5] forKey:@"myShadowOpacity0"];
    }];
}

#pragma mark--当收到消息收结束话筒发光动画
-(void)removeButtonAnimation{
    [_centerButton.layer removeAllAnimations];
    [self setButtonShadow:YES];
}

//讯飞语音的初始化
-(void)iflyInit{
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:NO];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}

-(void)createFunctionCell{
    FunctionModel *model = [[FunctionModel alloc] init];
    model.modelType = @"function";
    
    [_DlgView.dataArray addObject:model];
    [_DlgView.modeTypeArray addObject:model.modelType];
    
    //[_DlgView.tableView reloadData];
    unsigned long num = self.DlgView.dataArray.count;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:num-1  inSection:0];
    [self.DlgView.tableView insertRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
    [self.DlgView.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
}

@end
