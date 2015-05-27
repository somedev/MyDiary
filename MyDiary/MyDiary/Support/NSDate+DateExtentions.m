//
//  NSDate+DateExtentions.h
//  MyDiary
//
//  Created by Eduard Panasiuk on 18.03.14.
//  Copyright (c) 2014 Eduard Panasiuk. All rights reserved.
//

#import "NSDate+DateExtentions.h"

static NSString* const kWeakDayMounthDay = @"ext_dateFormatterWeekDayMounthDay";
static NSString* const kWeekDay = @"ext_dateFormatterWeekDay";
static NSString* const kMounthDay = @"ext_dateFormatterMounthAndDay";

@implementation NSDate (DateExtentions)

- (NSDate*)ext_zeroTimeToday
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                               fromDate:self];
    NSDate* dateOnly = [calendar dateFromComponents:components];
    return dateOnly;
}

+ (NSDateFormatter*)ext_dateFormatterWeekDayMounthDay
{
    NSMutableDictionary* threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter* dateFormatter = threadDictionary[kWeakDayMounthDay];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"EEEE, MMMM dd"];
        threadDictionary[kWeakDayMounthDay] = dateFormatter;
    }
    return dateFormatter;
}

+ (NSDateFormatter*)ext_dateFormatterWeekDay
{
    NSMutableDictionary* threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter* dateFormatter = threadDictionary[kWeekDay];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"EEEE"];
        threadDictionary[kWeekDay] = dateFormatter;
    }
    return dateFormatter;
}

+ (NSDateFormatter*)ext_dateFormatterMounthAndDay
{
    NSMutableDictionary* threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter* dateFormatter = threadDictionary[kMounthDay];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"MMMM dd"];
        threadDictionary[kMounthDay] = dateFormatter;
    }
    return dateFormatter;
}

@end