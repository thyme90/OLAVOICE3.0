//
//  NetScan.m
//  NoScreenAudio
//
//  Created by yanminli on 15/10/28.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import "NetworkAction.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import "AsyncSocket.h"
#import "AsyncUdpSocket.h"
#import "AudioBox.h"
#import "SimplePingHelper.h"
#import "UserManager.h"
#import "Reachability.h"
 

#define SEARCHBOXDONE_NOTIFICATION @"searchboxdone"

static BOOL  m_isConnectTimeout = false;// false 表示连接超时，即未找到任何可用音箱
static int num = 0;

@interface NetworkAction()<AsyncSocketDelegate,AsyncUdpSocketDelegate>{
    NSString    *m_connectedHostAddress;
    BOOL        m_isConnectToServerSuccess;
    int  m_phoneType;
    BOOL connectDone;
    NSString* addressStr;
    NSTimer *timer;
    NSMutableSet* ipSet;
    
    NSTimer *timer1;
    BOOL isOn;
    NSInteger ipNum;
    NSString* netIPPrefix;
    
    NSMutableArray* ipArray;
    //Reachability *reachabilityHelper;
    
    AsyncUdpSocket *asyncUdpSocket;
    
}

@end

@implementation NetworkAction

static NetworkAction* networkActionInstance = nil;
static Reachability *reachabilityhelper = nil;
+ (NetworkAction *)getNetworkActionInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkActionInstance = [[NetworkAction alloc]init];
    
        reachabilityhelper = [[Reachability alloc]init];
    });
    return networkActionInstance;
}

-(id)init{
    if(self = [super init]){
        _m_socket=[[AsyncSocket alloc] initWithDelegate:self];
        m_connectedHostAddress = nil;
        m_isConnectToServerSuccess = NO;
        self.isPhoneConnToSever = YES;
        connectDone = NO;
        ipSet = [[NSMutableSet alloc] init];
        isOn = YES;
        [self addobserverToNotification];
        
        
        
    }
    return (self);
}

- (BOOL)isConnectTimeout{
    return m_isConnectTimeout;
}

- (BOOL)isConnectToServer{
    return m_isConnectToServerSuccess;
}

//整个搜索音箱和连接音箱的流程如下
/*
 1.搜索整个网段，查找有哪些IP地址可以访问
 2.然后向可以访问的IP地址发送音箱连接请求，发送的时候要带一个消息，message= “get_box_sn\n”
   当音箱收到这个消息的时候，会返回数据给客户端，数据的内容是”receive_phone_type\n“ 客户端就知道这个音箱的名称和IP地址，就可以保留下来.
 
 3.要选择其中的一个音箱和手机连接。目前的方法是选择第一个连上的音箱。手机和音箱连接会有两个步骤
 1) 先通过8600端口向音箱发送一个字符串"phone_type_ios\n"，表示是iOS手机发起一个连接.
    音箱收到设置手机类型消息时，先判断是否已经与某手机连接，如果没有连接按以前一样发送字符串”receive_phone_type”并修改手机类型数据，
    如果已经有手机与音箱连接，音箱端发送”connected_to_other_phone”字符串，并不修改音箱端的手机类型。
    手机端可以根据”connected_to_other_phone”字符串提示已经有手机与音箱连接。
   2）然后根据这个IP，通过8080端口让手机和音箱连接
 */

#pragma mark 搜索网络中可用设备
-(void)scanNetwork{
    [ipSet removeAllObjects];
    NSLog(@"scanNetwork!");
 ////  得到当前局域网IP的前缀
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    NSArray *array = [address componentsSeparatedByString:@"."];
    if ([address isEqualToString:@"error"]|| [array count] == 0 ) {
        //// 没有搜到
        NSLog(@"手机没有上网");
    }else{
        NSString* prefixStr =[[NSString alloc] init];
        prefixStr = [prefixStr stringByAppendingFormat:@"%@.%@.%@.",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2]];
        netIPPrefix = prefixStr;
        NSLog(@"局域网前缀%@",prefixStr);
        [self pingAndConnectAvailableDevice];
    }
}

