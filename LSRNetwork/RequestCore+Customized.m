//
//  RequestCore+Customized.m
//  ECEJ
//
//  Created by jia on 16/5/25.
//  Copyright © 2016年 ECEJ. All rights reserved.
//

#import "RequestCore+Customized.h"
#import "AFHTTPSessionManager.h"
@implementation RequestCore (Customized)

+ (void)customizeHTTPSessionManager:(AFHTTPSessionManager *)manager;
{
    // do nothing
    // 告诉AFN，支持接受 text/xml 的数据
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
}

@end
