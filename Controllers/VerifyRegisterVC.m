//
//  VerifyRegisterVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/12/6.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "VerifyRegisterVC.h"
#import "macro.h"
#import "CommonHeadFile.h"
@interface VerifyRegisterVC ()<UITextFieldDelegate,MZTimerLabelDelegate>{
    UILabel *timer_show;
}


@end

@implementation VerifyRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _remindView.hidden = YES;
    _remindLabel.hidden = YES;
    _accountRemindLabel.text = [NSString stringWithFormat:@"验证码已发送至%@",self.account];
    [self sendVerifyCodeToPhone];
    _verificationCodeTextField.delegate = self;
}

- (IBAction)backAndReInput:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:^{    }];
}

- (IBAction)sendVerificationCodeButtonClickAction:(id)sender {
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
    [self sendVerifyCodeToPhone];//发送验证码
}

- (IBAction)confirmButtonClickAction:(id)sender {
    if (_verificationCodeTextField.text.length > 2) {
        SeverStatus statu = [self sendToServerForRegisterAndLogin];
        switch (statu) {
            case SEVERSTATUSSUCCESS:
                _remindView.hidden = NO;
                _remindLabel.hidden = NO;
                _remindLabel.text = @"注册成功";
                [self performSelector:@selector(successDelayMethod) withObject:nil afterDelay:2.0f];
                break;
            case SEVERSTATUSFAIL:
                _remindView.hidden = NO;
                _remindLabel.hidden = NO;
                _remindLabel.text =@"注册失败";
                [self performSelector:@selector(failDelayMethod) withObject:nil afterDelay:2.0f];
                break;
            case NETWORKTIMEOUT:
                _remindView.hidden = NO;
                _remindLabel.hidden = NO;
                _remindLabel.text =@"注册超时";
                [self performSelector:@selector(failDelayMethod) withObject:nil afterDelay:2.0f];
                break;
                
            default:
                break;
        }
    }
}

- (void)successDelayMethod{
    _remindView.hidden = YES;
    _remindLabel.hidden = YES;
    [self performSegueWithIdentifier:@"toRegisterBackMainPage" sender:self];
}
- (void)failDelayMethod{
    _remindView.hidden = YES;
    _remindLabel.hidden = YES;
}

-(void)sendVerifyCodeToPhone{
    HttpConnect* httpCon = [HttpConnect getHttpConnectInstance];
    [httpCon getVerifyCode:self.account newPhoneNum:@"" vcode:@"" opt:@"login"];
}

#pragma mark--实现定时器类定义的接口
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [timer_show removeFromSuperview];//移除倒计时模块
    [_sendVerificationButton setTitle:@"重新发送" forState:UIControlStateNormal];//倒计时结束后按钮名称改为"发送验证码"
    _sendVerificationButton.userInteractionEnabled = YES;//按钮可以点击
}

#pragma mark --把当前用户的注册\登陆信息发送给sever
-(SeverStatus)sendToServerForRegisterAndLogin{
    NSString* phoneNum = self.account;
    NSString* verifyCode = _verificationCodeTextField.text;
    NSString *url = nil;
    //注册和登陆对应的网址是不一样的，所以要做区分
    if (self.accountType == PHONEREGISTER) {
        url =[[NSString alloc] initWithFormat:@"%@mobile=%@&vcode=%@&deviceid=%@&clientid=%@",REGISTERURL,phoneNum,verifyCode,DEVICEID,CLINETID];
    }
    NSURLRequest *urlRequest =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIMEOUTINTERVAL];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data is %@",aString);
    
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
            if (self.accountType == PHONEREGISTER) {
                NSLog(@"手机注册成功");
            }else if (self.accountType == PHONENUMSUCCESS){
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

#pragma mark textfield Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    // 如果点击到UITextField以外的View则收回键盘
    if (![touch.view isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
