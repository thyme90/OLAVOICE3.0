//
//  BoxEditVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/23.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "BoxEditVC.h"

@interface BoxEditVC ()

@end

@implementation BoxEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //监听输入框的值的变化
  /////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
       ///////使用block传值至上一页
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction) name:UITextFieldTextDidChangeNotification object:nil];
    
}

/*
//设置设备名称
-(void)saveNewName{
    //如果为空或者字符超过10，无效
    //    if (textFile.text.length == 0 || textFile.text.length > 10) {
    //        return;
    //    }
    //
    //    NSString* newName = textFile.text;
    //    NSString *nameRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";
    //    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    //    BOOL isMailBox = [nameTest evaluateWithObject:newName];
    //    if (!isMailBox) {
    //        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"设备名称只能是中文，英文和数字!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //        [alert show];
    //    }else{
    //        BOOL isHave = [[AudioBox getAudioBoxInstance] isDuplicaitonNames:newName];
    //        if (isHave) {
    //            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"设备名已经存在，请重新输入!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //            [alert show];
    //        }else{
    //            [UserManager getUserManagerInstance].currentBoxName = textFile.text;
    //
    //            NSDictionary *commandData = [[NSDictionary alloc]init];
    //            //{"domain":"music","data":{"action_type":"command","action":"query_current_play_music","nick_name":"主人"}}
    //            commandData = [NSDictionary dictionaryWithObjectsAndKeys:@"command",@"action_type",@"setting",@"action",newName,@"music_box_name",nil];
    //            NetworkAction* networkAction = [NetworkAction getNetworkActionInstance];
    //            [networkAction sendJSONCommandToBoxWithCommandData:@"music_box_setting" CommandData:commandData];
    //
    //            [self.navigationController popViewControllerAnimated:YES];
    //        }
    //    }
    
    NSString* newName = textFile.text;
    
    [UserManager getUserManagerInstance].currentBoxName = textFile.text;
    
    NSDictionary *commandData = [[NSDictionary alloc]init];
    //{"domain":"music","data":{"action_type":"command","action":"query_current_play_music","nick_name":"主人"}}
    commandData = [NSDictionary dictionaryWithObjectsAndKeys:@"command",@"action_type",@"setting",@"action",newName,@"music_box_name",nil];
    NetworkAction* networkAction = [NetworkAction getNetworkActionInstance];
    [networkAction sendJSONCommandToBoxWithCommandData:@"music_box_setting" CommandData:commandData];
    [self.navigationController popViewControllerAnimated:YES];
}
 
 NSString* newName = _textField.text;
 [UserManager getUserManagerInstance].nickNameSetting = _textField.text;
 NSDictionary *commandData = [[NSDictionary alloc]init];
 //{"domain":"music","data":{"action_type":"command","action":"query_current_play_music","nick_name":"主人"}}
 commandData = [NSDictionary dictionaryWithObjectsAndKeys:@"command",@"action_type",@"setting",@"action",newName,@"nick_name",nil];
 NetworkAction* networkAction = [NetworkAction getNetworkActionInstance];
 [networkAction sendJSONCommandToBoxWithCommandData:@"music_box_setting" CommandData:commandData];



- (void)infoAction{
    //设备名称只能是中文，英文和数字!
    NSString* newName = textFile.text;
    //NSLog(@"%@",newName);
    NSString *nameRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    BOOL isMailBox = [nameTest evaluateWithObject:newName];
    
    if (isMailBox && newName.length < 11) {
        saveButtonItem.enabled = YES;
    }else{
        saveButtonItem.enabled = NO;
    }
    
}
 */

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
