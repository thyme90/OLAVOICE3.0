//
//  VerifyVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/16.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "VerifyVC.h"
#import "macro.h"
@interface VerifyVC ()

@end

@implementation VerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
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
    
}

- (IBAction)confirmVerifyFinish:(UIButton *)sender {
    
}

- (IBAction)backToLoginPage:(UITapGestureRecognizer *)sender {
    [self  dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toResetPasswordPage"]) {
        ResetPasswordVC *resetPasswordVC = [segue destinationViewController];
       resetPasswordVC.account = self.account;
    }
}

#pragma  mark 验证手机
-(void)sendVerifyMailAlertView{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil
                                                   message:@"验证邮件已发送至您的邮箱"
                                                  delegate:self
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil,nil];
    [alert show];
}

/*
-(void)sendToServerForRegister{
    NSString *url=[[NSString alloc] initWithFormat:@"%@user=%@&password=%@&deviceid=%@&clientid=%@",REGISTERURL,self.mailbox,self.passwd,DEVICEID,CLINETID];
    //NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLRequest *urlRequest =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIMEOUTINTERVAL];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data is %@",aString);
    
    int status = -1;
    NSString* mes = nil;
    //连接成功
    if (error == nil){
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        
        if ([jsonObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *dictionary = (NSDictionary *)jsonObject;
            status =[[dictionary objectForKey:@"status"] intValue];
            mes = [dictionary objectForKey:@"msg"];
            NSLog(@"邮箱注册状态码%d",status);
            NSLog(@"message %@",mes);
        }
        //status = 0 成功，-1失败
        if (!status) {
            
        }
    }
}

-(void)mailBoxActivate{
    NSURL *url = [NSURL URLWithString:CHECKUSERURL];
    NSString *post=[[NSString alloc] initWithFormat:@"user=%@&clientid=%@",self.mailbox,CLINETID];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10.0];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               int status = -1;
                               NSDictionary *dictionary = nil;
                               
                               if (error) {
                                   NSLog(@"Httperror:%@%ld", error.localizedDescription,(long)error.code);
                                   
                               }else{
                                   
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   
                                   NSLog(@"HttpResponseCode:%ld", (long)responseCode);
                                   //NSLog(@"HttpResponseBody %@",responseStr);
                                   id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                   options:NSJSONReadingAllowFragments
                                                                                     error:&error];
                                   
                                   if ([jsonObject isKindOfClass:[NSDictionary class]]){
                                       dictionary = (NSDictionary *)jsonObject;
                                       status =  [[dictionary objectForKey:@"status"] intValue];
                                       NSDictionary *dataDic = [dictionary objectForKey:@"data"];
                                       NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                                       NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:dataDic];
                                       
                                       //由于已经注册，这个时候status值为1
                                       if (status) {
                                           [userDefaultes setObject:dict forKey:self.mailbox];
                                           [dict setValue:self.passwd forKey:@"mailBoxPasswd"];//明文密码
                                           [dict setValue:self.passwdMD5 forKey:@"md5"];//md5加密过后的密码
                                       }
                                   }
                               }
                           }];
}

#pragma mark --验证用户是否被激活
//这个是同步实现
-(void)mailBoxActivate1{
    NSString *urlStr=[[NSString alloc] initWithFormat:@"%@user=%@&clientid=%@",CHECKUSERURL,self.mailbox,CLINETID];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (!error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:&error];
        int status = -1;
 
        if (dictionary){
            status =[[dictionary objectForKey:@"status"] intValue];
            //NSLog(@"用户是否存在状态码是%d",status);
            NSDictionary *dataDic = [dictionary objectForKey:@"data"];
            //            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            //            NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:dataDic];
            
            //由于已经注册，这个时候status值为1 填写邮箱的个人信息
            if (status) {
                //                [userDefaultes setObject:dict forKey:self.mailbox];
                //                [dict setValue:self.passwd forKey:@"mailBoxPasswd"];//明文密码
                //                [dict setValue:self.passwdMD5 forKey:@"md5"];//md5加密过后的密码
                //
                //                [userDefaultes synchronize];
                NSString* nickName = [dataDic objectForKey:@"nickname"];
                int verified = [[dataDic objectForKey:@"verified"] intValue];
                NSString* imgUrl = [dataDic objectForKey:@"imgurl"];
                UserManager* userManger = [UserManager getUserManagerInstance];
                userManger.nickName = nickName;
                userManger.verified = verified;
                userManger.imgurl = imgUrl;
                userManger.passwd = self.passwd;
                userManger.passwdMD5 = self.passwdMD5;
                userManger.isLog = YES;
                userManger.userName = self.mailbox;
                userManger.accountType = MAILBOXSUCCESS;
            }
        }
    }
}

*/
#pragma  mark 验证邮箱

