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
        format.dateFormat = @"yy/MM/dd HH:mm:ss:SSS";
    });
    return format;
}

static __inline__ __attribute__((always_inline)) void __showlog(const char *cString,LogLevel level,NSString *author){
    NSString *prefix = LogPrefixs[level];
    NSDateFormatter *format = loggerDataFormatter();
    const char *dateString = [[format stringFromDate:[NSDate date]] UTF8String];
    if (author) {
        printf("%s %s<%s>: %s \n",[prefix UTF8String],dateString,[author UTF8String],cString);
    }else{
        printf("%s %s: %s \n",[prefix UTF8String],dateString,cString);
    }
}

#pragma mark ====================================
#pragma mark - Public API

static LogLevel __curLogLevel = LogLevelDEBUG;
void setLogLevel(LogLevel level){
    __curLogLevel = level;
}

LogLevel currentLogLevel(void){
    return __curLogLevel;
}


void saveLog(NSString *log, NSUInteger level,NSString *author);

#ifndef doLog

#define doLog(__level,author,...)           \
    if ((__curLogLevel > __level)) {        \
        return;                             \
    }                                       \
    va_list argList;                        \
    va_start(argList, message);             \
    NSString *logString = [[NSString alloc] initWithFormat:message arguments:argList];                 \
    const char *cString = [logString UTF8String];   \
    __showlog(cString, __level,author);     \
    va_end(argList);                        \
    saveLog(logString,__level,author);      \

#endif

void DEBUGLog(NSString *message,...){
    doLog(LogLevelDEBUG,nil);
}

__attribute__((overloadable)) void DEBUGLog(NSString *author,NSString *message,...){
    doLog(LogLevelDEBUG,author);
}


void INFOLog(NSString *message,...){
    doLog(LogLevelINFO,nil);
}

__attribute__((overloadable)) void INFOLog(NSString *author,NSString *message,...){
    doLog(LogLevelINFO,author);
}

void WARNINGLog(NSString *message,...){
    doLog(LogLevelWARNING,nil);
}

__attribute__((overloadable)) void WARNINGLog(NSString *author,NSString *message,...){
    doLog(LogLevelWARNING,author);
}

void ERRORLog(NSString *message,...){
    doLog(LogLevelERROR,nil);
}

__attribute__((overloadable)) void ERRORLog(NSString *author,NSString *message,...){
    doLog(LogLevelERROR,author);
}
