//
//  ViewController.m
//  FFBannerAutoScroll
//
//  Created by mac on 2018/6/25.
//  Copyright © 2018年 healifeGroup. All rights reserved.
//

#import "ViewController.h"

#import "BannerAutoScroll.h"

#import <SDCycleScrollView.h>

#import "BannerScrollAnimation.h"

#import "LoopBanner/YSLoopBanner.h"

@interface ViewController ()<BannerAutoScrollDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    BannerAutoScroll *banner = [[BannerAutoScroll alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 200)];
    banner.dataArr = @[@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1278172030,1902271828&fm=27&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=785168405,1618349646&fm=27&gp=0.jpg",
                       @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=500808421,1575925585&fm=200&gp=0.jpg",
                       @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2511100503,501373762&fm=27&gp=0.jpg"];
    [self.view addSubview:banner];
    banner.delegate = self;
    
    
//    SDCycleScrollView *sc = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 240, self.view.bounds.size.width, 200)];
//    sc.currentPageDotColor = [UIColor orangeColor];
//    sc.imageURLStringsGroup = @[@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1278172030,1902271828&fm=27&gp=0.jpg",
//                                @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=785168405,1618349646&fm=27&gp=0.jpg",
//                                @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=500808421,1575925585&fm=200&gp=0.jpg",
//                                @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2511100503,501373762&fm=27&gp=0.jpg"];
//    [self.view addSubview:sc];
    
    YSLoopBanner *ba = [[YSLoopBanner alloc] initWithFrame:CGRectMake(0, 240, self.view.bounds.size.width, 200) ];
    
        ba.imageURLStrings = @[@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1278172030,1902271828&fm=27&gp=0.jpg",
                                    @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=785168405,1618349646&fm=27&gp=0.jpg",
                                    @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=500808421,1575925585&fm=200&gp=0.jpg",
                                    @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2511100503,501373762&fm=27&gp=0.jpg"];
        [self.view addSubview:ba];
    
    
    BannerScrollAnimation *animation = [[BannerScrollAnimation alloc] initWithFrame:CGRectMake(0, 480, self.view.bounds.size.width, 200)];
    animation.imageURLs = @[@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1278172030,1902271828&fm=27&gp=0.jpg",
                            @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=785168405,1618349646&fm=27&gp=0.jpg",
                            @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=500808421,1575925585&fm=200&gp=0.jpg",
                            @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2511100503,501373762&fm=27&gp=0.jpg"];
    
    [self.view addSubview:animation];

}

-(void)bannerAutoScroll:(BannerAutoScroll *)bannerScroll didSelectedAtIndex:(NSInteger)index{
    NSLog(@"---- 1 index = %ld",index);
}

-(void)bannerAutoScroll:(BannerAutoScroll *)bannerScroll didScrollToIndex:(NSInteger)index{
    NSLog(@"---- 2 index = %ld",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
