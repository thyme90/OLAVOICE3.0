//
//  DeviceLinkWifiVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/17.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "DeviceLinkWifiVC.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "macro.h"
@interface DeviceLinkWifiVC ()

@end

@implementation DeviceLinkWifiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
    //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////将wifi名称和密码传入下一页DeviceLinkingVC
    //得到当前连接的WIFI的name
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            _wifiName = [dict valueForKey:@"SSID"];
        }
    }
    /*
    //得到当前连接的WIFI的name
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            wifiName = [dict valueForKey:@"SSID"];
            NSString *str1 = @"请输入";
            NSString *str2 = @"使音箱接入网络";
            NSString *string = [[NSString alloc] init];
            string = [string stringByAppendingFormat:@"%@%@密码,%@",str1,wifiName,str2];
            self.wifiNameLabel.text = string;
            self.showWifiNameLabel.text = wifiName;
            self.passwordEdit.text = @"Wireless@S3";
        }
    }
     */
    ////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

- (IBAction)cancelButton:(UIButton *)sender {
    
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toDeviceLinkingPage"]) {
        DeviceLinkingVC *linkingVC = [segue destinationViewController];
        //linkingVC.wifiName = self.account;
        //linkingVC.wifiPassword = self.accountType;
    }
    
}
/*
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AudioCloudWifiViewController* vc =(AudioCloudWifiViewController*)[mainStoryBoard instantiateViewControllerWithIdentifier:@"audioCloudWifiVC"];
    vc.wifiName = self.showWifiNameLabel.text;
    vc.wifiPasswd = self.passwordEdit.text;
    
    [self.navigationController pushViewController:vc animated:NO];
    return YES;
}
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
