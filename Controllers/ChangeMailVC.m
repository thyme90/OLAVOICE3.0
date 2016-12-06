//
//  ChangeMailVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/9.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "ChangeMailVC.h"
#import "macro.h"
@interface ChangeMailVC ()<UITextFieldDelegate>

@end

@implementation ChangeMailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_primaryAccountTextField setValue:[UIColor colorWithWhite:1.0 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    [_verificationCodeTextField setValue:[UIColor colorWithWhite:1.0 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    _remindReasonLabel.hidden = YES;
    _remindImage.hidden = YES;
    _remindLabel.hidden = YES;
    _primaryAccountTextField.delegate = self;
    _verificationCodeTextField.delegate = self;
}

- (IBAction)cancelButtonClickAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark 发送验证码
///// 按钮类型需要为custom类型，否则读秒变化效果不好
- (IBAction)sendVerificationCodeButtonAction:(UIButton *)sender {
    BOOL isLinking = [self checkCurrentNetworkState];
    if (isLinking) {
           NSString* opt = [[NSString alloc] initWithFormat:@"user=%@&clientid=%@",self.mailBoxAccount,CLINETID];
        HttpConnect* httpcon = [HttpConnect getHttpConnectInstance];
        [httpcon sendMailBox:CHANGMAILBOX opt:opt];
        
        _remindImage.hidden = NO;
        _remindLabel.hidden = NO;
        _remindLabel.text = @"验证码已发送，请点击进入邮箱查看";
    }
//    __block NSInteger time = 59; //倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        if(time == 0){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置按钮的样式
//                [sender setTitle:@"重新发送" forState:UIControlStateNormal];
//                sender.userInteractionEnabled = YES;
//            });
//        }else{
//            int seconds = time % 60;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置按钮显示读秒效果
//                [sender setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
//                sender.userInteractionEnabled = NO;
//            });
//            time--;
//        }
//    });
//    dispatch_resume(_timer);
}

#pragma mark 进入邮箱
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
#pragma mark 下一步
- (IBAction)nextStepButtonAction:(UIButton *)sender {
    _remindImage.hidden = NO;
    _remindLabel.hidden = NO;
    _remindLabel.text = @"正在验证中......";
    [self performSegueWithIdentifier:@"toFinishChangeMailPage" sender:self];
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
    if (!_primaryAccountTextField.text.length) {
        _remindReasonLabel.text = @"邮箱地址不能为空";
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isMailBox = [emailTest evaluateWithObject:_primaryAccountTextField.text];
    if (!isMailBox) {
        _remindReasonLabel.text= @"您输入的邮箱格式有误，请重新输入";
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
