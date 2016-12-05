//
//  HttpConnect.m
//  NoScreenAudio
//
//  Created by yanminli on 15/12/11.
//  Copyright © 2015年 s3graphics. All rights reserved.
//

#import "HttpConnect.h"
#import <UIKit/UIKit.h>


@implementation HttpConnect

static HttpConnect* httpConnectInstance = nil;


#pragma mark  -- 定义单例函数
+ (HttpConnect *)getHttpConnectInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpConnectInstance = [[HttpConnect alloc]init];
    });
    return httpConnectInstance;
}


#pragma mark --手机获取验证码
-(void)getVerifyCode:(NSString*)phoneNumn newPhoneNum:(NSString*)newphonenum vcode:(NSString*)vcode opt:(NSString*)opt{
     NSURL *url = [NSURL URLWithString:VERIFYCODEURL];
    NSString *post=[[NSString alloc] initWithFormat:@"mobile=%@&dst_mobile=%@&vcode=%@&clientid=%@&isreg=%@&opt=%@",phoneNumn,newphonenum,vcode,CLINETID,@"1",opt];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10.0];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror:%@%ld", error.localizedDescription,(long)error.code);
                               }else{
                                   NSLog(@"手机发送验证码成功!");
                               }
                           }];

}

#pragma mark--验证用户是否存在
-(BOOL)getUser:(NSString*)userID{
    
    NSString *urlStr=[[NSString alloc] initWithFormat:@"%@user=%@&clientid=%@",CHECKUSERURL,userID,CLINETID];

    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
       
    if (!error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        int status = -1;
        //存在是非0，不存在是0
        if (dictionary){
            status =[[dictionary objectForKey:@"status"] intValue];
            //NSLog(@"用户是否存在状态码是%d",status);
        }
        
        if (status) {
            NSLog(@"用户存在");
            return YES;
        }else{
             NSLog(@"用户不存在");
            return NO;
        }

    }
    
    
    return NO;
    
}

//手机注册
-(void)phoneRegister:(NSString *)phoneNum verifyCode:(NSString*)verifycode{
    
    
    NSURL *url = [NSURL URLWithString:REGISTERURL];
    NSString *post=[[NSString alloc] initWithFormat:@"mobile=%@&vcode=%@&deviceid=%@&clientid=%@",phoneNum,verifycode,DEVICEID,CLINETID];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10.0];
    
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@""
                                                   message:@"正在注册"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:nil,nil];
    [alert show];

    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               int status;
                               
                               if (error) {
                                   NSLog(@"Httperror:%@%ld", error.localizedDescription,(long)error.code);
                                   [self.delegate connectFailed];
                                   [alert dismissWithClickedButtonIndex:0  animated:NO];
                               }else{
                                   
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   
                                   //NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                   NSLog(@"HttpResponseCode:%ld", (long)responseCode);
                                   //NSLog(@"HttpResponseBody %@",responseStr);
                                   NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                  options:NSJSONReadingAllowFragments
                                                                                    error:&error];

                                  if (dictionary){
                                      
                                      status = [[dictionary objectForKey:@"status"] intValue];
                                      NSLog(@"手机注册状态码%d",status);
                                   }
                                   
                                   if (!status) {
                                       [self.delegate connectSuccess];
                                   }else{
                                       [self.delegate connectFailed];
                                   }
                                   
                                   [alert dismissWithClickedButtonIndex:0  animated:NO];

                                   
                               }
                           }];

    NSLog(@"phoneRegister");
    
}

//邮箱注册
-(void)mailBoxRegister:(NSString*)mailbox passwd:(NSString*)passwd{
    NSURL *url = [NSURL URLWithString:REGISTERURL];
    NSString *post=[[NSString alloc] initWithFormat:@"user=%@&password=%@&deviceid=%@&clientid=%@",mailbox,passwd,DEVICEID,CLINETID];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10.0];
    
//    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@""
//                                                   message:@"正在注册"
//                                                  delegate:self
//                                         cancelButtonTitle:nil
//                                         otherButtonTitles:nil,nil];
//    [alert show];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               int status;
                               
                               if (error) {
                                   NSLog(@"Httperror:%@%ld", error.localizedDescription,(long)error.code);
                                   [self.delegate connectFailed];
                                   //[alert dismissWithClickedButtonIndex:0  animated:NO];
                               }else{
                                   
                                   //NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   
                                   //NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                  // NSLog(@"HttpResponseCode:%d", responseCode);
                                   //NSLog(@"HttpResponseBody %@",responseStr);
                                   id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                   options:NSJSONReadingAllowFragments
                                                                                     error:&error];
                                   
                                   if ([jsonObject isKindOfClass:[NSDictionary class]]){
                                       NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                                  options:NSJSONReadingAllowFragments
                                                                                                    error:&error];
                                       status = [[dictionary objectForKey:@"status"] intValue];
                                       NSLog(@"邮箱注册状态码%d",status);
                                   }
                                   
                                   if (!status) {
                                       [self.delegate connectSuccess];
                                   }else{
                                       [self.delegate connectFailed];
                                   }
                                   
                                   //[alert dismissWithClickedButtonIndex:0  animated:NO];
                                   
                                   
                               }
                           }];
    
    NSLog(@"phoneRegister");

}

