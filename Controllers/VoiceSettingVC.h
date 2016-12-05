//
//  VoiceSettingVC.h
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/2.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceSettingVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *voicePickViewBack;
@property (weak, nonatomic) IBOutlet UIPickerView *voicePickView;
@property (weak, nonatomic) IBOutlet UIView *salutationDialogBack;
@property (weak, nonatomic) IBOutlet UITextField *salutationTextField;

@end
