//
//  BannerAutoScroll.m
//  FFBannerAutoScroll
//
//  Created by mac on 2018/6/25.
//  Copyright © 2018年 healifeGroup. All rights reserved.
//

#import "BannerAutoScroll.h"
#import "BannerAutoImageViewCell.h"

@interface BannerAutoScroll ()

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,assign) NSInteger totalCount;

@property (nonatomic,assign) NSInteger currentItem;


@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation BannerAutoScroll

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
   
    }
    return self;
}

- (void)setupTimer{
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)invalidateTimer{
    [self.timer invalidate];
    self.timer = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(automaticScroll) object:self.timer];
}

- (void)automaticScroll{
  
    self.currentItem++;
    
    if (self.currentItem > self.totalCount - 1) {
        self.currentPage = 0;
        self.currentItem = self.totalCount / 2 ;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentItem inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentItem inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
    
    self.currentPage = self.currentItem % self.dataArr.count;
    [UIView animateWithDuration:0.2 animations:^{
        [self.pageControl setCurrentPage:self.currentPage];
    }];

}

-(void)setDataArr:(NSArray *)dataArr{
   
    _dataArr = dataArr;
    self.pageControl.numberOfPages = dataArr.count;
    
    ///扩大100倍 因为重用 所以不会有什么内存问题
    self.totalCount = dataArr.count * 100;
    [self.collectionView reloadData];
    
    ///默认从中间位置开始滚动 这样既可以向左滚动也可以向右滚动
    self.currentItem = self.totalCount / 2;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentItem inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];

    //一张图不滚动
    if (self.dataArr.count > 1) {
        [self setupTimer];
        self.pageControl.hidden = NO;
        self.collectionView.scrollEnabled = YES;
    }else{
        [self invalidateTimer];
        self.pageControl.hidden = YES;
        self.collectionView.scrollEnabled = NO;
    }
}

-(UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-40, CGRectGetWidth(self.frame), 40)];
        _pageControl.currentPage  = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [_pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

-(void)pageControlAction:(UIPageControl *)sender{
    [self invalidateTimer];
    
    if (sender.currentPage > self.currentPage) {
        self.currentItem++;
        
    }else{
        self.currentItem--;
    }
  
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentItem inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = self.bounds.size;
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 0.0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"BannerAutoImageViewCell" bundle:nil] forCellWithReuseIdentifier:@"BannerAutoImageViewCell"];
    }
    return _collectionView;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.totalCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BannerAutoImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BannerAutoImageViewCell" forIndexPath:indexPath];
    self.currentPage = indexPath.item % self.dataArr.count;
    NSString *imageName = self.dataArr[self.currentPage];
    if ([imageName hasPrefix:@"http"]) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
         }else{
             cell.imageView.image = [UIImage imageNamed:imageName];
         }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.currentPage = indexPath.item % self.dataArr.count;
    
    if ([self.delegate respondsToSelector:@selector(bannerAutoScroll:didSelectedAtIndex:)]) {
        [self.delegate bannerAutoScroll:self didSelectedAtIndex:self.currentPage];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    self.currentItem = scrollView.contentOffset.x / self.frame.size.width;
    self.currentPage = self.currentItem % self.dataArr.count;
    if ([self.delegate respondsToSelector:@selector(bannerAutoScroll:didScrollToIndex:)]) {
        [self.delegate bannerAutoScroll:self didScrollToIndex:self.currentPage];
    }
    if (self.timer == nil) {
        [self setupTimer];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  
    self.currentItem = scrollView.contentOffset.x / self.frame.size.width;
    self.currentPage = self.currentItem % self.dataArr.count;

    [UIView animateWithDuration:0.2 animations:^{
        [self.pageControl setCurrentPage:self.currentPage];
    }];
    
    if ([self.delegate respondsToSelector:@selector(bannerAutoScroll:didScrollToIndex:)]) {
        [self.delegate bannerAutoScroll:self didScrollToIndex:self.currentPage];
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self setupTimer];
}


@end
