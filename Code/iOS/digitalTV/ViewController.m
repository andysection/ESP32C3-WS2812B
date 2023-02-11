//
//  ViewController.m
//  digitalTV
//
//  Created by 李尧 on 2023/2/11.
//

#import "ViewController.h"
#import <Masonry.h>

int colum = 17;
int row = 5;

@interface ViewController ()

@property (nonatomic, strong) NSDictionary<NSNumber *, UIView *> *viewDic;

@property (nonatomic, strong) UIStackView *grid;

@property (weak, nonatomic) IBOutlet UIButton *colorBtn;
@property (nonatomic, strong) UIColor *currentColor;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGrid];
    self.currentColor = [self randColor];
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
        for (int i = 0; i < colum; i++) {
            UIView *view = [UIView new];
            int key = i + colum * j;
            mDic[@(key)] = view;
            view.backgroundColor = [self randColor];
            view.tag = key;
            [stack addArrangedSubview:view];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [view addGestureRecognizer:tap];
        }
        [grid addArrangedSubview:stack];
    }
    
    self.grid = grid;
    grid.backgroundColor = UIColor.blackColor;
    [self.view addSubview:grid];
    [self.grid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(12);
        make.height.mas_equalTo(row * 40 + (row - 1) * 2);
        make.left.offset(40);
        make.width.mas_equalTo(40 * colum+ (colum - 1) * 2);
    }];
    self.grid.layer.borderColor = UIColor.blackColor.CGColor;
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
    sender.view.backgroundColor = self.currentColor;
}

- (IBAction)allOffAction:(id)sender {
    for (UIView *view in self.viewDic.allValues) {
        view.backgroundColor = UIColor.darkGrayColor;
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
    for (int i = 0; i < colum; i++) {
        for (int j = 0; j < row; j ++) {
            int index = i + j * colum;
            if (i == colum - 1) {
                self.viewDic[@(index)].backgroundColor = UIColor.darkGrayColor;
            } else {
                self.viewDic[@(index)].backgroundColor = self.viewDic[@(index  + 1)].backgroundColor;
            }
        }
    }
}

- (IBAction)rightPush:(UIButton *)sender {
    for (int i = colum - 1; i > -1; i--) {
        for (int j = 0; j < row; j ++) {
            int index = i + j * colum;
            if (i == 0) {
                self.viewDic[@(index)].backgroundColor = UIColor.darkGrayColor;
            } else {
                self.viewDic[@(index)].backgroundColor = self.viewDic[@(index  - 1)].backgroundColor;
            }
        }
    }
}


@end
