//
//  Singleton.m
//  NoScreenAudio
//
//  Created by S3Graphic on 15/12/16.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import "Singleton.h"
#import "macro.h"
#import <ifaddrs.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import "AsyncSocket.h"
static Singleton *passDataWithsocket = nil;

@interface Singleton()<AsyncSocketDelegate>

@end


@implementation Singleton
/*
+ (Singleton *)shareSocketData{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        passDataWithsocket = [[Singleton alloc]init];
    });
    return passDataWithsocket;
}

- (instancetype)init{
    if (self = [super init]) {
        _socket = [[AsyncSocket alloc]initWithDelegate:self];
    }
    return self;
}


 [Singleton shareSocketData].socketHost = @"10.3.172.132";// host设定
 [Singleton shareSocketData].socketPort = 8600;// port设定
 
 // 在连接前先进行手动断开
 [Singleton shareSocketData].socket.userData = SocketOfflineByUser;
 [[Singleton shareSocketData] cutOffSocket];
 
 // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
 [Singleton shareSocketData].socket.userData = SocketOfflineByServer;
 [[Singleton shareSocketData] socketConnectHost];
 
 


#pragma mark  进行socket连接
- (void)socketConnectHost{
    self.socket    = [[AsyncSocket alloc] initWithDelegate:self];
    NSError *error = nil;
    [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:3 error:&error];
}
#pragma mark socket连接成功
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString  *)host port:(UInt16)port
{
    NSLog(@"已连接至音箱命令端口");
    //// 自定义心跳包
    //    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(SocketHeartBeatMessage) userInfo:nil repeats:YES];
    //    [self.connectTimer fire];
    
}
#pragma mark 心跳消息
- (void)SocketHeartBeatMessage{
    // 固定格式的数据
    NSLog(@"心跳消息");
    NSString *command = @"get_box_sn\n";
    NSData   *dataStream  = [command dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:dataStream withTimeout:1 tag:0];
    [self.socket readDataWithTimeout:20 tag:1];
}
#pragma mark 断开socket连接
-(void)cutOffSocket{
    self.socket.userData = SocketOfflineByUser;// 声明主动切断
    [self.connectTimer invalidate];
    [self.socket disconnect];
}
#pragma mark 连接失败

-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    if (sock.userData == SocketOfflineByServer) {
        // 若服务器掉线，重连
        NSLog(@"服务器掉线");
        _userManager.isPhoneToBox = NO;
        [self socketConnectHost];
    }
    else if (sock.userData == SocketOfflineByUser) {
        // 若由用户断开，不进行重连
        NSLog(@"主动断开");
        _userManager.isPhoneToBox = NO;
        return;
    }
}
 
#pragma mark 读取数据
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"did read data");
    /////// 对收到的数据进行拼接
    if (_preData == nil) {
        _preData = [[NSMutableData alloc] init];
    }
    [_preData appendData:data];
    /////// 判断收到的数据是否完整
    NSString *receiveString = [[NSString alloc]initWithData:_preData encoding:NSUTF8StringEncoding];
    NSRange range = [receiveString rangeOfString:@"}}]}"];
    if (range.length!=0) {
        [self.delegate passMusicValue: _preData];
        _preData = nil;
        NSLog(@"接受完毕，可以解析！");
        _userManager = [UserManager getUserManagerInstance];
        _userManager.isPhoneToBox = YES;
    }else
    {
        //数据读取未完毕，继续读取
        [self.socket readDataWithTimeout:-1 tag:0];
    }
}

#pragma mark 确认已发送命令
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"write");
}
#pragma mark 发送命令
- (void)sendJSONCommandToBoxWithCommandCategory:(NSString*)category MessageKind:(NSString*)messageKind Command:(NSString*)command{
    NSDictionary *commandData = [[NSDictionary alloc]init];
    commandData = @{@"action_type":messageKind,@"action":command};
    NSDictionary *message = @{@"domain":category,@"data":commandData};
    //NSLog(@"%@",message);
    NSData *jsonDa = [NSJSONSerialization dataWithJSONObject:message options:NSJSONWritingPrettyPrinted error:nil];
    /////// 添加命令数据头
    int firstInt = 0;
    int secondInt = 0;
    int thirdInt = (int)[jsonDa length];
    NSMutableData *dataA = [NSMutableData dataWithBytes: &firstInt length: sizeof(firstInt)];
    NSData *dataB = [NSData dataWithBytes: &secondInt length: sizeof(secondInt)];
    NSData *dataC = [NSData dataWithBytes: &thirdInt length:sizeof(thirdInt)];
    [dataA appendData:dataB];
    [dataA appendData:dataC];
    [dataA appendData:jsonDa];
    
    [_socket writeData:dataA withTimeout:5 tag:0];
}

- (void)sendJSONCommandToBoxWithCommandCategory:(NSString*)category MessageKind:(NSString*)messageKind Command:(id)command  addKey:(NSString*)addKey addValue:(int)addValue{
    //{"domain":"music","data":{"action_type":"command","action":"query_current_play_music"}}
    NSDictionary *commandData = [[NSDictionary alloc]init];
    if (addKey == nil) {
        commandData = @{@"action_type":messageKind,@"action":command};
    }else{
    NSNumber *volumeNum = [NSNumber numberWithInt:addValue];
        commandData = [NSDictionary dictionaryWithObjectsAndKeys:messageKind,@"action_type",command,@"action",volumeNum,[NSString stringWithFormat:@"%@",addKey], nil];
    }
    NSDictionary *message = @{@"domain":category,@"data":commandData};
//    NSLog(@"%@",message);
    NSData *jsonDa = [NSJSONSerialization dataWithJSONObject:message options:NSJSONWritingPrettyPrinted error:nil];
    
    /////// 添加命令数据头
    int firstInt = 0;
    int secondInt = 0;
    int thirdInt = (int)[jsonDa length];
    NSMutableData *dataA = [NSMutableData dataWithBytes: &firstInt length: sizeof(firstInt)];
    NSData *dataB = [NSData dataWithBytes: &secondInt length: sizeof(secondInt)];
    NSData *dataC = [NSData dataWithBytes: &thirdInt length:sizeof(thirdInt)];
    [dataA appendData:dataB];
    [dataA appendData:dataC];
    [dataA appendData:jsonDa];
    
    [_socket writeData:dataA withTimeout:5 tag:0];
}
*/
@end
