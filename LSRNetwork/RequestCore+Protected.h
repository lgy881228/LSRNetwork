//
//  RequestCore+Protected.h
//  ECEJ
//
//  Created by jia on 16/5/25.
//  Copyright © 2016年 ECEJ. All rights reserved.
//

#import "RequestCore.h"

typedef void (^SuccessResponseHandler)(NSDictionary *responseHeaderFields, id responseData);
typedef void (^FailureResponseHandler)(NSError *error);

@interface RequestCore (Protected)

#pragma mark - Get
+ (NSURLSessionDataTask *)get:(NSString *)uri params:(NSDictionary *)params success:(SuccessResponseHandler)successHandler failure:(FailureResponseHandler)failureHandler;

#pragma mark - Post
+ (NSURLSessionDataTask *)post:(NSString *)uri params:(NSDictionary *)params success:(SuccessResponseHandler)successHandler failure:(FailureResponseHandler)failureHandler;

/*
 上传数据
 对于 formDataParams 参数，有以下3种形式：
 
 1.
 NSURL *filePath = [NSURL fileURLWithPath:file];
 @{@"image" : filePath}
 
 2.
 NSString *fileName = @"image.jpg";
 NSData *fileData = UIImageJPEGRepresentation(self.bigImage, 0.5);
 @{fileName : fileData}
 
 3.
 RequestFormDataModel *formDataModel = [[RequestFormDataModel alloc] init];
 formDataModel.name = xxx;
 formDataModel.fileName = xxx;
 formDataModel.mimeType = xxx;
 formDataModel.data = xxx;
 @{@"unconditionalKey" : formDataModel}
 
 */
+ (NSURLSessionDataTask *)post:(NSString *)uri params:(NSDictionary *)params formDataParams:(NSDictionary *)formDataParams success:(SuccessResponseHandler)successHandler failure:(FailureResponseHandler)failureHandler;

@end

