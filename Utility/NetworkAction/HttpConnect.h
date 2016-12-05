//
//  HttpConnect.h
//  NoScreenAudio
//
//  Created by yanminli on 15/12/11.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "macro.h"

@protocol httpConnectDelegate <NSObject>

@required
-(void)connectFailed;
-(void)connectSuccess;


@end

@interface HttpConnect : NSObject
+ (HttpConnect*)getHttpConnectInstance;
-(void)getVerifyCode:(NSString*)phoneNumn newPhoneNum:(NSString*)newphonenum vcode:(NSString*)vcode opt:(NSString*)opt;
-(BOOL)getUser:(NSString*)userID;
-(void)phoneRegister:(NSString *)phoneNum verifyCode:(NSString*)verifycode;
-(void)mailBoxRegister:(NSString*)mailbox passwd:(NSString*)passwd;
-(void)sendMailBox:(NSString*)urlAddress opt:(NSString*)opt;
-(BOOL)validatePhoneNum:(NSString*)phoneNum;//校验手机的有效性
-(SeverStatus)validateVcode:(NSString*)phoneNum vcode:(NSString*)code;//验证手机号和验证码是否匹配
-(SeverStatus)changePhoneNum:(NSString*)srcPhoneNum dstPhoneNum:(NSString*)dstPhoneNum vcode:(NSString*)vcode;// 修改手机号

@property (weak,nonatomic) id<httpConnectDelegate> delegate;
@end
