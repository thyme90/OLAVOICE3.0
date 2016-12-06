//
//  CellModel.h
//  DialogDemo
//
//  Created by yanminli on 2016/10/21.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDAutoLayout.h"
#import "macro.h"

@interface CellModel : NSObject
@property (nonatomic,strong) NSString       *modelType;//cellModel的类型
@property(nonatomic,assign) BOOL            buttonIsShow;//如果cell折叠了，这个值为YES，否则为NO.初始值为NO
@property(nonatomic,strong) NSString        *ttsStr;//要显示的语音的文本

@end
