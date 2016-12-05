//
//  LoginPasswordVC.h
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/15.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commonHeadFile.h"

@interface LoginPasswordVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *accountTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

@property (strong, nonatomic) NSString *account;
@property (assign,nonatomic) AccountType accountType;
@end
