//
//  LoginVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/2.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "LoginVC.h"
#import "macro.h"
@interface LoginVC ()<UITextFieldDelegate>

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _remindLabel.hidden = YES;
    [_accountTextField setValue:[UIColor colorWithWhite:1.0 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    _accountTextField.delegate = self;
}
#pragma mark 取消返回主页
- (IBAction)cancelButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{    }];
}

#pragma mark 下一步进入输入密码页或验证码页
- (IBAction)nextStepButtonAction:(UIButton *)sender {
    if (_accountTextField.text.length>0) {
        BOOL isLinking = [self checkCurrentNetworkState];
        if (isLinking) {
            _accountType = [self verifyAccountTextContent];
            [UserManager getUserManagerInstance].accountType = _accountType;
            switch (_accountType) {
                case PHONENUMSUCCESS:
                    [self performSegueWithIdentifier:@"toReceiveVerifyCodePage" sender:self];
                    break;
                case MAILBOXSUCCESS:
                case OLASUCCESS:
                    [self performSegueWithIdentifier:@"toInputPasswordPage" sender:self];
                    break;
                case PHONENUMERROR:
                    _remindLabel.text = @"您输入的手机号有误";
                    break;
                case MAILBOXREGISTER:
                    _remindLabel.text = @"您输入的邮箱号有误";
                    break;
                case OLAERROR:
                    _remindLabel.text = @"您输入的OLA账号有误";
                    break;
                    
                default:
                    break;
            }
        }
    }else{
        _remindLabel.text = @"请输入！";
    }
}

#pragma mark textfield Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 验证账号类型
-(AccountType)verifyAccountTextContent{
    NSString* text = _accountTextField.text;
    NSString* numRegex = @"^[0-9]*$";
    NSPredicate *numTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numRegex];
    bool isNum = [numTest evaluateWithObject:text];//验证是否输入的是纯数字
    if (isNum){
        if (text.length == 11) {
            NSString* str = [text substringToIndex:1];
            if ([str isEqualToString:@"1"]) {
                //服务器端验证成功，则进入手机登陆界面，否则进入注册页面
                SeverStatus severStatus = [self getUser:text];
                switch (severStatus) {
                    case SEVERSTATUSSUCCESS:
                        return PHONENUMSUCCESS;
                        break;
                    case SEVERSTATUSFAIL:
                        return PHONEREGISTER;
                    case NETWORKTIMEOUT:
                        return ISERROR;
                    default:
                        break;
                }
            }
            return PHONENUMERROR;
        }else{
            return PHONENUMERROR;
        }
 
    }else{
        if ([text containsString:@"@"]) {
            NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            BOOL isMailBox = [emailTest evaluateWithObject:text];
            if (isMailBox) {
                SeverStatus severStatus = [self getUser:text];
                switch (severStatus) {
                    case SEVERSTATUSSUCCESS:
                        return MAILBOXSUCCESS;
                        break;
                    case SEVERSTATUSFAIL:
                        return MAILBOXREGISTER;
                    case NETWORKTIMEOUT:
                        return ISERROR;
                    default:
                        break;
                }
            }
            return MAILBOXERROR;
        }else{
            //如果都不是邮箱和手机号，就是OLA账号
            SeverStatus severStatus = [self getUser:text];
            switch (severStatus) {
                case SEVERSTATUSSUCCESS:
                    return OLASUCCESS;
                    break;
                case SEVERSTATUSFAIL:
                    return OLAERROR;
                case NETWORKTIMEOUT:
                    return ISERROR;
                default:
                    break;
            }
        }
    }
}

#pragma mark--发送给服务器的验证,包括手机号码，邮箱，OLA账号,验证用户是否存在
-(SeverStatus)getUser:(NSString*)userID{
    NSString *urlStr=[[NSString alloc] initWithFormat:@"%@user=%@&clientid=%@",CHECKUSERURL,userID,CLINETID];
    
    // NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSURLRequest *urlRequest =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIMEOUTINTERVAL];
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
        //存在是非0，不存在是0
        if (dictionary){
            status =[[dictionary objectForKey:@"status"] intValue];
            //NSLog(@"用户是否存在状态码是%d",status);
        }
        
        if (status) {
            NSLog(@"用户存在");
            return SEVERSTATUSSUCCESS;
        }else{
            NSLog(@"用户不存在");
            return SEVERSTATUSFAIL;
        }
    }
    return NETWORKTIMEOUT;
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

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toInputPasswordPage"]) {
        LoginPasswordVC *passwordVC = [segue destinationViewController];
        passwordVC.account = _account;
        passwordVC.accountType = _accountType;
    }else if ([segue.identifier isEqualToString:@"toReceiveVerifyCodePage"]){
        VerifyVC *verifyVC =  [segue destinationViewController];
        verifyVC.account = _account;
        verifyVC.accountType = PHONENUMSUCCESS;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
