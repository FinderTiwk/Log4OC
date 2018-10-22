//
//  Log4OC.h
//  Log4OC
//
//  Created by FinderTiwk on 2018/08/08.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import <Foundation/Foundation.h>

//系统日志级别
typedef NS_ENUM(NSUInteger,LogLevel) {
    /*! 显示包括(DEBUGLog,INFOLog,WARNINGLog,ERRORLog的Log)*/
    LogLevelDEBUG   = 0,
    /*! 显示包括(INFOLog,WARNINGLog,ERRORLog的Log)*/
    LogLevelINFO    = 1,
    /*! 显示包括(WARNINGLog,ERRORLog的Log)*/
    LogLevelWARNING = 2,
    /*! 只显示ERRORLog的log*/
    LogLevelERROR   = 3,
};

//日志打印前缀
static NSString * LogPrefixs[] = {
    [LogLevelDEBUG]   = @"[🐞DEBUG]",
    [LogLevelINFO]    = @"[🌴INFO]",
    [LogLevelWARNING] = @"[⚠️WARNING]",
    [LogLevelERROR]   = @"[🔴ERROR]"
};

// 设置日志级别，default LogLevelDEBUG
EXTERN_API(void) setLogLevel(LogLevel level);
EXTERN_API(LogLevel) currentLogLevel(void);

/* 是否将日志保存在本地
 @prama mode  是否存储日志
     0: 不保存,DEFAULT
     1: 保存到Sqlite
     2: 保存到本地文件
 @param clean 是否自动清理日志
     0: 不清除
     其它: 清除当前日期之前的n天的日志
 @param both 是否同时输入到文件和控制台
     YES: 同时输出到控制台和文件 (DEBUG时用)
     NO: 只输出到文件
 */
EXTERN_API(void) setLogMode(NSUInteger mode,NSUInteger clean, BOOL both);

//当日志存储为本地文件时,设置日志大小阀值,K为单位, default 1024K/1M
EXTERN_API(void) setLogMaxSize(NSUInteger threshold);

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
EXTERN_API(void) DEBUGLog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);

EXTERN_API(void) INFOLog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);

EXTERN_API(void) WARNINGLog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);

EXTERN_API(void) ERRORLog(NSString *message,...) NS_FORMAT_FUNCTION(1,2);

