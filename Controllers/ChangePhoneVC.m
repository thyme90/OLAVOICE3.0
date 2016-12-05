//
//  ChangePhoneVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/9.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "ChangePhoneVC.h"

@interface ChangePhoneVC ()

@end

@implementation ChangePhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)cancelButtonAction:(UIButton *)sender {
    
}
- (IBAction)sendVerificationCodeButtonAction:(UIButton *)sender {
    /*
    [sendButton setTitle:nil forState:UIControlStateNormal];//把按钮原先的名字消掉
    [sendButton setBackgroundImage:[UIImage imageNamed:@"btn-gray-right-pressed"]  forState:UIControlStateNormal];
    timer_show = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 78*WIDTHRATION,29*mKheight)];//UILabel设置成和UIButton一样的尺寸和位置
    [sendButton addSubview:timer_show];//把timer_show添加到_dynamicCode_btn按钮上
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:10];//倒计时时间60s
    timer_cutDown.timeFormat = @"重新发送(ss)";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = [UIColor whiteColor];//倒计时字体颜色
    timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//剧中
    timer_cutDown.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    sendButton.userInteractionEnabled = NO;//按钮禁止点击
    [timer_cutDown start];//开始计时
    [self sendVerifyCode];//发送验证码
     */
}
- (IBAction)nextStepAction:(UIButton *)sender {
    /*
    if (!textFile.text.length) {
        errorLabel.text = @"输入的不能验证码为空!";
        
    }else{
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
                
            }];
            
            [alertDialog addAction:cancelAction];
            [alertDialog addAction:settingAction];
            
            
            [m_superVC presentViewController:alertDialog animated:YES completion:nil];
        }else{
            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"      正在校验校验码！" preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            
            activeView.frame = CGRectMake(50,25,10,10);
            [activeView startAnimating];
            [alertDialog.view addSubview:activeView];
            [m_superVC presentViewController:alertDialog animated:YES completion:^(void){
                HttpConnect* httpCon = [HttpConnect getHttpConnectInstance];
                NSString* vcode = textFile.text;
                SeverStatus severStatus = [httpCon validateVcode:oldPhoneNum vcode:vcode];
                switch (severStatus) {
                    case SEVERSTATUSSUCCESS:{
                        [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                            [UserManager getUserManagerInstance].oldVcode = vcode;
                            [m_scVC setContentOffset:CGPointMake(Kwidth,0) animated:YES];
                        }];
                    }
                        break;
                    case SEVERSTATUSFAIL:{
                        [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                            errorLabel.text = @"您输入的验证码有误，请重新输入!";
                        }];
                        
                    }
                        break;
                    case NETWORKTIMEOUT:{
                        [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                            errorLabel.text = @"网络出错，请重新再试!";
                        }];
                    }
                        break;
                    default:
                        break;
                }
            }];
        }
    }
*/
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

/*
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [timer_show removeFromSuperview];//移除倒计时模块
    sendButton.userInteractionEnabled = YES;//按钮可以点击
    [sendButton setBackgroundImage:[UIImage imageNamed:@"btn-right-abled"] forState:UIControlStateNormal];
    [sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}

-(void)sendVerifyCode{
    NSLog(@"重新发送原手机号验证码");
    HttpConnect* httpCon = [HttpConnect getHttpConnectInstance];
    [httpCon getVerifyCode:oldPhoneNum newPhoneNum:@"" vcode:@"" opt:@"change_mobile"];
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
