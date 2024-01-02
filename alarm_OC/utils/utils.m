//
//  utils.m
//  alarm_OC
//
//  Created by xywu on 2023/12/28.
//

#import "utils.h"

NSString *const ALARM_INFO_ARRAY = @"ALARM_INFO_ARRAY";

UIImage *resizeImage(UIImage *image, CGSize imageSize) {
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

UIView *setupSeparatorLine(void) {
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = UIColorFromHexString(0x303030);
    return separator;
}
