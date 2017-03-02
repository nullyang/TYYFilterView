//
//  UIView (TYYExtension).h
//  TYYFilterView
//
//  Created by Null on 17/3/2.
//  Copyright © 2017年 zcs_yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TYYExtension)
@property (nonatomic ,assign)CGFloat left;
@property (nonatomic ,assign)CGFloat top;
@property (nonatomic ,assign)CGFloat width;
@property (nonatomic ,assign)CGFloat height;
@property (nonatomic ,assign)CGFloat centerX;
@property (nonatomic ,assign)CGFloat centerY;
@property (nonatomic ,assign)CGSize size;
@property (nonatomic ,assign)CGPoint origin;

- (UIView *)containViewWithClass:(Class)viewClass;
@end
