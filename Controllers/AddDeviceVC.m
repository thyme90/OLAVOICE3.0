//
//  AddDeviceVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/18.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "AddDeviceVC.h"
#import "macro.h"
@interface AddDeviceVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AddDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*nKheight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        AddDeviceVCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addDeviceVCCell" forIndexPath:indexPath];
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        _chooseDeviceName = @"音箱";
        [self performSegueWithIdentifier:@"toDeviceLinkPhonePage" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toDeviceLinkPhonePage"]) {
        DeviceLinkPhoneVC *deviceLinkPhoneVC = [segue destinationViewController];
        deviceLinkPhoneVC.deviceName = _chooseDeviceName;
    }else if ([segue.identifier isEqualToString:@"toDeviceLinkWifiPage"]) {
        DeviceLinkWifiVC *deviceLinkWifiVC = [segue destinationViewController];
        deviceLinkWifiVC.deviceName = _chooseDeviceName;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
