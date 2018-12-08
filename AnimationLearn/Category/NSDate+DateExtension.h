//
//  NSDate+DateExtension.h
//  QHCategorys
//
//  Created by imqiuhang on 15/2/10.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

typedef NS_OPTIONS(NSInteger, BSDateFormatterEnum) {
    BSDateFormatterEnumMMDD         = 0,/// 08-21
    BSDateFormatterEnumMMDDHH       = 1,/// 08-21 14时
    BSDateFormatterEnumMMDDHHSS     = 2,/// 08-21 14:28
    
    BSDateFormatterEnumYYYY         = 3,/// 2017年
    BSDateFormatterEnumYYYYMM       = 4,/// 2017年08月
    BSDateFormatterEnumYYYYMMDD     = 5,/// 2017-08-21
    BSDateFormatterEnumYYYYMMDDHH   = 6,/// 2017-08-21 14时
    BSDateFormatterEnumYYYYMMDDHHSS = 7,/// 2017-08-21 14:28
    
};



@interface NSDate (DateExtension)

#pragma mark - Component Properties

@property (nonatomic, readonly) NSInteger year;///年
@property (nonatomic, readonly) NSInteger month; ///月  (1~12)
@property (nonatomic, readonly) NSInteger day; ///日  (1~31)
@property (nonatomic, readonly) NSInteger hour; ///小时  (0~23)
@property (nonatomic, readonly) NSInteger minute; ///分  (0~59)
@property (nonatomic, readonly) NSInteger second; ///秒  (0~59)
@property (nonatomic, readonly) NSInteger nanosecond; ///纳秒
@property (nonatomic, readonly) NSInteger weekday; ///平日(1~7,初始是星期几根据用户系统设定)
@property (nonatomic,strong,readonly)NSString *weekdaySring;///周一~周日
@property (nonatomic, readonly) NSInteger weekdayOrdinal; /// 在下一个更大的日历单元中的位置
@property (nonatomic, readonly) NSInteger weekOfMonth; ///在月份中第几星期(1~5)
@property (nonatomic, readonly) NSInteger weekOfYear; ///在年份中是第几星期(1~53)
@property (nonatomic, readonly) NSInteger yearForWeekOfYear;
@property (nonatomic, readonly) NSInteger quarter; ///季度
@property (nonatomic, readonly) BOOL isLeapMonth; ///是否是闰月
@property (nonatomic, readonly) BOOL isLeapYear; /// 是否是闰年
@property (nonatomic, readonly) BOOL isToday; /// 是否是今天
@property (nonatomic, readonly) BOOL isYesterday;///是否是昨天


#pragma mark - creat
/*服务端都是以毫秒为准的，所以创建应该由该方法 以便于日后方便修改*/
+ (NSDate *)dateWithMillisecondTimeIntervalSince1970:(NSTimeInterval)millisecond;
- (NSTimeInterval)millisecondTimeIntervalSince1970;

#pragma mark - Date modify

- (NSDate *)dateByAddingYears:(NSInteger)years;///加几年
- (NSDate *)dateByAddingMonths:(NSInteger)months;///加几个月
- (NSDate *)dateByAddingWeeks:(NSInteger)weeks;///加几个星期
- (NSDate *)dateByAddingDays:(NSInteger)days;///加几天
- (NSDate *)dateByAddingHours:(NSInteger)hours;///加几小时
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes;///加几分钟
- (NSDate *)dateByAddingSeconds:(NSInteger)seconds;///加几秒钟
- (NSDate *)dateByDecreaseMinutes:(NSInteger)minutes;///减少几分钟
- (NSDate *)dateByDecreaseDays:(NSInteger)days;///减少几天

#pragma mark - Date Format

///Date转String
- ( NSString *)stringWithFormat:(NSString *)format;
- ( NSString *)stringWithFormatterEnum:(BSDateFormatterEnum )dateFormatterEnum;

///时间戳转String
+ (NSString *)stringWithTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format;
+ (NSString *)stringWithTimeInterval:(NSTimeInterval)timeInterval dateFormatterEnum:(BSDateFormatterEnum )dateFormatterEnum;

///string转date
+ ( NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;
+ ( NSDate *)dateWithString:(NSString *)dateString dateFormatterEnum:(BSDateFormatterEnum)dateFormatterEnum;

///时间戳date
+ ( NSDate *)dateWithTimeInterval:(NSTimeInterval)timeInterval;

@end

