//
//  VerifyRegisterVC.h
//  NoScreenAudio
//
//  Created by S3Graphic on 16/12/6.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"
#import "CommonHeadFile.h"
@interface VerifyRegisterVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendVerificationButton;

@property (weak, nonatomic) IBOutlet UILabel *accountRemindLabel;

@property (strong, nonatomic) NSString *account;
@property (assign,nonatomic) AccountType accountType;

@property (weak, nonatomic) IBOutlet UIImageView *remindView;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

@end
