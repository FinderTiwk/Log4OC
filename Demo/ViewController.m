//
//  ViewController.m
//  Demo
//
//  Created by FinderTiwk on 2018/08/08.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "ViewController.h"
#import <Log4OC/Log4OC.h>

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    
//    setLogMode(2, 1, YES);
    
//#ifdef __OPTIMIZE__
//    setLogMode(2, 1, NO);
//#else
//    setLogMode(1, 0, YES);
//#endif
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSDictionary *dict = @{@"k1":@"v1",@"k2":@"v2",@"k3":@"v3",};
    DEBUGLog(@"%@", dict);
    
    NSArray *array = @[@"v1",@"v2",@"v3",@"v4"];
    DEBUGLog(@"%@", array);
}

@end
