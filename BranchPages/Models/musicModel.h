//
//  musicModel.h
//  NoScreenAudio
//
//  Created by S3Graphic on 15/12/8.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface musicModel : NSObject
@property(nonatomic) int musicID;
@property(nonatomic) NSString *songName;
@property(nonatomic) NSString *singerName;
@property(nonatomic) NSString *songAlbum;
@property(nonatomic) NSString *songIndex;
@property(nonatomic) NSString *songPhoto;
@property(nonatomic) NSString *songURL;
-(instancetype)initWithDictionary:(NSDictionary *)Dictionary;
- (instancetype)initWithSongName:(NSString *)songName singerName:(NSString *)singerName musicID:(int) ID;
- (instancetype)initWithSongName:(NSString *)songName singerName:(NSString *)singerName;
@end
