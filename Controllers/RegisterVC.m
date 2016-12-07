//
//  RegisterVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/2.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "RegisterVC.h"
#import "macro.h"
#import "CommonHeadFile.h"
@interface RegisterVC ()<UITextFieldDelegate>

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)cancelButtonClickAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{  }];
}

- (IBAction)registerButtonClickAction:(id)sender {
    if (_accountTextFeild != nil) {
        switch (_accountType) {
            case PHONENUMBER:
                [self performSegueWithIdentifier:@"toVerifyRegisterPage" sender:self];
                break;
                
            case MAILBOXNUMBER:
                [self performSegueWithIdentifier:@"toMailBoxRegisterInputPasswordPage" sender:self];
                break;
                
            default:
                break;
        }
        
    }
}

#pragma mark textfield Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    // 如果点击到UITextField以外的View则收回键盘
    if (![touch.view isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField;{
    AccountType type = [self verifyAccountTextContent];
    switch (type) {
        case PHONENUMERROR:
            _remindLabel.text = @"您输入的手机号有误";
            break;
        case MAILBOXERROR:
            _remindLabel.text = @"您输入的邮箱号有误";
            break;
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _remindLabel.text = @"";
    return YES;
}



#pragma mark 验证账号类型
-(AccountType)verifyAccountTextContent{
    NSString* text = _accountTextFeild.text;
    NSString* numRegex = @"^[0-9]*$";
    NSPredicate *numTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numRegex];
    bool isNum = [numTest evaluateWithObject:text];//验证是否输入的是纯数字
    if (isNum){
        if (text.length == 11) {
            NSString* str = [text substringToIndex:1];
            if ([str isEqualToString:@"1"]) {
                _accountType = PHONENUMBER;
                return PHONENUMBER;
                }else{
                return PHONENUMERROR;
            }
        }
        return PHONENUMERROR;
    }else{
        if ([text containsString:@"@"]) {
            NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            BOOL isMailBox = [emailTest evaluateWithObject:text];
            if (isMailBox) {
                _accountType = MAILBOXNUMBER;
                return MAILBOXNUMBER;
            }else{
                return MAILBOXERROR;
            }
        }
         return MAILBOXERROR;
    }
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
    if ([segue.identifier isEqualToString:@"toVerifyRegisterPage"]) {
        VerifyRegisterVC *verifyRegisterVC = [segue destinationViewController];
        verifyRegisterVC.account = _accountTextFeild.text;
        verifyRegisterVC.accountType = _accountType;
    }else if ([segue.identifier isEqualToString:@"toMailBoxRegisterInputPasswordPage"]) {
        SetPasswordVC *setPasswordVC = [segue destinationViewController];
        setPasswordVC.account = _accountTextFeild.text;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
