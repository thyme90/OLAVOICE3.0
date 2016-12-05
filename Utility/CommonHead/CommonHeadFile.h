//
//  CommonHeadFile.h
//  NoScreenAudio
//
//  Created by yanminli on 15/12/14.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

#define Kwidth  [UIScreen mainScreen].bounds.size.width //屏幕的宽带
#define Kheight [UIScreen mainScreen].bounds.size.height //屏幕的高度
#define WIDTHRATION [UIScreen mainScreen].bounds.size.width/320
#define mKheight [UIScreen mainScreen].bounds.size.height/568
#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define TIMEOUTINTERVAL 5.0f //定义和服务器端通信的超时时间

//定义当前账号的类型，是手机，邮箱还是OLA账号登陆
typedef NS_ENUM(NSInteger,AccountType){
    OLANUMBER,
    PHONENUMBER,
    MAILBOXNUMBER,
    PHONENUMERROR,
    PHONENUMSUCCESS,
    MAILBOXERROR,
    MAILBOXSUCCESS,
    PHONEREGISTER,
    MAILBOXREGISTER,
    OLAERROR,
    OLASUCCESS,
    ISSUCCESS,
    ISERROR
};

typedef NS_ENUM(NSInteger,AccountStatus){
    LOGSUCCESS,
    LOGFAILE
};

typedef NS_ENUM(NSInteger,SeverStatus){
    SEVERSTATUSSUCCESS,//获得所需的信息
    SEVERSTATUSFAIL,//sever端没有所要的信息
    NETWORKTIMEOUT//网路出错或者超时
};

//记录刚进入APP时的状态，是首次登陆还是直接进入
typedef enum{
    FirstLog,//首次登陆
    MainPageLog//直接进入
}LogStatus;

#define CLINETID               @"D5780EB0-AA5A-1924-D455-C7DDCFCDD57F"//clientid
#define DEVICEID               @""//deviceid
#define REGISTERURL            @"http://10.3.172.214:9080/usermanager/register?"//注册
#define LOGINURL               @"http://10.3.172.214:9080/usermanager/validateuser?"//登陆
#define VERIFYCODEURL          @"http://10.3.172.214:9080/usermanager/validatemobile?"//手机验证码
#define CHECKUSERURL           @"http://10.3.172.214:9080/usermanager/checkuser?"//检查用户是否存在
#define RESETPASSWORD          @"http://10.3.172.214:9080/usermanager/resetpasswordbyemail?"//重设邮箱密码
#define CHANGMAILBOX           @"http://10.3.172.214:9080/usermanager/originalmail?"//修改音箱
#define VALIDVCODE             @"http://10.3.172.214:9080/usermanager/mobilevcodever?"//验证手机号和验证码是否匹配
#define VALIDATEPHONENUM       @"http://10.3.172.214:9080/usermanager/checkmobile?"//验证手机号和验证码是否匹配
#define CHANGEPHONENUM         @"http://10.3.172.214:9080/usermanager/changemobile?"//修改手机号
#define CHANGEPASSWORD         @"http://10.3.172.214:9080/usermanager/changepassword?"//修改邮箱密码
#define CHANGEEMIAL            @"http://10.3.172.214:9080/usermanager/checkchangemail?"//检查邮箱是否修改成功
#define CHANGENICKNAME         @"http://10.3.172.214:9080/usermanager/changenickname?"//修改昵称
#define CHANGEIMAGE            @"http://10.3.172.214:9080/usermanager/changeimg?"//修改昵称

@interface CommonHeadFile : NSObject
+ (CommonHeadFile*)getCommonHeadFileInstance;
- (NSString *)md5HexDigest:(NSString*)input;//md5加密函数
- (NSString *)random6Code;//随机生成6位的随机数
- (NetworkStatus)getNetWorkStates;//获得当前的网络状态

@end
