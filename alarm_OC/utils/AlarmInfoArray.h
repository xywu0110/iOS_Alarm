//
//  AlarmInfoArray.h
//  alarm_OC
//
//  Created by xywu on 2024/1/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlarmInfo : NSObject

@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSMutableArray *repeatOptions;
@property (nonatomic, assign) BOOL snooze;
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, assign) BOOL isUnsaved;

- (instancetype)mutableCopy;
- (instancetype)initWithCurrentTime;

@end

@interface AlarmInfoArray : NSObject

@property (nonatomic, readonly) NSUInteger count;

//- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject NS_UNAVAILABLE;
//- (void)addObject:(id)anObject NS_UNAVAILABLE;

+ (instancetype)sharedArrray;

- (void)addAlarm:(AlarmInfo *)info;
- (void)removeAlarm:(AlarmInfo *)info;
- (void)replaceAlarmAtIndex:(NSUInteger)index withNewInfo:(AlarmInfo *)info;
- (void)updatePersistenceStore;
- (AlarmInfo *)alarmAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
