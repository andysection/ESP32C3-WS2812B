//
//  SOFrameCell.m
//  digitalTV
//
//  Created by 李尧 on 2023/2/13.
//

#import "SOFrameCell.h"

@interface SOFrameCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SOFrameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.title.layer.borderColor = UIColor.orangeColor.CGColor;
    self.imageView.layer.borderColor = UIColor.orangeColor.CGColor;
    self.title.layer.cornerRadius = 4;
}

- (void)setTitle:(NSString *)title image:(UIImage *)image {
    self.title.text = title;
    self.imageView.image = image;
}

- (void)setIsCurrent:(BOOL)isCurrent {
    _isCurrent = isCurrent;
    self.title.layer.borderWidth = isCurrent? 2: 0;
}

@end
