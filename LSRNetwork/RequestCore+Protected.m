//
//  RequestCore+Protected.m
//  ECEJ
//
//  Created by jia on 16/5/25.
//  Copyright © 2016年 ECEJ. All rights reserved.
//

#import "RequestCore+Protected.h"
#import "RequestCore+Customized.h"
#import "RequestFormDataModel.h"
#import "AFNetworking.h"
#import <CoreServices/UTType.h>
#define kTimeoutTimeinterval 20.0

static inline NSString * FileContentTypeForPathExtension(NSString *extension) {
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    if (!contentType) {
        return @"application/octet-stream";
    } else {
        return contentType;
    }
}

@implementation RequestCore (Protected)

#pragma mark - Config
+ (AFHTTPSessionManager *)sharedHTTPSessionManager
{
    // 创建管理类
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = kTimeoutTimeinterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 设置二进制数据，数据格式默认json
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self customizeHTTPSessionManager:manager];
    
    return manager;
}

#pragma mark - Get
+ (NSURLSessionDataTask *)get:(NSString *)uri params:(NSDictionary *)params success:(SuccessResponseHandler)successHandler failure:(FailureResponseHandler)failureHandler
{
    if (!uri)
    {
        NSLog(@"Error, requestWithCmd cmd is nil");
        return nil;
    }
    
    // 创建管理类
    AFHTTPSessionManager *manager = [self sharedHTTPSessionManager];
    
    // 利用方法请求数据
    NSLog(@"Request URL:\n%@\ndata\n%@", uri, [params description]);

   return  [manager GET:uri parameters:params headers:manager.requestSerializer.HTTPRequestHeaders progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successHandler)
        {
            [self handleRequest:task resesponseData:responseObject forSuccessHandler:successHandler];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    if (error && failureHandler)
    {
        failureHandler(error);
        return;
    }
    }];
//    return [manager GET:uri parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (successHandler)
//        {
//            [self handleRequest:task resesponseData:responseObject forSuccessHandler:successHandler];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (error && failureHandler)
//        {
//            failureHandler(error);
//            return;
//        }
//    }];
}

#pragma mark - Post
+ (NSURLSessionDataTask *)post:(NSString *)uri params:(NSDictionary *)params success:(SuccessResponseHandler)successHandler failure:(FailureResponseHandler)failureHandler
{
    if (!uri)
    {
        NSLog(@"Error, requestWithCmd cmd is nil");
        return nil;
    }
    
    // 创建管理类
    AFHTTPSessionManager *manager = [self sharedHTTPSessionManager];
    
    // 利用方法请求数据 manager.requestSerializer.HTTPRequestHeaders
    NSLog(@"Request URL:\n%@\ndata\n%@", uri, [params description]);
    return  [manager POST:uri parameters:params headers:manager.requestSerializer.HTTPRequestHeaders progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successHandler)
               {
                   [self handleRequest:task resesponseData:responseObject forSuccessHandler:successHandler];
               }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error && failureHandler)
        {
            failureHandler(error);
            return;
        }
    }];
//    return [manager POST:uri parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (successHandler)
//        {
//            [self handleRequest:task resesponseData:responseObject forSuccessHandler:successHandler];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (error && failureHandler)
//        {
//            failureHandler(error);
//            return;
//        }
//    }];
}

