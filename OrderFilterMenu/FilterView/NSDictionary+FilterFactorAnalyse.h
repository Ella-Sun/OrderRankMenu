//
//  NSDictionary+FilterFactorAnalyse.h
//  OrderFilterMenu
//
//  Created by sunhong on 2016/10/21.
//  Copyright © 2016年 sunhong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DateType){
    DateTypeDefault = 0,    //全部
    //自己添加需要的枚举
};

typedef NS_ENUM(NSInteger, MoneyType){
    MoneyTypeDefault = 0,    //全部
    //自己添加需要的枚举
};

@interface NSDictionary (FilterFactorAnalyse)

@property (nonatomic, strong) NSArray * rankAry;
@property (nonatomic, strong) NSArray * moneyAry;
@property (nonatomic, strong) NSArray * dateAry;

- (NSDictionary *)accordDateTypeGetBeginAndEndDate:(DateType)type;

- (NSDictionary *)accordMoneyTypeGetBeginAndEndMoney:(MoneyType)type;

@end
