//
//  utils.h
//  alarm_OC
//
//  Created by xywu on 2023/12/26.
//


#include <UIKit/UIKit.h>

UIImage *resizeImage(UIImage *image, CGSize imageSize);

#ifndef UIColorFromHexString
#define UIColorFromHexString(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
#endif

#ifndef isValidStr
#define isValidStr(str) (str && [str isKindOfClass:[NSString class]] && (((NSString *)str).length != 0))
#endif

extern NSString *const ALARM_INFO_ARRAY;
