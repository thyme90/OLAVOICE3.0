//
//  FinishChangeMailVC.h
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/9.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinishChangeMailVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nextAccountTextField;
@property (weak, nonatomic) IBOutlet UILabel *remindReasonLabel;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *remindImage;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
@property (strong,nonatomic) NSString *mailBoxAccount;

@end
