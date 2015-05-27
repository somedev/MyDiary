//
//  DiaryTextView.m
//  MyDiary
//
//  Created by Eduard Panasiuk on 22.03.14.
//  Copyright (c) 2014 Eduard Panasiuk. All rights reserved.
//

#import "DiaryTextView.h"

static CGFloat const kBaseOffset = 6.0f;

// "magical number" for offset error compensation
static CGFloat const kOffsetShift = 0.42f;

@interface DiaryTextView ()

@end

@implementation DiaryTextView

- (void)drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGFloat pattern[2] = { 3, 2 };
    CGContextSetLineDash(context, 0, pattern, 2);
    CGContextBeginPath(context);

    NSUInteger numberOfLines = (NSUInteger)((self.contentSize.height + self.bounds.size.height) / self.font.leading);

    CGFloat baselineOffset = kBaseOffset;

    for (int x = 1; x < numberOfLines; x++) {

        CGContextMoveToPoint(context, self.bounds.origin.x, self.font.leading * x + x * kOffsetShift + baselineOffset);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.font.leading * x + x * kOffsetShift + baselineOffset);
    }

    CGContextClosePath(context);
    CGContextStrokePath(context);
}

@end
