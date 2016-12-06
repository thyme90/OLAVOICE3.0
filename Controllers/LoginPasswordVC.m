//
//  LoginPasswordVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/15.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "LoginPasswordVC.h"
#import "macro.h"
@interface LoginPasswordVC (){
    NSString *passwdMD5;
}

@end

@implementation LoginPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _accountTypeLabel.text = [NSString stringWithFormat:@"您正在以%@登录",_account];
    [_passwordTextField setValue:[UIColor colorWithWhite:1.0 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
}

#pragma mark 取消按钮
- (IBAction)cancelButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{  }];
}

#pragma mark 忘记密码
- (IBAction)forgetButtonAction:(UIButton *)sender {
    
}

#pragma mark 登录
- (IBAction)loginButtonAction:(UIButton *)sender {
    
}



-(SeverStatus )verifyPassword{
    NSString* md5 = [[CommonHeadFile getCommonHeadFileInstance] md5HexDigest:_passwordTextField.text];//对明文密码进行加密
    NSString* md51 = [[NSString alloc] initWithFormat:@"%@%@",md5,@"*via@S3#OLaS.VoIce"];
    passwdMD5 = [[CommonHeadFile getCommonHeadFileInstance] md5HexDigest:md51];
    NSString* vcode = [[CommonHeadFile getCommonHeadFileInstance] random6Code];//生成6位随机验证码
    NSString* md52 = [[NSString alloc] initWithFormat:@"%@%@",passwdMD5,vcode];
    NSString* passwd = [[CommonHeadFile getCommonHeadFileInstance] md5HexDigest:md52];
    
    NSString *url=[[NSString alloc] initWithFormat:@"%@user=%@&password=%@&vcode=%@&deviceid=%@&clientid=%@",LOGINURL,self.account,passwd,vcode,DEVICEID,CLINETID];
    //NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLRequest *urlRequest =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIMEOUTINTERVAL];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data is %@",aString);
    {
        int status = -1;
        NSDictionary *dictionary = nil;
        //连接成功
        if (error == nil){
            dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
            if (dictionary){
                status =[[dictionary objectForKey:@"status"] intValue];
            }
            //status = 0 成功，-1失败
            if (!status) {
                NSLog(@"登陆成功");
                NSDictionary *dataDic = [dictionary objectForKey:@"data"];
                NSString* phoneNum = [dataDic objectForKey:@"mobile"];//ola手机绑定的手机号
                NSString* nickName = [dataDic objectForKey:@"nickname"];
                NSString* imgUrl = [dataDic objectForKey:@"imgurl"];
                int verified = [[dataDic objectForKey:@"verified"] intValue];
                UserManager* userManger = [UserManager getUserManagerInstance];
                userManger.nickName = nickName;
                userManger.verified = verified;
                userManger.imgurl = imgUrl;
                userManger.passwd = _passwordTextField.text;
                userManger.passwdMD5 = passwdMD5;
                userManger.isLog = YES;
                userManger.userName = self.account;
                userManger.accountType = self.accountType;
                userManger.olaPhoneNum = phoneNum;
                return SEVERSTATUSSUCCESS;
            }else{
                return SEVERSTATUSFAIL;
            }
        }else{
            return NETWORKTIMEOUT;
        }
    }
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toVerifyPage"]) {
        VerifyVC *verifyVC = [segue destinationViewController];
        verifyVC.account = self.account;
        verifyVC.accountType = self.accountType;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
