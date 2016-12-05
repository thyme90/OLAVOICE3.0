//
//  VoiceView.h
//  DialogDemo
//
//  Created by yanminli on 2016/10/21.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DialogView;
@interface VoiceView : UIView
-(id)initWithFrame:(CGRect)frame;
@property (nonatomic,strong) DialogView             *DlgView;//tableView所在的视图
@end
