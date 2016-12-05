//
//  SelectionBaikeTableViewCell.h
//  DialogDemo
//
//  Created by yanminli on 2016/11/23.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionBaikeModel.h"
#import "CellTableViewCell.h"

@interface itemView : UIView
-(id)init;
-(void)setDatas:(SelectionBaikeData*) datas num:(NSString*)num;
@property (nonatomic,assign) int    viewNum;//保存点击的cell的索引;
@end

@interface SelectionBaikeTableViewCell : CellTableViewCell
@property (nonatomic,strong) SelectionBaikeModel *model;
@property (nonatomic, copy)  void       (^didSelectBlock)(int num);

@end
