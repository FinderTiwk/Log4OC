//
//  Log4OC.m
//  Log4OC
//
//  Created by FinderTiwk on 2018/08/08.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "Log4OC.h"
static __inline__ __attribute__((always_inline)) NSDateFormatter * loggerDataFormatter(void){
    static NSDateFormatter *format;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return format;
}

static __inline__ __attribute__((always_inline)) void __showlog(const char *cString,LogLevel level){
    NSString *prefix = LogPrefixs[level];
    NSDateFormatter *format = loggerDataFormatter();
    const char *dateString = [[format stringFromDate:[NSDate date]] UTF8String];
    printf("%s %s : %s \n",[prefix UTF8String],dateString,cString);
}

void saveLog(NSString *log, NSUInteger level);
#ifndef doLog

#define doLog(__level)                      \
    if ((__curLogLevel > __level)) {        \
        return;                             \
    }                                       \
    va_list argList;                        \
    va_start(argList, message);             \
    NSString *logString = [[NSString alloc] initWithFormat:message arguments:argList];                 \
    const char *cString = [logString UTF8String];   \
    __showlog(cString, __level);            \
    saveLog(logString,__level);             \
    va_end(argList);                        \

#endif


#pragma mark ====================================
#pragma mark - Public API

static LogLevel __curLogLevel = LogLevelDEBUG;
void setLogLevel(LogLevel level){
    __curLogLevel = level;
}

LogLevel currentLogLevel(void){
    return __curLogLevel;
}


void DEBUGLog(NSString *message,...){
    doLog(LogLevelDEBUG);
}

void INFOLog(NSString *message,...){
    doLog(LogLevelINFO);
}

void WARNINGLog(NSString *message,...){
    doLog(LogLevelWARNING);
}

void ERRORLog(NSString *message,...){
    doLog(LogLevelERROR);
}
