//
//  RequestFormDataModel.h
//  Network
//
//  Created by jia on 2017/5/18.
//  Copyright © 2017年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestFormDataModel : NSObject

// headers
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *mimeType; // 如果 fileName 包含扩展名，mimeType 可以不传

// body
@property (nonatomic, strong) NSData *data;

@end
