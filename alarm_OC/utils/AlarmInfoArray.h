//
//  AlarmInfoArray.h
//  alarm_OC
//
//  Created by xywu on 2024/1/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlarmInfoArray : NSObject

+ (NSArray *)getInfoArray;
+ (NSInteger)count;

+ (void)addAlarm:(NSDictionary *)info;
+ (void)removeAlarm:(NSDictionary *)info;
+ (void)replaceAlarmAtIndex:(NSUInteger)index withNewInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
