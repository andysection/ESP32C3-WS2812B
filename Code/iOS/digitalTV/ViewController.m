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

@property (weak, nonatomic) IBOutlet UITextField *durationTF;
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
    if (1) {// 木有数据 初始化状态
        [self saveFrame];
        [self.collectionView reloadData];
    }
    int i = 0xFFFFFF;
    NSLog(@"%d", i);
    int r = i/256/256;
    NSLog(@"%d", r);
    int d = 1 << 8;
    NSLog(@"%d", d);
    i = 255;
    i = (i << 8) + 255;
    i = (i << 8) + 254;
    NSLog(@"%d", i);
    int j = ((i & 0xFF0000) >> 8) >>8;
    NSLog(@"%d", j);
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
    NSLog(@"%d - %d", self.currentIndex, sender.view.tag);
    UIColor *color = CGColorEqualToColor(sender.view.backgroundColor.CGColor, self.currentColor.CGColor)? UIColor.blackColor: self.currentColor;
    if (CGColorEqualToColor(sender.view.backgroundColor.CGColor, self.currentColor.CGColor)) {
        NSLog(@"same color");
    }
    sender.view.backgroundColor = color;
    NSMutableArray *mArr = [self.frames[self.currentIndex][@"map"] mutableCopy];
    mArr[sender.view.tag] = [self getMapWithColor:color];
    NSMutableArray *mFrames = self.frames.mutableCopy;
    mFrames[self.currentIndex] = @{
        @"duration": self.frames[self.currentIndex][@"duration"],
        @"map": mArr.copy
    };
    self.frames = mFrames.copy;
}

- (IBAction)allOffAction:(id)sender {
    for (UIView *view in self.viewDic.allValues) {
        view.backgroundColor = UIColor.blackColor;
    }
    [self saveFrame];
}

- (IBAction)allSetAction:(id)sender {
    for (UIView *view in self.viewDic.allValues) {
        view.backgroundColor = self.currentColor;
    }
    [self saveFrame];
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
    [self saveFrame];
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
    [self saveFrame];
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
        @"color": @([self getR:red G:green B:blue])
    };
    return dic;
}

- (int)getDuration {
    int i = [self.durationTF.text intValue];
    if (i == 0) {
        return 250;
    }
    return i;
}

#pragma mark - save
- (void)saveFrame {
    NSMutableArray *mArr = self.frames.mutableCopy;
    mArr[self.currentIndex] = [self getJsonWithDuration:[self getDuration]];
    self.frames = mArr.copy;
}

- (void)addFrame {
    NSMutableArray *mArr = self.frames.mutableCopy;
    [mArr addObject:[self getJsonWithDuration:[self getDuration]]];
    self.frames = mArr.copy;
    self.currentIndex = self.frames.count - 1;
    
}

- (void)resetData {
    self.frames = @[];
}

- (IBAction)outAction:(id)sender {
    NSString *str = [self.frames yy_modelToJSONString];
    int bgR = 0;
    int bgG = 0;
    int bgB = 0;
    [[NSUserDefaults standardUserDefaults] setValue:str forKey:kJsonKey];
    NSLog(@"%@", str);
}

- (IBAction)loadAction:(id)sender {
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kJsonKey];
    NSArray *arr = nil;
    NSData *jsonData = [str dataUsingEncoding: NSUTF8StringEncoding];
    NSArray *list = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
    if (list.count > 0) {
        self.frames = list;
        self.currentIndex = 0;
    }
}

- (IBAction)saveAction:(id)sender {
    [self saveFrame];
}
- (IBAction)removeAction:(id)sender {
    NSMutableArray *mArr = self.frames.mutableCopy;
    if (mArr.count > 1) {
        [mArr removeLastObject];
    } else {
        return;
    }
    self.frames = mArr.copy;
    self.currentIndex = self.frames.count - 1;
    [self.collectionView reloadData];
}

- (void)showAnimation {
    if (self.currentIndex < self.frames.count) {
        NSDictionary *dic = self.frames[self.currentIndex];
        double time = [dic[@"duration"] doubleValue];
        if (self.currentIndex != self.frames.count - 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time / 1000 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.currentIndex++;
                [self showAnimation];
            });
        }
    } else {
        
    }
}

- (IBAction)animationAction:(id)sender {
    self.currentIndex = 0;
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
        self.currentIndex = indexPath.row;
        [collectionView reloadData];
    } else {
        [self addFrame];
        [collectionView reloadData];
    }
}

- (void)setCurrentIndex:(int)currentIndex {
    _currentIndex = currentIndex;
    NSDictionary *frame = self.frames[_currentIndex];
    NSArray *arr = frame[@"map"];
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *dic = arr[i];
        int rgb = [dic[@"color"] intValue];
        int red = [self getRedFromRGB:rgb];
        int green = [self getGreenFromRGB:rgb];
        int blue = [self getBlueFromRGB:rgb];
        UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        self.viewDic[@(i)].backgroundColor = color;
    }
    [self.collectionView reloadData];
    if (self.frames.count > 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (int)getR:(int)r G:(int)g B:(int)b {
    int i = r;
    i = (i << 8) + g;
    i = (i << 8) + b;
    return i;
}

- (int)getRedFromRGB:(int)rgb {
    return ((rgb & 0xFF0000) >> 8) >>8;
}

- (int)getGreenFromRGB:(int)rgb {
    return (rgb & 0xFF00) >> 8;
}

- (int)getBlueFromRGB:(int)rgb {
    return rgb & 0xFF;
}
@end
