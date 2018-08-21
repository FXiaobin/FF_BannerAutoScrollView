//
//  AutoScrollBanner02.m
//  FF_AutoScrollBanner
//
//  Created by mac on 2018/8/20.
//  Copyright © 2018年 healifeGroup. All rights reserved.
//

#import "AutoScrollBanner02.h"

@interface AutoScrollBanner02 ()<UIScrollViewDelegate>


@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,assign) NSInteger currentIndex;


@property (nonatomic,strong) UIImageView *leftImageView;


@property (nonatomic,strong) UIImageView *centerImageView;


@property (nonatomic,strong) UIImageView *rightImageView;


@property (nonatomic,strong) UILabel *leftLabel;

@property (nonatomic,strong) UILabel *centerLabel;


@property (nonatomic,strong) UILabel *rightLabel;



@property (nonatomic,strong) UIView *leftBg;

@property (nonatomic,strong) UIView *centerBg;
@property (nonatomic,strong) UIView *rightBg;

@end

@implementation AutoScrollBanner02



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.leftImageView];
        [self.scrollView addSubview:self.centerImageView];
        [self.scrollView addSubview:self.rightImageView];
        
        self.leftBg = [self blackMaskViewInitWithFrame:self.leftLabel.frame];
        self.centerBg = [self blackMaskViewInitWithFrame:self.centerLabel.frame];
        self.rightBg = [self blackMaskViewInitWithFrame:self.rightLabel.frame];
        
        [self.leftImageView addSubview:self.leftBg];
        [self.centerImageView addSubview:self.centerBg];
        [self.rightImageView addSubview:self.rightBg];
        
        [self.leftImageView addSubview:self.leftLabel];
        [self.centerImageView addSubview:self.centerLabel];
        [self.rightImageView addSubview:self.rightLabel];
        
        
        [self addSubview:self.pageControl];
    }
    return self;
}

-(UIView *)blackMaskViewInitWithFrame:(CGRect)frame{
    UIView *bg = [[UIView alloc] initWithFrame:frame];
    bg.backgroundColor = [UIColor blackColor];
    bg.alpha = 0.5;
    bg.hidden = YES;
    return bg;
}

- (void)showBlackMaskView{
    self.leftBg.hidden = NO;
    self.centerBg.hidden = NO;
    self.rightBg.hidden = NO;
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    self.pageControl.currentPage = _currentIndex;
    
    if (currentIndex == 0) {
        self.leftImageView.image = [UIImage imageNamed:self.images[self.images.count - 1]];
        self.centerImageView.image = [UIImage imageNamed:self.images[currentIndex]];
        self.rightImageView.image = [UIImage imageNamed:self.images[currentIndex + 1]];
        
        if (self.titles.count == self.images.count) {
            [self showBlackMaskView];
            self.leftLabel.text = self.titles[self.titles.count - 1];
            self.centerLabel.text = self.titles[currentIndex];
            self.rightLabel.text = self.titles[currentIndex + 1];
        }
        
    }else if (currentIndex == self.images.count - 1){
        
        self.leftImageView.image = [UIImage imageNamed:self.images[currentIndex - 1]];
        self.centerImageView.image = [UIImage imageNamed:self.images[currentIndex]];
        self.rightImageView.image = [UIImage imageNamed:self.images[0]];
        
        if (self.titles.count == self.images.count) {
            [self showBlackMaskView];
            self.leftLabel.text = self.titles[currentIndex - 1];
            self.centerLabel.text = self.titles[currentIndex];
            self.rightLabel.text = self.titles[0];
        }
        
    }else{
        self.leftImageView.image = [UIImage imageNamed:self.images[currentIndex - 1]];
        self.centerImageView.image = [UIImage imageNamed:self.images[currentIndex]];
        self.rightImageView.image = [UIImage imageNamed:self.images[currentIndex + 1]];
        
        if (self.titles.count == self.images.count) {
            [self showBlackMaskView];
            self.leftLabel.text = self.titles[currentIndex - 1];
            self.centerLabel.text = self.titles[currentIndex];
            self.rightLabel.text = self.titles[currentIndex + 1];
        }
    }
    
}

