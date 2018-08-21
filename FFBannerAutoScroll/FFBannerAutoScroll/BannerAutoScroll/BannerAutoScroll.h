//
//  BannerAutoScroll.h
//  FFBannerAutoScroll
//
//  Created by mac on 2018/6/25.
//  Copyright © 2018年 healifeGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@class BannerAutoScroll;

/*
 *  简易版的SDCycleScrollView实现
 */

@protocol BannerAutoScrollDelegate <NSObject>

///当前点击的是第几张图片
- (void)bannerAutoScroll:(BannerAutoScroll *)bannerScroll didSelectedAtIndex:(NSInteger)index;

///当前滚动到第几张图片
- (void)bannerAutoScroll:(BannerAutoScroll *)bannerScroll didScrollToIndex:(NSInteger)index;

@end

@interface BannerAutoScroll : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic,copy) NSArray *dataArr;

@property (nonatomic,weak) id <BannerAutoScrollDelegate> delegate;

@end


/*
 实现原理：
 
 数据扩大100倍 cell重用
 
 从中间位置开始滚动
 
 通过取余数来获取当前是第几个图片
 
 中间滚动带动画YES  两边的滚动设置动画为NO
 
 */
