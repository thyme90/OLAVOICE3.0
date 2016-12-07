//
//  ChangeNicknameVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/8.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "ChangeNicknameVC.h"
#import "macro.h"
@interface ChangeNicknameVC ()<UITextFieldDelegate>

@end

@implementation ChangeNicknameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _textField.delegate = self;
    [_textField setValue:[UIColor colorWithWhite:1.0 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nickNameChangeAction) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)nickNameChangeAction{
    //中文，英文和数字，且不能超过11个
    NSString* newName = _textField.text;
    //NSLog(@"%@",newName);
    NSString *nameRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    BOOL isMailBox = [nameTest evaluateWithObject:newName];
    if (isMailBox && newName.length < 11) {
        _saveButton.enabled = YES;
    }else{
        _saveButton.enabled = NO;
    }
}

- (IBAction)cancelButtonClickAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark  保存修改过的昵称
- (IBAction)saveNickNameAction:(UIButton *)sender {
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
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"正在修改昵称" preferredStyle:UIAlertControllerStyleAlert];
        
        UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        activeView.frame = CGRectMake(50,25,10,10);
        [activeView startAnimating];
        [alertDialog.view addSubview:activeView];
        [self presentViewController:alertDialog animated:YES completion:^(void){
            SeverStatus severStatus = [self changeNickName];
            switch (severStatus) {
                case SEVERSTATUSSUCCESS:{
                    [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
                    break;
                case SEVERSTATUSFAIL:{
                    [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                        NSLog(@"sever端返回数据不正确");
                    }];
                }
                case NETWORKTIMEOUT:{
                    [alertDialog dismissViewControllerAnimated:YES completion:^(void){
                        NSLog(@"网路出错！");
                    }];
                }
                    break;
                default:
                    break;
            }
            
        }];
    }
}

#pragma mark --修改昵称回调
-(SeverStatus)changeNickName{
    NSString *urlUTF8 = nil;
    UserManager* userManger = [UserManager getUserManagerInstance];
    
    if (userManger.accountType == PHONENUMSUCCESS) {
        NSLog(@"手机修改昵称");
        NSString* url = [[NSString alloc] initWithFormat:@"%@mobile=%@&vcode=%@&newnickname=%@&clientid=%@",CHANGENICKNAME,userManger.userName, userManger.phoneVcode,_textField.text,CLINETID];
        urlUTF8 = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else{
        NSLog(@"邮箱和OLA账号修改昵称");
        NSString* passwdMD5 = userManger.passwdMD5;
        NSString* vcode = [[CommonHeadFile getCommonHeadFileInstance] random6Code];//生成6位随机验证码
        NSString* md52 = [[NSString alloc] initWithFormat:@"%@%@",passwdMD5,vcode];
        NSString* passwd = [[CommonHeadFile getCommonHeadFileInstance] md5HexDigest:md52];
        NSString *url = [[NSString alloc] initWithFormat:@"%@user=%@&password=%@&vcode=%@&newnickname=%@&clientid=%@",CHANGENICKNAME,userManger.userName,passwd,vcode,_textField.text,CLINETID];
        urlUTF8 = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }

    NSURLRequest *urlRequest =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlUTF8] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIMEOUTINTERVAL];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    int status = -1;
    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data is %@",aString);
    
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
            NSLog(@"昵称修改成功!");
            userManger.nickName = _textField.text;
            return SEVERSTATUSSUCCESS;
        }else{
            NSLog(@"昵称修改失败!");
            return SEVERSTATUSFAIL;
        }
    }
    
    return NETWORKTIMEOUT;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
