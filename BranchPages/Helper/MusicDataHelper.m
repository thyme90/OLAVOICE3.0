//
//  MusicDataHelper.m
//  NoScreenAudio
//
//  Created by S3Graphic on 15/12/8.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import "MusicDataHelper.h"
static MusicDataHelper *MDBHelper = nil;
@implementation MusicDataHelper
+ (MusicDataHelper *)shareMusicDataBaseHelper{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MDBHelper = [[MusicDataHelper alloc]init];
    });
    return MDBHelper;
}


//初始化数据原数组
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
//创建数据库
- (void)createDataBase
{
    //获取数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //拼接路径
    NSString *musicDataBaseFilePath = [doc stringByAppendingPathComponent:@"personalMusic.sqlite"];
    //创建数据库
    FMDatabase *dateBase = [FMDatabase databaseWithPath:musicDataBaseFilePath];
    self.MusicDataBase = dateBase;
}
//创建表
- (void)createTable
{
    if ([self.MusicDataBase open]) {
        //创建表
        BOOL result = [self.MusicDataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS musicList (id integer PRIMARY KEY AUTOINCREMENT, songName text NOT NULL, singerName text NOT NULL);"];
        if (result) {
            NSLog(@"创建表成功");
        }else
        {
            NSLog(@"创建表失败");
        }
    }else
    {
        NSLog(@"数据库打开失败");
    }
    [self.MusicDataBase close];
}
//插入数据
- (void)insertMusic:(musicModel *)music
{
    if ([self.MusicDataBase open]) {
        BOOL result = [self.MusicDataBase executeUpdate:@"INSERT INTO musicList (songName, singerName) VALUES (?,?);",music.songName,music.singerName];
        if (result) {
            NSLog(@"插入成功");
        }
        else
        {
            NSLog(@"插入失败");
        }
    }
    [self.MusicDataBase close];
    
}
//删除数据
- (void)deleteMusic:(musicModel *)music
{
    
    if ([self.MusicDataBase open]) {
        BOOL result = [self.MusicDataBase executeUpdate:@"delete from musicList where songName = ?,singerName = ?",music.songName,music.singerName];
        if (result) {
            NSLog(@"删除成功");
        }
        else
        {
            NSLog(@"删除失败");
        }
    }
    [self.MusicDataBase close];
    
}
//修改数据
/*
- (void)updateMusic:(musicModel *)music
{
    if ([self.MusicDataBase open]) {
        
        BOOL result = [self.MusicDataBase executeUpdate:@"UPDATE t_personalMusic SET songName = ?,phoneNumber = ? WHERE phoneNumber = ?",
                       contact.name,contact.phoneNumber,contact.phoneNumber];
        if (result) {
            NSLog(@"修改成功");
        }
        else
        {
            NSLog(@"修改失败");
        }
    }
    [self.MusicDataBase close];
}
 */
//查询数据
- (NSMutableArray *)queryMusic
{
    NSMutableArray *arr = [NSMutableArray array];
    if ([self.MusicDataBase open]) {
        FMResultSet *resultSet = [self.MusicDataBase executeQuery:@"SELECT * FROM musicList"];
        
        while ([resultSet next]) {
            int ID = [resultSet intForColumn:@"id"];
            NSString *songName = [resultSet stringForColumn:@"songName"];
            NSString *singerName = [resultSet stringForColumn:@"singerName"];
            musicModel *queryMusic = [[musicModel alloc]initWithSongName:songName singerName:singerName musicID:ID];
            [arr addObject:queryMusic];
        }
    }
    NSLog(@"%@" ,arr);
    return arr;
}

@end
