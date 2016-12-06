//
//  VerifyVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/16.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "VerifyVC.h"
#import "macro.h"
@interface VerifyVC ()<UITextFieldDelegate,MZTimerLabelDelegate>{
    UILabel *timer_show;
}

@end

@implementation VerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_verificationCodeTextField setValue:[UIColor colorWithWhite:1.0 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    if (_accountType == PHONENUMBER) {
        _verifyTypeImage.image =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"icnMessage" ofType:@"png"]];
    }else if (_accountType == MAILBOXNUMBER){
        _verifyTypeImage.image =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"icnMail" ofType:@"png"]];
    }else{
        
    }
    _verifyTypeLabel.hidden = YES;
}

- (IBAction)sendVerificationButtonAction:(UIButton *)sender {
    [_sendVerificationButton setTitle:nil forState:UIControlStateNormal];//把按钮原先的名字消掉
    [_sendVerificationButton setBackgroundImage:[UIImage imageNamed:@"btn-gray-right-pressed"]  forState:UIControlStateNormal];
    timer_show = [[UILabel alloc] initWithFrame:CGRectMake(265*nKwidth, 332*nKheight, 85*nKwidth,25*nKheight)];//UILabel设置成和UIButton一样的尺寸和位置
    [_sendVerificationButton addSubview:timer_show];//把timer_show添加到_dynamicCode_btn按钮上
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:10];//倒计时时间60s
    timer_cutDown.timeFormat = @"重新发送(ss)";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = [UIColor whiteColor];//倒计时字体颜色
    timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//剧中
    timer_cutDown.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    _sendVerificationButton.userInteractionEnabled = NO;//按钮禁止点击
    [timer_cutDown start];//开始计时
    [self sendVerifyCode];//发送验证码
}

- (IBAction)confirmVerifyFinish:(UIButton *)sender {
    //验证码后登录
    //[self performSegueWithIdentifier:@"finishMessageLogToMainPage" sender:self];
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"      正在登陆" preferredStyle:UIAlertControllerStyleAlert];
    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activeView.frame = CGRectMake(50,25,10,10);
    [activeView startAnimating];
    [alertDialog.view addSubview:activeView];
    [self presentViewController:alertDialog animated:YES completion:^(void){
        SeverStatus severStatus = [self sendToServerForRegisterAndLogin];
        switch (severStatus) {
            case SEVERSTATUSSUCCESS:{
                
            }
                break;
            case SEVERSTATUSFAIL:{
                
            }
                break;
            case NETWORKTIMEOUT:{
                
            }
            default:
                break;
        }
    }];
    //验证后修改密码
    //[self performSegueWithIdentifier:@"toResetPasswordPage" sender:self];
}

- (IBAction)backToLoginPage:(UITapGestureRecognizer *)sender {
    [self  dismissViewControllerAnimated:YES completion:^{    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toResetPasswordPage"]) {
        ResetPasswordVC *resetPasswordVC = [segue destinationViewController];
       resetPasswordVC.account = self.account;
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

#pragma mark--实现定时器类定义的接口
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [timer_show removeFromSuperview];//移除倒计时模块
    [_sendVerificationButton setTitle:@"重新发送" forState:UIControlStateNormal];//倒计时结束后按钮名称改为"发送验证码"
    _sendVerificationButton.userInteractionEnabled = YES;//按钮可以点击
    //[_sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}

#pragma mark --把当前用户的注册
-(SeverStatus)sendToServerForRegisterAndLogin{
    NSString* phoneNum = self.account;
    NSString* verifyCode = _verificationCodeTextField.text;
    NSString *url = nil;
    if (self.accountType == PHONENUMSUCCESS){
        url =[[NSString alloc] initWithFormat:@"%@mobile=%@&vcode=%@&deviceid=%@&clientid=%@",LOGINURL,phoneNum,verifyCode,DEVICEID,CLINETID];
    }
    NSURLRequest *urlRequest =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIMEOUTINTERVAL];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    int status = -1;
    NSDictionary* dataDic = nil;
    //连接成功
    if (error == nil){
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:&error];
        if (dictionary){
            status =[[dictionary objectForKey:@"status"] intValue];
            dataDic = [dictionary objectForKey:@"data"];
            NSLog(@"手机状态码%d",status);
        }
        //status = 0 成功，-1失败
        if (!status) {
             if (self.accountType == PHONENUMSUCCESS){
                NSLog(@"手机登陆成功");
            }
            NSString* nickName = [dataDic objectForKey:@"nickname"];
            NSString* imgUrl = [dataDic objectForKey:@"imgurl"];
            
            UserManager* userManger = [UserManager getUserManagerInstance];
            userManger.nickName = nickName;
            userManger.imgurl = imgUrl;
            userManger.isLog = YES;
            userManger.userName = self.account;
            userManger.accountType = PHONENUMSUCCESS;
            userManger.phoneVcode = verifyCode;
            return SEVERSTATUSSUCCESS;
        }else{
            return SEVERSTATUSFAIL;
        }
    }else{
        return NETWORKTIMEOUT;
    }
}

-(void)sendVerifyCode{
    NSLog(@"重新发送登录验证");
    HttpConnect* httpCon = [HttpConnect getHttpConnectInstance];
    [httpCon getVerifyCode:self.account newPhoneNum:@"" vcode:@"" opt:@"login"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
