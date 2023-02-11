//
//  ViewController.m
//  digitalTV
//
//  Created by 李尧 on 2023/2/11.
//

#import "ViewController.h"
#import <Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) NSDictionary *viewDic;

@property (nonatomic, strong) UIStackView *grid;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGrid];
}

- (void)setupGrid {
    UIStackView *grid = [[UIStackView alloc] init];
    grid.axis = UILayoutConstraintAxisVertical;
    grid.distribution = UIStackViewDistributionFillEqually;
    grid.spacing = 2;
    int colum = 17;
    int row = 5;
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
}

- (UIColor *)randColor {
    CGFloat red = arc4random_uniform(256) / 255.0;
    CGFloat green = arc4random_uniform(256) / 255.0;
    CGFloat blue = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}



- (void)tapAction:(UITapGestureRecognizer *)sender {
    NSLog(@"%d", sender.view.tag);
    sender.view.backgroundColor = UIColor.orangeColor;
}




@end
