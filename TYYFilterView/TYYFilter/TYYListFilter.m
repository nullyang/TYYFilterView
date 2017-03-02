//
//  TYYListFilter.m
//  TYYFilterView
//
//  Created by Null on 17/3/2.
//  Copyright © 2017年 zcs_yang. All rights reserved.
//

#import "TYYListFilter.h"
#import "UIView+TYYExtension.h"
#import "TYYListFilterCell.h"
#import "Masonry.h"

@interface TYYListFilter()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)UIView *backgroundView;

@property (nonatomic ,copy)void (^selectedBlock)(NSString *seletedTitle,NSInteger selectedIndex);
@property (nonatomic ,copy)void (^hideBlock)();

@end

@implementation TYYListFilter{
    NSArray *_titleList;
    NSInteger _selectedIndex;
}

+ (instancetype)filterView{
    return [[TYYListFilter alloc]initWithFrame:CGRectZero];
}

- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backgroundView];
        [self addSubview:self.tableView];
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(screenScrollEnable)];
        [self addGestureRecognizer:panGes];
    }
    return self;
}

+ (void)showListViewWithTitleList:(NSArray *)titleList selectedIndex:(NSInteger)selectedIndex selectedBlock:(void (^)(NSString *, NSInteger))selectedBlock hideBlock:(void (^)(void))hideBlock inView:(UIView *)supView{
    TYYListFilter *listFilter = (TYYListFilter *)[supView containViewWithClass:[self class]];
    if (listFilter) {
        [listFilter hideFilterListViewWithRotate:NO];
    }else {
        listFilter = [TYYListFilter filterView];
        [listFilter showListViewWithTitleList:titleList selectedIndex:selectedIndex selectedBlock:selectedBlock hideBlock:hideBlock inView:supView];
    }
}

- (void)showListViewWithTitleList:(NSArray *)titleList selectedIndex:(NSInteger)selectedIndex selectedBlock:(void (^)(NSString *, NSInteger))selectedBlock hideBlock:(void (^)(void))hideBlock inView:(UIView *)supView{
    _selectedIndex = selectedIndex;
    _selectedBlock = selectedBlock;
    _hideBlock = hideBlock;
    _titleList = titleList;
    if ([supView containViewWithClass:self.class]) {
        [self hideFilterListView];
        return;
    }else {
        [supView addSubview:self];
    }
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.equalTo(supView);
    }];
    
    [self.tableView reloadData];
    
    CGFloat tableHeight = 0;
    //44是预留的空间，给背景点击用的
    if (self.tableView.contentSize.height < supView.height - 44) {
        tableHeight = self.tableView.contentSize.height;
    }else {
        tableHeight = supView.height - 44;
    }
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(-tableHeight);
        make.height.equalTo(@(tableHeight));
    }];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
        self.backgroundView.alpha = 0.6;
    }];
}

- (void)hideFilterListViewWithRotate:(BOOL)rotate{
    if (rotate && self.hideBlock) {
        self.hideBlock();
    }
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(-self.tableView.height);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
        self.backgroundView.alpha = 0.f;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)hideFilterListView{
    [self hideFilterListViewWithRotate:YES];
}

//屏蔽手势滑动
- (void)screenScrollEnable{
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"filterListCellID";
    TYYListFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[TYYListFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *text = _titleList[indexPath.row];
    BOOL selected = (_selectedIndex == indexPath.row);
    [cell configureWithTitle:text selected:selected];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != _selectedIndex) {
        if (self.selectedBlock) {
            self.selectedBlock(_titleList[indexPath.row],indexPath.row);
        }
    }
    [self hideFilterListView];
}

#pragma mark - 子视图

- (UITableView *)tableView
{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollsToTop = NO;
    return _tableView;
}

- (UIView *)backgroundView{
    if (_backgroundView) {
        return _backgroundView;
    }
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0.6;
    _backgroundView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideFilterListView)];
    [_backgroundView addGestureRecognizer:tapGes];
    return _backgroundView;
}
@end
