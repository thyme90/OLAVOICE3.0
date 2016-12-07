//
//  DeviceLinkPhoneVC.h
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/17.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceLinkPhoneVC : UIViewController
@property (strong,nonatomic) NSString *deviceName;
@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;

@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

@end