#pragma mark --发送邮箱地址
-(void)sendMailBox:(NSString*)urlAddress opt:(NSString*)opt{
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSData *postData = [opt dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10.0];
    
//    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@""
//                                                   message:@"正在注册"
//                                                  delegate:self
//                                         cancelButtonTitle:nil
//                                         otherButtonTitles:nil,nil];
//    [alert show];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               int status;
                               
                               if (error) {
                                   NSLog(@"Httperror:%@%ld", error.localizedDescription,(long)error.code);
                                   //[self.delegate connectFailed];
                                   //[alert dismissWithClickedButtonIndex:0  animated:NO];
                               }else{
                                   
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   
                                   //NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                   NSLog(@"HttpResponseCode:%ld", (long)responseCode);
                                   //NSLog(@"HttpResponseBody %@",responseStr);
                                   NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                   options:NSJSONReadingAllowFragments
                                                                                     error:&error];
                                   
                                   if (dictionary){
                                       status = [[dictionary objectForKey:@"status"] intValue];
                                       NSLog(@"状态码%d",status);
                                   }
                                   
                                   if (!status) {
                                       
                                   }else{
                                       
                                   }
                                   
                                   //[alert dismissWithClickedButtonIndex:0  animated:NO];
                                   
                                   
                               }
                           }];
    
    NSLog(@"resendMailBox");

}

#pragma mark --校验手机的有效性
-(BOOL)validatePhoneNum:(NSString*)phoneNum{
    NSString *urlStr=[[NSString alloc] initWithFormat:@"%@mobile=%@",VALIDATEPHONENUM,phoneNum];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    
    if (!error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        int status = -1;
        
        if (dictionary){
            status =[[dictionary objectForKey:@"status"] intValue];
            
        }
        
        if (!status) {
            NSLog(@"手机号有效");
            return YES;
        }else{
            NSLog(@"手机号无效");
            return NO;
        }
        
    }
    

    return NO;
}

#pragma mark --验证手机号和验证码是否匹配
-(SeverStatus)validateVcode:(NSString*)phoneNum vcode:(NSString*)code{
    NSString *urlStr=[[NSString alloc] initWithFormat:@"%@mobile=%@&vcode=%@&clientid=%@",VALIDVCODE,phoneNum,code,CLINETID];
    
    //NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
      NSURLRequest *urlRequest =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIMEOUTINTERVAL];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    
    if (!error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        int status = -1;
         
        if (dictionary){
            status =[[dictionary objectForKey:@"status"] intValue];
            NSString* msg = [dictionary objectForKey:@"msg"];
            NSLog(@"验证手机号和验证码是否匹配的msg %@",msg);
        }
        
        if (!status) {
            NSLog(@"手机校验成功");
            return SEVERSTATUSSUCCESS;
        }else{
            NSLog(@"手机校验失败");
            return SEVERSTATUSSUCCESS;
        }
        
    }
    
    
    
    return NETWORKTIMEOUT;
}

#pragma mark --修改手机号
-(SeverStatus)changePhoneNum:(NSString*)srcPhoneNum dstPhoneNum:(NSString*)dstPhoneNum vcode:(NSString*)vcode{
    NSString *urlStr=[[NSString alloc] initWithFormat:@"%@mobile=%@&dst_mobile=%@&vcode=%@&clientid=%@",CHANGEPHONENUM,srcPhoneNum,dstPhoneNum, vcode,CLINETID];
    
    //NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
      NSURLRequest *urlRequest =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIMEOUTINTERVAL];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    
    if (!error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        int status = -1;
        
        if (dictionary){
            status =[[dictionary objectForKey:@"status"] intValue];
            NSString* msg = [dictionary objectForKey:@"msg"];
            NSLog(@"修改手机号msg %@",msg);
        }
        
        if (!status) {
            NSLog(@"修改手机号成功");
            return SEVERSTATUSSUCCESS;
        }else{
            NSLog(@"修改手机号失败");
            return SEVERSTATUSFAIL;
        }
        
    }
    
    
    
    return NETWORKTIMEOUT;

}


@end


