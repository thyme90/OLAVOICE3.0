//
//  AudioBox.h
//  NoScreenAudio
//
//  Created by yanminli on 15/12/25.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioBox : NSObject
+ (AudioBox*)getAudioBoxInstance;
@property (strong,nonatomic) NSMutableArray* boxArray;
@property (strong,nonatomic) NSMutableArray* boxIPs;//保存音响的IP
@property (strong,nonatomic) NSMutableArray* boxNames;//保存可用音响的名称
@property (strong,nonatomic) NSMutableDictionary*   boxDicts;//保存IP和名称的对应关系
@property (strong,nonatomic) NSMutableArray* boxAllNames;//保存所有的音箱
@property (strong,nonatomic) NSMutableArray* unBoxNames;//保存不可用音箱的名称
-(void)getunAuidoBoxNames;
-(BOOL)isDuplicaitonNames:(NSString*) boxName;//判断输入的音箱的名称是否已经存在。存在返回true，否则返回false;
@end
