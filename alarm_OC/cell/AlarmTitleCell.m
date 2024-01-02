//
//  AlarmTitleCell.m
//  alarm_OC
//
//  Created by xywu on 2024/1/3.
//

#import "AlarmTitleCell.h"
#import "utils.h"
#import <Masonry/Masonry.h>

@implementation AlarmTitleCell

- (void)loadWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:30];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
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
}

@end
