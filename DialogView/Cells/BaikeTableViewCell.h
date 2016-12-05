//
//  BaikeTableViewCell.h
//  DialogDemo
//
//  Created by yanminli on 2016/10/28.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaikeiModel.h"
#import "CellTableViewCell.h"


@interface  itemLabel : UIView
-(id)init;
-(void)setData:(NSString*)leftValue rightValue:(NSString*)rightVal;
@end

@interface BaikeTableViewCell : CellTableViewCell
@property (nonatomic,strong) BaikeiModel *model;


@end
