//
//  LoggerStoreLocalFile.m
//  Log4OC
//
//  Created by FinderTiwk on 2018/08/08.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "LoggerStoreLocalFile.h"
#include <sys/stat.h>
#include <dirent.h>
#include <unistd.h>

@implementation LoggerStoreLocalFile

static NSString *_currentLogPath;
static NSUInteger _maxLogSize = 8;
static BOOL _both;

+ (void)prepare:(NSUInteger)day
           both:(BOOL)both{
    _both = both;
    // 组成文件名： 2018_10_01-01.log
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy_MM_dd";
    
    NSDate *today = [NSDate date];
    if (day > 0) {
        NSDate *before = [NSDate dateWithTimeInterval:-24*60*60*day sinceDate:today];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *deletingLogPrefix = [formatter stringFromDate:before];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath:documentsPath];
        NSString *fileName;
        while (fileName = [dirEnum nextObject]) {
            if ([fileName hasPrefix:deletingLogPrefix]) {
                NSString *path = [documentsPath stringByAppendingPathComponent:fileName];
                NSError *error;
                [manager removeItemAtPath:path error:&error];
                if (error) {
                    NSLog(@"删除过期日志失败 - %@",error);
                }
            }
        }
    }
    
    NSString *logFileName = [formatter stringFromDate:today];
    NSUInteger index = 1;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *cachedLogFileName = [defaults valueForKey:@"logFileName"];
    NSUInteger cachedIndex = [defaults integerForKey:@"logIndex"];
    if (cachedLogFileName) {
        if ([logFileName isEqualToString:cachedLogFileName]) {
            index = cachedIndex;
        }
    }
    redirectTo(logFileName, index);
}

+ (void)setLogSizeThreshold:(NSUInteger)threshold{
    _maxLogSize = threshold > 0 ? threshold : _maxLogSize;
}

static void divLog(){
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *cachedLogFileName = [defaults valueForKey:@"logFileName"];
    NSUInteger cachedIndex = [defaults integerForKey:@"logIndex"];
    redirectTo(cachedLogFileName,cachedIndex+1);
}

static void redirectTo(NSString *fileName,NSUInteger index){
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:fileName forKey:@"logFileName"];
    [defaults setInteger:index forKey:@"logIndex"];
    [defaults synchronize];
    
    fileName = [NSString stringWithFormat:@"%@-%@.log",fileName,@(index)];
    
    _currentLogPath = [documentsPath stringByAppendingPathComponent:fileName];
}

static double __fileSize(NSString *filePath){
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return (double)st.st_size/1024;
    }
    return 0.0;
}

//use this to resolve compile warning
//https://stackoverflow.com/questions/32719140/calling-convention-with-a-shared-library-for-android
#define __cdecl
int __cdecl printf(const char *format, ...)  {
    int charCount = 0;
    va_list args;
    if (!_currentLogPath) {
        va_start(args, format);
        charCount = vprintf(format, args);
        va_end(args);
        return charCount;
    }
    
    //_IOFBF(满缓冲）：当缓冲区为空时，从流读入数据。或者当缓冲区满时，向流写入数据。
    //_IOLBF(行缓冲）：每次从流中读入一行数据或向流中写入一行数据。
    //_IONBF(无缓冲）：直接从流中读入数据或直接向流中写入数据，而没有缓冲区。
    va_start(args, format);
    if (!_both) {
        FILE *file = freopen([_currentLogPath UTF8String], "a", stdout);
        setvbuf(file, NULL, _IONBF, 0);
        charCount = vfprintf(file, format, args);
        fclose(file);
    }else{
        va_list fileArgs;
        va_copy(fileArgs, args);
        int old = dup(1);
        FILE *file = freopen([_currentLogPath UTF8String], "a", stdout);
        setvbuf(file, NULL, _IONBF, 0);
        charCount = vfprintf(file, format, fileArgs);
        dup2(old, 1 );//恢复标准输出文件描述符
        va_end(fileArgs);
        charCount = vprintf(format, args);
    }
    va_end(args);
    
    //check Size
    double size = __fileSize(_currentLogPath);
    if (size > _maxLogSize) {
        divLog();
    }
    return charCount;
}

@end
