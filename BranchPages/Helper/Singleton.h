//
//  Singleton.h
//  NoScreenAudio
//
//  Created by S3Graphic on 15/12/16.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserManager;
@class AsyncSocket;
//enum{
//    SocketOfflineByServer,// 服务器掉线，0
//    SocketOfflineByUser,  // 用户断开连接，1
//};

@protocol GetDataDelegate <NSObject>
- (void)passMusicValue:(id)value;

@end

@interface Singleton : NSObject
/*
//创建单例
+ (Singleton *)shareSocketData;
@property (nonatomic, strong) AsyncSocket  *socket;       // socket
@property (nonatomic, copy  ) NSString        *socketHost;   // socket的Host
@property (nonatomic, assign) UInt16           socketPort;
@property (nonatomic, retain) NSTimer         *connectTimer; //心跳定时器
@property (nonatomic, retain) NSMutableData* preData;

@property (strong, nonatomic) UserManager *userManager;

-(void)socketConnectHost;// socket连接
-(void)cutOffSocket; // 断开socket连接
//向音箱发送命令
//- (void)sendJSONPhoneInfoToBoxWithIP:(NSString *)ip Port:(int)port;
- (void)sendJSONCommandToBoxWithCommandCategory:(NSString*)category MessageKind:(NSString*)messageKind Command:(NSString*)command;
- (void)sendJSONCommandToBoxWithCommandCategory:(NSString*)category MessageKind:(NSString*)messageKind Command:(NSString*)command addKey:(NSString*)addKey addValue:(int)addValue;
//- (void)sendJSONCommandToBoxWithIP:(NSString *)ip Port:(int)port CommandCategory:(NSString*)category MessageKind:(NSString*)messageKind Command:(NSString *)command;
//- (void)connectToBox:(NSString*)ip onPort:(UInt16)port WithData:(NSData*)message;
//- (NSData *)getReplyData;
@property (nonatomic, assign) id<GetDataDelegate>delegate;
 */
@end
