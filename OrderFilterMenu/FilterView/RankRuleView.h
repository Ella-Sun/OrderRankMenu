//
//  RankRuleView.h
//  OrderFilterMenu
//
//  Created by sunhong on 2016/10/19.
//  Copyright © 2016年 sunhong Funds Management. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankRuleView : UIView

//筛选参数 排序的序列号，金额的范围，日期的范围
@property (nonatomic, copy) void(^FilterBlock)(NSString *,NSInteger, NSInteger);

/**
 初始化方法

 已经定义排序三个条件
 */
- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)view;


@end
