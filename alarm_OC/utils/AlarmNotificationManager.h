//
//  AlarmNotificationManager.h
//  alarm_OC
//
//  Created by xywu on 2024/1/21.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import "AlarmInfoArray.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlarmNotificationManager : NSObject

+ (instancetype)defaultManager;

- (void)scheduleAlarmNotification:(AlarmInfo *)alarmInfo;

@end

NS_ASSUME_NONNULL_END
