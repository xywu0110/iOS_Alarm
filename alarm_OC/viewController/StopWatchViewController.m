//
//  StopWatchViewController.m
//  alarm_OC
//
//  Created by xywu on 2023/12/22.
//

#import "StopWatchViewController.h"

@interface StopWatchViewController ()

@end

@implementation StopWatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"StopWatch";
}

@end