/*
 #pragma mark --登录的流程
 -(void)loginButtonClick{
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
 
        [self presentViewController:alertDialog animated:YES completion:nil];
    }else{
        if (!textFile.text.length ) {
            errorLabel.hidden = NO;
            return;
        }
        
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"      正在登陆" preferredStyle:UIAlertControllerStyleAlert];
        UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
 
        activeView.frame = CGRectMake(50,25,10,10);
        [activeView startAnimating];
        [alertDialog.view addSubview:activeView];
        [self presentViewController:alertDialog animated:YES completion:^(void){
            SeverStatus severStatus = [self sendToServerForRegisterAndLogin];
            switch (severStatus) {
                case SEVERSTATUSSUCCESS:{
                    [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@""
                                                                       message:@"登陆成功"
                                                                      delegate:self
                                                             cancelButtonTitle:nil
                                                             otherButtonTitles:nil,nil];
                        [alert show];
                        
                        double delayInSeconds = 2;
                        dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                            [alert dismissWithClickedButtonIndex:0  animated:NO];
                            // AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                            //LoginViewController* loginView = (LoginViewController*)(tempAppDelegate.m_leftSlideVC.leftVC);
                            //if (loginView) {
                            // [loginView reloadLeftVC];
                            // }
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            
                        });
                    }];
                }
                    break;
                case SEVERSTATUSFAIL:{
                    [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                        errorLabel.hidden = NO;
                    }];
                }
                    break;
                case NETWORKTIMEOUT:{
                    [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                        errorLabel.hidden = YES;
                        errorLabel.text = @"网路有问题，请重新再试!";
                    }];
                }
                default:
                    break;
            }
        }];
    }
}

#pragma mark --注册的流程
-(void)registerButtonClick{
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
        
        [self presentViewController:alertDialog animated:YES completion:nil];
    }else{
        if (!textFile.text.length ) {
            errorLabel.hidden = NO;
            return;
        }
        
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"      正在注册" preferredStyle:UIAlertControllerStyleAlert];
        UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
 
        activeView.frame = CGRectMake(50,25,10,10);
        [activeView startAnimating];
        [alertDialog.view addSubview:activeView];
        [self presentViewController:alertDialog animated:YES completion:^(void){
            SeverStatus severStatus = [self sendToServerForRegisterAndLogin];
            switch (severStatus) {
                case SEVERSTATUSSUCCESS:{
                    [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@""
                                                                       message:@"注册成功"
                                                                      delegate:self
                                                             cancelButtonTitle:nil
                                                             otherButtonTitles:nil,nil];
                        [alert show];
                        
                        double delayInSeconds = 2;
                        dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                            [alert dismissWithClickedButtonIndex:0  animated:NO];
                            //  AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                            //LoginViewController* loginView = (LoginViewController*)(tempAppDelegate.m_leftSlideVC.leftVC);
                            // if (loginView) {
                            //   [loginView reloadLeftVC];
                            //  }
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            
                        });
                    }];
                }
                    break;
                case SEVERSTATUSFAIL:{
                    [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                        errorLabel.hidden = NO;
                    }];
                }
                    break;
                case NETWORKTIMEOUT:{
                    [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                        errorLabel.hidden = YES;
                        errorLabel.text = @"网路有问题，请重新再试!";
                    }];
                }
                default:
                    break;
            }
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    errorLabel.text = @"";
    
    NSString* text = [[NSString alloc] initWithFormat:@"%@%@",@"验证码已发送至",self.userPhoneNum];
    showAccountLabel.text = text;
    
    sendButton.alpha = 0.7;
    [sendButton setTitle:nil forState:UIControlStateNormal];//把按钮原先的名字消掉
    //[sendButton setBackgroundImage:[UIImage imageNamed:@"btn-gray-right-pressed"] forState:UIControlStateNormal];
    timer_show = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 83*WIDTHRATION,32*mKheight)];//UILabel设置成和UIButton一样的尺寸和位置
    [sendButton addSubview:timer_show];//把timer_show添加到_dynamicCode_btn按钮上
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:60];//倒计时时间60s
    timer_cutDown.timeFormat = @"重新发送(ss)";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；
    timer_cutDown.timeLabel.textColor = [UIColor whiteColor];//倒计时字体颜色
    timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//剧中
    timer_cutDown.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    sendButton.userInteractionEnabled = NO;//按钮禁止点击
    [timer_cutDown start];//开始计时
}

-(void)sendButtonClick{
    errorLabel.hidden = YES;
    [sendButton setTitle:nil forState:UIControlStateNormal];//把按钮原先的名字消掉
    sendButton.alpha = 0.7;
    //[sendButton setBackgroundImage:[UIImage imageNamed:@"btn-gray-right-pressed"] forState:UIControlStateNormal];
    timer_show = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 78*WIDTHRATION,29*mKheight)];//UILabel设置成和UIButton一样的尺寸和位置
    [sendButton addSubview:timer_show];//把timer_show添加到_dynamicCode_btn按钮上
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:60];//倒计时时间60s
    timer_cutDown.timeFormat = @"重新发送(ss)";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = [UIColor whiteColor];//倒计时字体颜色
    timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//剧中
    timer_cutDown.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    sendButton.userInteractionEnabled = NO;//按钮禁止点击
    [timer_cutDown start];//开始计时
    [self sendVerifyCode];//重新发送验证码
    
}

#pragma mark--实现定时器类定义的接口
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [sendButton setTitle:@"重新发送" forState:UIControlStateNormal];//倒计时结束后按钮名称改为"发送验证码"
    [timer_show removeFromSuperview];//移除倒计时模块
    sendButton.userInteractionEnabled = YES;//按钮禁止点击
    sendButton.alpha = 1;
}


-(void)sendVerifyCode{
    NSLog(@"重新发送登录验证");
    HttpConnect* httpCon = [HttpConnect getHttpConnectInstance];
    [httpCon getVerifyCode:self.userPhoneNum newPhoneNum:@"" vcode:@"" opt:@"login"];
}

#pragma mark --把当前用户的注册\登陆信息发送给sever
-(SeverStatus)sendToServerForRegisterAndLogin{
    NSString* phoneNum = self.userPhoneNum;
    NSString* verifyCode = textFile.text;
    NSString *url = nil;
    //注册和登陆对应的网址是不一样的，所以要做区分
    if (self.accountType == PHONEREGISTER) {
        url =[[NSString alloc] initWithFormat:@"%@mobile=%@&vcode=%@&deviceid=%@&clientid=%@",REGISTERURL,phoneNum,verifyCode,DEVICEID,CLINETID];
    }else if (self.accountType == PHONENUMSUCCESS){
        url =[[NSString alloc] initWithFormat:@"%@mobile=%@&vcode=%@&deviceid=%@&clientid=%@",LOGINURL,phoneNum,verifyCode,DEVICEID,CLINETID];
    }
    
    //NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
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
            userManger.userName = self.userPhoneNum;
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

*/
@end
