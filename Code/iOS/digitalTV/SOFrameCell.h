//
//  SOFrameCell.h
//  digitalTV
//
//  Created by 李尧 on 2023/2/13.
//

#import <UIKit/UIKit.h>

@interface SOFrameCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isCurrent;

- (void)setTitle:(NSString *)title image:(UIImage *)image;

@end

