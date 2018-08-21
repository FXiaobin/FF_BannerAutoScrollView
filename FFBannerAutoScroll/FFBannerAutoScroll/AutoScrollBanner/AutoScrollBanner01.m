//
//  AutoScrollBanner01.m
//  FF_AutoScrollBanner
//
//  Created by mac on 2018/8/20.
//  Copyright © 2018年 healifeGroup. All rights reserved.
//

#import "AutoScrollBanner01.h"

@interface AutoScrollBanner01 ()


@property (nonatomic,strong) NSMutableArray *imageArray;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,assign) NSInteger currentIndex;


@end

@implementation AutoScrollBanner01



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

-(void)setImages:(NSArray *)images{
    _images = images;
    
    if (images.count == 0) {
        return;
    }
    
    [self.imageArray addObjectsFromArray:images];
    
    if (images.count > 1) {
        NSString *first = images.firstObject;
        NSString *last = images.lastObject;
        [self.imageArray insertObject:last atIndex:0];
        [self.imageArray addObject:first];
        _currentIndex = 1;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
        ///大于1张滚动
        [self timer];
        self.pageControl.hidden = NO;
        
    }else{
        self.pageControl.hidden = YES;
    }
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * self.imageArray.count, CGRectGetHeight(self.frame));
    
    for (int i = 0; i < self.imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) * i, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
        [imageView addGestureRecognizer:tap];
        
        if (images.count == 1) {
            imageView.tag = 3000 + i;
        }else{
          imageView.tag = 3000 + i - 1;
        }
        
        imageView.image = [UIImage imageNamed:self.imageArray[i]];
        [self.scrollView addSubview:imageView];
        
        if (_titles.count) {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(imageView.frame) - 40, CGRectGetWidth(imageView.frame), 40)];
            bgView.backgroundColor = [UIColor blackColor];
            bgView.alpha = 0.5;
            [imageView addSubview:bgView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:bgView.frame];
            label.textColor = [UIColor whiteColor];
            NSString *title = _titles[0];
            if (i == 0) {
                title = _titles.lastObject;
            }else if (i == self.imageArray.count - 1){
                title = _titles.firstObject;
            }else{
                title = _titles[i - 1];
            }
            
            label.text = title;
            
            [imageView addSubview:label];
        }
    }
    
    self.pageControl.numberOfPages = images.count;
    self.pageControl.currentPage = _currentIndex - 1;
    
    
}

- (void)imageViewTap:(UITapGestureRecognizer *)sender{
    NSInteger tag = sender.view.tag - 3000;
    
    if (self.didClickedAtIndexBlock) {
        self.didClickedAtIndexBlock(tag);
    }
}

- (void)pageControlChange:(UIPageControl *)pg{
    [self.timer invalidate];
    self.timer = nil;
    _currentIndex = pg.currentPage + 1;
    [self.scrollView setContentOffset:CGPointMake(_currentIndex * CGRectGetWidth(self.frame), 0) animated:YES];
    [self performSelector:@selector(timerRestart) withObject:nil afterDelay:3.0];
}

-(void)timerRestart{
    [self timer];
}

-(NSTimer *)timer{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(change:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

-(void)change:(NSTimer *)timer{
    [self performSelector:@selector(changeImages:) withObject:self.timer afterDelay:0.0];
    
}

- (void)changeImages:(NSTimer *)timer{
    _currentIndex++;
    if (_currentIndex > self.imageArray.count - 2) {
        _currentIndex = 1;
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    self.pageControl.currentPage = _currentIndex - 1;
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame) * _currentIndex, 0) animated:YES];
    
    if (self.didScrollToIndexBlock) {
        self.didScrollToIndexBlock(_currentIndex - 1);
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.timer invalidate];
    self.timer = nil;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self timer];
    
    NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    _currentIndex = index;
    
    if (index == 0) {
        scrollView.contentOffset = CGPointMake(CGRectGetWidth(scrollView.frame) * (self.imageArray.count - 2), 0);
        _currentIndex = self.imageArray.count - 2;
    }else if (index == self.imageArray.count - 1){
        scrollView.contentOffset = CGPointMake(CGRectGetWidth(scrollView.frame), 0);
        _currentIndex = 1;
    }
    self.pageControl.currentPage = _currentIndex - 1;
    
    if (self.didScrollToIndexBlock) {
        self.didScrollToIndexBlock(_currentIndex - 1);
    }
}


-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        
    }
    return _scrollView;
}

-(NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

-(UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-30, CGRectGetWidth(self.frame),30)];
        [_pageControl addTarget:self action:@selector(pageControlChange:) forControlEvents:UIControlEventValueChanged];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    }
    return _pageControl;
}




@end
