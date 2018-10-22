//
//  LoggerStorageSqlite.h
//  Log4OC
//
//  Created by FinderTiwk on 2018/08/08.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoggerStorageSqlite : NSObject

+ (instancetype)sharedStorage;

- (void)prepare:(void(^)(BOOL success,LoggerStorageSqlite *storage))completion;

- (void)executeSQL:(NSString *)sql
        completion:(void(^)(BOOL success,LoggerStorageSqlite *storage))completion;
@end

