//
//  BindingPhoneVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/9.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "BindingPhoneVC.h"
#import "macro.h"
#import "CommonHeadFile.h"
@interface BindingPhoneVC ()<UITextFieldDelegate,MZTimerLabelDelegate
>{
    UILabel *timer_show;
}

@end

@implementation BindingPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_phoneNumberTextField setValue:[UIColor colorWithWhite:1.0 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    _phoneNumberTextField.delegate = self;
}
- (IBAction)cancelButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{   }];
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

-(void)sendVerifyCode{
    NSLog(@"重新发送原手机号验证码");
    HttpConnect* httpCon = [HttpConnect getHttpConnectInstance];
    [httpCon getVerifyCode:_phoneNumber newPhoneNum:@"" vcode:@"" opt:@"change_mobile"];
}

- (IBAction)nextStepButtonAction:(UIButton *)sender {
    HttpConnect* httpCon = [HttpConnect getHttpConnectInstance];
    NSString* vcode = _verificationCodeTextField.text;
    SeverStatus severStatus = [httpCon validateVcode:_phoneNumber vcode:vcode];
    switch (severStatus) {
        case SEVERSTATUSSUCCESS:
            
            break;
            
        case SEVERSTATUSFAIL:
            
            break;
            
        default:
            break;
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

#pragma mark 检查输入正确与否
////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self verifyPhoneNum:textField.text];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark --判断手机号的有效性
-(BOOL)verifyPhoneNum:(NSString*)code{
    NSString* text = _verificationCodeTextField.text;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
