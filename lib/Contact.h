//
//  Contact.h
//  Demo2
//
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject
@property (nonatomic,strong) NSString *DisplayName;//联系人的全称
@property (nonatomic,assign) int    indexID;//联系人的位置
-(id)initWith:(int)indexID displayName:(NSString*)DisplayName;
 

@end
