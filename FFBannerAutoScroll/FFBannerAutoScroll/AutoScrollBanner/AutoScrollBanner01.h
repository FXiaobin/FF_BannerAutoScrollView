//
//  AutoScrollBanner01.h
//  FF_AutoScrollBanner
//
//  Created by mac on 2018/8/20.
//  Copyright © 2018年 healifeGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

///前后各添加一张图片实现

@interface AutoScrollBanner01 : UIView<UIScrollViewDelegate>

///标题设置要放到图片设置之前
@property (nonatomic,strong) NSArray *titles;

@property (nonatomic,strong) NSArray *images;


@property (nonatomic,copy) void (^didClickedAtIndexBlock) (NSInteger index);

@property (nonatomic,copy) void (^didScrollToIndexBlock) (NSInteger index);

@end
