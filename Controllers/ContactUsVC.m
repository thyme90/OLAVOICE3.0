//
//  ContactUsVC.m
//  NoScreenAudio
//
//  Created by S3Graphic on 16/11/2.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "ContactUsVC.h"

@interface ContactUsVC ()

@end

@implementation ContactUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)backButtonAction:(UIButton *)sender {
    
}

-(void)webAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.olavoice.com"]];
}

-(void)phoneAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://021-12345678"]];
}

-(void)mailAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://olavoice@s3graphics.com"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
