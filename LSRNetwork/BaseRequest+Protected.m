//
//  BaseRequest+Protected.m
//  ECEJ
//
//  Created by jia on 16/5/25.
//  Copyright © 2016年 ECEJ. All rights reserved.
//

#import "BaseRequest+Protected.h"
#import "RequestCore+Protected.h"
#import "BaseRequest+Customized.h"
#import <JSONModel/JSONModel.h>
@implementation BaseRequest (Protected)

#pragma mark - Inner Methods
+ (void)handleError:(NSError *)error withFailureBlock:(TTFailureBlock)failureBlock
{
    if (failureBlock)
    {
        switch ([error code])
        {
            case NSURLErrorNotConnectedToInternet:
            {
                // 没有网络
                failureBlock(kNetworkUnavailable);
                break;
            }
            case NSURLErrorTimedOut:
            {
                // 连接超时
                failureBlock(kNetworkTimedOut);
                break;
            }
            case NSURLErrorCannotConnectToHost:
            {
                // 无法连接网络
                failureBlock(kCannotConnectToHost);
                break;
            }
            case NSURLErrorNetworkConnectionLost:
            {
                // 连接丢失
                failureBlock(kNetworkConnectionLost);
                break;
            }
            case NSURLErrorCancelled:
            {
                // 取消连接
                failureBlock(nil);
                break;
            }
            default:
            {
                failureBlock(kCannotConnectToHost);
                break;
            }
        }
    }
}

#pragma mark - Get
+ (NSURLSessionDataTask *)get:(NSString *)keyword params:(NSDictionary *)params dataModel:(Class)jsonModel success:(TTSuccessBlock)successBlock failure:(TTFailureBlock)failureBlock
{
    NSString *uri = [self urlStringToKeyword:keyword];
    [self customizeRequestParams:&params];
    
    return [super get:uri params:params success:^(NSDictionary *responseHeaderFields, id responseData) {
        
        [self handleResponseHeader:responseHeaderFields resesponseData:responseData withSuccessBlock:successBlock dataModel:jsonModel failure:failureBlock];
        
    } failure:^(NSError *error) {
        
        [self handleError:error withFailureBlock:failureBlock];
    }];
}

#pragma mark - Post
+ (NSURLSessionDataTask *)post:(NSString *)keyword params:(NSDictionary *)params dataModel:(Class)jsonModel success:(TTSuccessBlock)successBlock failure:(TTFailureBlock)failureBlock
{
    NSString *uri = [self urlStringToKeyword:keyword];
    [self customizeRequestParams:&params];
    
    return [self post:uri params:params success:^(NSDictionary *responseHeaderFields, id responseData) {
        
        [self handleResponseHeader:responseHeaderFields resesponseData:responseData withSuccessBlock:successBlock dataModel:jsonModel failure:failureBlock];
        
    } failure:^(NSError *error) {
        
        [self handleError:error withFailureBlock:failureBlock];
    }];
}

// 上传数据
+ (NSURLSessionDataTask *)post:(NSString *)keyword params:(NSDictionary *)params formDataParams:(NSDictionary *)formDataParams dataModel:(Class)jsonModel success:(TTSuccessBlock)successBlock failure:(TTFailureBlock)failureBlock
{
    NSString *uri = [self urlStringToKeyword:keyword];
    [self customizeRequestParams:&params];
    
    return [self post:uri params:params formDataParams:formDataParams success:^(NSDictionary *responseHeaderFields, id responseData) {
        
        [self handleResponseHeader:responseHeaderFields resesponseData:responseData withSuccessBlock:successBlock dataModel:jsonModel failure:failureBlock];
        
    } failure:^(NSError *error) {
        
        [self handleError:error withFailureBlock:failureBlock];
    }];
}

#pragma mark - Response
+ (void)handleSuccessData:(NSDictionary *)jsonData code:(NSUInteger)code message:(NSString *)message withSuccessBlock:(TTSuccessBlock)successBlock dataModel:(Class)jsonModel
{
    if ([jsonData isKindOfClass:NSString.class])
    {
        NSData *data = [(NSString *)jsonData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *tmp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (tmp)
        {
            jsonData = tmp;
        }
    }
    
    // 未传入数据实体，不解析
    if (!jsonModel ||
        ![jsonModel isSubclassOfClass:[JSONModel class]])
    {
        if (successBlock) successBlock(jsonData, code, message);
        
        return;
    }
    else
    {
        if ([jsonData isKindOfClass:[NSArray class]])
        {
            NSMutableArray *outputArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in jsonData)
            {
                JSONModel *itemData = [[jsonModel alloc] initWithDictionary:dic error:nil];
                
                
                [outputArray addObject:itemData];
            }
            
            if (successBlock) successBlock(outputArray, code, message);
            
            return;
        }
        else if ([jsonData isKindOfClass:[NSDictionary class]])
        {
            JSONModel *dataModal = [[jsonModel alloc] initWithDictionary:jsonData error:nil];
            
            if (successBlock) successBlock(dataModal, code, message);
            
            return;
        }
        else
        {
            if (successBlock) successBlock(jsonData, code, message);
            
            return;
        }
    }
}

@end
