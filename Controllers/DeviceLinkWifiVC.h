//
//  DeviceLinkWifiVC.h
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/17.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceLinkWifiVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *deviceLinkWifiLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) NSString *wifiName;
@end
