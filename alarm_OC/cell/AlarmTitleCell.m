//
//  AlarmTitleCell.m
//  alarm_OC
//
//  Created by xywu on 2024/1/3.
//

#import "AlarmTitleCell.h"
#import "utils.h"
#import <Masonry/Masonry.h>

@interface AlarmTitleCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation AlarmTitleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView).offset(10);
    }];
    UIView *separatorLine = setupSeparatorLine();
    [self.contentView addSubview:separatorLine];
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.contentView.mas_bottom).offset(-1);
    }];
    return self;
}

- (void)updateWithTitle:(NSString *)title
{
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:30];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

@end
