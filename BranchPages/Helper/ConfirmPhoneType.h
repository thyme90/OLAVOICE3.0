//
//  ConfirmPhoneType.h
//  NoScreenAudio
//
//  Created by S3Graphic on 15/12/18.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AsyncSocket;
//enum{
//    SocketOfflineByServer,// 服务器掉线，0
//    SocketOfflineByUser,  // 用户断开连接，1
//};

@interface ConfirmPhoneType : NSObject
//创建单例
+ (ConfirmPhoneType *)confirmPhoneTypeData;
@property (nonatomic, strong) AsyncSocket    *socket;       // socket
@property (nonatomic, copy  ) NSString       *socketHost;   // socket的Host
@property (nonatomic, assign) UInt16         socketPort;
@property (nonatomic, retain) NSTimer        *connectTimer; //心跳定时器


-(void)socketConnectHost;// socket连接

-(void)cutOffSocket; // 断开socket连接



//向音箱发送命令
//- (void)sendJSONPhoneInfoToBoxWithIP:(NSString *)ip Port:(int)port;
//- (void)sendJSONCommandToBoxWithIP:(NSString *)ip Port:(int)port CommandCategory:(NSString*)category MessageKind:(NSString*)messageKind Command:(NSString *)command;



@end
