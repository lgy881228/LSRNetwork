//
//  BaseRequest.m
//  ECEJ
//
//  Created by jia on 16/5/24.
//  Copyright © 2016年 ECEJ. All rights reserved.
//

#import "BaseRequest.h"
#import "BaseRequest+Customized.h"
#import <objc/runtime.h>
#define RequestURL(server, interface)  [NSString stringWithFormat:@"%@%@", server, interface]

const char _interfacesDictionary;

@implementation BaseRequest


#pragma mark - Inner Methods
+ (NSString *)urlStringToKeyword:(NSString *)keyword
{
//    NSString *interface = keyword;
    return RequestURL([self customRequestServer], keyword);
}

@end
