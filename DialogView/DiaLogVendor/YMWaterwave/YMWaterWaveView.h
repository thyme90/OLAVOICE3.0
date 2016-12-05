//
//  YMWaterWaveView.h
//  DialogDemo
//
//  Created by yanminli on 2016/11/3.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YMWaterWaveAnimateType) {
    YMWaterWaveAnimateTypeShow,
    YMWaterWaveAnimateTypeHide,
};


@protocol YMWaterWaveViewDeleagte <NSObject>

-(void)waterWaveDone;//水波纹下降结束
-(int)volNum;//声音能量的返回值

@end

@interface YMWaterWaveView : UIView
@property (nonatomic, strong)   UIColor *firstWaveColor;    // 第一个波浪颜色
@property (nonatomic, strong)   UIColor *secondWaveColor;   // 第二个波浪颜色

@property (nonatomic, assign)   CGFloat percent;            // //水波纹最高的高度是水波纹视图高度的百分度
@property (nonatomic, weak)     id<YMWaterWaveViewDeleagte> delegate;

-(void) startWave;
-(void) stopWave;
-(void) reset;
- (void)removeFromParentView;

 
@end