- (void)pingAndConnectAvailableDevice{
    self.boxDataType = SEARCHBOXDATA;
    //原代码
    timer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(doTask) userInfo:nil repeats:YES];
    [timer fire];
    
   
    //double delayInSeconds = 0.15*40;
    double delayInSeconds = 0.15*270;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        ipArray = [NSMutableArray arrayWithArray:[ipSet allObjects]];
        ipNum = ipSet.count;
        NSLog(@"ipNum = %ld",(long)ipNum);
        ipNum--;
        timer1 = [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(connectServer) userInfo:nil repeats:YES];
        [timer1 fire];
        });
    
}
#pragma mark 停止搜索
- (void)stopAllTheScanProcess{
    [timer  invalidate];
    [timer1 invalidate];
}

- (void)connectToTheFirstMusicBox{
     [self phoneConnectToServer];
}

#pragma mark --定时器的回调函数
-(void)doTask{
    addressStr = [NSString stringWithFormat:@"%@%d",netIPPrefix,num];
    [SimplePingHelper ping:addressStr target:self sel:@selector(pingResult:)];
    num+=1;
    //num > 255
    if (num > 255) {
        [timer invalidate];
    }
}

#pragma mark --ping命令的回调函数
- (void)pingResult:(NSNumber *)success {
    if (success.boolValue == 1) {
        NSLog(@"addressStr is %@",addressStr);
        [ipSet addObject:addressStr];
    }
}

-(void)connectServer{
    if (isOn) {
        self.boxDataType = SEARCHBOXDATA;
        NSString* ipStr = [ipArray objectAtIndex:ipNum--];
        NSLog(@"此时连接%@",ipStr);
        NSString *message=@"get_box_sn\n";
        [self connectToServer:ipStr onPort:8600 WithData:message];
        isOn = NO;
        if (ipNum<0) {
////////////////////////////////////////////////////////////--------------------------------------------------------------
            [self.delegate scanFinished:YES];
            [timer1 invalidate];
            NSLog(@"Scan finshed!");
        }
    }
}

#pragma mark --手机和音箱的连接
-(void)phoneConnectToServer{
        NSLog(@"phoneConnectToServer");
        AudioBox* box = [AudioBox getAudioBoxInstance];
        //获得不可用音箱
        [box getunAuidoBoxNames];

        if (box.boxNames.count != 0) {
            [UserManager getUserManagerInstance].isBoxConnect = YES;
            //手机和音响的连接
            NSString* serverIP = [self getFirstSeverIP];
            if (serverIP) {
                [self phoneTypeToSever:serverIP];
            }
            double delayInSeconds = 5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                BOOL isPhoneToServer = [self isPhoneType];
                if (isPhoneToServer) {
                    [self phoneToSever:serverIP phoneType:1];
                    double delayInSeconds = 5;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    ///////////////////////////////////////////////////////////////////////////////////////////////////////
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        BOOL isPhoneToServer = [self isPhoneConnToSever];
                        if (isPhoneToServer) {
                            [UserManager getUserManagerInstance].isPhoneToBox = YES;
                            [self sendBoxsetting];//当手机和音箱连接成功的时候，获得音箱配置的信息
                        }else{
                            [UserManager getUserManagerInstance].isPhoneToBox = NO;
                        }
                        //完成搜索
                        [self.delegate completeSearchBox];
                    });
                    ////////////////////////////////////////////////////////////////////////////////////////////////////////
                    }else{
                    //完成搜索
                    [self.delegate completeSearchBox];
                }
            });
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        }
}
/////、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、
/////、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、

