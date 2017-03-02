//
//  TYYNavFilter.h
//  TYYFilterView
//
//  Created by Null on 17/3/2.
//  Copyright © 2017年 zcs_yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYYNavFilter;
@protocol TYYNavFilterDelegate <NSObject>

- (NSInteger)navFilterCurrentIndex;
- (NSArray <NSString *>*)navFilterTitleList;

@end

@interface TYYNavFilter : UIView

- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor nomalFontSize:(CGFloat)nomalFontSize selectedFontSize:(CGFloat)selectedFontSize viewController:(UIViewController<TYYNavFilterDelegate> *)viewController selectedBlock:(void(^)(NSInteger selectedBlock))selectedBlock;

- (void)observedScrollViewDidScroll:(UIScrollView *)observedScrollView;
- (void)observedScrollViewDidEndScroll:(UIScrollView *)obseredScrollView;

@end
