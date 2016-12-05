//
//  AnswerModel.h
//  DialogDemo
//
//  Created by yanminli on 2016/11/1.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerModel : NSObject
-(id)initWithData:(NSDictionary *)dic;
-(id)init;
@property (nonatomic,strong) NSString   *content;
@property (nonatomic,strong) NSString   *result;
@end
