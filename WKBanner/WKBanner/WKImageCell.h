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

+ (instancetype)imageCell;
@end
