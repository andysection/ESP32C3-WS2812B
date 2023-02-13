//
//  SOCubeModel.h
//  digitalTV
//
//  Created by 李尧 on 2023/2/13.
//

#import <Foundation/Foundation.h>

@class UIColor;
@interface SOCubeModel : NSObject

@property (nonatomic, assign) int red;
@property (nonatomic, assign) int green;
@property (nonatomic, assign) int blue;

@property (nonatomic, assign) int row;
@property (nonatomic, assign) int column;


- (UIColor *)color;
- (void)setColor:(UIColor *)color;

@end

//@interface SOFrameModel : NSObject
///// 毫秒
//@property (nonatomic, assign) int time;
///// 5 * 17数据矩阵
//@property (nonatomic, strong) NSArray<SOCubeModel *> *cubes;
//
//@end
//
//@interface SOAnimationModel : NSObject
///// 帧集合
//@property (nonatomic, strong) NSArray<SOFrameModel *> *frames;
//
//@end
