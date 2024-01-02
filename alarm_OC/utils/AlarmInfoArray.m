//
//  AlarmInfoArray.m
//  alarm_OC
//
//  Created by xywu on 2024/1/1.
//

#import "AlarmInfoArray.h"
#import "utils.h"

@interface AlarmInfoArray ()

@property (class, nonatomic, strong) NSMutableArray *infoArray;

@end

@implementation AlarmInfoArray

static NSMutableArray *_infoArray = nil;

+ (NSArray *)getInfoArray {
    return [self.infoArray copy];
}

+ (NSInteger)count {
    return [self.infoArray count];
}

+ (void)addAlarm:(NSDictionary *)info {
    if (![info isKindOfClass:[NSDictionary class]] || [self.infoArray containsObject:info]) {
        return;
    }
    [self.infoArray addObject:info];
    [self sortArray];
    [self updatePersistenceStore];
}

+ (void)removeAlarm:(NSDictionary *)info {
    if (![info isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Incorrect class!");
        return;
    }
    [self.infoArray removeObject:info];
    [self updatePersistenceStore];
}

+ (void)replaceAlarmAtIndex:(NSUInteger)index withNewInfo:(NSDictionary *)info {
    if (![info isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Incorrect class!");
        return;
    }
    [self.infoArray replaceObjectAtIndex:index withObject:info];
    [self sortArray];
    [self updatePersistenceStore];
}

+ (void)sortArray {
    [self.infoArray sortUsingComparator:^NSComparisonResult(NSDictionary *dict1, NSDictionary *dict2) {
        // todo: following code will cause exception when some dict doesn't have expected paramater
        NSInteger hour1 = [[dict1 objectForKey:@"hour"] integerValue];
        NSInteger hour2 = [[dict1 objectForKey:@"hour"] integerValue];
        NSInteger minute1 = [[dict1 objectForKey:@"minute"] integerValue];
        NSInteger minute2 = [[dict1 objectForKey:@"minute"] integerValue];
        if (hour1 != hour2) {
            return hour1 < hour2 ? NSOrderedAscending : NSOrderedDescending;
        }
        if (minute1 != minute2) {
            return minute1 < minute2 ? NSOrderedAscending : NSOrderedDescending;
        }
        // todo: check repeat & label & ...
        return NSOrderedSame;
    }];
}

+ (void)updatePersistenceStore {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.infoArray copy] forKey:ALARM_INFO_ARRAY];
    [defaults synchronize];
}

+ (NSMutableArray *)infoArray {
    if (!_infoArray) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults objectForKey:ALARM_INFO_ARRAY]) {
            [defaults setObject:[NSArray new] forKey:ALARM_INFO_ARRAY];
            [defaults synchronize];
        }
        NSArray *array = [defaults objectForKey:ALARM_INFO_ARRAY];
        _infoArray = [array mutableCopy];
    }
    return _infoArray;
}

+ (void)setInfoArray:(NSMutableArray *)array {
    _infoArray = array;
}

@end
