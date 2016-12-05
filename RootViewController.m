//
//  ViewController.m
//  NoScreenAudio
//
//  Created by yanminli on 15/10/8.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import "RootViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "CommonHeadFile.h"
#import "AppDelegate.h"
#import "CommonHeadFile.h"
#import "UserManager.h"
 

@interface RootViewController()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
//    self.navigationController.navigationBar.layer.masksToBounds = YES;

    //_searchBoxButton
    _searchBoxButton.layer.borderWidth = 1;
    _searchBoxButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [_searchBoxButton.layer setMasksToBounds:YES];
    [_searchBoxButton.layer setCornerRadius:3.0];
    [_searchBoxButton addTarget:self action:@selector(searchBox) forControlEvents:UIControlEventTouchUpInside];
    
    
    //_enterButton
    _enterButton.layer.borderWidth = 1;
    _enterButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [_enterButton.layer setMasksToBounds:YES];
    [_enterButton.layer setCornerRadius:3.0];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     self.navigationController.navigationBarHidden = YES;
}

- (void)searchBox{
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
        [UserManager getUserManagerInstance].logStatus = FirstLog;
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController* wifivc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"audioWifiSettingView"];
//        //AudioWifiSettingViewController* wifivc = [[AudioWifiSettingViewController alloc] init];
//        [self.navigationController pushViewController:musicVC animated:YES];
        
        CATransition* transition = [CATransition animation];
        transition.type = kCATransitionPush;//可更改为其他方式
        transition.subtype = kCATransitionFromTop;//可更改为其他方式
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:wifivc animated:NO];
    }
}

//直接进入主页
- (IBAction)enterMainPageDirect:(id)sender {
    [UserManager getUserManagerInstance].isPhoneToBox = NO;
    [UserManager getUserManagerInstance].isBoxConnect = NO;
    [UserManager getUserManagerInstance].logStatus = MainPageLog;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
