//
//  FinishChangeMailVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/9.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "FinishChangeMailVC.h"
#import "macro.h"
@interface FinishChangeMailVC ()<UITextFieldDelegate>

@end

@implementation FinishChangeMailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _nextAccountTextField.delegate = self;
    [_nextAccountTextField setValue:[UIColor colorWithWhite:1.0 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    _verificationCodeTextField.delegate = self;
    [_verificationCodeTextField setValue:[UIColor colorWithWhite:1.0 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
}
- (IBAction)sendVerificationCodeButtonAction:(UIButton *)sender {
    BOOL isSuccess = [self verifyMailBox:_nextAccountTextField.text];
    if (isSuccess) {
        BOOL isLinking = [self checkCurrentNetworkState];
        if (isLinking) {
            NSString* opt = [[NSString alloc] initWithFormat:@"user=%@&clientid=%@",self.mailBoxAccount,CLINETID];
            HttpConnect* httpcon = [HttpConnect getHttpConnectInstance];
            [httpcon sendMailBox:CHANGMAILBOX opt:opt];
            
            NSString* text = self.mailBoxAccount;
            NSArray *arr = [text componentsSeparatedByString:@"@"];
            NSString* subStr = [arr objectAtIndex:1];
            
            NSString* mail = [[NSString alloc] initWithFormat:@"%@%@",@"http://mail.",subStr];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mail]];
            _remindImage.hidden = NO;
            _remindLabel.hidden = NO;
            [_remindImage setImage:[UIImage imageNamed:@"alertBackground-L.png"]];
            _remindLabel.text = @"验证码已发送，请点击进入邮箱查看";
        }
    }
}

- (IBAction)enterMailboxButtonAction:(UIButton *)sender {
    BOOL isLinking = [self checkCurrentNetworkState];
    if (isLinking) {
        NSString* text = self.mailBoxAccount;
        NSArray *arr = [text componentsSeparatedByString:@"@"];
        NSString* subStr = [arr objectAtIndex:1];
        NSString* mail = [[NSString alloc] initWithFormat:@"%@%@",@"http://mail.",subStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mail]];
    }
}

#pragma mark 验证验证码是否正确，正确则账号修改成功，进入下一页
- (IBAction)nextStepButtonAction:(UIButton *)sender {
    BOOL isLinking = [self checkCurrentNetworkState];
    if (isLinking) {
        BOOL isChangeSuccess = [self changeEmail];
        if (isChangeSuccess) {
            [_remindImage setImage:[UIImage imageNamed:@"alertBackground-S.png"]];
            _remindImage.hidden = NO;
            _remindLabel.hidden = NO;
            _remindLabel.text = @"修改成功";
            [self performSelector:@selector(successDelayMethod) withObject:nil afterDelay:1.5f];
            //
        }else{
            [_remindImage setImage:[UIImage imageNamed:@"alertBackground-S.png"]];
            _remindImage.hidden = NO;
            _remindLabel.hidden = NO;
            _remindLabel.text = @"修改失败，请重试";
             [self performSelector:@selector(failDelayMethod) withObject:nil afterDelay:1.5f];
        }
    }
}
- (void)successDelayMethod{
     [self performSegueWithIdentifier:@"backToUserCenterPage" sender:self];
}
- (void)failDelayMethod{
    _remindImage.hidden = YES;
    _remindLabel.hidden = YES;
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
    [self verifyMailBox:textField.text];
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)verifyMailBox:(NSString*)mailBox{
    if (!_nextAccountTextField.text.length) {
        _remindReasonLabel.text = @"邮箱地址不能为空";
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isMailBox = [emailTest evaluateWithObject:_nextAccountTextField.text];
    if (!isMailBox) {
        _remindReasonLabel.text= @"您输入的邮箱格式有误，请重新输入";
        return NO;
    }
    return YES;
}
////////////////////////////////////////////////////////////////////////////////////////

#pragma mark 修改邮箱
-(BOOL)changeEmail{
    UserManager* userManger = [UserManager getUserManagerInstance];
    NSString* passwdMD5 = userManger.passwdMD5;
    NSString* vcode = [[CommonHeadFile getCommonHeadFileInstance] random6Code];//生成6位随机验证码
    NSString* md52 = [[NSString alloc] initWithFormat:@"%@%@",passwdMD5,vcode];
    NSString* passwd = [[CommonHeadFile getCommonHeadFileInstance] md5HexDigest:md52];
    NSString *urlStr=[[NSString alloc] initWithFormat:@"%@user=%@&password=%@&vcode=%@",CHANGEEMIAL,self.mailBoxAccount,passwd,vcode];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data is %@",aString);
    if (!error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:&error];
        int status = -1;
        NSDictionary* dataDic = nil;
        if (dictionary){
            status =[[dictionary objectForKey:@"status"] intValue];
            dataDic = [dictionary objectForKey:@"data"];
        }
        //0表示成功
        if (!status) {
            //创建一个新的数据。
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            [userDefaultes removeObjectForKey:self.mailBoxAccount];//删除旧的邮箱
            NSString* newMailBox = [dataDic objectForKey:@"email"];
            UserManager* userManger = [UserManager getUserManagerInstance];
            userManger.userName = newMailBox;
            return YES;
        }else
            return NO;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
