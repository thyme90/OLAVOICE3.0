//
//  UserManager.m
//  NoScreenAudio
//
//  Created by yanminli on 15/12/24.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import "UserManager.h"

#import <objc/message.h>
 

@implementation UserManager
static UserManager* UserManagerInstance = nil;

+ (UserManager *)getUserManagerInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UserManagerInstance = [[UserManager alloc]init];
    });
    return UserManagerInstance;
}

-(id)init{
    if(self = [super init]){
        self.boxName = [[NSMutableArray alloc] init];
    }
    
    return (self);
}



-(void)initUserManager{
    self.nickName           = @"";
    self.olaPhoneNum        = @"";
    self.passwd             = @"";
    self.passwdMD5          = @"";
    self.phoneVcode         = @"";
    self.verified           = -1;
    self.imgurl             = @"";
    self.isLog              = NO;
    self.userName           = @"未登录";
    self.accountType        = ISERROR;
    self.headImage          = @"pic_avatar";
    self.isBoxConnect       = NO;
    self.isPhoneToBox       = NO;
    self.currentConnectIP   = @"";
    self.nickNameSetting    = @"";
    self.currentBoxName     = @"";
    self.nickNameSetting    = @"";
    self.oldPhoneNum        = @"";
    self.oldVcode           = @"";
}


#pragma mark --利用反射机制获得所有属性的值
- (NSArray*)propertyKeys{
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        [keys addObject:propertyName];
       // NSLog(@"propertyName is %@",propertyName);
        
    }
    
    free(properties);
    
    return keys;
    
}

//读取保存的属性的值
- (void)reflectDataFromOtherObject{
     NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    for(NSString *key in [self propertyKeys]){
        id propertyValue = [userDefaultes valueForKey:key];
        if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
            
            [self setValue:propertyValue forKey:key];
            //NSLog(@"key is %@,propertyName is %@",key,propertyValue);
            
        }
    }
}

#pragma mark--保存属性的值
-(void)saveDataFromObject{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    for(NSString *key in [self propertyKeys]){
        id propertyValue = [self valueForKey:key];
        if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
            [userDefaultes setObject:propertyValue forKey:key];
        }
            
    }
}

@end


