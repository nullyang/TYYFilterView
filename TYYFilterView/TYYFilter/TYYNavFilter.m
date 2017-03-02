//
//  TYYNavFilter.m
//  TYYFilterView
//
//  Created by Null on 17/3/2.
//  Copyright © 2017年 zcs_yang. All rights reserved.
//

#import "TYYNavFilter.h"
#import "UIView+TYYExtension.h"
#import "TYYListFilter.h"

static const CGFloat filterLabelMarginX = 30;
static const CGFloat filterLabelHeight = 22;
static const NSInteger filterLabelBaseTag = 0x999;

@interface TYYNavFilter()

@property (nonatomic ,strong)UIButton *baseButton;
@property (nonatomic ,strong)UIScrollView *scrollView;
@property (nonatomic ,assign)UIViewController *viewController;
@property (nonatomic ,assign)UINavigationItem *navigationItem;
@property (nonatomic ,copy)void (^selectedBlock)(NSInteger selectedIndex);

@end

@implementation TYYNavFilter {
    UIFont *_nomalFont;
    UIFont *_selectedFont;
    UIColor *_textColor;
    CGFloat _fontScale;
    NSInteger _currentIndex;
    
    NSArray *_titleList;
}

- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor nomalFontSize:(CGFloat)nomalFontSize selectedFontSize:(CGFloat)selectedFontSize viewController:(UIViewController<TYYNavFilterDelegate> *)viewController selectedBlock:(void (^)(NSInteger))selectedBlock{
    if (self = [super initWithFrame:frame]) {
        _viewController = viewController;
        _navigationItem = _viewController.navigationItem;
        _textColor = textColor;
        _nomalFont = [UIFont systemFontOfSize:nomalFontSize];
        _selectedFont = [UIFont systemFontOfSize:selectedFontSize];
        _fontScale = _selectedFont.pointSize / _nomalFont.pointSize;
        _selectedBlock = selectedBlock;
        if ([viewController respondsToSelector:@selector(navFilterCurrentIndex)]) {
            _currentIndex = [viewController navFilterCurrentIndex];
        }
        if ([viewController respondsToSelector:@selector(navFilterTitleList)]) {
            _titleList = [viewController navFilterTitleList];
        }
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    [self addSubview:self.scrollView];
    [self addSubview:self.baseButton];
    if (!_titleList.count) {
        return;
    }
    for (int i = 0; i < _titleList.count; i++) {
        NSString *title = _titleList[i];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*(self.width + filterLabelMarginX), 0, self.width, filterLabelHeight)];
        label.tag = filterLabelBaseTag + i;
        label.text = title;
        if (i == _currentIndex) {
            label.font = _selectedFont;
        }else {
            label.font = _nomalFont;
        }
        label.textColor = _textColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:label];
    }
    self.scrollView.contentSize = CGSizeMake(self.width * _titleList.count + filterLabelMarginX * (_titleList.count - 1), filterLabelHeight);
    if (_currentIndex) {
        [self.scrollView setContentOffset:CGPointMake(_currentIndex * (filterLabelMarginX + self.width), 0)];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.baseButton.frame = self.bounds;
    UIImage *image = [UIImage imageNamed:@"ef_fundProduct_arrow"];
    self.baseButton.imageEdgeInsets = UIEdgeInsetsMake(self.baseButton.height - image.size.height, 0.5*(self.baseButton.width - image.size.width), 0, 0.5*(self.baseButton.width - image.size.width));
    self.scrollView.frame = CGRectMake(0, 10, self.width, filterLabelHeight);
}

#pragma mark - 事件

- (void)showFilterView{
    [self changeButtonState];
    __weak typeof(self) weakSelf = self;
    [TYYListFilter showListViewWithTitleList:_titleList selectedIndex:_currentIndex selectedBlock:^(NSString *selectedTitle, NSInteger selectedIndex) {
        [weakSelf scrollToIndex:selectedIndex];
    } hideBlock:^{
        [weakSelf changeButtonState];
    } inView:self.viewController.view];
}

