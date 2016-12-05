//
//  NetScan.h
//  NoScreenAudio
//
//  Created by yanminli on 15/10/28.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserManager;
@class AsyncSocket;
enum{
    SocketOfflineByServer,// 服务器掉线，0
    SocketOfflineByUser  // 用户断开连接，1
};
@protocol GetSocketDataDelegate <NSObject>
@ optional
- (void)passSocketValue:(id)value;
- (void)scanFinished:(BOOL)isFinished;
- (void)firstConnectFinished:(BOOL)isFinished;

- (void)completeSearchBox;//完成音箱的搜索的时候，调用这个函数

- (void)stopAllTheScanProcess; //点击暂停按钮时停止所有的进程

@end

//定义进行socket连接的时候，接受的数据的类型
typedef NS_ENUM(NSInteger,BoxDataType){
    SEARCHBOXDATA,              //扫描音箱时，接受的数据
    BOXSETTINGDATA,             //获取音箱设置的数据
    PHONETYPETOSERVERDATA,      //获取手机的类型
    PHONETOSERVERDATA,          //手机和音箱连接返回的数据
    OTHERDATA
};

@interface NetworkAction : NSObject{
    
}

+ (NetworkAction*)getNetworkActionInstance;


- (void)scanNetwork;//扫描音箱
- (void)stopAllTheScanProcess;
- (void)connectToTheFirstMusicBox;//连接到搜索到的第一个音箱


- (BOOL)isConnectTimeout;//判断是否超时
- (int)connectToServer:(NSString*)ip onPort:(UInt16)port WithData:(NSString*)message;//和server连接
- (void)phoneTypeToSever:(NSString*) ipServer;//向音箱发送客户端类型
- (void)phoneToSever:(NSString*) ipServer phoneType:(int) phoneType;//手机连接音箱，其中第二个参数用来定义当前是“手机连接音箱”的动作，
                                                                    //根据这个标志来获得网络断开时的状态:,1，表示当前是这个动作
//由于目前音箱的连接有两次动作，一次是测试那些音箱是可以连接的。一次是确定一个手机和一个音箱连接

- (NSString*)getFirstSeverIP;//获得当前可用音箱数组中的第一个ip

@property (assign,nonatomic) BOOL isPhoneType;
@property (assign,nonatomic) BOOL isPhoneConnToSever;
@property (assign,nonatomic) BOOL isPhoneConnToBox;
@property (strong, nonatomic) AsyncSocket *m_socket;

@property (strong, nonatomic) UserManager *userManager;
@property (nonatomic, retain) NSMutableData* preData;
- (void)sendJSONCommandToBoxWithCommandCategory:(NSString*)category MessageKind:(NSString*)messageKind Command:(NSString*)command;
- (void)sendJSONCommandToBoxWithCommandCategory:(NSString*)category MessageKind:(NSString*)messageKind Command:(NSString*)command addKey:(NSString*)addKey addValue:(int)addValue;
- (void)sendJSONCommandToBoxWithCommandData:(NSString *)category CommandData:(NSDictionary*) commandData;
@property (nonatomic, assign) id<GetSocketDataDelegate>delegate;
@property(assign,nonatomic)BoxDataType boxDataType;

@end
