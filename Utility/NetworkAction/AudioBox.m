//
//  AudioBox.m
//  NoScreenAudio
//
//  Created by yanminli on 15/12/25.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import "AudioBox.h"

@implementation AudioBox
static AudioBox* AudioBoxInstance = nil;

+ (AudioBox *)getAudioBoxInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AudioBoxInstance = [[AudioBox alloc]init];
    });
    return AudioBoxInstance;
}

-(id)init{
    if(self = [super init]){
        self.boxIPs = [[NSMutableArray alloc] init];
        self.boxArray = [[NSMutableArray alloc] init];
        self.boxDicts = [[NSMutableDictionary alloc] init];
        self.boxNames = [[NSMutableArray alloc] init];
        self.unBoxNames = [[NSMutableArray alloc] init];
    }
    
    return (self);
}

-(void)getunAuidoBoxNames{
    for(id obj in self.boxAllNames){
        if (![self.boxNames containsObject:obj]) {
            [self.unBoxNames addObject:obj];
        }
    }
}

#pragma mark --判断修改的音箱名是否已经存在
-(BOOL)isDuplicaitonNames:(NSString *)boxName{
    for (NSString* str in self.boxAllNames) {
        if ([str isEqualToString:boxName]) {
            return YES;
        }
    }
    return  NO;
}

@end
