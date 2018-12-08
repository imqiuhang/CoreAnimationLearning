//
//  NSDate+DateExtension.m
//  QHCategorys
//
//  Created by imqiuhang on 15/2/10.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "NSDate+DateExtension.h"
#import <time.h>



@implementation NSDate (DateExtension)

- (NSInteger)year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)nanosecond {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

- (NSInteger)weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSString *)weekdaySring {
    return [@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"] qh_objAtIndex:self.weekday-1];
}

- (NSInteger)weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)weekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)yearForWeekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

- (NSInteger)quarter {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

- (BOOL)isLeapMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL)isLeapYear {
    NSUInteger year = self.year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate new].day == self.day;
}

- (BOOL)isYesterday {
    NSDate *added = [self dateByAddingDays:1];
    return [added isToday];
}

+ (NSDate *)dateWithMillisecondTimeIntervalSince1970:(NSTimeInterval)millisecond {
    return [NSDate dateWithTimeIntervalSince1970:millisecond/1000];
}
- (NSTimeInterval)millisecondTimeIntervalSince1970 {
    return self.timeIntervalSince1970*1000;
}

- (NSDate *)dateByAddingYears:(NSInteger)years {
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingWeeks:(NSInteger)weeks {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByDecreaseMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] - 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByDecreaseDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] - 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingSeconds:(NSInteger)seconds {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

- ( NSString *)stringWithFormatterEnum:(BSDateFormatterEnum )dateFormatterEnum {
    return [self stringWithFormat:[[self class] dateFormatterStringWithEnum:dateFormatterEnum]];
}

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

+ (NSString *)stringWithTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format {
    
    
    if (![format isNotBlank]) {
        return nil;
    }
    
    NSDate *date = [self dateWithTimeInterval:timeInterval];
    if (!date) {
        return nil;
    }
    
    return [date stringWithFormat:format];
}

+ (NSString *)stringWithTimeInterval:(NSTimeInterval)timeInterval dateFormatterEnum:(BSDateFormatterEnum )dateFormatterEnum {
    
    NSString *dateFormatter = [self dateFormatterStringWithEnum:dateFormatterEnum]?[self dateFormatterStringWithEnum:dateFormatterEnum]:[self dateFormatterStringWithEnum:BSDateFormatterEnumYYYYMMDDHHSS];
    return [self stringWithTimeInterval:timeInterval format:dateFormatter];
}

+ ( NSDate *)dateWithString:(NSString *)dateString dateFormatterEnum:(BSDateFormatterEnum)dateFormatterEnum {
    return [self dateWithString:dateString format:[self dateFormatterStringWithEnum:dateFormatterEnum]];
}

+ (NSDate *)dateWithTimeInterval:(NSTimeInterval)timeInterval {
    
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

+ (NSString *)dateFormatterStringWithEnum:(BSDateFormatterEnum)dateFormatterEnum {
    NSDictionary *dateFormatterTypeDic = @{@(BSDateFormatterEnumMMDD) : @"MM-dd",
                                           @(BSDateFormatterEnumMMDDHH) : @"MM-dd HH时",
                                           @(BSDateFormatterEnumMMDDHHSS) : @"MM-dd HH:mm",
                                           @(BSDateFormatterEnumYYYY) : @"YYYY年",
                                           @(BSDateFormatterEnumYYYYMM) : @"YYYY年MM月",
                                           @(BSDateFormatterEnumYYYYMMDD) : @"YYYY-MM-dd",
                                           @(BSDateFormatterEnumYYYYMMDDHH) : @"YYYY-MM-dd HH时",
                                           @(BSDateFormatterEnumYYYYMMDDHHSS) : @"YYYY-MM-dd HH:mm",
                                           };
    return dateFormatterTypeDic[@(dateFormatterEnum)];
}

@end
