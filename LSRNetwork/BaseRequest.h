//
//  BaseRequest.h
//  ECEJ
//
//  Created by jia on 16/5/24.
//  Copyright © 2016年 ECEJ. All rights reserved.
//

#import "RequestCore.h"


@interface BaseRequest : RequestCore

#pragma mark - Inner Methods
+ (NSString *)urlStringToKeyword:(NSString *)keyword;

@end
