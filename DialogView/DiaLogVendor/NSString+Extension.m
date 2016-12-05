//
//  NSString+Extension.m
//  testDemo
//
//  Created by yanminli on 2016/11/17.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
-(BOOL)isEmpty{
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [self stringByTrimmingCharactersInSet:charSet];
    return [trimmed isEqualToString:@""];

}
@end
