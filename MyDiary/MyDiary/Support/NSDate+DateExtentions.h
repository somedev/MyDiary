//
//  NSDate+DateExtentions.h
//  MyDiary
//
//  Created by Eduard Panasiuk on 18.03.14.
//  Copyright (c) 2014 Eduard Panasiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateExtentions)

- (NSDate*)ext_zeroTimeToday;
+ (NSDateFormatter*)ext_dateFormatterWeekDayMounthDay;
+ (NSDateFormatter*)ext_dateFormatterWeekDay;
+ (NSDateFormatter*)ext_dateFormatterMounthAndDay;

@end