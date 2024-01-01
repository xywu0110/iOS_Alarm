//
//  AlarmItemCell.m
//  alarm_OC
//
//  Created by xywu on 2024/1/1.
//

#import "AlarmItemCell.h"
#import "utils.h"
#import <Masonry/Masonry.h>

@interface AlarmItemCell ()

@property (nonatomic, strong)UILabel *labelText;

@end

@implementation AlarmItemCell

- (void)loadWithData:(NSDictionary *)info {
    // todo: rewrite
    UILabel *label = [[UILabel alloc] init];
    NSString *hour = [info[@"hour"] stringValue];
    NSString *minute = [info[@"minute"] stringValue];
    label.text = (isValidStr(hour) && isValidStr(minute)) ? [NSString stringWithFormat:@"%@ : %@", hour, minute] : @"";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView).offset(10);
    }];
    
    UIView *separatorLine = [self setupSeparatorLine];
    [self.contentView addSubview:separatorLine];
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(label.mas_bottom).offset(-1);
    }];
}

- (UIView *)setupSeparatorLine {
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = UIColorFromHexString(0x303030);
    return separator;
}

@end
