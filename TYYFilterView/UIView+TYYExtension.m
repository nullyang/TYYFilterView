//
//  UIView (TYYExtension).m
//  TYYFilterView
//
//  Created by Null on 17/3/2.
//  Copyright © 2017年 zcs_yang. All rights reserved.
//

#import "UIView+TYYExtension.h"

@implementation UIView (TYYExtension)
- (void)setLeft:(CGFloat)left{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)left{
    return self.frame.origin.x;
}

- (void)setTop:(CGFloat)top{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)top{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX{
    [self setCenter:CGPointMake(centerX, self.center.y)];
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY{
    [self setCenter:CGPointMake(self.center.x, centerY)];
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (UIView *)containViewWithClass:(Class)viewClass{
    UIView *containView;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:viewClass]) {
            containView = view;
        }
    }
    return containView;
}

@end
