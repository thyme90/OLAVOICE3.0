//
//  TTSInterfaceAdapter.h
//  TTSAudioDemo
//
//  Created by yanminli on 16/4/19.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTSInterfaceAdapter : NSObject
-(BOOL)playSound:(NSString*)text;
-(BOOL)stopSound;
@property BOOL isPlayDone;
@end
