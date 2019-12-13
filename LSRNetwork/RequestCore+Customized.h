//
//  RequestCore+Customized.h
//  ECEJ
//
//  Created by jia on 16/5/25.
//  Copyright © 2016年 ECEJ. All rights reserved.
//

#import "RequestCore.h"
//#import "AFHTTPSessionManager.h"
@class AFHTTPSessionManager;
@protocol RequestCoreCustomizedDelegate <NSObject>

@optional
+ (void)customizeHTTPSessionManager:(AFHTTPSessionManager *)manager;

@end

@interface RequestCore (Customized) <RequestCoreCustomizedDelegate>

@end
