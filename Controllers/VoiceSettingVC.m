//
//  VoiceSettingVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/2.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "VoiceSettingVC.h"

@interface VoiceSettingVC ()

@end

@implementation VoiceSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _voicePickViewBack.hidden = YES;
    _salutationDialogBack.hidden = YES;
}


#pragma mark  设置朗读人声
- (IBAction)setReadVoice:(UITapGestureRecognizer *)sender {
    
    _voicePickViewBack.hidden = NO;
}

#pragma mark 取消设置朗读人声
- (IBAction)cancelSetVoice:(id)sender {
    
    _voicePickViewBack.hidden = YES;
}

#pragma mark 确定设置朗读人声
- (IBAction)confirmSetVoice:(id)sender {
    
    _voicePickViewBack.hidden = YES;
}

#pragma mark 修改称呼
- (IBAction)modifySalutation:(UITapGestureRecognizer *)sender {
    
    _salutationDialogBack.hidden = NO;
}

#pragma mark 取消修改称呼
- (IBAction)cancelModifySalutation:(id)sender {
    
    _salutationDialogBack.hidden = YES;
}

#pragma mark 确定修改称呼
- (IBAction)confirmModifySalutation:(id)sender {
    
    _salutationDialogBack.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
