//
// Created by Eduard Panasiuk on 23.03.14.
// Copyright (c) 2014 Eduard Panasiuk. All rights reserved.
//

#import "Record.h"

@implementation Record

#pragma mark Properties
- (void)setRecordDate:(NSDate*)recordDate
{
    //store only Date, not time
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                               fromDate:recordDate];
    _recordDate = [calendar dateFromComponents:components];
}

#pragma mark convert
- (NSAttributedString*)generateSmilesString
{
    if (!self.recordText || self.recordText.length <= 0) {
        return nil;
    }

    __block NSMutableAttributedString* mutableAttributedString = [[NSMutableAttributedString alloc] init];
    [self.recordText enumerateAttribute:NSAttachmentAttributeName
                                inRange:NSMakeRange(0, self.recordText.length)
                                options:0
                             usingBlock:^(NSTextAttachment* value, NSRange range, BOOL* stop) {
                                 if (!value) {
                                     return;
                                 }
                                 NSMutableAttributedString* attachString = [[NSAttributedString attributedStringWithAttachment:value] mutableCopy];

                                 UIFont* font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:15];
                                 [attachString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attachString.length)];
                                 [mutableAttributedString appendAttributedString:attachString];
                             }];

    return [mutableAttributedString copy];
}

#pragma mark NSCoding protocol
- (void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:self.recordDate forKey:@"recordDate"];
    [coder encodeObject:self.recordText forKey:@"recordText"];
    [coder encodeObject:self.smilesText forKey:@"smilesText"];
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.recordDate = [coder decodeObjectForKey:@"recordDate"];
    self.recordText = [coder decodeObjectForKey:@"recordText"];
    self.smilesText = [coder decodeObjectForKey:@"smilesText"];
    return self;
}

#pragma mark NSCopying protocol
- (id)copyWithZone:(NSZone*)zone
{
    id copy = [[[self class] alloc] init];
    if (copy) {
        [copy setRecordDate:[self.recordDate copyWithZone:zone]];
        [copy setRecordText:[self.recordText copyWithZone:zone]];
        [copy setSmilesText:[self.smilesText copyWithZone:zone]];
    }
    return copy;
}

@end