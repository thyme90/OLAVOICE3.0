//
//  MusicDataHelper.h
//  NoScreenAudio
//
//  Created by S3Graphic on 15/12/8.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "macro.h"
@interface MusicDataHelper : NSObject
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)FMDatabase *MusicDataBase;
+ (MusicDataHelper *)shareMusicDataBaseHelper;
- (void)insertMusic:(musicModel *)music;
- (void)deleteMusic:(musicModel *)music;
//- (void)updateMusic:(musicModel *)music;
- (NSMutableArray *)queryMusic;
@end
