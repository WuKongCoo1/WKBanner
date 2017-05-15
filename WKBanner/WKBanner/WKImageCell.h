//
//  WKImageCell.h
//  AoMeiProject
//
//  Created by 吴珂 on 15/7/6.
//  Copyright (c) 2015年 张圆圆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

/**
 For资讯
 */
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *titleLabelRight;//标题右侧间距
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *bgView;

+ (instancetype)imageCell;

- (void)scaleAnimationWithTime:(CGFloat)time;
- (void)setTitle:(NSString *)title;

@end
