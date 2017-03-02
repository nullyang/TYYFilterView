//
//  TYYListFilter.h
//  TYYFilterView
//
//  Created by Null on 17/3/2.
//  Copyright © 2017年 zcs_yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYYListFilter : UIView

+ (void)showListViewWithTitleList:(NSArray *)titleList selectedIndex:(NSInteger)selectedIndex selectedBlock:(void(^)(NSString *selectedTitle, NSInteger selectedIndex))selectedBlock hideBlock:(void(^)(void))hideBlock inView:(UIView *)supView;


@end
