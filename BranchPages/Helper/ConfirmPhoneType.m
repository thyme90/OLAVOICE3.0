//
//  ConfirmPhoneType.m
//  NoScreenAudio
//
//  Created by S3Graphic on 15/12/18.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import "ConfirmPhoneType.h"
#import "macro.h"

static ConfirmPhoneType *confirm;

@interface ConfirmPhoneType()<AsyncSocketDelegate>

@end

@implementation ConfirmPhoneType
+ (ConfirmPhoneType *)confirmPhoneTypeData{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        confirm = [[ConfirmPhoneType alloc]init];
    });
    return confirm;
}

- (instancetype)init{
    if (self = [super init]) {
        _socket = [[AsyncSocket alloc]initWithDelegate:self];
    }
    return self;
}

/*
 [Singleton shareSocketData].socketHost = @"10.3.172.132";// host设定
 [Singleton shareSocketData].socketPort = 8600;// port设定
 
 // 在连接前先进行手动断开
 [Singleton shareSocketData].socket.userData = SocketOfflineByUser;
 [[Singleton shareSocketData] cutOffSocket];
 
 // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
 [Singleton shareSocketData].socket.userData = SocketOfflineByServer;
 [[Singleton shareSocketData] socketConnectHost];
 
 */


////// socket连接
- (void)socketConnectHost{
    
    self.socket    = [[AsyncSocket alloc] initWithDelegate:self];
    NSError *error = nil;
    [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:3 error:&error];
}
//／／／／／／／／／／／
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString  *)host port:(UInt16)port
{
    NSLog(@"确认命令端口服务器已连接");
    //NSString *phoneType = @"get_box_sn\n";
    NSString *phoneType = @"phone_type_ios\n";
    NSData   *phoneInfo  = [phoneType dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:phoneInfo withTimeout:1 tag:1];
    [self.socket readDataWithTimeout:20 tag:1];
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"did read phoneType exchange data");
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",aStr);
    
    //NSString *trueStr = @"receive_phone_type";
    if ([aStr  isEqual: @"receive_phone_type\n"]) {
        NSLog(@"right");
    }
}
#pragma mark 连接失败
/*
-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    if (sock.userData == SocketOfflineByServer) {
        // 若服务器掉线，重连
        NSLog(@"确认命令服务器掉线");
        [self socketConnectHost];
    }
    else if (sock.userData == SocketOfflineByUser) {
        // 若由用户断开，不进行重连
        NSLog(@"确认命令主动断开");
        return;
    }
}
*/
-(void)cutOffSocket{
    self.socket.userData = SocketOfflineByUser;// 声明主动切断
    [self.connectTimer invalidate];
    [self.socket disconnect];
}

@end
