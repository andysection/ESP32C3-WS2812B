//
//  ViewController.m
//  digitalTV
//
//  Created by 李尧 on 2023/2/11.
//

#import "ViewController.h"
#import <Masonry.h>
#import <YYModel.h>
#import "SOFrameCell.h"

int column = 17;
int row = 5;
NSString *kJsonKey = @"com.json.key";
NSString *cellId = @"cellId";

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSDictionary<NSNumber *, UIView *> *viewDic;

@property (nonatomic, strong) UIStackView *grid;

@property (weak, nonatomic) IBOutlet UIView *gridView;
@property (weak, nonatomic) IBOutlet UIView *trackView;
@property (weak, nonatomic) IBOutlet UIButton *colorBtn;
@property (nonatomic, strong) UIColor *currentColor;

@property (nonatomic, strong) NSArray *frames;

@property (nonatomic, assign) int currentIndex;

@property (nonatomic, strong) UICollectionView *collectionView;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGrid];
    self.currentColor = [self randColor];
    self.frames = @[];
    [self initTrack];
    self.currentIndex = 0;
    if (1) {// 木有数据 初始化状态
        [self saveFrame];
        [self.collectionView reloadData];
    }
}

- (void)setupGrid {
    UIStackView *grid = [[UIStackView alloc] init];
    grid.axis = UILayoutConstraintAxisVertical;
    grid.distribution = UIStackViewDistributionFillEqually;
    grid.spacing = 2;

    NSMutableDictionary *mDic = @{}.mutableCopy;
    for (int j = 0; j < row; j ++) {
        UIStackView *stack = [[UIStackView alloc] init];
        stack.axis = UILayoutConstraintAxisHorizontal;
        stack.distribution = UIStackViewDistributionFillEqually;
        stack.spacing = 2;
        for (int i = 0; i < column; i++) {
            UIView *view = [UIView new];
            int key = i + column * j;
            mDic[@(key)] = view;
            view.backgroundColor = UIColor.blackColor;
            view.tag = key;
            [stack addArrangedSubview:view];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [view addGestureRecognizer:tap];
        }
        [grid addArrangedSubview:stack];
    }
    
    self.grid = grid;
    grid.backgroundColor = UIColor.darkGrayColor;
    [self.gridView addSubview:grid];
    [self.grid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.offset(0);
//        make.top.offset(12);
//        make.height.mas_equalTo(row * 40 + (row - 1) * 2);
//        make.left.offset(40);
//        make.width.mas_equalTo(40 * colum+ (colum - 1) * 2);
    }];
    self.grid.layer.borderColor = UIColor.darkGrayColor.CGColor;
    self.grid.layer.borderWidth = 2;
    self.viewDic = mDic.copy;
}

- (UIColor *)randColor {
    CGFloat red = arc4random_uniform(256) / 255.0;
    CGFloat green = arc4random_uniform(256) / 255.0;
    CGFloat blue = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    NSLog(@"%d", sender.view.tag);
    if (sender.view.backgroundColor == self.currentColor) {
        sender.view.backgroundColor = UIColor.blackColor;
    } else {
        sender.view.backgroundColor = self.currentColor;
    }
}

- (IBAction)allOffAction:(id)sender {
    for (UIView *view in self.viewDic.allValues) {
        view.backgroundColor = UIColor.blackColor;
    }
}

- (IBAction)allSetAction:(id)sender {
    for (UIView *view in self.viewDic.allValues) {
        view.backgroundColor = self.currentColor;
    }
}

- (IBAction)currentColor:(UIButton *)sender {
    sender.backgroundColor = [self randColor];
    self.currentColor = sender.backgroundColor;
}

- (void)setCurrentColor:(UIColor *)currentColor {
    _currentColor = currentColor;
    self.colorBtn.backgroundColor = currentColor;
}

