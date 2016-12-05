//
//  DataBaseManager.m
//  LessonUI20_DataBase
//
//  Created by lanou26Thyme on 15-7-21.
//  Copyright (c) 2015年 lanou-thy. All rights reserved.
//

#import "DataBaseManager.h"
#import "macro.h"

static sqlite3 *sqlite = nil;//存储数据库地址 创建数据库对象
@implementation DataBaseManager
///////////、、、、、、、、、、、、、、、、、、、、、、、、、、打开数据库
+ (sqlite3 *)openDataBase{
    //优化：数据库只需打开一次即可
    if (sqlite){
        return sqlite;//如果sqlite对象存在，说明此时数据库已经打开，直接返回即可
    }
    //打开数据库操作
    NSString *filePath = [self dataBaseFilePath];
    //根据路径打开数据库
    int flag = sqlite3_open([filePath UTF8String],&sqlite);
    if (flag == SQLITE_OK) {
        NSLog(@"数据库已打开");
    }
    return sqlite;//返回数据库对象的地址
}

///////////、、、、、、、、、、、、、、、、、、、、、、、、、、关闭数据库
+ (void)closeDataBase{
    //若数据库此时已经打开，则关闭
    if (sqlite) {
        sqlite3_close(sqlite);
        //并且将数据库对象置空
        sqlite = nil;
    }
}


//数据库文件路径
+ (NSString *)dataBaseFilePath{
    //NSString *docFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"fmChannels" ofType:@"sqlite"];
    return path;
}
@end


