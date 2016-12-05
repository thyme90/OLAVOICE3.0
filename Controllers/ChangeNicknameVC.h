//
//  ChangeNicknameVC.h
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/8.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeNicknameVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property(strong, nonatomic) NSString *foreNickName;

@end