- (void)changeButtonState{
    self.baseButton.selected = !self.baseButton.selected;
    [UIView beginAnimations:@"rotate"context:nil];
    [UIView setAnimationDuration:0.25];
    if(CGAffineTransformEqualToTransform(self.baseButton.imageView.transform,CGAffineTransformIdentity)) {
        self.baseButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }else {
        self.baseButton.imageView.transform = CGAffineTransformIdentity;
    }
    [UIView commitAnimations];
}

- (void)scrollToIndex:(NSInteger)index{
    if (_currentIndex == index) {
        return;
    }
    [self.scrollView setContentOffset:CGPointMake(index * (filterLabelMarginX + self.width), 0)];
    for (int i = 0; i < _titleList.count; i++) {
        UILabel *label = [self.scrollView viewWithTag:filterLabelBaseTag + i];
        label.font = (i == index)? _selectedFont:_nomalFont;
    }
    self.navigationItem.leftBarButtonItem.customView.hidden = NO;
    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    if (self.selectedBlock) {
        self.selectedBlock(index);
    }
    _currentIndex = index;
}

- (void)observedScrollViewDidScroll:(UIScrollView *)observedScrollView{
    self.scrollView.clipsToBounds = NO;
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    
    [self filterLabelFontTransform:observedScrollView];
    self.baseButton.hidden = YES;
    
    if (observedScrollView.width) {
        CGFloat offsetScale = (self.width + filterLabelMarginX)/observedScrollView.width;
        [self.scrollView setContentOffset:CGPointMake(observedScrollView.contentOffset.x * offsetScale, 0)];
    }
}

- (void)observedScrollViewDidEndScroll:(UIScrollView *)obseredScrollView{
    self.scrollView.clipsToBounds = YES;
    self.baseButton.hidden = NO;
    self.navigationItem.leftBarButtonItem.customView.hidden = NO;
    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    
    _currentIndex = obseredScrollView.contentOffset.x / obseredScrollView.width;
    for (int i = 0; i < _titleList.count; i++) {
        UILabel *label = [self.scrollView viewWithTag:i + filterLabelBaseTag];
        label.font = (i == _currentIndex)?_selectedFont:_nomalFont;
        label.transform = CGAffineTransformIdentity;
    }
}

- (void)filterLabelFontTransform:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = scrollView.width;
    if (offsetX < 0) {
        return;
    }
    if (offsetX > scrollView.contentSize.width - scrollViewWidth) {
        return;
    }
    NSInteger leftIndex = offsetX / scrollViewWidth;
    NSInteger rightIndex = leftIndex + 1;
    UILabel *leftLabel = [self.scrollView viewWithTag:filterLabelBaseTag + leftIndex];
    UILabel *rightLabel = nil;
    if (rightIndex < _titleList.count) {
        rightLabel = [self.scrollView viewWithTag:filterLabelBaseTag + rightIndex];
    }
    
    // 计算右边按钮偏移量
    CGFloat rightScale = offsetX / scrollViewWidth;
    // 只想要 0~1
    rightScale = rightScale - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    if (scrollView.isDragging || scrollView.isDecelerating) {
        [self fontSizeAnimated:leftLabel scale:leftScale];
        [self fontSizeAnimated:rightLabel scale:rightScale];
    }
}

- (void)fontSizeAnimated:(UILabel *)label scale:(CGFloat)scale{
    CGFloat diffL = _fontScale - 1;
    CGFloat diffS = 1/_fontScale;
    if (label.font == _selectedFont) {
        label.transform = CGAffineTransformMakeScale(diffS + (1-diffS)*scale,diffS + (1-diffS)*scale);
    }else if (label.font == _nomalFont){
        label.transform = CGAffineTransformMakeScale(scale * diffL + 1, scale * diffL + 1);
    }
}

#pragma mark - subViews

- (UIScrollView *)scrollView{
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    return _scrollView;
}

- (UIButton *)baseButton{
    if (_baseButton) {
        return _baseButton;
    }
    _baseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _baseButton.backgroundColor = [UIColor clearColor];
    [_baseButton setImage:[UIImage imageNamed:@"ef_fundProduct_arrow"] forState:UIControlStateNormal];
    [_baseButton addTarget:self action:@selector(showFilterView) forControlEvents:UIControlEventTouchUpInside];
    return _baseButton;
}

@end
