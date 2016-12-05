//
//  EnterPageViewController.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/10/9.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "EnterPageViewController.h"
#import "macro.h"
@interface EnterPageViewController ()
@property (nonatomic,strong) VoiceView  *voiceView;
@end

@implementation EnterPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _backboardView.userInteractionEnabled = YES;
    _buttonboardView.userInteractionEnabled = YES;
    _mainContent.userInteractionEnabled = YES;
    _mainImageView.userInteractionEnabled = NO;
    
    _voiceView = [[VoiceView alloc]initWithFrame:CGRectMake(0, 64, _mainContent.frame.size.width, _mainContent.frame.size.height-64)];
    [_mainContent addSubview:_voiceView];
    
    _menuButton.selected = NO;
   
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTriangleButtonAction:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [_mainImageView addGestureRecognizer:tapGesture];
 
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(voiceButtonClickAction:) name:@"voiceClick" object:nil];
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"voiceClick" object:nil userInfo:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([UserManager getUserManagerInstance].isLog) {
        UserManager* userManger = [UserManager getUserManagerInstance];
        _userNameView.hidden = NO;
        _loginRegisterView.hidden = YES;
        _userNameLabel.text = userManger.userName;
        [_userCenterButton setImage:[UIImage imageNamed:[UserManager getUserManagerInstance].headImage] forState:UIControlStateNormal];
    }else{
        _userNameView.hidden = YES;
    }
}
#pragma mark 侧边栏按钮
- (IBAction)settingButtonClickAction:(UIButton *)sender {
    if (sender.selected == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            _backboardView.frame = CGRectMake(0, 0 , 670*nKwidth, 667*nKheight) ;
        }];
        sender.selected = YES;
    }else if (sender.selected == YES){
        [UIView animateWithDuration:0.5 animations:^{
            _backboardView.frame = CGRectMake(-295*nKwidth, 0 , 670*nKwidth, 667*nKheight) ;
        }];
        sender.selected = NO;
    }
}
#pragma mark 点击话筒按钮
- (void)voiceButtonClickAction:(UIButton *)sender{
    [UIView animateWithDuration:0.3 animations:^{
        _buttonboardView.frame =  CGRectMake(0, -36*nKheight , 375*nKwidth, 400*nKheight) ;
        _mainTriangleImage.transform = CGAffineTransformMakeRotation((-120.0f * M_PI) / 180.0f);
    }completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.1 animations:^{
                _buttonboardView.hidden = YES;
            }];
        }
    }];
    _mainImageView.userInteractionEnabled = YES;
    [_voiceView DlgShow];
}

#pragma mark 三角形按钮
- (void)clickTriangleButtonAction:(UIButton *)sender{
    [UIView animateWithDuration:0.1 animations:^{
        _buttonboardView.hidden = NO;
    }completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.3 animations:^{
                _mainTriangleImage.transform = CGAffineTransformMakeRotation((120.0f * M_PI) / 180.0f);
                _buttonboardView.frame =  CGRectMake(0, 64*nKheight , 375*nKwidth, 400*nKheight) ;
            }];
        }
    }];
    _mainImageView.userInteractionEnabled = NO;
    [_voiceView DlgShow];
    
}

#pragma mark 主页面 - 设置页功能
#pragma mark //点击用户头像
- (IBAction)userCenterButtonClickAction:(UIButton *)sender {
    if ([UserManager getUserManagerInstance].isLog) {
            //如果登陆，就进入用户中心页面
        [self performSegueWithIdentifier:@"toUserCenterPage" sender:self];
    }
}

- (IBAction)loginButtonClickAction:(UIButton *)sender {
    //[self performSegueWithIdentifier:@"toLoginPage" sender:self];
}

- (IBAction)registerButtonClickAction:(UIButton *)sender {
    
}

- (IBAction)voiceSettingButtonClickAction:(UIButton *)sender {
    
}

- (IBAction)boxSettingButtonClickAction:(UIButton *)sender {
    
}

- (IBAction)checkUpdateButtonClickAction:(UIButton *)sender {
    
}

- (IBAction)contactUsButtonClickAction:(UIButton *)sender {
    
}

#pragma mark 主页面 - 主页功能
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //toChangeNickNamePage
    if ([segue.identifier isEqualToString:@"toInputPasswordPage"]) {
        ChangeNicknameVC *nickNameVC = [segue destinationViewController];
        nickNameVC.foreNickName = @" ";
    }else if ([segue.identifier isEqualToString:@"toUserCenterPage"]){
        UserCenterVC *userCenterVC = [segue destinationViewController];
        userCenterVC.userName = [UserManager getUserManagerInstance].userName;
        userCenterVC.accountType = [UserManager getUserManagerInstance].accountType;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
