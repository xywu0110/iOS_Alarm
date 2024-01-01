//
//  AddAlarmViewController.h
//  alarm_OC
//
//  Created by xywu on 2023/12/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AddAlarmDelagate <NSObject>

@optional
- (void)dismissModalVC;

@end


@interface AddAlarmViewController : UIViewController

@property (nonatomic, weak) id<AddAlarmDelagate> delegate;

- (void)showAlarmConfigWithCurrentTime;
- (void)showAlarmConfigWithInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