#pragma mark --保存音箱的信息
-(void)saveAudioInfo:(NSData*)boxInfoData{
    NSLog(@"saveAudioBoxInfo!");
    if (!boxInfoData) {
        return;
    }
    AudioBox* box = [AudioBox getAudioBoxInstance];
    NSString* newObj = [[NSString alloc] initWithData:boxInfoData encoding:NSUTF8StringEncoding];
    if ([newObj isEqualToString:@"receive_phone_type\n"]) {
        return;
    }
    NSLog(@"boxIPAdress is %@",m_connectedHostAddress);
    newObj = [newObj stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    newObj = [newObj stringByAppendingFormat:@"$$%@",m_connectedHostAddress];
    NSString* boxName = [[NSString alloc] initWithData:boxInfoData encoding:NSUTF8StringEncoding];
    NSLog(@"boxName is %@",boxName);
    
    if (boxName == nil) {
        return;
    }
    
    BOOL isContains = [box.boxNames containsObject:boxName];
    if (!isContains) {
        //找到一个新的音箱
        [box.boxArray addObject:newObj];
        [box.boxAllNames addObject:boxName];
        [box.boxNames addObject:boxName];
        [box.boxIPs addObject:m_connectedHostAddress];
        [box.boxDicts setObject:boxName forKey:m_connectedHostAddress];
        NSLog(@"------------------------ add new object");
        m_isConnectTimeout = true;
    }
}

#pragma mark --连接server
-(int)connectToServer:(NSString*)ip onPort:(UInt16)port WithData:(NSString*)message{
        NSError *error=nil;
        if(![_m_socket connectToHost:ip onPort:port error:&error]){
             NSLog(@"连接服务器失败!");
            return  -1;
        }else{
            NSLog(@"连接服务器!");
            if (message) {
                [_m_socket writeData:[message dataUsingEncoding:NSUTF8StringEncoding] withTimeout:5 tag:0];
            }
            return 0;
        }
}

#pragma mark - AsyncScoket Delagate
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    //NSLog(@"didConnectToHost");
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"writedataing");
   [sock readDataWithTimeout: -1 tag: 0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"readdata");
    switch (self.boxDataType) {
        // 搜索音箱反馈
        case SEARCHBOXDATA:{
            NSLog(@"搜索音箱的信息");
            NSLog(@"address is %@",[sock connectedHost]);
            m_connectedHostAddress = [sock connectedHost];
            isOn = YES;
            [self saveAudioInfo:data];
        }
            break;
        // 音箱设置反馈
        case BOXSETTINGDATA:{
            [self getBoxSetting:data];
            [self.delegate firstConnectFinished:YES];
            NSLog(@"接收到了音箱的设置信息");
        }
            break;
        // 获取手机类型反馈
        case PHONETYPETOSERVERDATA:{
            NSLog(@"获取手机类型!");
            if (!data) {
                self.isPhoneType = NO;
            }else{
                NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"已经获取手机类型，%@",str);
                if ([str isEqualToString:@"receive_phone_type\n"]) {
                    self.isPhoneType = YES;
//                    NSString* serverIP = [self getSeverIP];
//                    [self  phoneToSever:serverIP phoneType:1];
                }else if ([str isEqualToString:@"connected_to_other_phone"]){
                    self.isPhoneType = NO;
                }
            }
        }
            break;
        // 手机连接音箱成功反馈
        case PHONETOSERVERDATA:{
            NSLog(@"手机和音箱连接成功!");
            [UserManager getUserManagerInstance].isPhoneToBox = YES;
            //[sock readDataWithTimeout:-1 tag:0];
        }
            break;
        // 8080端口发送命令反馈
        default:{
            /////// 对收到的数据进行拼接
            if (_preData == nil) {
                _preData = [[NSMutableData alloc] init];
            }
            [_preData appendData:data];
            /////// 判断收到的数据是否完整
            NSString *receiveString = [[NSString alloc]initWithData:_preData encoding:NSUTF8StringEncoding];
            NSRange range = [receiveString rangeOfString:@"}}]}"];
            if (range.length!=0) {
                [self.delegate passSocketValue: _preData];
                _preData = nil;
                NSLog(@"接受完毕，可以解析！");
                _userManager = [UserManager getUserManagerInstance];
                _userManager.isPhoneToBox = YES;
            }else{
                //数据读取未完毕，继续读取
                [sock readDataWithTimeout:-1 tag:0];
            }
        }
            break;
    }
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    NSLog(@"连接断开");
    //断开连接了
   if ((sock.userData == SocketOfflineByServer | sock.userData == SocketOfflineByUser) && m_phoneType) {
        NSLog(@"手机连接音箱断开,socket.userData = %ld",sock.userData);
        self.isPhoneConnToSever = NO;
        sock = nil;
    }else if(sock.userData == SocketOfflineByServer | sock.userData == SocketOfflineByUser){
        isOn = YES;
        NSLog(@"测试音箱是否可用");
        if (ipNum<0 ) {
            AudioBox* box = [AudioBox getAudioBoxInstance];
            if (box.boxNames.count == 0){
                [self.delegate completeSearchBox];
                NSLog(@"已经连接完毕");
            }
        }
    }
}

