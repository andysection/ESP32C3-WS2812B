//
//  SecColorVC.m
//  digitalTV
//
//  Created by 李尧 on 2023/2/11.
//

#import "SecColorVC.h"
#import "Palette.h"
#import <Masonry.h>

@interface SecColorVC ()

@property (strong, nonatomic) IBOutlet Palette *paletteMainView;

@end

@implementation SecColorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paletteMainView = [[Palette alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self.view addSubview:self.paletteMainView];
    [self.paletteMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.mas_equalTo(200);
    }];
    
    self.paletteMainView.backgroundColor=[UIColor clearColor];
    self.paletteMainView.delegate=self;
}

#pragma mark 取色板代理方法
-(void)patette:(Palette *)patette choiceColor:(UIColor *)color colorPoint:(CGPoint)colorPoint{
//    self.choicesColorView.backgroundColor=color;
}

@end
