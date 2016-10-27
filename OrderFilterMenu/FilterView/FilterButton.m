//
//  FilterButton.h
//  OrderFilterMenu
//
//  Created by sunhong on 2016/9/22.
//  Copyright © 2016年 sunhong. All rights reserved.
//

#import "FilterButton.h"

@implementation FilterButton

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    CGFloat imageWidth = 20.f;
    //(height + 14.f) * 0.5 - imageWidth
    CGFloat imageY = (height - imageWidth) * 0.5;
    self.titleLabel.frame = CGRectMake(0, 0, width, height);
    self.imageView.frame = CGRectMake(width*0.75, imageY, imageWidth, imageWidth);
}

@end
