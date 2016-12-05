//
//  YSCVoiceWaveView.h
//  Waver
//
//  Created by yushichao on 16/8/9.
//  Copyright © 2016年 YSC Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YSCShowLoadingCircleCallback)(void);


@protocol YSCVoiceWaveViewDeleagte <NSObject>

//-(void)waterWaveDone;//水波纹下降结束
-(float)volNum;//声音能量的返回值

@end

@interface YSCVoiceWaveView : UIView

/**
 *  添加并初始化波纹视图
 *
 *  @param parentView                 父视图
 *  @param voiceWaveDisappearCallback 波纹消失时回调
 */
- (void)showInParentView:(UIView *)parentView;

/**
 *  开始声波动画
 */
- (void)startVoiceWave;

/**
 *  改变音量来改变声波振动幅度
 *
 *  @param volume 音量大小 大小为0~1
 */
- (void)changeVolume:(CGFloat)volume;

/**
 *  停止声波动画
 */
- (void)stopVoiceWaveWithShowLoadingViewCallback:(YSCShowLoadingCircleCallback)showLoadingCircleCallback;

/**
 *  移掉声波
 */
- (void)removeFromParent;

@property (nonatomic, weak)     id<YSCVoiceWaveViewDeleagte> delegate;

@end
