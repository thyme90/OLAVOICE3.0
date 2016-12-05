//
//  DeviceLinkPhoneVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/17.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "DeviceLinkPhoneVC.h"

@interface DeviceLinkPhoneVC ()

@end

@implementation DeviceLinkPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
