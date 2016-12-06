//
//  FinishChangePhoneVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/9.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "FinishChangePhoneVC.h"
#import "macro.h"
#import "CommonHeadFile.h"
@interface FinishChangePhoneVC ()<UITextFieldDelegate,MZTimerLabelDelegate>{
    UILabel *timer_show;
}

@end

@implementation FinishChangePhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _phoneNumberTextField.delegate = self;
    [_phoneNumberTextField setValue:[UIColor colorWithWhite:1.0 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    _verificationCodeTextField.delegate = self;
    [_verificationCodeTextField setValue:[UIColor colorWithWhite:1.0 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
}

- (IBAction)cancelButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)sendVerificationCodeButtonAction:(UIButton *)sender {
    [_sendButton setTitle:nil forState:UIControlStateNormal];//把按钮原先的名字消掉
    [_sendButton setBackgroundImage:[UIImage imageNamed:@"btn-gray-right-pressed"]  forState:UIControlStateNormal];
    timer_show = [[UILabel alloc] initWithFrame:CGRectMake(25*nKwidth, 190*nKheight, 115*nKwidth,30*nKheight)];//UILabel设置成和UIButton一样的尺寸和位置
    [_sendButton addSubview:timer_show];//把timer_show添加到_dynamicCode_btn按钮上
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:10];//倒计时时间60s
    timer_cutDown.timeFormat = @"重新发送(ss)";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = [UIColor whiteColor];//倒计时字体颜色
    timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//剧中
    timer_cutDown.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    _sendButton.userInteractionEnabled = NO;//按钮禁止点击
    [timer_cutDown start];//开始计时
    [self sendVerifyCode];//发送验证码
}

- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [timer_show removeFromSuperview];//移除倒计时模块
    _sendButton.userInteractionEnabled = YES;//按钮可以点击
    [_sendButton setBackgroundImage:[UIImage imageNamed:@"btn-right-abled"] forState:UIControlStateNormal];
    [_sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (IBAction)nextStepButtonAction:(UIButton *)sender {
            NSString* newPhoneNum = _phoneNumberTextField.text;//新手机号
            UserManager* userManager = [UserManager getUserManagerInstance];
            if ([self verifyPhoneNum:newPhoneNum]) {
                HttpConnect* httpCon = [HttpConnect getHttpConnectInstance];
                NSString* vcode = _verificationCodeTextField.text;
                SeverStatus severStatus = [httpCon changePhoneNum:userManager.oldPhoneNum dstPhoneNum:newPhoneNum vcode:vcode];
                switch (severStatus) {
                    case SEVERSTATUSSUCCESS:{
//                            userManager.phoneVcode = vcode;//保存新的验证码
//                            userManager.userName = newPhoneNum;//保存新的手机号码
//                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"手机号修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                            [alert show];
//                            
//                            NSLog(@"手机号修改成功");
                    }
                        break;
                    case SEVERSTATUSFAIL:{
                        
                           // errorLabel.text = @"校验码有误，请重新输入或者重新发送！";
                        
                        
                    }
                        break;
                    case NETWORKTIMEOUT:{
                        
                    }
                        break;
                    default:
                        break;
                }
            }
}

#pragma mark 检测当前网络状态
-(BOOL)checkCurrentNetworkState{
    NetworkStatus enabelWifi = [[CommonHeadFile getCommonHeadFileInstance] getNetWorkStates];
    //判断没有WiFi或者不是WiFi就打开WiFi的设置界面
    if(enabelWifi != ReachableViaWiFi){
        NSString *message = @"您的手机没有处在WIFI网络中";
        NSString *settingButton = @"设置";
        NSString *cancelButton = @"取消";
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *settingAction = [UIAlertAction actionWithTitle:settingButton style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButton style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            [alertDialog dismissViewControllerAnimated:YES completion:^{}];
        }];
        [alertDialog addAction:cancelAction];
        [alertDialog addAction:settingAction];
        [self presentViewController:alertDialog animated:YES completion:nil];
        return NO;
    }else{
        return YES;
    }
}


#pragma mark --判断手机号的有效性
-(BOOL)verifyPhoneNum:(NSString*)code{
    NSString* text = _phoneNumberTextField.text;
    NSString* numRegex = @"^[0-9]*$";
    NSPredicate *numTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numRegex];
    bool isNum = [numTest evaluateWithObject:text];//验证是否输入的是纯数字
    if (isNum){
        if (text.length == 11) {
            NSString* str = [text substringToIndex:1];
            if ([str isEqualToString:@"1"]) {
                if ([self serverValidPhoneNum:text]) {
                    return YES;
                }
            }
        }
    }
   _remindReasonLabel.text = @"输入的手机号有误!";
    return NO;
}


//服务器端验证手机号是否正确
-(BOOL)serverValidPhoneNum:(NSString*)phoneNum{
    HttpConnect* httpCon = [HttpConnect getHttpConnectInstance];
    BOOL isSuccess = [httpCon validatePhoneNum:phoneNum];
    return isSuccess;
}

//重新发送验证码
-(void)sendVerifyCode{
    NSLog(@"重新发送新手机的验证码");
    NSString* newPhoneNum = _phoneNumberTextField.text;
    HttpConnect* httpCon = [HttpConnect getHttpConnectInstance];
    UserManager* userManager = [UserManager getUserManagerInstance];
    [httpCon getVerifyCode:userManager.oldPhoneNum newPhoneNum:newPhoneNum vcode:userManager.oldVcode opt:@"change_mobile"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