// 上传数据
+ (NSURLSessionDataTask *)post:(NSString *)uri params:(NSDictionary *)params formDataParams:(NSDictionary *)formDataParams success:(SuccessResponseHandler)successHandler failure:(FailureResponseHandler)failureHandler
{
    if (!uri)
    {
        NSLog(@"Error, requestWithCmd cmd is nil");
        return nil;
    }
    
    // 创建管理类
    AFHTTPSessionManager *manager = [self sharedHTTPSessionManager];
   
    
   return [manager POST:uri parameters:params headers:manager.requestSerializer.HTTPRequestHeaders constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (formDataParams && formDataParams.count)
        {
            for (NSString *key in formDataParams)
            {
                id value = formDataParams[key];
                if ([value isKindOfClass:NSData.class])
                {
                    NSData *data = value;
                    NSString *fileName = key;
                    [formData appendPartWithFileData:data name:fileName.stringByDeletingPathExtension fileName:fileName mimeType:FileContentTypeForPathExtension(fileName.pathExtension)];
                    
                    /*
                     在 AFStreamingMultipartFormData 类中
                     
                     NSMutableDictionary *mutableHeaders = [NSMutableDictionary dictionary];
                     [mutableHeaders setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"; filename=\"%@\"", name, fileName] forKey:@"Content-Disposition"];
                     [mutableHeaders setValue:mimeType forKey:@"Content-Type"];
                     
                     [self appendPartWithHeaders:mutableHeaders body:data];
                     */
                }
                else if ([value isKindOfClass:RequestFormDataModel.class])
                {
                    RequestFormDataModel *formDataModel = value;
                    
                    // fileName 和 data 必须要有
                    if (formDataModel.fileName && formDataModel.data)
                    {
                        NSString *name     = formDataModel.name ?: formDataModel.fileName.stringByDeletingPathExtension;
                        NSString *fileName = formDataModel.fileName;
                        NSString *mimeType = formDataModel.mimeType ?: FileContentTypeForPathExtension(formDataModel.fileName.pathExtension);
                        NSData   *data     = formDataModel.data;
                        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
                    }
                    else
                    {
                        continue;
                    }
                }
                else
                {
                    NSURL *fileURL = value;
                    NSString *name = key;
                    [formData appendPartWithFileURL:fileURL name:name error:nil];
                    
                    /*
                     在 AFStreamingMultipartFormData 类中
                     
                     NSString *fileName = [fileURL lastPathComponent];
                     NSString *mimeType = AFContentTypeForPathExtension([fileURL pathExtension]);
                     
                     return [self appendPartWithFileURL:fileURL name:name fileName:fileName mimeType:mimeType error:error];
                     */
                }
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self handleRequest:task resesponseData:responseObject forSuccessHandler:successHandler];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error && failureHandler)
        {
            failureHandler(error);
            return;
        }
    }];
    
    
    
//    return [manager POST:uri parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//
//        if (formDataParams && formDataParams.count)
//        {
//            for (NSString *key in formDataParams)
//            {
//                id value = formDataParams[key];
//                if ([value isKindOfClass:NSData.class])
//                {
//                    NSData *data = value;
//                    NSString *fileName = key;
//                    [formData appendPartWithFileData:data name:fileName.stringByDeletingPathExtension fileName:fileName mimeType:FileContentTypeForPathExtension(fileName.pathExtension)];
//
//                    /*
//                     在 AFStreamingMultipartFormData 类中
//
//                     NSMutableDictionary *mutableHeaders = [NSMutableDictionary dictionary];
//                     [mutableHeaders setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"; filename=\"%@\"", name, fileName] forKey:@"Content-Disposition"];
//                     [mutableHeaders setValue:mimeType forKey:@"Content-Type"];
//
//                     [self appendPartWithHeaders:mutableHeaders body:data];
//                     */
//                }
//                else if ([value isKindOfClass:RequestFormDataModel.class])
//                {
//                    RequestFormDataModel *formDataModel = value;
//
//                    // fileName 和 data 必须要有
//                    if (formDataModel.fileName && formDataModel.data)
//                    {
//                        NSString *name     = formDataModel.name ?: formDataModel.fileName.stringByDeletingPathExtension;
//                        NSString *fileName = formDataModel.fileName;
//                        NSString *mimeType = formDataModel.mimeType ?: FileContentTypeForPathExtension(formDataModel.fileName.pathExtension);
//                        NSData   *data     = formDataModel.data;
//                        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
//                    }
//                    else
//                    {
//                        continue;
//                    }
//                }
//                else
//                {
//                    NSURL *fileURL = value;
//                    NSString *name = key;
//                    [formData appendPartWithFileURL:fileURL name:name error:nil];
//
//                    /*
//                     在 AFStreamingMultipartFormData 类中
//
//                     NSString *fileName = [fileURL lastPathComponent];
//                     NSString *mimeType = AFContentTypeForPathExtension([fileURL pathExtension]);
//
//                     return [self appendPartWithFileURL:fileURL name:name fileName:fileName mimeType:mimeType error:error];
//                     */
//                }
//            }
//        }
//
//    } progress:^(NSProgress *uploadProgress) {
//
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//
//        [self handleRequest:task resesponseData:responseObject forSuccessHandler:successHandler];
//
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if (error && failureHandler)
//        {
//            failureHandler(error);
//            return;
//        }
//    }];
}

#pragma mark - Response Handler
+ (void)handleRequest:(NSURLSessionDataTask *)task resesponseData:(id)responseData forSuccessHandler:(SuccessResponseHandler)successHandler
{
    NSLog(@"response for %@", task.originalRequest.URL.absoluteURL);
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSDictionary *headerFields = [response allHeaderFields];
    
    if (successHandler)
    {
        successHandler(headerFields, responseData);
    }
}

@end


