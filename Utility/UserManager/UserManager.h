//
//  UserManager.h
//  NoScreenAudio
//
//  Created by yanminli on 15/12/24.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "macro.h"
@interface UserManager : NSObject
+(UserManager*)getUserManagerInstance;
@property(strong,nonatomic) NSString*           nickName;//昵称
@property(strong,nonatomic) NSString*           emailNew;//修改的新的邮件的名称
@property(assign,nonatomic) long                verified;//是否校验的标志 1为验证过，0为未验证
@property(strong,nonatomic) NSString*           imgurl;//头像图片的位置
@property(strong,nonatomic) NSString*           passwd;//明文密码
@property(strong,nonatomic) NSString*           passwdMD5;//MD5加密过后的密码
@property(assign,nonatomic) BOOL                isLog;//账号是否登录
@property(strong,nonatomic) NSString*           olaPhoneNum;//ola手机绑定的手机号
@property(strong,nonatomic) NSString*           userName;//用户名称
@property(strong,nonatomic) NSString*           phoneVcode;//手机登陆的时候保存的短信验证码,如果手机修改以后，改为修改时发送的验证码
@property(assign,nonatomic) AccountType         accountType;//用户的账号类型
@property(strong,nonatomic) NSString*           headImage;//保存用户的头像的名称
@property(strong,nonatomic) NSMutableArray*     boxName;
@property(assign,nonatomic) BOOL                isBoxConnect;//音箱是否联网
@property(assign,nonatomic) BOOL                isPhoneToBox;//音箱和手机是否连接
@property(assign,nonatomic) LogStatus           logStatus;//记录进入APP时的状态
@property(strong,nonatomic) NSString*           currentConnectIP;//保存手机正在连接的音箱的IP
@property(strong,nonatomic) NSString*           nickNameSetting;//音箱的称呼设置
@property(strong,nonatomic) NSString*           currentBoxName;//当前可用音箱的名称，及设备名称
@property(strong,nonatomic) NSString*           oldPhoneNum;//旧手机号
@property(strong,nonatomic) NSString*           oldVcode;//进行修改手机号的时候，保存旧手机号的验证码

-(void)initUserManager;
-(void)reflectDataFromOtherObject;//利用反射机制获得所有属性的值
-(void)saveDataFromObject;//保存属性的值
@end