- (IBAction)leftPush:(UIButton *)sender {
    for (int i = 0; i < column; i++) {
        for (int j = 0; j < row; j ++) {
            int index = i + j * column;
            if (i == column - 1) {
                self.viewDic[@(index)].backgroundColor = UIColor.blackColor;
            } else {
                self.viewDic[@(index)].backgroundColor = self.viewDic[@(index  + 1)].backgroundColor;
            }
        }
    }
}

- (IBAction)rightPush:(UIButton *)sender {
    for (int i = column - 1; i > -1; i--) {
        for (int j = 0; j < row; j ++) {
            int index = i + j * column;
            if (i == 0) {
                self.viewDic[@(index)].backgroundColor = UIColor.blackColor;
            } else {
                self.viewDic[@(index)].backgroundColor = self.viewDic[@(index  - 1)].backgroundColor;
            }
        }
    }
}

- (NSDictionary *)getJsonWithDuration:(int)duration {
    NSMutableArray *marr = @[].mutableCopy;
    for (int i = 0; i < (row + 1) * (column + 1); i++) {
        UIColor *color = self.viewDic[@(i)].backgroundColor;
        [marr addObject:[self getMapWithColor:color]];
    }
    NSDictionary *dict = @{
        @"duration": @(duration),
        @"map": marr.copy
    };
    return dict;
}

- (NSDictionary *)getMapWithColor:(UIColor *)color {
    CIColor *ci = [[CIColor alloc] initWithColor:color];
    int red = ci.red * 255;
    int green = ci.green * 255;
    int blue = ci.blue * 255;
    NSDictionary *dic = @{
        @"red": @(red),
        @"green": @(green),
        @"blue": @(blue),
    };
    return dic;
}

#pragma mark - save
- (void)saveFrame {
    NSMutableArray *mArr = self.frames.mutableCopy;
    [mArr addObject:[self getJsonWithDuration:1000]];
    self.frames = mArr.copy;
}

- (void)resetData {
    self.frames = @[];
}

- (IBAction)outAction:(id)sender {
    NSString *str = [self.frames yy_modelToJSONString];
    NSLog(@"%@", str);
}

- (IBAction)saveAction:(id)sender {
    [self saveFrame];
}

- (void)showAnimation {
    NSArray *arr = self.frames;
    if (self.currentIndex < arr.count) {
        NSDictionary *dic = arr[self.currentIndex];
        double time = [dic[@"duration"] doubleValue];
        NSArray *map = dic[@"map"];
        for (int i = 0; i < map.count; i++) {
            int red = [dic[@"red"] intValue];
            int green = [dic[@"green"] intValue];
            int blue = [dic[@"blue"] intValue];
            UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
            self.viewDic[@(i)].backgroundColor = color;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time / 1000 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showAnimation];
        });
        self.currentIndex ++;
    } else {
        self.currentIndex = 0;
    }
}

- (IBAction)animationAction:(id)sender {
    [self showAnimation];
}

#pragma mark - 帧数栏
- (void)initTrack {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.itemSize = CGSizeMake(90, 40);
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.minimumInteritemSpacing = 10;
    flow.minimumLineSpacing = 10;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SOFrameCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    [self.trackView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.frames.count + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SOFrameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (indexPath.row < self.frames.count) {
        NSString *str = @(indexPath.row).stringValue;
        [cell setTitle:str image:nil];
        cell.isCurrent = indexPath.row == self.currentIndex;
    } else {
        [cell setTitle:@"添加 "image:nil];
        cell.isCurrent = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.frames.count) {
        if (indexPath.row == self.currentIndex) return;
        NSDictionary *frame = self.frames[indexPath.row];
        NSArray *arr = frame[@"map"];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            int red = [dic[@"red"] intValue];
            int green = [dic[@"green"] intValue];
            int blue = [dic[@"blue"] intValue];
            UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
            self.viewDic[@(i)].backgroundColor = color;
        }
        self.currentIndex = indexPath.row;
        [collectionView reloadData];
    } else {
        [self saveFrame];
        [collectionView reloadData];
    }
}

@end
