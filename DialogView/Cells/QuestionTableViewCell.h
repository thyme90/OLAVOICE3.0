//
//  QuestionModelTableViewCell.h
//  DialogDemo
//
//  Created by yanminli on 2016/10/20.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

@interface QuestionTableViewCell : UITableViewCell
@property (nonatomic,strong)  QuestionModel     *model;
@property (nonatomic,strong)  NSString          *modelType;
-(void)labelShowAnimation;
-(void)animationAction;
-(void)showText;

@end
