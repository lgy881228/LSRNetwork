//
//  BaseRequest+Protected.h
//  ECEJ
//
//  Created by jia on 16/5/25.
//  Copyright © 2016年 ECEJ. All rights reserved.
//

#import "BaseRequest.h"
#import "RequestFormDataModel.h"

#import "NetworkStatusMessages.h"

//#import "NotificationNameDefines.h"

typedef void (^TTSuccessBlock)(id result, NSUInteger code, NSString *message);
typedef void (^TTFailureBlock)(NSString *errorString);

@interface BaseRequest (Protected)

#pragma mark - Get
+ (NSURLSessionDataTask *)get:(NSString *)keyword params:(NSDictionary *)params dataModel:(Class)jsonModel success:(TTSuccessBlock)successBlock failure:(TTFailureBlock)failureBlock;

#pragma mark - Post
+ (NSURLSessionDataTask *)post:(NSString *)keyword params:(NSDictionary *)params dataModel:(Class)jsonModel success:(TTSuccessBlock)successBlock failure:(TTFailureBlock)failureBlock;

// 上传数据
+ (NSURLSessionDataTask *)post:(NSString *)keyword params:(NSDictionary *)params formDataParams:(NSDictionary *)formDataParams dataModel:(Class)jsonModel success:(TTSuccessBlock)successBlock failure:(TTFailureBlock)failureBlock;

#pragma mark - Response
+ (void)handleSuccessData:(NSDictionary *)jsonData code:(NSUInteger)code message:(NSString *)message withSuccessBlock:(TTSuccessBlock)successBlock dataModel:(Class)jsonModel;

@end