-(void)setImages:(NSArray *)images{
    _images = images;
    
    if (images.count == 0) {
        return;
    }

    self.pageControl.numberOfPages = images.count;
    
    if (images.count > 1) {
      
        self.currentIndex = 0;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
        ///大于1张滚动
        [self timer];
        self.pageControl.hidden = NO;
        
    }else{
        self.pageControl.hidden = YES;
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.leftImageView.image = [UIImage imageNamed:images.firstObject];
    }
    
}

- (void)imageViewTap:(UITapGestureRecognizer *)sender{
    
    if (self.didClickedAtIndexBlock) {
        self.didClickedAtIndexBlock(_currentIndex);
    }
}

- (void)pageControlChange:(UIPageControl *)pg{
    [self.timer invalidate];
    self.timer = nil;
  
    if (pg.currentPage < _currentIndex){ //向右滑动
        ///每次滚动后要偏移到中间位置
        [self.scrollView setContentOffset:CGPointMake(2 * CGRectGetWidth(self.frame), 0) animated:NO];
        
    }else if(pg.currentPage > _currentIndex){ //向左滑动
        ///每次滚动后要偏移到中间位置
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
   
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:YES];
    
    self.currentIndex = pg.currentPage;
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
    
    if (_currentIndex > self.images.count - 1) {
        _currentIndex = 0;
    }
 
    self.currentIndex = _currentIndex;
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame), 0) animated:YES];
    
    
    if (self.didScrollToIndexBlock) {
        self.didScrollToIndexBlock(_currentIndex);
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.timer invalidate];
    self.timer = nil;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_timer == nil) {
        [self timer];
    }
    
    CGPoint offset = [_scrollView contentOffset] ;
    
    if (offset.x > self.frame.size.width){ //向右滑动
        _currentIndex = (_currentIndex + 1) % self.images.count ;
        
    }else if(offset.x < self.frame.size.width){ //向左滑动
        _currentIndex = (_currentIndex + self.images.count - 1) % self.images.count ;
    }
    
    self.currentIndex = _currentIndex;
    
    self.pageControl.currentPage = _currentIndex;
    
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:NO];

    if (self.didScrollToIndexBlock) {
        self.didScrollToIndexBlock(_currentIndex);
    }
}


-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * 3, CGRectGetHeight(self.frame));
    }
    return _scrollView;
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

-(UIImageView *)leftImageView{
    if (_leftImageView == nil) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
        _leftImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
        [_leftImageView addGestureRecognizer:tap];
    }
    return _leftImageView;
}

-(UIImageView *)centerImageView{
    if (_centerImageView == nil) {
        _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
        _centerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
        [_centerImageView addGestureRecognizer:tap];
    }
    return _centerImageView;
}

-(UIImageView *)rightImageView{
    if (_rightImageView == nil) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.frame) * 2, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
        _rightImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
        [_rightImageView addGestureRecognizer:tap];
    }
    return _rightImageView;
}

-(UILabel *)leftLabel{
    if (_leftLabel == nil) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.leftImageView.frame)-40, CGRectGetWidth(self.leftImageView.frame), 40)];
        _leftLabel.textColor = [UIColor whiteColor];
    }
    return _leftLabel;
}

-(UILabel *)centerLabel{
    if (_centerLabel == nil) {
        _centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.centerImageView.frame)-40, CGRectGetWidth(self.centerImageView.frame), 40)];
        _centerLabel.textColor = [UIColor whiteColor];
    }
    return _centerLabel;
}

-(UILabel *)rightLabel{
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.rightImageView.frame)-40, CGRectGetWidth(self.rightImageView.frame), 40)];
        _rightLabel.textColor = [UIColor whiteColor];
    }
    return _rightLabel;
}

@end
