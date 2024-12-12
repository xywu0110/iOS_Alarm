//
//  AlarmInfoArray.m
//  alarm_OC
//
//  Created by xywu on 2024/1/1.
//

#import "AlarmInfoArray.h"
#import "utils.h"

@implementation AlarmInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isUnsaved = YES;
        self.label = @"";
        self.repeatOptions = [@[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)] mutableCopy];
    }
    return self;
}

- (instancetype)initWithCurrentTime
{
    self = [self init];
    if (self) {
        NSDate *currentDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:currentDate];
        self.hour = [components hour];
        self.minute = [components minute];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.hour = [dict[@"hour"] integerValue];
        self.minute = [dict[@"minute"] integerValue];
//        self.fireDate = [NSKeyedUnarchiver unarchiveObjectWithData:dict[@"fireDate"]];
        self.label = dict[@"label"];
        self.repeatOptions = [dict[@"repeatOptions"] mutableCopy];
        self.snooze = [dict[@"snooze"] boolValue];
        self.isEnabled = [dict[@"isEnabled"] boolValue];
        self.isUnsaved = NO;
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    return @{
        @"hour" : @(self.hour),
        @"minute" : @(self.minute),
        @"label" : self.label ? : @"",
        @"repeatOptions" : [self.repeatOptions copy],
        @"snooze" : @(self.snooze),
        @"isEnabled" : @(self.isEnabled)
    };
}

- (instancetype)mutableCopy
{
    AlarmInfo *newInfo = [[AlarmInfo alloc] init];
    newInfo.hour = self.hour;
    newInfo.minute = self.minute;
    newInfo.label = self.label;
    newInfo.repeatOptions = [NSMutableArray arrayWithArray:self.repeatOptions];
    newInfo.snooze = self.snooze;
    newInfo.isEnabled = self.isEnabled;
    
    return newInfo;
}

- (void)setHour:(NSInteger)hour
{
    if (hour < 0) {
        _hour = 0;
    } else if (hour > 23) {
        _hour = 23;
    } else {
        _hour = hour;
    }
}

- (void)setMinute:(NSInteger)minute
{
    if (minute < 0) {
        _minute = 0;
    } else if (minute > 59) {
        _minute = 59;
    } else {
        _minute = minute;
    }
}

@end


@interface AlarmInfoArray ()

@property (nonatomic, strong) NSMutableArray<AlarmInfo *> *muArray;

@end

@implementation AlarmInfoArray

+ (instancetype)sharedArrray
{
    static AlarmInfoArray *array = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = [[AlarmInfoArray alloc] init];
        array.muArray = [NSMutableArray array];
        [array recoverDataIfNeeded];
    });
    return array;
}

- (void)recoverDataIfNeeded
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:ALARM_INFO_ARRAY]) {
        [defaults setObject:[NSArray new] forKey:ALARM_INFO_ARRAY];
        [defaults synchronize];
    }
    NSArray *dictArray = [defaults objectForKey:ALARM_INFO_ARRAY];
    for (NSDictionary *dict in dictArray) {
        AlarmInfo *info = [[AlarmInfo alloc] initWithDictionary:dict];
        [self.muArray addObject:info];
    }
}

- (void)addAlarm:(AlarmInfo *)info {
    info.isUnsaved = NO;
    if ([self.muArray containsObject:info]) {
        return;
    }
    [self.muArray addObject:info];
    [self sortArray];
    [self updatePersistenceStore];
}

- (void)removeAlarm:(AlarmInfo *)info {
    if (![info isKindOfClass:[AlarmInfo class]]) {
        NSLog(@"remove alarm failed due to incorrect class");
        return;
    }
    [self.muArray removeObject:info];
    [self updatePersistenceStore];
}

- (void)replaceAlarmAtIndex:(NSUInteger)index withNewInfo:(AlarmInfo *)info {
    if (![info isKindOfClass:[AlarmInfo class]]) {
        NSLog(@"replace alarm failed due to incorrect class");
        return;
    }
    info.isUnsaved = YES;
    [self.muArray replaceObjectAtIndex:index withObject:info];
    [self sortArray];
    [self updatePersistenceStore];
}

- (void)sortArray
{
    [self.muArray sortUsingComparator:^NSComparisonResult(AlarmInfo *info1, AlarmInfo *info2) {
        if (info1.hour != info2.hour) {
            return info1.hour < info2.hour ? NSOrderedAscending : NSOrderedDescending;
        }
        if (info1.minute != info2.minute) {
            return info1.minute < info2.minute ? NSOrderedAscending : NSOrderedDescending;
        }
        // todo: check repeat & label & ...
        return NSOrderedSame;
    }];
}

- (void)updatePersistenceStore
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *dictArray = [NSMutableArray array];
    for (AlarmInfo *info in self.muArray) {
        [dictArray addObject:[info dictionaryRepresentation]];
    }
    [defaults setObject:[dictArray copy] forKey:ALARM_INFO_ARRAY];
    [defaults synchronize];
}

- (NSUInteger)count 
{
    return [self.muArray count];
}

- (AlarmInfo *)alarmAtIndex:(NSInteger)index
{
    if (index < 0 || index > [self count]) {
        return nil;
    }
    return self.muArray[index];
}

@end
