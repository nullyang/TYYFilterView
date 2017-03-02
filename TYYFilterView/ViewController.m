//
//  ViewController.m
//  TYYFilterView
//
//  Created by Null on 17/3/2.
//  Copyright © 2017年 zcs_yang. All rights reserved.
//

#import "ViewController.h"
#import "TYYNavFilter.h"
#import "UIView+TYYExtension.h"
#import "Masonry.h"

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface ViewController ()<UIScrollViewDelegate,TYYNavFilterDelegate>

@property (nonatomic ,strong)UIView *containerView;
@property (nonatomic ,strong)UIScrollView *scrollView;
@property (nonatomic ,strong)TYYNavFilter *navFilter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    self.navigationController.navigationBar.translucent = NO;
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.equalTo(self.view);
    }];
    
    _containerView = [[UIView alloc]init];
    [_scrollView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.height.equalTo(_scrollView.mas_height);
    }];
    
    UIView *lastView;
    for (int i = 0; i<[self navFilterTitleList].count; i++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = randomColor;
        [_containerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
            }else {
                make.left.equalTo(_containerView.mas_left);
            }
            make.width.equalTo(self.view.mas_width);
            make.top.height.equalTo(_containerView);
        }];
        lastView = view;
    }
    if (lastView) {
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView.mas_right);
        }];
    }
    
    self.navigationItem.titleView = self.navFilter;
}

- (TYYNavFilter *)navFilter{
    if (_navFilter) {
        return _navFilter;
    }
    __weak typeof(self) weakSelf = self;
    _navFilter = [[TYYNavFilter alloc]initWithFrame:CGRectMake(0, 0, 100, 44) textColor:[UIColor blackColor] nomalFontSize:12.f selectedFontSize:17.f viewController:self selectedBlock:^(NSInteger selectedIndex) {
        //直接设置contentOffset有问题
        CGRect bounds = weakSelf.scrollView.bounds;
        bounds.origin = CGPointMake(weakSelf.view.width*selectedIndex, 0);
        weakSelf.scrollView.bounds = bounds;
    }];
    return _navFilter;
}

- (NSInteger)navFilterCurrentIndex{
    return 3;
}

- (NSArray<NSString *> *)navFilterTitleList{
    return @[@"选项1",@"选项2",@"选项3",@"选项4",@"选项5",@"选项6"];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.navFilter observedScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.navFilter observedScrollViewDidEndScroll:scrollView];
}

@end
