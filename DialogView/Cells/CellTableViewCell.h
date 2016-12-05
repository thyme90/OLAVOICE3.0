//
//  CellTableViewCell.h
//  DialogDemo
//
//  Created by yanminli on 2016/11/25.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"

//当点击折叠的cell的button按钮时调用的接口
@protocol CellTableViewCellDelegate <NSObject>
-(void)UnfoldCellDidClickUnfoldBtn:(CellModel *)model;

@end

//所有TableViewCell的基类
@interface CellTableViewCell : UITableViewCell
@property (nonatomic,weak)id<CellTableViewCellDelegate> delegate;

@end
