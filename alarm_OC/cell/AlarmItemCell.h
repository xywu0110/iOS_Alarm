//
//  AlarmItemCell.h
//  alarm_OC
//
//  Created by xywu on 2024/1/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AlarmItemDelagate <NSObject>

@optional
- (void)dismissModalVC; // todo

@end


@interface AlarmItemCell : UICollectionViewCell

@property (nonatomic, weak) id<AlarmItemDelagate> delegate;

- (void)loadWithData:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
