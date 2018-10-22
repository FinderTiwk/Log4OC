//
//  LoggerStoreLocalFile.h
//  Log4OC
//
//  Created by FinderTiwk on 2018/08/08.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoggerStoreLocalFile : NSObject

//将print重定向到本地文件
+ (void)prepare:(NSUInteger)day
           both:(BOOL)both;

// 设置日志大小阀值,K为单位, default 1024K/1M
+ (void)setLogSizeThreshold:(NSUInteger)threshold;

@end

