//
//  AddAlarmViewController.m
//  alarm_OC
//
//  Created by xywu on 2023/12/26.
//

#import "AddAlarmViewController.h"
#import "utils.h"
#import "AlarmInfoArray.h"
#import <Masonry/Masonry.h>

@interface AddAlarmViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIPickerView *timePickerView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *configPanel;
@property (nonatomic, strong) UIButton *repeatSheet;
@property (nonatomic, strong) UIButton *labelSheet;
@property (nonatomic, strong) UIButton *soundSheet;
@property (nonatomic, strong) UIButton *snoozeSheet;
@property (nonatomic, strong) UILabel *labelOption;
@property (nonatomic, strong) UILabel *soundOption;
@property (nonatomic, strong) UITextField *labelText;

@property (nonatomic, strong) NSMutableDictionary *currentAlarmInfo;

@end

@implementation AddAlarmViewController

// MARK: lifecircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

// MARK: UI
- (void)setupUI {
    self.view.backgroundColor = UIColorFromHexString(0x171717);
    [self setupTopBar];
    [self setupTimePickerView];
    [self setupConfigPanel];
}

- (void)setupTopBar {
    [self.view addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10);
        make.left.mas_equalTo(self.view).offset(18);
    }];
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.cancelButton.mas_centerY);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-18);
    }];
}

- (void)setupTimePickerView {
    [self.view addSubview:self.timePickerView];
    [self.timePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(25);
        make.left.right.mas_equalTo(self.view);
    }];
}

- (void)setupConfigPanel {
    [self.view addSubview:self.configPanel];
    [self.configPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timePickerView.mas_bottom).offset(25);
        make.height.mas_equalTo(160);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    
    [self.configPanel addSubview:self.repeatSheet];
    [self.repeatSheet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.configPanel);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.configPanel.mas_top);
    }];
    UIView *separatorLine1 = [self setupSeparatorLine];
    [self.configPanel addSubview:separatorLine1];
    [separatorLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.configPanel);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.repeatSheet.mas_bottom).offset(-1);
    }];
    
    [self.configPanel addSubview:self.labelSheet];
    [self.labelSheet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.configPanel);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.repeatSheet.mas_bottom);
    }];
    UIView *separatorLine2 = [self setupSeparatorLine];
    [self.configPanel addSubview:separatorLine2];
    [separatorLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.configPanel);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.labelSheet.mas_bottom).offset(-1);
    }];
    
    [self.configPanel addSubview:self.soundSheet];
    [self.soundSheet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.configPanel);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.labelSheet.mas_bottom);
    }];
    UIView *separatorLine3 = [self setupSeparatorLine];
    [self.configPanel addSubview:separatorLine3];
    [separatorLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.configPanel);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.soundSheet.mas_bottom).offset(-1);
    }];
    
    [self.configPanel addSubview:self.snoozeSheet];
    [self.snoozeSheet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.configPanel);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.soundSheet.mas_bottom);
    }];
}

- (UIView *)setupSeparatorLine {
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = UIColorFromHexString(0x303030);
    return separator;
}

// MARK: event
- (void)onClickCancel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissModalVC)]) {
        [self.delegate dismissModalVC];
    }
}

- (void)onClickSave {
    if (self.currentAlarmInfo[@"index"]) {
        NSInteger index = [self.currentAlarmInfo[@"index"] integerValue];
        [self.currentAlarmInfo removeObjectForKey:@"index"];
        [AlarmInfoArray replaceAlarmAtIndex:index withNewInfo:[self.currentAlarmInfo copy]];
    } else {
        [AlarmInfoArray addAlarm:[self.currentAlarmInfo copy]];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissModalVC)]) {
        [self.delegate dismissModalVC];
    }
}

//- (void)updatePersistenceStore {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:[self.alarmInfoArray copy] forKey:ALARM_INFO_ARRAY];
//    [defaults synchronize];
//}

- (void)onClickRepeat {
    // todo
    NSLog(@"clicked repeat");
}

- (void)onClickSound {
    // todo
}

- (void)buttonTouchDown:(UIButton *)sender {
    sender.backgroundColor = UIColorFromHexString(0x303030);
}

- (void)buttonTouchUp:(UIButton *)sender {
    sender.backgroundColor = [UIColor clearColor];
}

