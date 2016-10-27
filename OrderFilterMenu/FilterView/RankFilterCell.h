//
//  RankFilterCell.h
//  OrderFilterMenu
//
//  Created by sunhong on 2016/10/20.
//  Copyright © 2016年 sunhong Funds Management. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonStatusStyle){
    ButtonStatusStyleDefault = 1, //默认按钮状态 灰色
    ButtonStatusStyleUp,            //按钮 被奇数次点击 箭头向上
    ButtonStatusStyleDown,          //按钮 被偶数次点击 箭头向下
    ButtonStatusStyleNonImage,       //按钮 没有箭头
};

@interface RankFilterCell : UITableViewCell

@property (nonatomic, copy) NSString * btnTitle;
@property (nonatomic, assign) ButtonStatusStyle style;

+ (instancetype)cellWithTableView:(UITableView *)tableView
                     withIdenfier:(NSString *)identifier;

@end
