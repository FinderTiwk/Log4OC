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
    
#ifdef __OPTIMIZE__
    setLogMode(2, 1, NO);
#else
    setLogMode(2, 1, YES);
#endif
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    DEBUGLog(@"谷歌是一家位于美国的跨国科技企业，业务包括互联网搜索、云计算、广告技术等，同时开发并提供大量基于互联网的产品与服务，其主要利润来自于AdWords等广告服务。");
    
    INFOLog(@"1999年下半年，谷歌网站“Google”正式启用。 [3]  2010年3月23日，宣布关闭在中国大陆市场搜索服务。2015年8月10日，宣布对企业架构进行调整，并创办了一家名为Alphabet的“伞形公司”（Umbrella Company），成为Alphabet旗下子公司。");
    
    WARNINGLog(@"2017年12月13日，谷歌正式宣布谷歌AI中国中心（Google AI China Center）在北京成立。");
    
    ERRORLog(@"2018年1月，腾讯和谷歌宣布双方签署一份覆盖多项产品和技术的专利交叉授权许可协议。 [8]  2018年5月29日，《2018年BrandZ全球最具价值品牌100强》发布，谷歌公司名列第一位。");
}

@end
