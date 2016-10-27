//
//  LimitFilterView.h
//  OrderFilterMenu
//
//  Created by sunhong on 2016/9/12.
//  Copyright © 2016年 sunhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LimitFilterView : UIView

@property (nonatomic, copy) void(^LimitFilterBlock)(NSInteger, NSInteger);
//如果父视图的Y值不是从0开始——>决定maskview
@property (nonatomic, assign) CGFloat customeMaskYpixel;
//点击按钮事件
@property (nonatomic, copy) void(^ClickButtonBlock)();

/**
 *  创建后面半透明遮罩视图
 *
 *  @param view  遮罩视图所在的父视图
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
                    superView:(UIView *)view;

//点击不同筛选
- (void)tapFilterAction:(UIButton *)sender;


/**
 不进行传值的非正常消失
 */
- (void)filterViewDismiss;


@end
