//
//  EnterPageViewController.h
//  NoScreenAudio
//
//  Created by S3Graphic on 16/10/9.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VoiceView;
@interface EnterPageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIImageView *mainTriangleImage;

@property (weak, nonatomic) IBOutlet UIView *backboardView;
@property (weak, nonatomic) IBOutlet UIView *mainContent;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

//@property (strong, nonatomic) VoiceView *voiceView;


@property (weak, nonatomic) IBOutlet UIView *leftSidebar;

@property (weak, nonatomic) IBOutlet UIView *buttonboardView;

@property (weak, nonatomic) IBOutlet UIButton *userCenterButton;

@property (weak, nonatomic) IBOutlet UIView *loginRegisterView;

@property (weak, nonatomic) IBOutlet UIView *userNameView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIImageView *AdsImageView;

@end
