//
//  ResetPasswordVC.h
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/16.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordVC : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *remindAccountLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;


@property (strong, nonatomic) NSString *account;
@end
