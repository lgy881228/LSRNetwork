//
//  BaseRequest+Customized.m
//  ECEJ
//
//  Created by jia on 16/5/25.
//  Copyright © 2016年 ECEJ. All rights reserved.
//

#import "BaseRequest+Customized.h"
//#import "EnvironmentManager.h"
//#import "PublicData+City.h"

@implementation BaseRequest (Customized)

+ (void)customizeHTTPSessionManager:(AFHTTPSessionManager *)manager
{
    [super customizeHTTPSessionManager:manager];
    
}

#pragma mark - Request
+ (void)customizeRequestParams:(NSDictionary **)inputParams
{
    // do nothing
}

+ (NSString *)customRequestServer
{
    return @"";
}

#pragma mark - Response
+ (void)handleResponseHeader:(NSDictionary *)responseHeaderFields resesponseData:(id)responseData withSuccessBlock:(TTSuccessBlock)successBlock dataModel:(Class)jsonModel failure:(TTFailureBlock)failureBlock
{
    // do nothing
}

@end
