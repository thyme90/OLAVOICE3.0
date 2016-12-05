//
//  BoxSettingVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/2.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "BoxSettingVC.h"

@interface BoxSettingVC ()

@end

@implementation BoxSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
     _passValue = [NetworkAction getNetworkActionInstance];
     _passValue.delegate = self;
     //取得可用音箱
     AudioBox* box = [AudioBox getAudioBoxInstance];
     availableBoxNameArray = [[NSMutableArray alloc] initWithArray:box.boxNames];
     if (availableBoxNameArray.count != 0) {
     firstBoxName = [availableBoxNameArray objectAtIndex:0];
     UserManager* manager = [UserManager getUserManagerInstance];
     manager.currentBoxName = firstBoxName;
     }
     //获得不可用音箱
     [box getunAuidoBoxNames];
     unavailableBoxNameArray = [[NSMutableArray alloc] initWithArray:box.unBoxNames];
     */
}

- (IBAction)connectBox:(UITapGestureRecognizer *)sender {
    
}

- (IBAction)boxLocationAndName:(UITapGestureRecognizer *)sender {
    
}

- (IBAction)setBoxSalutation:(UITapGestureRecognizer *)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/*
- (void)viewWillAppear:(BOOL)animated{
    boxName.text = [UserManager getUserManagerInstance].currentBoxName;
    m_nickName.text = [UserManager getUserManagerInstance].nickNameSetting;
}
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