- (void)textFieldDidChange:(UITextField *)textField {
    self.currentAlarmInfo[@"label"] = textField.text ? : @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)showAlarmConfigWithCurrentTime {
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:currentDate];
    NSDictionary *alarmInfo = @{
        @"hour": @([components hour]),
        @"minute": @([components minute])
    };
    [self showAlarmConfigWithInfo:alarmInfo];
}

- (void)showAlarmConfigWithInfo:(NSDictionary *)info {
    if (!info[@"hour"] || !info[@"minute"]) {
        [self showAlarmConfigWithCurrentTime];
        return;
    }
    NSMutableDictionary *currentInfo = [info mutableCopy];
    currentInfo[@"repeat"] = currentInfo[@"repeat"] ? : @[@(NO), @(NO), @(NO), @(NO), @(NO), @(NO), @(NO)];
    currentInfo[@"label"] = currentInfo[@"label"] ? : @"";
    currentInfo[@"sound"] = currentInfo[@"sound"] ? : @(0);
    currentInfo[@"snooze"] = currentInfo[@"snooze"] ? : @(NO);
    self.currentAlarmInfo = currentInfo;
    
    [self.timePickerView selectRow:[currentInfo[@"hour"] integerValue] inComponent:0 animated:NO];
    [self.timePickerView selectRow:[currentInfo[@"minute"] integerValue] inComponent:1 animated:NO];
    // todo
}

// MARK: delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return component == 0 ? 24 : 60;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row < 10) {
        return [NSString stringWithFormat: @"0%ld", (long)row];
    } else {
        return [NSString stringWithFormat: @"%ld", (long)row];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *newView = (UILabel *)view;
    if (newView == nil) {
        newView = [[UILabel alloc] init];
    }
    newView.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    newView.textAlignment = NSTextAlignmentCenter;
    newView.textColor = [UIColor whiteColor];
    newView.backgroundColor = [UIColor clearColor];
    newView.font = [UIFont systemFontOfSize:22];
    return newView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.currentAlarmInfo[@"hour"] = @(row);
    } else {
        self.currentAlarmInfo[@"minute"] = @(row);
    }
    UIView *view = [pickerView viewForRow:row forComponent:component];
    view.backgroundColor = [UIColor lightGrayColor];
    [pickerView reloadComponent:component];
}

// MARK: getter
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Cancel"];
        [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexString(0xFFA500) range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:NSMakeRange(0, attributedString.length)];
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setAttributedTitle:attributedString forState:UIControlStateNormal];
        [_cancelButton sizeToFit];
        [_cancelButton addTarget:self action:@selector(onClickCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Save"];
        [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexString(0xFFA500) range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18.0] range:NSMakeRange(0, attributedString.length)];
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setAttributedTitle:attributedString forState:UIControlStateNormal];
        [_saveButton sizeToFit];
        [_saveButton addTarget:self action:@selector(onClickSave) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Add Alarm"];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18.0] range:NSMakeRange(0, attributedString.length)];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.attributedText = attributedString;
        _titleLabel.numberOfLines = 1;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIPickerView *)timePickerView {
    if (!_timePickerView) {
        _timePickerView = [[UIPickerView alloc] init];
        _timePickerView.dataSource = self;
        _timePickerView.delegate = self;
        _timePickerView.backgroundColor = [UIColor clearColor];
    }
    return _timePickerView;
}

- (UIView *)configPanel {
    if (!_configPanel) {
        _configPanel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 160)];
        _configPanel.backgroundColor = UIColorFromHexString(0x222222);
        _configPanel.layer.cornerRadius = 10;
        _configPanel.layer.masksToBounds = YES;
    }
    return _configPanel;
}

- (UIButton *)repeatSheet {
    if (!_repeatSheet) {
        _repeatSheet = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _repeatSheet.backgroundColor = [UIColor clearColor];
        [_repeatSheet addTarget:self action:@selector(onClickRepeat) forControlEvents:UIControlEventTouchUpInside];
        [_repeatSheet addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_repeatSheet addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *title = [[UILabel alloc] init];
        title.backgroundColor = [UIColor clearColor];
        title.text = @"Repeat";
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont systemFontOfSize:18];
        title.numberOfLines = 1;
        [title sizeToFit];
        [_repeatSheet addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_repeatSheet.mas_left).offset(15);
            make.centerY.mas_equalTo(_repeatSheet.mas_centerY);
        }];
        
        UILabel *option = [[UILabel alloc] init];
        option.backgroundColor = [UIColor clearColor];
        // todo: get from storage
        option.text = @"Never >";
        option.textColor = [UIColor whiteColor];
        option.font = [UIFont systemFontOfSize:18];
        option.numberOfLines = 1;
        [option sizeToFit];
        [_repeatSheet addSubview:option];
        [option mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_repeatSheet.mas_right).offset(-15);
            make.centerY.mas_equalTo(_repeatSheet.mas_centerY);
        }];
    }
    return _repeatSheet;
}

