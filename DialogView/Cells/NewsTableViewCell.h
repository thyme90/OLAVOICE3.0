//
//  NewsTableViewCell.h
//  testSDLayout
//
//  Created by yanminli on 2016/10/24.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
#import "CellTableViewCell.h"

@interface NewsTitleView : UIView
-(id)init;
-(void)setNewsData:(NewsData*)data num:(int)num;
@property (nonatomic,assign) int    viewNum;//保存点击的cell的索引;

@end



@interface NewsTableViewCell : CellTableViewCell
@property (nonatomic,strong) NewsModel  *model;
@property (nonatomic, copy)  void       (^didSelectBlock)(int num);
@end
