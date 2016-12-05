//
//  commonHeader.h
//  testSDLayout
//
//  Created by yanminli on 2016/10/24.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#ifndef commonHeader_h
#define commonHeader_h

#define OLAAPPID   @"0B647B01-1BAF-4EE2-8165-239752A3B76F"
#define OLACUSID   @"73D424AD-A85D-8163-52BB-F7515BFC3CBF"

#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define NSSLog(FORMAT, ...)  fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])

#import "SDAutoLayout.h"
#import "UIImageView+WebCache.h"

#endif /* commonHeader_h */
