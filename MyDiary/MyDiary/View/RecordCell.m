//
//  RecordCell.m
//  MyDiary
//
//  Created by Eduard Panasiuk on 19.03.14.
//  Copyright (c) 2014 Eduard Panasiuk. All rights reserved.
//

#import "RecordCell.h"
#import "NSAttributedString+Adjust.h"

static CGFloat const kMaxTextHeight = 42.0f;
static CGFloat const kBottomOffset = 10.0f;
static CGFloat const kMinHeight = 29.0f;
static CGFloat const kRecordLabelYFromMinHeight = 17.0f;
static CGFloat const kContentFontSize = 12.0f;
static CGFloat const kDateFontSize = 13.0f;

@interface RecordCell ()
@property (weak, nonatomic) IBOutlet UIView* colorView;
@property (weak, nonatomic) IBOutlet UILabel* contentLabel;
@property (weak, nonatomic) IBOutlet UILabel* dateLabel;

@end

@implementation RecordCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    return;
}

- (void)prepareForReuse
{
    self.contentLabel.text = nil;
}

- (CGSize)intrinsicContentSize
{
    CGSize size = CGSizeMake(self.frame.size.width, 0);
    CGFloat recordHeight = MIN(kMaxTextHeight, [self.contentLabel intrinsicContentSize].height);
    size.height = kMinHeight + recordHeight + ((recordHeight > 0) ? kRecordLabelYFromMinHeight : 0) + kBottomOffset;
    return size;
}

- (void)setupWithTitle:(NSAttributedString*)title
                record:(NSAttributedString*)record
                 color:(UIColor*)color
{
    self.colorView.backgroundColor = color;
    self.dateLabel.attributedText = [title ?: [[NSAttributedString alloc] initWithString:@""] adjust_adjustedAttributedStringWithFont:[UIFont fontWithName:@"HelveticaNeue"
                                                                                                                                                      size:kDateFontSize]];
    self.contentLabel.attributedText = [record ?: [[NSAttributedString alloc] initWithString:@""] adjust_adjustedAttributedStringWithFont:[UIFont fontWithName:@"HelveticaNeue-LightItalic"
                                                                                                                                                          size:kContentFontSize]];
    [self invalidateIntrinsicContentSize];
    [self layoutIfNeeded];
}

@end
