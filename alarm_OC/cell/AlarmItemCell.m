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
    label.text = [self formatTimeStringWithHour:hour Minute:minute];
    label.font = [UIFont systemFontOfSize:18];
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

- (NSString *)formatTimeStringWithHour:(NSString *)hour Minute:(NSString *)minute {
    if (!isValidStr(hour) || !isValidStr(minute)) {
        return @"";
    }
    NSString *hourPart = [hour length] > 1 ? hour : [@"0" stringByAppendingString:hour];
    NSString *minutePart = [minute length] > 1 ? minute : [@"0" stringByAppendingString:minute];
    return [NSString stringWithFormat:@"%@ : %@", hourPart, minutePart];
}

@end
