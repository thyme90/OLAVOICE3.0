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
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
