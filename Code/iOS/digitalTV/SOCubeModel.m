//
//  SOCubeModel.m
//  digitalTV
//
//  Created by 李尧 on 2023/2/13.
//

#import "SOCubeModel.h"
#import "UIKit/UIKit.h"

@implementation SOCubeModel

- (void)setColor:(UIColor *)color {
    CIColor *ci = [[CIColor alloc] initWithColor:color];
    self.red = ci.red * 255;
    self.green = ci.green * 255;
    self.blue = ci.blue * 255;
}

- (UIColor *)color {
    return [UIColor colorWithRed:self.red / 255.0 green:self.green / 255.0 blue:self.blue / 255.0 alpha:1];
}

@end
