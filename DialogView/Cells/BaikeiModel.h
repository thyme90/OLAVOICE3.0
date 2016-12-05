//
//  BaikeiModel.h
//  DialogDemo
//
//  Created by yanminli on 2016/10/28.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellModel.h"

@interface BaikeiModel : CellModel
-(id)initWithData:(NSDictionary *)dic;
@property(nonatomic,strong) NSString        *photo_url;
@property(nonatomic,strong) NSString        *type;
@property(nonatomic,strong) NSString        *descr;//人物描述
@property(nonatomic,strong) NSArray         *field_name;
@property(nonatomic,strong) NSArray         *field_value;


 

@end
