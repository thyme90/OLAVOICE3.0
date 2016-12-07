//
//  AddDeviceVC.h
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/18.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeviceVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSString *chooseDeviceName;
@end
