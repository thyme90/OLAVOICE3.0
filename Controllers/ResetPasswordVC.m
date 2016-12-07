//
//  ResetPasswordVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/16.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "ResetPasswordVC.h"
#import "macro.h"
@interface ResetPasswordVC ()

@end

@implementation ResetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_passwordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
     [_confirmTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
   }
#pragma mark 两次输入无误确定修改密码
- (IBAction)confirmButtonAction:(id)sender {
    BOOL twiceEqual = [self verifyPassword];
    if (twiceEqual) {
        SeverStatus severStatus = [self changePassword];
        switch (severStatus) {
            case SEVERSTATUSSUCCESS:{
                [self performSegueWithIdentifier:@"resetPasswordBackToMainPage" sender:self];
            }
                break;
            case SEVERSTATUSFAIL:{
                _remindAccountLabel.text =@"您输入的原密码有误，请重新输入!";
            }
                break;
            case NETWORKTIMEOUT:{
                _remindAccountLabel.text =@"网络出错，请重新输入!";
            }
                break;
            default:
                break;
        }
    }
}

-(SeverStatus)changePassword{
    UserManager* userManger = [UserManager getUserManagerInstance];
    NSString* user = userManger.userName;
    NSString* oldPW = _passwordTextField.text;
    NSString* newPW = _confirmTextField.text;
    NSString *urlStr=[[NSString alloc] initWithFormat:@"%@user=%@&oldpass=%@&newpass=%@&clientid=%@",CHANGEPASSWORD,user,oldPW,newPW,CLINETID];
    NSURLRequest *urlRequest =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIMEOUTINTERVAL];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    NSLog(@"修改邮箱密码是否成功的data %@",data);
    
    if (!error) {
        NSDictionary *dictionary= [NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:&error];
        int status = -1;
        
        if (dictionary){
            status =[[dictionary objectForKey:@"status"] intValue];
        }
        if (!status) {
            NSLog(@"修改密码成功");
            userManger.passwd = _confirmTextField.text;
            return SEVERSTATUSSUCCESS;
        }else{
            NSLog(@"修改密码失败");
            return SEVERSTATUSFAIL;
        }
    }
    return NETWORKTIMEOUT;
}


-(BOOL)verifyPassword{
    //密码规则 1.不能为空 2.长度不能超过15位 3.只能为数字和字母
    NSString* text1 = _passwordTextField.text;
    NSString* text2 = _confirmTextField.text;
    if (text1.length == 0 || text2.length == 0) {
        _remindAccountLabel.text = @"密码不能为空";
        return NO;
    }
    if (text1.length != text2.length) {
        _remindAccountLabel.text = @"两次密码输入不一致，请重新输入";
        return NO;
    }
    if (text1.length > 15 || text2.length > 15) {
        _remindAccountLabel.text = @"密码长度超过了15个字符，请重新输入";
        return NO;
    }
    NSString *pwRegex = @"^[a-zA-Z0-9]+$";
    NSPredicate *pwTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwRegex];
    BOOL isPW1= [pwTest evaluateWithObject:text1];
    BOOL isPW2= [pwTest evaluateWithObject:text2];
    if (isPW1 && isPW2) {
        if ([text1 isEqualToString:text2]) {
            return YES;
        }else{
            _remindAccountLabel.text = @"两次密码输入不一致，请重新输入";
            return NO;
        }
    }else{
        _remindAccountLabel.text = @"密码只能为数字和字母,请重新输入";
    }
    return NO;
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

/*
#pragma mark 为新注册的账号设置密码
-(void)buttonClick{
    BOOL isSuccess = [self verifyPassword];
    if (!isSuccess) {
        return;
    }
    
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

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"resetPasswordBackToMainPage"]) {
//        ResetPasswordVC *resetPasswordVC = [segue destinationViewController];
//        resetPasswordVC.account = self.account;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
