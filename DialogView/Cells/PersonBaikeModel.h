//
//  PersonBaikeModel.h
//  DialogDemo
//
//  Created by yanminli on 2016/10/31.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellModel.h"


@interface PersonBaikeData : NSObject
@property (nonatomic,strong) NSString   *startTime;
@property (nonatomic,strong) NSString   *post;
@property (nonatomic,strong) NSString   *nation;
@property (nonatomic,strong) NSString   *endTime;
@property (nonatomic,strong) NSString   *personName;
@property (nonatomic,strong) NSString   *postOfTimes;
@end

@interface PersonBaikeModel : CellModel
-(id)initWithData:(NSDictionary *)dic;
@property(nonatomic,strong) NSMutableArray         *personBaikeArray;
@end
