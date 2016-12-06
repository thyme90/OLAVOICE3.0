//
//  RegisterVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/2.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
-(void)okButtonAction{

        AccountType type = [UserManager getUserManagerInstance].accountType;
        switch (type) {
            case PHONEREGISTER:{
                //手机注册
                CheckPhoneNumViewController* vc = [[CheckPhoneNumViewController alloc] init];
                vc.userPhoneNum = self.userAccount;
                vc.accountType = self.accountType;
                [self sendVerifyCode];
                [self.navigationController pushViewController:vc animated:YES];
            }
                
                break;
            case MAILBOXREGISTER:{
                //邮箱注册
                SetPasswordViewController* vc = [[SetPasswordViewController alloc] init];
                vc.userAccount = self.userAccount;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
    
}


-(void)sendVerifyCode{
    HttpConnect* httpCon = [HttpConnect getHttpConnectInstance];
    [httpCon getVerifyCode:self.userAccount newPhoneNum:@"" vcode:@"" opt:@"login"];
}
 
 

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

#pragma mark --把当前用户的注册\登陆信息发送给sever
-(SeverStatus)sendToServerForRegisterAndLogin{
    NSString* phoneNum = self.account;
    NSString* verifyCode = _verificationCodeTextField.text;
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


#pragma mark --注册的流程
-(void)registerButtonClick{
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

#pragma mark 为新注册的账号设置密码
-(void)buttonClick{
    BOOL isSuccess = [self verifyPassword];
    if (!isSuccess) {
        return;
    }
    
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
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"      正在注册" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        
        activeView.frame = CGRectMake(50,25,10,10);
        [activeView startAnimating];
        [alertDialog.view addSubview:activeView];
        [self presentViewController:alertDialog animated:YES completion:^(void){
            SeverStatus severStatus = [self sendToServerForRegister];
            switch (severStatus) {
                case SEVERSTATUSSUCCESS:{
                    [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                        UIAlertView  *alertSuccess =[[UIAlertView alloc] initWithTitle:nil
                                                                               message:@"请激活您的邮箱以完成注册"
                                                                              delegate:self
                                                                     cancelButtonTitle:@"激活"
                                                                     otherButtonTitles:@"取消",nil];
                        [alertSuccess show];
                    }];
                }
                    break;
                case SEVERSTATUSFAIL:{
                    [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                        UIAlertView  *alertSuccess =[[UIAlertView alloc] initWithTitle:nil
                                                                               message:@"注册失败，请稍后再试"
                                                                              delegate:self
                                                                     cancelButtonTitle:@"重试"
                                                                     otherButtonTitles:@"取消",nil];
                        
                        [alertSuccess show];
                    }];
                }
                    break;
                case NETWORKTIMEOUT:{
                    errorLabel.hidden = NO;
                    errorLabel.text = @"网络出错，请重新连接!";
                }
                    break;
                default:
                    break;
            }
        }];
    }
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
