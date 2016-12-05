//
//  NewsContentTableViewCell.h
//  testSDLayout
//
//  Created by yanminli on 2016/10/26.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsContentModel.h"
#import "CellTableViewCell.h"

@interface NewsContentTableViewCell : CellTableViewCell
@property (nonatomic,strong) NewsContentModel   *model;

@end
