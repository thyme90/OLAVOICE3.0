//
//  DataBaseManager.h
//  LessonUI20_DataBase
//
//  Created by lanou26Thyme on 15-7-21.
//  Copyright (c) 2015年 lanou-thy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>//导入数据库sqlite3头文件
/*
 该类为数据库管理类
 一：打开数据库
 二：关闭数据库
 */
@interface DataBaseManager : NSObject
// sqlite3 *为数据库对象类型，指向数据库首地址
//打开数据库
+ (sqlite3 *)openDataBase;
+ (void)closeDataBase;
@end
