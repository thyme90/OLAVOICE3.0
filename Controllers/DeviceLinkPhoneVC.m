//
//  DeviceLinkPhoneVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/17.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "DeviceLinkPhoneVC.h"
#import "macro.h"

@interface DeviceLinkPhoneVC ()

@end

@implementation DeviceLinkPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tittleLabel.text = [NSString stringWithFormat:@"%@连接手机",_deviceName];
    
    NSString *content = @"音箱需与手机进行匹配连接，进入手机设置无线局域网选择 ola-wifi";
    NSRange olaRange = [content rangeOfString:@"ola-wifi"];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:content];
    [attributeStr addAttributes:@{NSForegroundColorAttributeName : COLOR(45, 214, 236, 1.0)}  range:olaRange];
    _remindLabel.attributedText = attributeStr;
    
}
- (IBAction)remindLabelTapGestureAction:(UITapGestureRecognizer *)sender {
    NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        
    }
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
}
- (IBAction)littleCancelButtonClickAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)bigCancleClickAction:(id)sender {
    NSLog(@"will open");
    NSURL *url = [NSURL URLWithString:@"Prefs:root=General&path=About"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        NSLog(@"can not open");
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

/*
#pragma mark--手机连接音箱
-(void)phoneConnSever:(NSString*)boxName{
    AudioBox* box = [AudioBox getAudioBoxInstance];
    NSDictionary* dict = [box boxDicts];
    NSString* ip = [dict objectForKey:boxName];
    [_passValue phoneTypeToSever:ip];
    double delayInSeconds = 5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        BOOL isPhoneToServer = [_passValue isPhoneType];
        if (isPhoneToServer) {
            [_passValue phoneToSever:ip phoneType:1];
            double delayInSeconds = 5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                BOOL isPhoneToServer = [_passValue isPhoneConnToSever];
                if (isPhoneToServer) {
                    [UserManager getUserManagerInstance].isPhoneToBox = YES;
                    [UserManager getUserManagerInstance].currentConnectIP = ip;//保存当前连接的ip
                }else{
                    [UserManager getUserManagerInstance].isPhoneToBox = NO;
                }
            });
        }
    });
}

15237665245

//#pragma mark --选择单元格
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//            ItemTableViewCell *cell = (ItemTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//            NSString * boxName = [cell getBoxName];
//            if(![boxName isEqualToString:m_firstBoxName]){
//                [self viewRetract];
//                [self phoneConnSever:boxName];//连接音箱
//                self.boxActivieView.hidden = NO;
//                self.boxActivieView.boxName.text = boxName;
//                double delayInSeconds = 2;
//                dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//                dispatch_after(timer, dispatch_get_main_queue(), ^(void){
//                    BOOL isSuccess = [m_networkAction isPhoneConnToSever];
//                    if (isSuccess) {
//                        [self.currentCellItem setCurrentBox];
//                        [cell setCurrentBox];
//                        self.currentCellItem = cell;
//                        m_firstBoxName = boxName;
//                        UserManager* manager = [UserManager getUserManagerInstance];
//                        manager.currentBoxName = m_firstBoxName;
//                    }
//                });
//            }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
