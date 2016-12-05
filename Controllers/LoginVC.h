//
//  LoginVC.h
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/2.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeadFile.h"
@interface LoginVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

@property (strong, nonatomic) NSString *account;
@property (assign,nonatomic) AccountType accountType;
@end
