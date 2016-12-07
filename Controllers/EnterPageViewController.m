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
@property (nonatomic,strong) UserManager* userManger;
@end

@implementation EnterPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _backboardView.userInteractionEnabled = YES;
    _buttonboardView.userInteractionEnabled = YES;
    _mainContent.userInteractionEnabled = YES;
    _mainImageView.userInteractionEnabled = YES;
    
    _voiceView = [[VoiceView alloc]initWithFrame:CGRectMake(0, 64, _mainContent.frame.size.width, _mainContent.frame.size.height-64)];
    [_mainContent addSubview:_voiceView];
    
    [self.mainContent bringSubviewToFront:_buttonboardView];
    
    _menuButton.selected = NO;
    _mainTriangleImage.hidden = YES;
   
 
<<<<<<< HEAD
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(voiceButtonClickAction:) name:@"voiceClick" object:nil];
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"voiceClick" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connServerError) name:@"connectServerError" object:nil];
=======

    _userManger = [UserManager getUserManagerInstance];
    _userManger.buttonNames = [@[@"0",@"1",@"3"]mutableCopy];
    
    [self  setButtonBoardView];
>>>>>>> master
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([UserManager getUserManagerInstance].isLog) {
        _userNameView.hidden = NO;
        _loginRegisterView.hidden = YES;
        _userNameLabel.text = _userManger.userName;
        [_userCenterButton setImage:[UIImage imageNamed:[UserManager getUserManagerInstance].headImage] forState:UIControlStateNormal];
    }else{
        _userNameView.hidden = YES;
    }
}

- (void)setButtonBoardView{
    _triangle1.hidden = YES;
    _triangle2.hidden = YES;
    _triangle3.hidden = YES;
    _triangle4.hidden = YES;
    _triangle5.hidden = YES;
    _triangle6.hidden = YES;
    _button1.hidden = YES;
    _button2.hidden = YES;
    _button3.hidden = YES;
    _button4.hidden = YES;
    _button5.hidden = YES;
    _button6.hidden = YES;
    NSMutableArray *buttonArray = _userManger.buttonNames;
    NSUInteger count = [buttonArray count];
    NSLog(@"number in array %lu",(unsigned long)count);
    switch (count) {
        case 1:
            _triangle5.hidden = NO;
            _button5.hidden = NO;
            break;
        case 2:
            _triangle2.hidden = NO;
            _button2.hidden = NO;
            _triangle5.hidden = NO;
            _button5.hidden = NO;
            break;
        case 3:
            _triangle2.hidden = NO;
            _button2.hidden = NO;
            _triangle6.hidden = NO;
            _button6.hidden = NO;
            _triangle5.hidden = NO;
            _button5.hidden = NO;
            break;
        case 4:
            _triangle1.hidden = NO;
            _button1.hidden = NO;
            _triangle3.hidden = NO;
            _button3.hidden = NO;
            _triangle4.hidden = NO;
            _button4.hidden = NO;
            _triangle6.hidden = NO;
            _button6.hidden = NO;
            break;
        case 5:
            _triangle2.hidden = NO;
            _button2.hidden = NO;
            _triangle3.hidden = NO;
            _button3.hidden = NO;
            _triangle4.hidden = NO;
            _button4.hidden = NO;
            _triangle5.hidden = NO;
            _button5.hidden = NO;
            _triangle6.hidden = NO;
            _button6.hidden = NO;
            break;
        case 6:
            _triangle1.hidden = NO;
            _button1.hidden = NO;
            _triangle2.hidden = NO;
            _button2.hidden = NO;
            _triangle3.hidden = NO;
            _button3.hidden = NO;
            _triangle4.hidden = NO;
            _button4.hidden = NO;
            _triangle5.hidden = NO;
            _button5.hidden = NO;
            _triangle6.hidden = NO;
            _button6.hidden = NO;
            break;
        
        default:
            break;
    }
}
#pragma mark 删除按钮时发送消息
- (void)deleteButtonOnButtonBoard{
    //创建发送消息
    NSNotification * notice = [NSNotification notificationWithName:@"SETBUTTONBOARD" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
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
- (void)voiceButtonClickAction{
    _mainTriangleImage.hidden = NO;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTriangleButtonAction:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [_mainTriangleImage addGestureRecognizer:tapGesture];
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
    //对话流页面消失
    [_voiceView DlgShow];
}

#pragma mark 主页按钮功能实现
- (IBAction)button1:(UIButton *)sender {
    
}
- (IBAction)button2:(id)sender {
    UIStoryboard *smartHomeStoryBoard = [UIStoryboard storyboardWithName:@"smartHomes" bundle:nil];
    UIViewController *smartHomeVC = [smartHomeStoryBoard instantiateViewControllerWithIdentifier:@"smartHomeMainPage"];
    [self presentViewController:smartHomeVC animated:YES completion:^{}];
}
- (IBAction)button3:(UIButton *)sender {
    
}
- (IBAction)button4:(UIButton *)sender {
    
}
- (IBAction)button5:(UIButton *)sender {
    //创建发送消息
    NSMutableArray *array = [@[@"0"]mutableCopy];
    NSNotification * notice = [NSNotification notificationWithName:@"ClickButtonOnBoard" object:array userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}
- (IBAction)button6:(UIButton *)sender {
    //创建发送消息
    NSMutableArray *array = [@[@"1"]mutableCopy];
    NSNotification * notice = [NSNotification notificationWithName:@"ClickButtonOnBoard" object:array userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}

#pragma mark 点击按钮时发送消息
- (void)clickButtonOnButtonBoard{
    //创建发送消息
    NSMutableArray *array = [@[@3]mutableCopy];
    NSNotification * notice = [NSNotification notificationWithName:@"ClickButtonOnBoard" object:array userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
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

-(void)connServerError{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"连接服务器超时，请稍后再试！" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //显示3秒消失
    dispatch_time_t delayTime3 = dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC);
    [self presentViewController:alertController animated:YES completion:^{
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        
        dispatch_after(delayTime3, mainQueue, ^{
            [alertController dismissViewControllerAnimated:YES completion:nil];
        });
    }];

}

@end
