//
//  WKImageCell.m
//  AoMeiProject
//
//  Created by 吴珂 on 15/7/6.
//  Copyright (c) 2015年 张圆圆. All rights reserved.
//

#import "WKImageCell.h"

@implementation WKImageCell

+ (instancetype)imageCell
{
    return  [[NSBundle mainBundle] loadNibNamed:@"WKImageCell" owner:nil options:nil] [0];
}

- (void)scaleAnimationWithTime:(CGFloat)time
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.imageView.bounds = CGRectMake(0, 0, self.bounds.size.width / 1.5, self.bounds.size.height / 1.5);
    self.imageView.bounds = self.bounds;
//    [UIView animateWithDuration:time animations:^{
//        self.imageView.bounds = self.bounds;
//    }];
    
//    _imageView.layer.backgroundColor = [UIColor whiteColor].CGColor;
//   
//    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    
//    basicAnimation.duration = time;
//    basicAnimation.fromValue = @0.5;
//    basicAnimation.toValue = @1.0f;
//    
//    [basicAnimation setValue:@1.0f forKey:@"toValue"];
//    
//    basicAnimation.delegate = self;
//    
//    [self.imageView.layer addAnimation:basicAnimation forKey:@"scale"];
}

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    [CATransaction begin];
//    
//
//    [CATransaction commit];
//}
- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
    self.bgView.hidden = title.length == 0;
}

@end
