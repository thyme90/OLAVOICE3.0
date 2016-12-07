//
//  macro.h
//  NoScreenAudio
//
//  Created by S3Graphic on 15/12/4.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#ifndef macro_h
#define macro_h
//=============================================
static BOOL leftSliderOpenOrNot = NO;//控制中心侧边栏是否打开

// ------------------------------------------------------------------ controllers  控制器
#import "RootViewController.h"// 最初始页面“搜索音箱”、“直接进入”
#import <CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/CaptiveNetwork.h>
//================================
//註冊和登錄頁面
#import "LoginVC.h"
#import "LoginPasswordVC.h"
#import "VerifyVC.h"
#import "ResetPasswordVC.h"
#import "RegisterVC.h"
#import "VerifyRegisterVC.h"
#import "SetPasswordVC.h"
//各个设置页面
#import "UserCenterVC.h"
#import "ChangeNicknameVC.h"
#import "ChangeMailVC.h"
#import "FinishChangeMailVC.h"
#import "BindingPhoneVC.h"
#import "ChangePhoneVC.h"
#import "FinishChangePhoneVC.h"
#import "VoiceSettingVC.h"
#import "BoxSettingVC.h"
#import "BoxEditVC.h"
#import "ContactUsVC.h"
//  家居頁面
#import "SmartHomeVC.h"
#import "AddDeviceVC.h"
#import "DeviceEditVC.h"
#import "DeviceLinkPhoneVC.h"
#import "DeviceLinkWifiVC.h"
#import "DeviceLinkingVC.h"
//====================================
// ------------------------------------------------------- views  子視圖
// --------------- 自定義視圖
#import "TYDotIndicatorView.h"

#import "VoiceView.h"
// --------------- 自定義cell
#import "SmartHomeCell.h"
#import "AddDeviceVCCell.h"
//====================================
// ------------------------------------------------------ models  模型
#import "musicModel.h"
#import "Channel.h"
//====================================
// ------------------------------------------------------ vendors  第三方
#import "FMDatabase.h"
#import "AsyncSocket.h"
#import "UIImageView+WebCache.h"
#import "MZTimerLabel.h"
//====================================
// ------------------------------------------------------ helpers 單例
#import "CommonHeadFile.h"
#import "NetworkAction.h"
#import "AudioBox.h"
#import "HttpConnect.h"
//
#import "DataBaseManager.h"//  FM數據庫
#import "NetworkAction.h" //  發送命令
#import "HttpConnect.h"
#import "UserManager.h"//  獲取信息
#import "NSString+Extension.h"//nsstring的扩展类
//====================================
// ------------------------------------------------------ macro  宏
#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define Kwidth [UIScreen mainScreen].bounds.size.width
#define Kheight [UIScreen mainScreen].bounds.size.height
#define mKwidth [UIScreen mainScreen].bounds.size.width/320
#define mKheight [UIScreen mainScreen].bounds.size.height/568
#define nKwidth [UIScreen mainScreen].bounds.size.width/375
#define nKheight [UIScreen mainScreen].bounds.size.height/667

<<<<<<< HEAD
#define TIMEOUTINTERVAL 5.0f //定义和服务器端通信的超时时间

=======
typedef NS_ENUM(NSInteger,ButtonType){
    MORE,
    SMARTHOME,
    WEATHER,
    NEWS,
    ENCYCLOPEDIA,
    TRANSLATION
};
>>>>>>> master


#endif /* macro_h */
