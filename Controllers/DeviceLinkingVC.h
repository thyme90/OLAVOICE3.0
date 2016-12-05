//
//  DeviceLinkingVC.h
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/17.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NetworkAction;
@interface DeviceLinkingVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *linkStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkRemindLabel;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;

@property (strong, nonatomic) NSString *wifiName;
@property (strong, nonatomic) NSString *wifiPassword;

@property (strong, nonatomic) NetworkAction *networkAction;
@end
