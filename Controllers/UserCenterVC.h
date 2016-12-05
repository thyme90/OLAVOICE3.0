//
//  UserCenterVC.h
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/2.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"
#import "CommonHeadFile.h"
@interface UserCenterVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *userPicButton;
@property (weak, nonatomic) IBOutlet UIView *changeUserPicView;
@property (assign,nonatomic) AccountType accountType;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) UIImageView *m_headImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_userNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_OLAAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_passwordLabel;
@end
