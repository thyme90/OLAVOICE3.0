//
//  SelectionBaike.h
//  DialogDemo
//
//  Created by yanminli on 2016/11/23.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellModel.h"

@interface SelectionBaikeData : NSObject
@property (nonatomic,strong) NSString   *name;
@property (nonatomic,strong) NSString   *desc;
@end

@interface SelectionBaikeModel : CellModel
-(id)initWithData:(NSDictionary *)dic;
@property(nonatomic,strong) NSMutableArray         *dataArray;
@end
