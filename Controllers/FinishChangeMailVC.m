//
//  FinishChangeMailVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/9.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "FinishChangeMailVC.h"
#import "macro.h"
@interface FinishChangeMailVC ()

@end

@implementation FinishChangeMailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)sendVerificationCodeButtonAction:(UIButton *)sender {
    NSString* opt = [[NSString alloc] initWithFormat:@"user=%@&clientid=%@",self.mailBoxAccount,CLINETID];
    HttpConnect* httpcon = [HttpConnect getHttpConnectInstance];
    [httpcon sendMailBox:CHANGMAILBOX opt:opt];
    
    NSString* text = self.mailBoxAccount;
    NSArray *arr = [text componentsSeparatedByString:@"@"];
    NSString* subStr = [arr objectAtIndex:1];
    
    NSString* mail = [[NSString alloc] initWithFormat:@"%@%@",@"http://mail.",subStr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mail]];
}

- (IBAction)enterMailboxButtonAction:(UIButton *)sender {
    
}

#pragma mark 验证验证码是否正确，正确则账号修改成功，进入下一页
- (IBAction)nextStepButtonAction:(UIButton *)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(void)buttonClick{
    //NSLog(@"buttonClick");
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
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"正在发送邮件" preferredStyle:UIAlertControllerStyleAlert];
 
        UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
 
        activeView.frame = CGRectMake(50,25,10,10);
        [activeView startAnimating];
        [alertDialog.view addSubview:activeView];
        [self presentViewController:alertDialog animated:YES completion:^(void){
            BOOL isSuccess = [self verifyMailBox:textFile.text];
            if (isSuccess) {
                [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                    [self sendMailBox];
                    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"邮件已发送至您的邮箱"
                                                                   message:nil
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil,nil];
                    [alert show];
                }];
                
            }else{
                [alertDialog dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    BOOL isSuccess = [self verifyMailBox:textField.text];
    if (isSuccess) {
        [button setTitle:nil forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icn-circle-ok"] forState:UIControlStateNormal];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"邮件已发送至您的邮箱" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        errorLabel.text = @"您输入的邮箱格式有误，请重新输入";
        return false;
    }
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)verifyMailBox:(NSString*)mailBox{
    if (!textFile.text.length) {
        errorLabel.text = @"邮箱地址不能为空";
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isMailBox = [emailTest evaluateWithObject:textFile.text];
    if (!isMailBox) {
        errorLabel.text= @"您输入的邮箱格式有误，请重新输入";
        return NO;
    }
    return YES;
}

#pragma mark-- 修改邮箱
-(void)changeEmail{
    UserManager* userManger = [UserManager getUserManagerInstance];
    NSString* passwdMD5 = userManger.passwdMD5;
    NSString* vcode = [[CommonHeadFile getCommonHeadFileInstance] random6Code];//生成6位随机验证码
    NSString* md52 = [[NSString alloc] initWithFormat:@"%@%@",passwdMD5,vcode];
    NSString* passwd = [[CommonHeadFile getCommonHeadFileInstance] md5HexDigest:md52];
    
    NSString *urlStr=[[NSString alloc] initWithFormat:@"%@user=%@&password=%@&vcode=%@",CHANGEEMIAL,self.mailBox,passwd,vcode];
    
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
            [userDefaultes removeObjectForKey:self.mailBox];//删除旧的邮箱
            NSString* newMailBox = [dataDic objectForKey:@"email"];
            UserManager* userManger = [UserManager getUserManagerInstance];
            userManger.userName = newMailBox;
            
        }else{
            NSLog(@"修改失败!");
        }
    }
}
*/
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
