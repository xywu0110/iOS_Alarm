//
//  AlarmItemCell.m
//  alarm_OC
//
//  Created by xywu on 2024/1/1.
//

#import "AlarmItemCell.h"
#import "utils.h"
#import <Masonry/Masonry.h>

# define menuWidth 80

@interface AlarmItemCell () <UIGestureRecognizerDelegate>

@property (nonatomic, strong)UILabel *labelText;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *switchIcon;
@property (nonatomic, assign) BOOL isAlarmOn;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation AlarmItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
        [self setupGestures];
    }
    return self;
}

- (void)setupSubViews
{
    self.containerView = [[UIView alloc] initWithFrame:self.contentView.frame];
    [self.contentView addSubview:self.containerView];
    [self setupContainerView];
    [self setupMenuView];
}

- (void)setupContainerView
{
    [self.containerView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.containerView.mas_centerY).mas_offset(-10);
        make.left.mas_equalTo(self.containerView).offset(10);
    }];
    [self.containerView addSubview:self.labelText];
    [self.labelText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.containerView.mas_centerY).mas_offset(18);
        make.left.mas_equalTo(self.containerView).offset(10);
    }];
    [self.containerView addSubview:self.switchIcon];
    [self.switchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.containerView.mas_centerY);
        make.right.mas_equalTo(self.containerView).offset(-15);
    }];
    UIView *separatorLine = setupSeparatorLine();
    [self.containerView addSubview:separatorLine];
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.containerView);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.containerView.mas_bottom).offset(-1);
    }];
}

- (void)setupMenuView
{
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.bounds.size.width, 0, menuWidth, self.contentView.bounds.size.height)];
    menuView.backgroundColor = [UIColor redColor];
    [self.containerView addSubview:menuView];
    self.menuView = menuView;
    
    UILabel *deleteLabel = [[UILabel alloc] initWithFrame:self.menuView.bounds];
    deleteLabel.text = @"Delete";
    deleteLabel.textColor = [UIColor whiteColor];
    deleteLabel.textAlignment = NSTextAlignmentCenter;
    deleteLabel.font = [UIFont systemFontOfSize:15];
    [menuView addSubview:deleteLabel];
}

- (void)setupGestures
{
    UITapGestureRecognizer *contentGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapCell:)];
    [self.containerView addGestureRecognizer:contentGesture];
    
    UITapGestureRecognizer *switchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSwitch:)];
    [self.switchIcon addGestureRecognizer:switchGesture];
    [contentGesture requireGestureRecognizerToFail:switchGesture];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    [self.containerView addGestureRecognizer:self.panGesture];
    
    UITapGestureRecognizer *deleteGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDelete:)];
    [deleteGesture requireGestureRecognizerToFail:self.panGesture];
    [self.menuView addGestureRecognizer:deleteGesture];
}

- (void)updateWithInfo:(AlarmInfo *)info index:(NSInteger)index
{
    if (!info) {
        return;
    }
    self.currentIndex = index;
    self.timeLabel.text = [self formatTimeStringWithHour:info.hour Minute:info.minute];
    [self.timeLabel sizeToFit];
    self.labelText.text = info.label ? : @"Alarm";
    [self.labelText sizeToFit];
    self.isAlarmOn = info.isEnabled;
}

- (NSString *)formatTimeStringWithHour:(NSInteger)hour Minute:(NSInteger)minute
{
    if (!isValidHour(hour) || !isValidMinute(minute)) {
        return @"";
    }
    NSString *hourPart = hour > 9 ? [NSString stringWithFormat:@"%ld", (long)hour] : [NSString stringWithFormat:@"0%ld", (long)hour];
    NSString *minutePart = minute > 9 ? [NSString stringWithFormat:@"%ld", (long)minute] : [NSString stringWithFormat:@"0%ld", (long)minute];
    return [NSString stringWithFormat:@"%@ : %@", hourPart, minutePart];
}

- (void)onTapCell:(UITapGestureRecognizer *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTapCell:)]) {
        [self.delegate onTapCell:self.currentIndex];
    }
}

- (void)onTapSwitch:(UITapGestureRecognizer *)sender
{
    self.isAlarmOn = !self.isAlarmOn;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTapSwitch:newState:)]) {
        [self.delegate onTapSwitch:self.currentIndex newState:self.isAlarmOn];
    }
}

- (void)onSwipe:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:self.contentView];
    if (gesture.state == UIGestureRecognizerStateChanged) {
        if (translation.x < 0) {
            CGRect frame = self.containerView.frame;
            frame.origin.x = translation.x;
            if (frame.origin.x < -menuWidth) {
                frame.origin.x = -menuWidth;
            }
            self.containerView.frame = frame;
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.containerView.frame;
            frame.origin.x = translation.x < -menuWidth/2 ? -menuWidth : 0;
            self.containerView.frame = frame;
        }];
    }
}

- (void)onTapDelete:(UITapGestureRecognizer *)sender
{
    NSLog(@"tap menu");
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:24];
        _timeLabel.textColor = [UIColor whiteColor];
    }
    return _timeLabel;
}

- (UILabel *)labelText
{
    if (!_labelText) {
        _labelText = [[UILabel alloc] init];
        _labelText.font = [UIFont systemFontOfSize:15];
        _labelText.textColor = [UIColor whiteColor];
    }
    return _labelText;
}

- (UIImageView *)switchIcon
{
    if (!_switchIcon) {
        _switchIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _switchIcon.contentMode = UIViewContentModeScaleAspectFill;
        _switchIcon.image = [UIImage imageNamed:self.isAlarmOn ? @"switch_on" : @"switch_off"];
        _switchIcon.userInteractionEnabled = YES;
    }
    return _switchIcon;
}

- (void)setIsAlarmOn:(BOOL)isAlarmOn
{
    _isAlarmOn = isAlarmOn;
    if (isAlarmOn) {
        self.switchIcon.image = [UIImage imageNamed:@"switch_on"];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.labelText.textColor = [UIColor whiteColor];
    } else {
        self.switchIcon.image = [UIImage imageNamed:@"switch_off"];
        self.timeLabel.textColor = UIColorFromHexString(0x909090);
        self.labelText.textColor = UIColorFromHexString(0x909090);
    }
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    NSLog(@"GEsture: %@", gestureRecognizer);
//    if (gestureRecognizer == self.panGesture) {
//        CGPoint velocity = [self.panGesture velocityInView:self.contentView];
//        BOOL result = fabs(velocity.x) > fabs(velocity.y);
//        return result;
//    }
//    return YES;
//}

@end
