//
//  AlarmItemCell.h
//  alarm_OC
//
//  Created by xywu on 2024/1/1.
//

#import <UIKit/UIKit.h>
#import "AlarmInfoArray.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AlarmItemDelagate <NSObject>

- (void)onTapSwitch:(NSInteger)index newState:(BOOL)isAlarmOn;
- (void)onTapCell:(NSInteger)index;

@end


@interface AlarmItemCell : UICollectionViewCell

@property (nonatomic, weak) id<AlarmItemDelagate> delegate;

- (void)updateWithInfo:(AlarmInfo *)info index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