- (UIButton *)labelSheet {
    if (!_labelSheet) {
        _labelSheet = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _labelSheet.backgroundColor = [UIColor clearColor];
        
        UILabel *title = [[UILabel alloc] init];
        title.backgroundColor = [UIColor clearColor];
        title.text = @"Label";
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont systemFontOfSize:18];
        title.numberOfLines = 1;
        [title sizeToFit];
        [_labelSheet addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_labelSheet.mas_left).offset(15);
            make.centerY.mas_equalTo(_labelSheet.mas_centerY);
        }];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.delegate = self;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        UIColor *fontColor = [UIColor whiteColor];
        NSDictionary *attributes = @{
            NSForegroundColorAttributeName: fontColor,
            NSFontAttributeName: [UIFont systemFontOfSize:18]
        };
        NSString *defaultText = isValidStr(self.currentAlarmInfo[@"label"]) ? self.currentAlarmInfo[@"label"] : @"Alarm";
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:defaultText attributes:attributes];
        textField.textColor = fontColor;
        textField.borderStyle = UITextBorderStyleNone;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyDone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.textAlignment = NSTextAlignmentRight;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_labelSheet addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(40);
            make.right.mas_equalTo(_labelSheet.mas_right).offset(-15);
            make.centerY.mas_equalTo(_labelSheet.mas_centerY);
        }];
    }
    return _labelSheet;
}

- (UIButton *)soundSheet {
    if (!_soundSheet) {
        _soundSheet = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _soundSheet.backgroundColor = [UIColor clearColor];
        [_soundSheet addTarget:self action:@selector(onClickSound) forControlEvents:UIControlEventTouchUpInside];
        [_soundSheet addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_soundSheet addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *title = [[UILabel alloc] init];
        title.backgroundColor = [UIColor clearColor];
        title.text = @"Sound";
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont systemFontOfSize:18];
        title.numberOfLines = 1;
        [title sizeToFit];
        [_soundSheet addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_soundSheet.mas_left).offset(15);
            make.centerY.mas_equalTo(_soundSheet.mas_centerY);
        }];
        
        UILabel *option = [[UILabel alloc] init];
        option.backgroundColor = [UIColor clearColor];
        // todo: get from storage
        option.text = @"None >";
        option.textColor = [UIColor whiteColor];
        option.font = [UIFont systemFontOfSize:18];
        option.numberOfLines = 1;
        [option sizeToFit];
        [_soundSheet addSubview:option];
        [option mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_soundSheet.mas_right).offset(-15);
            make.centerY.mas_equalTo(_soundSheet.mas_centerY);
        }];
    }
    return _soundSheet;
}

- (UIButton *)snoozeSheet {
    if (!_snoozeSheet) {
        _snoozeSheet = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _snoozeSheet.backgroundColor = [UIColor clearColor];
        
        UILabel *title = [[UILabel alloc] init];
        title.backgroundColor = [UIColor clearColor];
        title.text = @"Snooze";
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont systemFontOfSize:18];
        title.numberOfLines = 1;
        [title sizeToFit];
        [_snoozeSheet addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_snoozeSheet.mas_left).offset(15);
            make.centerY.mas_equalTo(_snoozeSheet.mas_centerY);
        }];
        // todo
    }
    return _snoozeSheet;
}

- (NSMutableDictionary *)currentAlarmInfo {
    if (!_currentAlarmInfo) {
        _currentAlarmInfo = [[NSMutableDictionary alloc] initWithCapacity:6];
        _currentAlarmInfo[@"hour"] = @(0);
        _currentAlarmInfo[@"minute"] = @(0);
        _currentAlarmInfo[@"repeat"] = @[@(NO), @(NO), @(NO), @(NO), @(NO), @(NO), @(NO)];
        _currentAlarmInfo[@"label"] = @"";
        // todo
        _currentAlarmInfo[@"sound"] = @(0);
        _currentAlarmInfo[@"snooze"] = @(NO);
    }
    return _currentAlarmInfo;
}

@end
