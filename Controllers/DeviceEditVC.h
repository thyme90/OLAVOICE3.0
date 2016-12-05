//
//  DeviceEditVC.h
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/17.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceEditVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *deviceEditTitle;
@property (weak, nonatomic) IBOutlet UILabel *deviceInformationLabel;

@property (weak, nonatomic) IBOutlet UILabel *salutationSettingLabel;

@property (weak, nonatomic) IBOutlet UITextField *salutationTextField;

@property (weak, nonatomic) IBOutlet UIButton *enterOrFinishButton;


@end
