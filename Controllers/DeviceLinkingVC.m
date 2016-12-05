//
//  DeviceLinkingVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/17.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "DeviceLinkingVC.h"
#import "macro.h"
@interface DeviceLinkingVC ()<GetSocketDataDelegate>{
    BOOL isSuccessSearchedOrNot;
    //UIImageView *wrongAndRightView;
    //TYDotIndicatorView *darkCircleDot;
    //NSOperationQueue *queue;
}

@end

@implementation DeviceLinkingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _linkStateLabel.text = @"正在强力搜索局域网内的可连接音箱...";
    _linkButton.hidden = YES;
    //
    //@"连接失败"
    [self backConnectAction];
}

-(void)backConnectAction{
    double delayInSeconds1 = 2;
    dispatch_time_t timer1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds1 * NSEC_PER_SEC));
    dispatch_after(timer1, dispatch_get_main_queue(), ^(void){
        dispatch_after(timer1, dispatch_get_main_queue(), ^(void){
            _networkAction = [NetworkAction getNetworkActionInstance];
            _networkAction.delegate = self;
            [_networkAction scanNetwork];
        });
    });
}

- (void)completeSearchBox{
    NSLog(@"搜索完成");
}

- (void)scanFinished:(BOOL)isFinished{
    if (isFinished== YES) {
        BOOL hasAudio = [_networkAction isConnectTimeout];
        if (hasAudio) {
            isSuccessSearchedOrNot = YES;
            //[UserManager getUserManagerInstance].isBoxConnect = YES;
            [self connectSuccessedAction];
        }else{
            isSuccessSearchedOrNot = NO;
            [self connectFailedAction];
        }
    }
}


#pragma mark  点击重试按钮时，恢复初始界面
- (IBAction)retryButtonClickAction:(id)sender {
    
    _linkStateLabel.text = @"正在强力搜索局域网内的可连接音箱...";
    //wrongAndRightView.hidden = YES;
    //[darkCircleDot startAnimating];
    //取消和重试按钮恢复的动画效果
    [self backConnectAction];
}

#pragma mark  连接成功
- (void)connectSuccessedAction{
    _linkStateLabel.text = @"搜索到1个可连接音箱\n音箱一";
    //[darkCircleDot stopAnimating];
    //wrongAndRightView.hidden = NO;
    //[wrongAndRightView setImage:[UIImage imageNamed:@"icn_right_gray"]];
    
    double delayInSeconds = 3;
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(timer, dispatch_get_main_queue(), ^(void){
        /*
         UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         UIViewController* phoneConnectBoxVC =[mainStoryBoard instantiateViewControllerWithIdentifier:@"audioPhoneSettingVC"];
         [self.navigationController pushViewController:phoneConnectBoxVC animated:NO];
         */
        [self performSegueWithIdentifier:@"toDeviceEditPage" sender:self];
    });
}

#pragma mark  连接失败
-(void)connectFailedAction{
    _linkStateLabel.text = @"连接失败";
    _linkRemindLabel.text = @"1.请确认wifii密码是否输入正确\n2.确保手机wifi与您上一步选择的wifi是同一(可进入手机设置查看/更改手机wifi连接状态)";
    _linkButton.hidden = NO;
    //[darkCircleDot stopAnimating];
    //wrongAndRightView.hidden = NO;
    //[wrongAndRightView setImage:[UIImage imageNamed:@"icn_wrong_red"]];
    
    //取消和重试按钮的动画效果
}

////////////////////////////////////////////////////////////////////////////////////////////////
/*
- (void)viewDidLoad {
    [super viewDidLoad];
 
    [darkCircleDot startAnimating];
    [self.view addSubview:darkCircleDot];
    
    wrongAndRightView = [[UIImageView alloc]init];
    wrongAndRightView.backgroundColor = [UIColor whiteColor];
    wrongAndRightView.center = CGPointMake(160*mKwidth, 154.5*mKheight);
    wrongAndRightView.contentMode = UIViewContentModeCenter;
    wrongAndRightView.hidden = YES;
    [self.view addSubview:wrongAndRightView];
    
    _connectStatuLabel.text = @"手机正在与音箱建立连接";
    
    self.cancelButton.hidden = YES;
    self.retryButton.hidden = YES;
    self.separatorView.hidden = YES;
    
    networkAction = [NetworkAction getNetworkActionInstance];
    networkAction.delegate = self;
    [networkAction connectToTheFirstMusicBox];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)completeSearchBox{
    NSLog(@"搜索完成");
}

- (void)firstConnectFinished:(BOOL)isFinished{
    if (isFinished == YES) {
        m_isSuccessConnecting = YES;
        [self connectSuccessedAction];
    }else{
        m_isSuccessConnecting = NO;
        [self connectFailedAction];
    }
}

//连接成功的时候，界面的动画
- (void)connectSuccessedAction{
    _connectStatuLabel.text = @"连接成功";
    [darkCircleDot stopAnimating];
    wrongAndRightView.hidden = NO;
    [wrongAndRightView setImage:[UIImage imageNamed:@"icn_right_gray"]];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerAdvanced) userInfo:nil repeats:NO];
}

-(void)timerAdvanced{
    [UserManager getUserManagerInstance].isPhoneToBox = YES;//手机和音箱已经连接
    //    if ([UserManager getUserManagerInstance].logStatus == FirstLog) {
    //
    //    }else{
    //        NSLog(@"回到主页面");
    //        [self.navigationController popToRootViewControllerAnimated:YES];
    //    }
}

//连接失败的时候，界面的动画
-(void)connectFailedAction{
    _connectStatuLabel.text = @"Oppos!出问题了";
    [darkCircleDot stopAnimating];
    wrongAndRightView.hidden = NO;
    [wrongAndRightView setImage:[UIImage imageNamed:@"icn_wrong_red"]];
    
    //取消和重试按钮的动画效果
}

#pragma mark  点击重试按钮时，恢复初始界面
-(IBAction)retryButtonClickAction:(id)sender{
    _connectStatuLabel.text = @"手机正在与音箱建立连接";
    [darkCircleDot startAnimating];
 
    [networkAction connectToTheFirstMusicBox];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    if ([UserManager getUserManagerInstance].isPhoneToBox == YES) {
}
 */
////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
