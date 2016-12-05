//
//  EditTableViewCell.h
//  testSDLayout
//
//  Created by yanminli on 2016/10/24.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditModel.h"

@protocol EditTableViewCellDelegate<NSObject>

-(void)sendMessageToTableView:(NSString*)message;
-(void)setAnimation;

@end

@interface EditTableViewCell : UITableViewCell
@property (nonatomic,strong)    EditModel                     *model;
@property (nonatomic,copy)      NSString                      *modelType;
@property (nonatomic,weak)      id<EditTableViewCellDelegate> delegate;
-(void)animationEditCell;

@end
