//
//  DiaryEditViewController.m
//  MyDiary
//
//  Created by Eduard Panasiuk on 18.03.14.
//  Copyright (c) 2014 Eduard Panasiuk. All rights reserved.
//

#import "DiaryEditViewController.h"
#import "IconLoader.h"
#import "NSDate+DateExtentions.h"
#import "DiaryTextView.h"
#import "SmilesKeyboardView.h"
#import "NSAttributedString+Adjust.h"

static CGFloat const kFontSize = 15.0f;

@interface DiaryEditViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet DiaryTextView* textView;
@property (weak, nonatomic) IBOutlet UILabel* dayOfWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel* dateLabel;
@property (nonatomic, strong) SmilesKeyboardView* smileKeyboardView;
@property (nonatomic, assign) BOOL isSmilesInput;

- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)smileKeyboardPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView* colorView;

@end

@implementation DiaryEditViewController

#pragma mark UIViewController lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backPressed:)];

    self.textView.delegate = self;

    [self setupSmilesKeyboardView];
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    self.dayOfWeekLabel.text = [[NSDate ext_dateFormatterWeekDay] stringFromDate:self.record.recordDate];
    self.dayOfWeekLabel.text = [self.dayOfWeekLabel.text stringByAppendingString:@","];
    self.dateLabel.text = [[NSDate ext_dateFormatterMounthAndDay] stringFromDate:self.record.recordDate];
    self.colorView.backgroundColor = self.recordColor;
    self.textView.attributedText = [self.record.recordText adjust_adjustedAttributedStringWithFont:[UIFont fontWithName:@"HelveticaNeue-LightItalic"
                                                                                                                   size:kFontSize]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

#pragma mark setup
- (void)setupSmilesKeyboardView
{
    self.smileKeyboardView = [[NSBundle mainBundle] loadNibNamed:@"SmilesKeyboardView"
                                                           owner:self
                                                         options:nil][0];
    __weak typeof(self) wself = self;
    self.smileKeyboardView.smileToushedBlock = ^(NSInteger tag) {
        DLog(@"smile touched with tag: %ld", tag);
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:wself.textView.attributedText];
        NSRange selectedRange = wself.textView.selectedRange;
        NSTextAttachment* attachment = [[NSTextAttachment alloc] init];
        attachment.fileWrapper = [[NSFileWrapper alloc] initWithURL:[IconLoader smallIconURLWithTag:tag]
                                                            options:0
                                                              error:nil];
        attachment.bounds = CGRectMake(0, 0, 14.7, 14.7);

        NSMutableAttributedString* attachString =
            [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];

        UIFont* font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:kFontSize];
        NSAttributedString* emptyString = [[NSAttributedString alloc] initWithString:@" "
                                                                          attributes:@{ NSFontAttributeName : font }];
        [attachString insertAttributedString:emptyString atIndex:0];
        [attachString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attachString.length)];
        [attachString appendAttributedString:emptyString];

        [attributedString insertAttributedString:attachString
                                         atIndex:selectedRange.location];

        selectedRange.location += 3;

        wself.textView.attributedText = attributedString;
        wself.textView.selectedRange = selectedRange;
    };
}

#pragma mark Actions

- (void)backPressed:(id)backPressed
{
    if (self.editCompletionBlock) {
        self.editCompletionBlock(NO, nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonPressed:(id)sender
{
    self.record.recordText = self.textView.attributedText;
    self.record.smilesText = [self.record generateSmilesString];
    if (self.editCompletionBlock) {
        self.editCompletionBlock(YES, self.record);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)smileKeyboardPressed:(id)sender
{
    [self.textView resignFirstResponder];
    self.isSmilesInput = !self.isSmilesInput;
    if (self.isSmilesInput) {
        self.textView.inputView = self.smileKeyboardView;
    }
    else {
        self.textView.inputView = nil;
    }
    [self.textView reloadInputViews];
    [self.textView becomeFirstResponder];
}

#pragma mark UITextviewDelegate
- (void)textViewDidChangeSelection:(UITextView*)textView
{
    [textView scrollRangeToVisible:textView.selectedRange];
}

//fix iOS7 bug with '\n' character
- (void)textViewDidChange:(UITextView*)textView
{
    CGRect line = [textView caretRectForPosition:textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height - (textView.contentOffset.y + textView.bounds.size.height - textView.contentInset.bottom - textView.contentInset.top);

    //fix crash on iOS6
    //overflow can be too large
    if (overflow >= 1000.0) {
        return;
    }

    if (overflow > 0) {
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7;
        [UIView animateWithDuration:.2
                         animations:^{
                             [textView setContentOffset:offset];
                         }];
    }
}

@end
