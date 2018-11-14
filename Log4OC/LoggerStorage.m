//
//  LoggerStorage.m
//  Log4OC
//
//  Created by FinderTiwk on 2018/08/08.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "LoggerStorageSqlite.h"
#import "LoggerStoreLocalFile.h"

static NSUInteger __logStoragemode = 0;
void setLogMode(NSUInteger mode,NSUInteger clean, BOOL both){
    __logStoragemode = mode;
    
    //保存到数据库
    if (mode == 1) {
        LoggerStorageSqlite *logger = [LoggerStorageSqlite sharedStorage];
        [logger prepare:^(BOOL success, LoggerStorageSqlite *storage) {
            if (clean > 0) {
                NSDate *today = [NSDate date];
                NSTimeInterval interval = -(NSTimeInterval)(clean*24*60*60);
                NSDate *before = [NSDate dateWithTimeInterval:interval sinceDate:today];
                NSString *sql = [NSString stringWithFormat:@"DELETE FROM `Logger` where time < '%@'",before];
                [storage executeSQL:sql completion:NULL];
            }
        }];
        return;
    }
    
    if(mode == 2){
        [LoggerStoreLocalFile prepare:clean
                                 both:both];
    }
}

void setLogMaxSize(NSUInteger threshold){
    [LoggerStoreLocalFile setLogSizeThreshold:threshold];
}

void saveLog(NSString *log, NSUInteger level,NSString *author){
    if (__logStoragemode == 1) {
        //保存到数据库
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO `Logger` (level,content,author) VALUES (%@,'%@','%@')",@(level),log,author?:@"Apple"];
        [[LoggerStorageSqlite sharedStorage] executeSQL:sql completion:NULL];
    }
}



