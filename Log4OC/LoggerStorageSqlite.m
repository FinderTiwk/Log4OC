//
//  LoggerStorageSqlite.m
//  Log4OC
//
//  Created by FinderTiwk on 2018/08/08.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "LoggerStorageSqlite.h"
#import <sqlite3.h>

@implementation LoggerStorageSqlite{
    sqlite3 *_database;
}

+ (instancetype)sharedStorage {
    static dispatch_once_t onceToken;
    static LoggerStorageSqlite *__instance;
    dispatch_once(&onceToken, ^{
        __instance = [[LoggerStorageSqlite alloc] init];
    });
    return __instance;
}

- (void)prepare:(void (^)(BOOL, LoggerStorageSqlite *))completion{
    [self connectDB:^(BOOL success, LoggerStorageSqlite *storage) {
        if (success) {
            NSString *sql = @"CREATE TABLE IF NOT EXISTS `Logger`  ( `level` INTEGER, `time` DATE DEFAULT CURRENT_TIMESTAMP,`content` TEXT, `author` TEXT)";
            [storage executeSQL:sql
                     completion:completion];
        }
    }];
}

- (void)connectDB:(void(^)(BOOL success,LoggerStorageSqlite *storage))completion {
    if (_database != NULL) {
        return;
    }
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *dbPath = [docuPath stringByAppendingPathComponent:@"log.db"];
    int result = sqlite3_open(dbPath.UTF8String, &_database);
    BOOL success = (result == SQLITE_OK);
    if (!success) {
        NSLog(@"[Log4OC]: 打开数据库<%@>失败! %@",dbPath,@(result));
        _database = NULL;
    }
    !completion?:completion(success,self);
}

- (void)executeSQL:(NSString *)sql
        completion:(void(^)(BOOL success,LoggerStorageSqlite *storage))completion{
    if (_database == NULL) {
        [self prepare:^(BOOL success, LoggerStorageSqlite *storage) {
            if (success) {
                [storage executeSQL:sql
                         completion:completion];
            }
        }];
        return;
    }
    
    char *errmsg = NULL;
    int result = sqlite3_exec(_database, sql.UTF8String, NULL, NULL, &errmsg);
    BOOL success = (result == SQLITE_OK);
    if (!success) {
        NSLog(@"[Log4OC]: (%@) exec failure \r\n  reason: %s",sql,errmsg);
    }
    !completion?:completion(success,self);
}


@end
