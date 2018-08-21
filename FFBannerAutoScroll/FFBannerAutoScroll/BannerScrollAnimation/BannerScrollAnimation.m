//
//  BannerScrollAnimation.m
//  FFBannerAutoScroll
//
//  Created by mac on 2018/6/25.
//  Copyright © 2018年 healifeGroup. All rights reserved.
//

#import "BannerScrollAnimation.h"
#import <UIImageView+WebCache.h>

@interface BannerScrollAnimation ()<CAAnimationDelegate>

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) UIPageControl *pageControl;


@property (nonatomic,strong) UIImageView *imageView;


@property (nonatomic,assign) NSInteger currentPage;


@end

@implementation BannerScrollAnimation


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.imageView];
        [self addSubview:self.pageControl];
        
    }
    return self;
}

-(void)setImageURLs:(NSArray *)imageURLs{
    _imageURLs = imageURLs;
    self.pageControl.numberOfPages = imageURLs.count;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURLs.firstObject]];
    
    [self setupTimer];
}

#pragma mark - UIImageView

-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.image = [UIImage imageNamed:@""];
        _imageView.userInteractionEnabled = YES;
        
        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeAction:)];
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [_imageView addGestureRecognizer:leftSwipe];
        
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeAction:)];
        rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        [_imageView addGestureRecognizer:rightSwipe];
    }
    return _imageView;
}

- (void)rightSwipeAction:(UISwipeGestureRecognizer *)sender{
    self.currentPage--;
    if (self.currentPage < 0) {
        self.currentPage = self.imageURLs.count - 1;
    }
    
    ///获取图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[self.currentPage]]];
    
    [self imageViewAnimationWithType:@"right"];
    
    
    [self invalidateTimer];
    
    if (sender.state == UIGestureRecognizerStateEnded){
        if (self.timer == nil) {
            [self setupTimer];
        }
    }
}

- (void)leftSwipeAction:(UISwipeGestureRecognizer *)sender{
    self.currentPage++;
    if (self.currentPage > self.imageURLs.count - 1) {
        self.currentPage = 0;
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[self.currentPage]]];
    
    [self imageViewAnimationWithType:@"left"];
    
    ///做手势的时候先让定时器停下来
    [self invalidateTimer];
    ///然后再开启
    [self setupTimer];
   
}

- (void)imageViewAnimationWithType:(NSString *)type{
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    animation.type =@"reveal";
    
    if ([type isEqualToString:@"left"]) {
        animation.subtype = kCATransitionFromRight;
    }else{
        animation.subtype = kCATransitionFromLeft;
    }
    [self.imageView.layer addAnimation:animation forKey:nil];
 
    [UIView animateWithDuration:0.2 animations:^{
        self.pageControl.currentPage = self.currentPage;
    }];
}

#pragma mark - UIPageControl

-(UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-40, CGRectGetWidth(self.frame), 40)];
        _pageControl.currentPage  = 0;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [_pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
        [_pageControl addTarget:self action:@selector(pageControlEndAction:) forControlEvents:UIControlEventAllEvents];
    }
    return _pageControl;
}

-(void)pageControlAction:(UIPageControl *)sender{
    [self invalidateTimer];
    
    if (sender.currentPage > self.currentPage) {
        self.currentPage = sender.currentPage % self.imageURLs.count;
        [self imageViewAnimationWithType:@"left"];
    }else{
        self.currentPage = sender.currentPage % self.imageURLs.count;
        [self imageViewAnimationWithType:@"right"];
    }
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[self.currentPage]]];
    
}

- (void)pageControlEndAction:(UIPageControl *)sender{
    if (self.timer == nil) {
        [self setupTimer];
    }
}

#pragma mark - NSTimer
- (void)setupTimer{
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(animationAutomaticScroll:) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)invalidateTimer{
    [self.timer invalidate];
    self.timer = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animationAutomaticScroll:) object:self.timer];
}

-(void)animationAutomaticScroll:(NSTimer *)timer{
    
    [self leftSwipeAction:nil];
}

- (void)animationDidStart:(CAAnimation *)anim{
    //[self invalidateTimer];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //[self setupTimer];
}

@end
