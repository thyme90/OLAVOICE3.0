//
//  VerifyVC.h
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/16.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeadFile.h"
@interface VerifyVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *verifyTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *verifyTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindAccountLabel;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendVerificationButton;

@property (strong, nonatomic) NSString *account;
@property (assign, nonatomic)  AccountType accountType;
@end
