![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Platform](https://img.shields.io/badge/Platform-iOS-orange.svg)
![Author](https://img.shields.io/badge/Author-__Finder丶Tiwk-green.svg)


# Log4OC

OC分级日志工具，支持4种日志级别，提供两种持久化方案

## Usage
```C
    //DEBUGLog（建议开发调试使用）
    DEBUGLog(@"这是一个DEBUG级别日志");
    DEBUGLog(@"FinderTiwk", @"这是一个带作者的的DEBUG级别日志");
    
    //INFOLog(建议记录关键信息使用)
    INFOLog(@"这是一个INFO级别日志");
    INFOLog(@"FinderTiwk", @"这是一个带作者的的INFO级别日志");
    
    //WARNINGLog(建议记录警告敏信息使用)
    WARNINGLog(@"这是一个WARNING级别日志");
    WARNINGLog(@"FinderTiwk", @"这是一个带作者的的WARNING级别日志");
    
    //ERRORLog(建议记录发生异常错误时使用)
    ERRORLog(@"这是一个ERROR级别日志");
    ERRORLog(@"FinderTiwk", @"这是一个带作者的的ERROR级别日志");

----------------------Console Print-----------------------
[🐞DEBUG] 2018-11-14 12:53:45: 这是一个DEBUG级别日志 
[🐞DEBUG] 2018-11-14 12:53:45(FinderTiwk): 这是一个带作者的的DEBUG级别日志 
[🌴INFO] 2018-11-14 12:53:45: 这是一个INFO级别日志 
[🌴INFO] 2018-11-14 12:53:45(FinderTiwk): 这是一个带作者的的INFO级别日志 
[⚠️WARNING] 2018-11-14 12:53:45: 这是一个WARNING级别日志 
[⚠️WARNING] 2018-11-14 12:53:45(FinderTiwk): 这是一个带作者的的WARNING级别日志 
[🔴ERROR] 2018-11-14 12:53:45: 这是一个ERROR级别日志 
[🔴ERROR] 2018-11-14 12:53:45(FinderTiwk): 这是一个带作者的的ERROR级别日志 
```

## 偏好设置
### 0x00 日志级别
| LogLevel  | DESC |
| --- | --- |
| LogLevelDEBUG | 默认; 显示包括(DEBUGLog,INFOLog,WARNINGLog,ERRORLog的Log) |
| LogLevelINFO | 显示包括(INFOLog,WARNINGLog,ERRORLog的Log) |
| LogLevelWARNING | 显示包括(WARNINGLog,ERRORLog的Log)* |
| LogLevelERROR | 只显示ERRORLog的log |
| LogLevelNONE | 关闭所有日志 |



```C

#ifdef __OPTIMIZE__
    //当打包时建议去除DEBUG级别的日志
    setLogLevel(LogLevelINFO);
#endif

//获取当前日志级别
LogLevel level = currentLogLevel();

```

### 0x01 日志模式
* **mode:** 日志模式
    * **0:** 只打印到控制台,**DEFAULT**
    * **1:** 将日志保存到Sqlite中
    * **2:** 将日志保存到本地文件中
* **clean:** 当日志模式不是0时,是否自动清理日志
    * **0:** 不自动清理
    * **大于0:** 自动清理当前日期之前的n天的日志
* **both:** 当日志模式不是0时,日志持久化时是否同时打印到控制台
    * **YES:** 同时输出到控制台和文件 (DEBUG时用)
    * **NO:** 只输出到文件

```C
extern void setLogMode(NSUInteger mode,NSUInteger clean, BOOL both);
```


### 0x02 日志文件切割
当日志模式为2存储为本地文件时,设置日志文件大小阀值,K为单位, default 1024K/1M,当单个.log文件大于这个阀值时，会自动生成新的文件写入。
>日志将会保存在应用沙盒中,名称例如： 2018_xx_xx-1.log  ，2018_xx_xx-2.log

```C
extern void setLogMaxSize(NSUInteger threshold);
```

## 日志过滤
1. 按日志级别过滤
2. 按写日志的作者名称过滤
3. 按时间过滤

### 0x00 控制台模式下
**日志级别:** 可以通过打印出的日志前缀用肉眼观测，或者在控制台里COMMAND+F搜索关键字(DEBUG,INFO,WARNING,ERROR)

**作者名称：** 在控制台里COMMAND+F搜索作者名称

**时间：** 控制台日志输出按时间顺序输出,自己查看日志前缀里的时间戳

### 0x01 数据库模式下
数据库表结构,表名`Logger`

| 字段 | 数据类型 | 默认值 | 描述 |
| --- | --- | --- | --- |
| level | INTEGER |  | 日志级别 |
| time | DATE | CURRENT_TIMESTAMP | 打印时间 |
| content | TEXT |  | 日志内容 |
| author | TEXT |  | 作者,DEAFULT Apple |


**日志级别:** 

```sql
SELECT * FROM `Logger` WHERE level = 2
```
**作者名称：** 
```sql
SELECT * FROM `Logger` WHERE author = 'FinderTiwk'
```

**时间：** 
```sql
SELECT * FROM `Logger` WHERE time > '2018-11-13 12:12:12'
```

**多条件过滤：** 
```sql
SELECT * FROM `Logger` WHERE author = 'FinderTiwk' AND level = 2 AND time > '2018-11-13 12:12:12'
```

### 0x02 本地文件模式
使用Mac系统自带的Console打开`2018_xx_xx-1.log`文件,通过关键字搜索
![Console](https://blogimage-1251472213.cos.ap-shanghai.myqcloud.com/2018-11-14%2013-52-41.2018-11-14%2013_57_00.gif)