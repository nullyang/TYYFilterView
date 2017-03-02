//
//  TYYListFilterCell.m
//  TYYFilterView
//
//  Created by Null on 17/3/2.
//  Copyright © 2017年 zcs_yang. All rights reserved.
//

#import "TYYListFilterCell.h"
#import "Masonry.h"

#define RGB_A(r, g, b, a) [UIColor colorWithRed:(CGFloat)(r)/255.0f green:(CGFloat)(g)/255.0f blue:(CGFloat)(b)/255.0f alpha:(CGFloat)(a)]
#define RGB(r, g, b) RGB_A(r, g, b, 1)
#define RGB_HEX(__h__) RGB((__h__ >> 16) & 0xFF, (__h__ >> 8) & 0xFF, __h__ & 0xFF)

@interface TYYListFilterCell ()
@property (nonatomic, strong) UILabel *titlelabel;
@property (nonatomic ,strong) UIView *bottomLine;
@end
@implementation TYYListFilterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ef_transfer_selected"]];
        self.accessoryView.hidden = YES;
        [self.contentView addSubview:self.titlelabel];
        [self addSubview:self.bottomLine];
        [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15.f);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        CGFloat lineHeight = 1/[UIScreen mainScreen].scale;
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(@(lineHeight));
        }];
    }
    return  self;
}

- (void)configureWithTitle:(NSString *)title selected:(BOOL)selected{
    self.titlelabel.text = title;
    self.titlelabel.textColor = selected? RGB_HEX(0xff4400):RGB_HEX(0x666666);
    self.accessoryView.hidden = !selected;
    if (!selected) {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (UILabel *)titlelabel{
    if (_titlelabel) {
        return _titlelabel;
    }
    _titlelabel = [[UILabel alloc] init];
    _titlelabel.font = [UIFont systemFontOfSize:14.f];
    _titlelabel.textColor = RGB_HEX(0x666666);
    return _titlelabel;
}

- (UIView *)bottomLine{
    if (_bottomLine) {
        return _bottomLine;
    }
    _bottomLine = [[UIView alloc]init];
    _bottomLine.backgroundColor = [UIColor lightGrayColor];
    return _bottomLine;
}

@end
