//
//  utils.h
//  alarm_OC
//
//  Created by xywu on 2023/12/26.
//


#include <UIKit/UIKit.h>

#ifndef UIColorFromHexString
#define UIColorFromHexString(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
#endif

#ifndef isValidStr
#define isValidStr(str) (str && [str isKindOfClass:[NSString class]] && (((NSString *)str).length != 0))
#endif

#ifndef isValidHour
#define isValidHour(hour) (hour >= 0 && hour <= 23)
#endif

#ifndef isValidMinute
#define isValidMinute(minute) (minute >= 0 && minute <= 59)
#endif

extern NSString *const ALARM_INFO_ARRAY;

UIImage *resizeImage(UIImage *image, CGSize imageSize);

UIView *setupSeparatorLine(void);