-(void)phoneTypeToSever:(NSString*) ipServer{
    NSLog(@"手机向音箱发送手机类型");
    NSString *phoneType = @"phone_type_ios\n";
    self.boxDataType = PHONETYPETOSERVERDATA;
    [self connectToServer:ipServer onPort:8600 WithData:phoneType];
}

-(void)phoneToSever:(NSString*) ipServer phoneType:(int) phoneType{
    m_phoneType = phoneType;
    if (![self connectToServer:ipServer onPort:8080 WithData:nil]) {
        NSLog(@"手机开始连接音箱！（8080端口）");
    }
}

- (NSString*)getFirstSeverIP{
    NSMutableArray* boxsnArray = [AudioBox getAudioBoxInstance].boxIPs;
    if (boxsnArray.count != 0) {
        NSString* ip = [boxsnArray objectAtIndex:0];
        UserManager* manager = [UserManager getUserManagerInstance];
        manager.currentConnectIP = ip;
        NSLog(@"server ip is %@",ip);
        return ip;
     }else{
        NSLog(@"server ip array is nil");
     }
    return nil;
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
    
    [_m_socket writeData:dataA withTimeout:5 tag:0];
}

- (void)sendJSONCommandToBoxWithCommandCategory:(NSString*)category MessageKind:(NSString*)messageKind Command:(id)command  addKey:(NSString*)addKey addValue:(int)addValue{
    //{"domain":"music","data":{"action_type":"command","action":"query_current_play_music","nick_name":"主人"}}
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
    [_m_socket writeData:dataA withTimeout:5 tag:0];
}

//发送设置的值给音箱端
- (void)sendJSONCommandToBoxWithCommandData:(NSString *)category CommandData:(NSDictionary*) commandData{
     //{"domain":"music","data":{"action_type":"command","action":"query_current_play_music","nick_name":"主人"}}
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
    
    [_m_socket writeData:dataA withTimeout:5 tag:0];
}

//在手机和音箱连接之后，手机xiang音箱发送消息，获得音箱的设备名称和昵称
-(void)sendBoxsetting{
    NSDictionary *commandData = [[NSDictionary alloc]init];
    //{"domain":"music","data":{"action_type":"command","action":"query_current_play_music","nick_name":"主人"}}
    commandData = [NSDictionary dictionaryWithObjectsAndKeys:@"command",@"action_type",@"query_setting",@"action",nil];
    self.boxDataType = BOXSETTINGDATA;
    [self sendJSONCommandToBoxWithCommandData:@"music_box_setting" CommandData:commandData];
    NSLog(@"发送音箱配置消息");
}

- (void)getBoxSetting:(NSData*) data{
    NSError *error = nil;
    NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
    NSLog(@"receiveDic = %@ ",receiveDic);
    NSDictionary *contentDic = [[receiveDic objectForKey:@"Just Talk Dialog Outputs"]objectAtIndex:0];
    if (contentDic){
        NSDictionary *dictData = [contentDic objectForKey:@"App"];
        
        //NSString* boxName  = [dictData objectForKey:@"music_box_name"];
        NSString* nick_name = [dictData objectForKey:@"nick_name"];
        NSLog(@"%@",nick_name);
        [UserManager getUserManagerInstance].nickNameSetting = nick_name;
    }else {
        NSLog(@"An error happened while deserializing the JSON data.");
    }
}

#pragma mark-- 得到当前局域网IP的前缀
-(NSString*) getIPPrefix{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    NSArray *array = [address componentsSeparatedByString:@"."];
    if ([address isEqualToString:@"error"]|| [array count] == 0 ) {
        return nil;
    }
    NSString* prefixStr =[[NSString alloc] init];
    prefixStr = [prefixStr stringByAppendingFormat:@"%@.%@.%@.",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2]];
    NSLog(@"局域网前缀%@",prefixStr);
    [self pingAndConnectAvailableDevice];
    return prefixStr;
    
}

#pragma mark--发送通知
-(void)postNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:SEARCHBOXDONE_NOTIFICATION object:self userInfo:nil];
}

#pragma mark--添加监听
-(void)addobserverToNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneConnectToServer) name:SEARCHBOXDONE_NOTIFICATION object:nil];
}

@end
