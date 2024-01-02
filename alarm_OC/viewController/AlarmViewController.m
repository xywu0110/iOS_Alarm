//
//  AlarmViewController.m
//  alarm_OC
//
//  Created by xywu on 2023/12/22.
//

#import "AlarmViewController.h"
#import "AddAlarmViewController.h"
#import "utils.h"
#import "AlarmTitleCell.h"
#import "AlarmItemCell.h"
#import "AlarmInfoArray.h"
#import <Masonry/Masonry.h>

@interface AlarmViewController () <AddAlarmDelagate, AlarmItemDelagate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) AddAlarmViewController *addAlarmVC;

@property(nonatomic, strong) UIBarButtonItem *editButton;
@property(nonatomic, strong) UIBarButtonItem *moreButton;

@property(nonatomic, strong) UICollectionView *collectionView;

@end


@implementation AlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

// MARK: UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    [self setupNavigationBar];
    [self setupCollectionView];
}

- (void)setupNavigationBar {
    self.navigationItem.leftBarButtonItem = self.editButton;
    self.navigationItem.rightBarButtonItem = self.moreButton;
}

- (void)setupCollectionView {
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    [self.collectionView registerClass:[AlarmTitleCell class] forCellWithReuseIdentifier:@"alarmTitleCell"];
    [self.collectionView registerClass:[AlarmItemCell class] forCellWithReuseIdentifier:@"alarmItemCell"];
}

// MARK: event
- (void)onClickEdit {
    // todo
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)onClickMore {
    [self showModalVCWithCurrentTime];
}

- (void)showModalVCWithCurrentTime {
    [self presentViewController:self.addAlarmVC animated:YES completion:nil];
    [self.addAlarmVC showAlarmConfigWithCurrentTime];
}

- (void)showModalVCWithAlarmInfo:(NSDictionary *)info {
    [self presentViewController:self.addAlarmVC animated:YES completion:nil];
    [self.addAlarmVC showAlarmConfigWithInfo:info];
}

- (void)dismissModalVC {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.collectionView reloadData];   // todo: cells got polluted
}

- (NSDictionary *)getAlarmInfoAtIndex:(NSInteger)index {
    if (index < 0 || index >= [AlarmInfoArray count]) {
        return @{};
    }
    return [AlarmInfoArray getInfoArray][index];
}

// MARK: delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [AlarmInfoArray count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    NSInteger index = indexPath.item;
    if (index == 0) {
        AlarmTitleCell *titleCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"alarmTitleCell" forIndexPath:indexPath];
        [titleCell loadWithTitle:@"Alarms"];
        cell = titleCell;
    } else {
        AlarmItemCell *itemCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"alarmItemCell" forIndexPath:indexPath];
        itemCell.delegate = self;
        [itemCell loadWithData:[self getAlarmInfoAtIndex:index-1]];
        cell = itemCell;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (indexPath.item == 0) {
        return CGSizeMake(screenWidth, 80);
    } else {
        return CGSizeMake(screenWidth, 60);
    }
}

// MARK: getter
- (AddAlarmViewController *)addAlarmVC {
    if (!_addAlarmVC) {
        _addAlarmVC = [[AddAlarmViewController alloc] init];
        _addAlarmVC.modalPresentationStyle = UIModalPresentationPageSheet;
        _addAlarmVC.delegate = self;
    }
    return _addAlarmVC;
}

- (UIBarButtonItem *)editButton {
    if (!_editButton) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Edit"];
        [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexString(0xFFA500) range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:NSMakeRange(0, attributedString.length)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setAttributedTitle:attributedString forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(onClickEdit) forControlEvents:UIControlEventTouchUpInside];
        _editButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _editButton;
}

- (UIBarButtonItem *)moreButton {
    if (!_moreButton) {
        UIImage *moreIcon = resizeImage([UIImage imageNamed:@"more"], CGSizeMake(23, 23));
        moreIcon = [moreIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _moreButton = [[UIBarButtonItem alloc] initWithImage:moreIcon style:UIBarButtonItemStylePlain target:self action:@selector(onClickMore)];
    }
    return _moreButton;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

@end
