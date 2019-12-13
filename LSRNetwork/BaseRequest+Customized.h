//
//  BaseRequest+Customized.h
//  ECEJ
//
//  Created by jia on 16/5/25.
//  Copyright © 2016年 ECEJ. All rights reserved.
//

#import "BaseRequest.h"
#import "RequestCore+Customized.h"
#import "BaseRequest+Protected.h"

@protocol BaseRequestCustomizedDelegate <NSObject>

#pragma mark - Request
@optional
+ (void)customizeRequestParams:(NSDictionary **)inputParams;

+ (NSString *)customRequestServer;

#pragma mark - Response
@optional
+ (void)handleResponseHeader:(NSDictionary *)responseHeaderFields resesponseData:(id)responseData withSuccessBlock:(TTSuccessBlock)successBlock dataModel:(Class)jsonModel failure:(TTFailureBlock)failureBlock;

@end

@interface BaseRequest (Customized) <BaseRequestCustomizedDelegate>

@end
