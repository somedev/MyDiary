//
// Created by Eduard Panasiuk on 23.03.14.
// Copyright (c) 2014 Eduard Panasiuk. All rights reserved.
//

#import "NSAttributedString+Adjust.h"

static const NSInteger kMaxPointSize = 15;
static const CGFloat kLargePointAdjustment = 0.3;

static const double kDefaultPointAdjustment = 1.0;

@implementation NSAttributedString (Adjust)

- (NSAttributedString*)adjust_adjustedAttributedStringWithFont:(UIFont*)font
{
    __block NSMutableAttributedString* mutableString = [self mutableCopy];
    [self enumerateAttributesInRange:NSMakeRange(0, self.length)
                             options:0
                          usingBlock:^(NSDictionary* attrs, NSRange range, BOOL* stop) {
                              [self processAttributes:attrs font:font mutableString:mutableString range:&range];
                          }];
    return [mutableString copy];
}

- (void)processAttributes:(NSDictionary*)attrs
                     font:(UIFont*)font
            mutableString:(NSMutableAttributedString*)mutableString
                    range:(NSRange*)range
{
    NSMutableDictionary* mutableAttrs = [attrs mutableCopy];

    BOOL fontChanged = [self adjustFont:font
                          mutableString:mutableString
                                  attrs:attrs
                                  range:range
                           mutableAttrs:mutableAttrs];

    BOOL imgSizeChanged = [self adjustImgSize:font
                                mutableString:mutableString
                                        attrs:attrs
                                        range:range
                                 mutableAttrs:mutableAttrs];

    if (fontChanged || imgSizeChanged) {
        [mutableString setAttributes:[mutableAttrs copy] range:*range];
    }
}

- (BOOL)adjustImgSize:(UIFont*)font
        mutableString:(NSMutableAttributedString*)mutableString
                attrs:(NSDictionary*)attrs
                range:(NSRange*)range
         mutableAttrs:(NSMutableDictionary*)mutableAttrs
{
    BOOL changed = NO;
    if (attrs[NSAttachmentAttributeName]) {
        NSTextAttachment* attachment = mutableAttrs[NSAttachmentAttributeName];
        CGFloat adjustment = (CGFloat)((font.pointSize >= kMaxPointSize) ? kLargePointAdjustment : kDefaultPointAdjustment);
        CGRect newBounds = attachment.bounds;
        newBounds.size.height = font.pointSize - adjustment;
        newBounds.size.width = font.pointSize - adjustment;
        attachment.bounds = newBounds;
        mutableAttrs[NSAttachmentAttributeName] = attachment;
        changed = YES;
        [mutableString removeAttribute:NSAttachmentAttributeName range:*range];
    }
    return changed;
}

- (BOOL)adjustFont:(UIFont*)font
     mutableString:(NSMutableAttributedString*)mutableString
             attrs:(NSDictionary*)attrs
             range:(NSRange*)range
      mutableAttrs:(NSMutableDictionary*)mutableAttrs
{
    BOOL changed = NO;
    if (attrs[NSFontAttributeName]) {
        mutableAttrs[NSFontAttributeName] = font;
        changed = YES;
        [mutableString removeAttribute:NSFontAttributeName range:*range];
    }
    return changed;
}

@end