//
//  AnswerTableViewCell.h
//  DialogDemo
//
//  Created by yanminli on 2016/11/1.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerModel.h"

@interface AnswerTableViewCell : UITableViewCell
@property (nonatomic,strong) AnswerModel    *model;
-(void)animationAction;

@end
