//
//  NSDictionary+FilterFactorAnalyse.m
//  OrderFilterMenu
//
//  Created by sunhong on 2016/10/21.
//  Copyright © 2016年 sunhong Funds Management. All rights reserved.
//

#import "NSDictionary+FilterFactorAnalyse.h"

@implementation NSDictionary (FilterFactorAnalyse)

@dynamic rankAry;
@dynamic moneyAry;
@dynamic dateAry;

- (NSArray *)rankAry {
    
    return @[];
}

- (NSArray *)moneyAry {

    return @[@"全部",@"1000以内",@"10000以内",@"1万~10万及以内",@"10万~50万及以内",@"50万以上"];
}

- (NSArray *)dateAry {
    
    return  @[@"全部",@"当日",@"本周内",@"本月内",@"上月内"];
}

- (NSString *)accordRankIndexGetRankSerialNum:(NSInteger)rankIndex andRankType:(NSInteger)type {
    switch (rankIndex) {
        case 1:{//金额
            if (type == 1) {//UP
                ;
            } else if (type == 2) {//DROW
                ;
            }
        }
            break;
        case 2:{//日期
            if (type == 1) {//UP
                ;
            } else if (type == 2) {//DROW
                ;
            }
        }
            break;
        default:{//默认排序
            
        }
            break;
    }
    return @"";
}

/**
 根据选择日期返回开始日期结束日期
 
 @param type 日期类型
 
 @return 字典{@"start",@"end"}
 */
- (NSDictionary *)accordDateTypeGetBeginAndEndDate:(DateType)type {
    
    NSString *startDateStr, *endDateStr;
    switch (type) {
        case DateTypeDefault: //全部
        {
            //自己添加需要
        }
            break;
        //自己添加需要的枚举
        default: // 全部
        {
            
        }
            break;
    }
    NSDictionary *dateDic = @{@"start":startDateStr,
                              @"end":endDateStr};
    return dateDic;
}



/**
 根据选择金额返回最大值最小值
 
 @param type 金额类型
 
 @return 字典{@"min",@"max"}
 */
- (NSDictionary *)accordMoneyTypeGetBeginAndEndMoney:(MoneyType)type {
    
    NSString *minAmountStr, *maxAmountStr;
    switch (type) {
        case MoneyTypeDefault: //// 全部
        {
            minAmountStr = nil;
            maxAmountStr = nil;
        }
            break;
        
        //自己添加需要的枚举
        default:
        {
            minAmountStr = nil;
            maxAmountStr = nil;
        }
            break;
    }
    NSDictionary *dateDic = @{@"min":minAmountStr,
                              @"max":maxAmountStr};
    return dateDic;
}

@end
