//
//  ResetPasswordVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/16.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "ResetPasswordVC.h"

@interface ResetPasswordVC ()

@end

@implementation ResetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_passwordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
     [_confirmTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
   }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

/*
-(void)buttonClick{
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
        NSString* newPassword = newPasswordText.text;
        NSString* repeatPassword = repeatPasswordText.text;
        BOOL isequ = [repeatPassword isEqualToString:newPassword];
        if (!isequ) {
            errorLabel.text = @"两次输入的新密码不一致，请重新输入";
        }else{
            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"      正在修改密码" preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            
            activeView.frame = CGRectMake(50,25,10,10);
            [activeView startAnimating];
            [alertDialog.view addSubview:activeView];
            [self presentViewController:alertDialog animated:YES completion:^(void){
                SeverStatus severStatus = [self changePassword];
                switch (severStatus) {
                    case SEVERSTATUSSUCCESS:{
                        [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"密码修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }];
                    }
                        break;
                    case SEVERSTATUSFAIL:{
                        [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                            errorLabel.text =@"您输入的原密码有误，请重新输入!";
                        }];
                    }
                        break;
                    case NETWORKTIMEOUT:{
                        [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                            errorLabel.text =@"网络出错，请重新输入!";
                        }];
                    }
                        break;
                    default:
                        break;
                }
            }];
        }
    }
}


-(SeverStatus)changePassword{
    UserManager* userManger = [UserManager getUserManagerInstance];
    NSString* user = userManger.userName;
    NSString* oldPW = oldPasswordText.text;
    NSString* newPW = newPasswordText.text;
    NSString *urlStr=[[NSString alloc] initWithFormat:@"%@user=%@&oldpass=%@&newpass=%@&clientid=%@",CHANGEPASSWORD,user,oldPW,newPW,CLINETID];
    
    //NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
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
            userManger.passwd = oldPasswordText.text;
            return SEVERSTATUSSUCCESS;
        }else{
            NSLog(@"修改密码失败");
            return SEVERSTATUSFAIL;
        }
    }
    return NETWORKTIMEOUT;
}

-(void)buttonClick{
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
        NSString* text = textFile.text;
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        BOOL isMailBox = [emailTest evaluateWithObject:text];//验证邮箱格式是否正确
        if (isMailBox) {
            [self sendMailBox];
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@""
                                                           message:@"验证邮件已发送至您的邮箱"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil,nil];
            [alert show];
        }else{
            errorLabel.hidden = NO;
        }
    }
}

- (void) alertView:(UIAlertView *)alertview clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString* text = textFile.text;
    NSArray *arr = [text componentsSeparatedByString:@"@"];
    NSString* subStr = [arr objectAtIndex:1];
    
    NSString* mail = [[NSString alloc] initWithFormat:@"%@%@",@"http://mail.",subStr];
    NSLog(@"%@",mail);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mail]];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)sendMailBox{
    NSString* opt = [[NSString alloc] initWithFormat:@"user=%@&clientid=%@",self.mailbox,CLINETID];
    HttpConnect* httpcon = [HttpConnect getHttpConnectInstance];
    [httpcon sendMailBox:RESETPASSWORD opt:opt];
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


-(BOOL)verifyPassword{
    //密码规则 1.不能为空 2.长度不能超过15位 3.只能为数字和字母
    NSString* text1 = textFile.text;
    NSString* text2 = textFile1.text;
    if (text1.length == 0 || text2.length == 0) {
        errorLabel.text = @"密码不能为空";
        return NO;
    }
    
    if (text1.length != text2.length) {
        errorLabel.text = @"两次密码输入不一致，请重新输入";
        return NO;
    }
    
    if (text1.length > 15 || text2.length > 15) {
        errorLabel.text = @"密码长度超过了15个字符，请重新输入";
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
            errorLabel.text = @"两次密码输入不一致，请重新输入";
            return NO;
        }
    }else{
        errorLabel.text = @"密码只能为数字和字母,请重新输入";
    }
    
    
    
    return NO;
}


-(void)viewWillAppear:(BOOL)animated{
    NSString* text = [[NSString alloc] initWithFormat:@"%@%@%@",@"请为",self.userAccount,@"创建新账户"];
    showAccountLabel.text = text;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString* buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"激活"]) {
        //激活按钮
        NSString* text = self.userAccount;
        NSArray *arr = [text componentsSeparatedByString:@"@"];
        NSString* subStr = [arr objectAtIndex:1];
        
        NSString* mail = [[NSString alloc] initWithFormat:@"%@%@",@"http://mail.",subStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mail]];
        
        if (!verifyMailBoxVC) {
            verifyMailBoxVC = [[VerifyMailBoxViewController alloc] init];
        }
        
        verifyMailBoxVC.mailbox = self.userAccount;
        verifyMailBoxVC.passwd = textFile1.text;
        verifyMailBoxVC.passwdMD5 = passwdMD5;
        [self.navigationController pushViewController:verifyMailBoxVC animated:YES];
    }
    
    if ([buttonTitle isEqualToString:@"取消"]) {
        //取消按钮
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
    if ([buttonTitle isEqualToString:@"重试"]) {
        [self sendToServerForRegister];
    }
    
}

//把当前用户的注册信息发送给sever
-(SeverStatus)sendToServerForRegister{
    NSString* mailbox = self.userAccount;
    NSString* encry1 = [[CommonHeadFile getCommonHeadFileInstance] md5HexDigest:textFile.text];//对密码进行MD5加密
    NSString* encry2 = [[NSString alloc] initWithFormat:@"%@%@",encry1,@"*via@S3#OLaS.VoIce"];
    passwdMD5 = [[CommonHeadFile getCommonHeadFileInstance] md5HexDigest:encry2];//对字符串进行md532位加密
    
    
    NSString *url=[[NSString alloc] initWithFormat:@"%@user=%@&password=%@&deviceid=%@&clientid=%@",REGISTERURL,mailbox,passwdMD5,DEVICEID,CLINETID];
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
    
    //连接成功
    if (!error){
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:&error];
        
        if (dictionary){
            status =[[dictionary objectForKey:@"status"] intValue];
        }
        
        //status = 0 成功，-1失败
        if (!status) {
            return SEVERSTATUSSUCCESS;
            
        }else{
            return SEVERSTATUSFAIL;
        }
    }
    return NETWORKTIMEOUT;
    
}
  */
@end
