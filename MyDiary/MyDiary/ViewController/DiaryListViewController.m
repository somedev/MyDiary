//
//  DiaryListViewController.m
//  MyDiary
//
//  Created by Eduard Panasiuk on 18.03.14.
//  Copyright (c) 2014 Eduard Panasiuk. All rights reserved.
//

#import "DiaryListViewController.h"
#import "Record.h"
#import "NSDate+DateExtentions.h"
#import "RecordCell.h"
#import "DiaryEditViewController.h"
#import "DiaryModel.h"

static NSInteger const kItemsCountStep = 100;
static NSTimeInterval const kOneDayInterval = 60 * 60 * 24;
static CGFloat const kNavButtonsDivider = 16;

@interface DiaryListViewController () <UITableViewDelegate,
    UITableViewDataSource,
    NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UIView* tableContentView;
@property (nonatomic, strong) NSMutableArray* records;
@property (nonatomic, strong) DiaryModel* model;
@property (nonatomic, assign)
    NSInteger recordsPossibleCount; // count of records (include empty days)

@end

@implementation DiaryListViewController

#pragma mark UIViewController lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    // start with first kItemsCountStep items
    self.recordsPossibleCount = kItemsCountStep;
    [self setupTableView];
    [self setupModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavbar];
}

#pragma mark actions
- (void)addPressed
{
    DLog(@"add pressed");
}

- (void)helpPressed
{
    DLog(@"help pressed");
}

#pragma mark Navigation bar setup

- (void)setupNavbar
{
    UIView* container = [self makeNavButtonsPanel];

    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithCustomView:container];
}

- (UIView*)makeNavButtonsPanel
{
    UIImage* helpImage = [UIImage imageNamed:@"nav_help"];
    UIButton* helpButton = [self makeHelpButtonWithImage:helpImage];

    UIImage* addImage = [UIImage imageNamed:@"nav_add"];
    UIButton* addButton = [self makeAddButtonWithImage:addImage helpImage:helpImage];

    UIView* container = [[UIView alloc]
        initWithFrame:CGRectMake(
                          0, 0, helpButton.frame.size.width + addImage.size.width + kNavButtonsDivider,
                          MAX(helpImage.size.height, addImage.size.height))];
    container.backgroundColor = [UIColor clearColor];
    [container addSubview:helpButton];
    [container addSubview:addButton];
    return container;
}

- (UIButton*)makeAddButtonWithImage:(UIImage*)addImage helpImage:(UIImage*)helpImage
{
    UIButton* addButton = [[UIButton alloc]
        initWithFrame:CGRectMake(kNavButtonsDivider + helpImage.size.width, 0,
                          addImage.size.width, addImage.size.height)];
    [addButton addTarget:self
                  action:@selector(addPressed)
        forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:addImage forState:UIControlStateNormal];
    return addButton;
}

- (UIButton*)makeHelpButtonWithImage:(UIImage*)image
{
    UIButton* helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [helpButton addTarget:self
                   action:@selector(helpPressed)
         forControlEvents:UIControlEventTouchUpInside];
    [helpButton setImage:image forState:UIControlStateNormal];
    return helpButton;
}

- (void)setupTableView
{
    [self addGradient];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [[self tableView] registerNib:[UINib nibWithNibName:NSStringFromClass([RecordCell class])
                                                 bundle:[NSBundle mainBundle]]
           forCellReuseIdentifier:NSStringFromClass([RecordCell class])];
}

- (void)addGradient
{
    CAGradientLayer* maskLayer = [[CAGradientLayer alloc] init];
    maskLayer.frame = self.tableContentView.frame;
    UIColor* solidColor = [UIColor whiteColor];
    UIColor* alphaColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    NSArray* colors = @[
        (id)solidColor.CGColor,
        (id)solidColor.CGColor,
        (id)alphaColor.CGColor
    ];
    NSArray* positions = @[ @(0.0), @(0.8), @(1.0) ];
    maskLayer.colors = colors;
    maskLayer.locations = positions;
    self.tableContentView.layer.mask = maskLayer;
}

- (void)setupModel
{
    self.model = [DiaryModel loadFromDefaultPath];
    self.records = [self.model.records mutableCopy];
    [self.records sortUsingDescriptors:@[
        [NSSortDescriptor sortDescriptorWithKey:@"recordDate"
                                      ascending:NO]
    ]];
}

#pragma mark Calculations
- (UIColor*)colorWithIndex:(NSInteger)index
{
    NSInteger rest = index % 3;
    switch (rest) {
    case 0:
        return [UIColor colorWithRed:248 / 255.0f
                               green:198 / 255.0f
                                blue:14 / 255.0f
                               alpha:1.0f];
    case 1:
        return [UIColor colorWithRed:138 / 255.0f
                               green:198 / 255.0f
                                blue:37 / 255.0f
                               alpha:1.0f];
    case 2:
        return [UIColor colorWithRed:255 / 255.0f
                               green:46 / 255.0f
                                blue:45 / 255.0f
                               alpha:1.0f];
    default:
        return [UIColor clearColor];
    }
}

- (NSAttributedString*)dateTextForIndexpath:(NSIndexPath*)indexPath
{
    NSDate* date = [[[NSDate date] ext_zeroTimeToday]
        dateByAddingTimeInterval:(-kOneDayInterval * indexPath.row)];
    NSString* dateString =
        [[NSDate ext_dateFormatterWeekDayMounthDay] stringFromDate:date];
    dateString = [dateString stringByAppendingString:@" "];
    NSMutableAttributedString* attributedString =
        [[NSMutableAttributedString alloc] initWithString:dateString];
    Record* record = [self recordForIndexpath:indexPath];
    if (record && record.smilesText) {
        [attributedString appendAttributedString:record.smilesText];
    }
    return [attributedString copy];
}

- (NSAttributedString*)recordTextForIndexpath:(NSIndexPath*)indexPath
{
    Record* record = [self recordForIndexpath:indexPath];
    if (record) {
        return record.recordText;
    }
    return nil;
}

- (Record*)recordForIndexpath:(NSIndexPath*)indexPath
{
    NSDate* date = [[[NSDate date] ext_zeroTimeToday]
        dateByAddingTimeInterval:(-kOneDayInterval * indexPath.row)];
    NSPredicate* searchPredicate =
        [NSPredicate predicateWithFormat:@"recordDate==%@", date];

    NSArray* recordsWithDate =
        [self.records filteredArrayUsingPredicate:searchPredicate];
    if (recordsWithDate.count > 0) {
        Record* record = [recordsWithDate lastObject];
        return record;
    }
    return nil;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView
    heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    RecordCell* cell = [self.tableView
        dequeueReusableCellWithIdentifier:NSStringFromClass([RecordCell class])];
    [cell setupWithTitle:nil
                  record:[self recordTextForIndexpath:indexPath]
                   color:nil];
    return [cell intrinsicContentSize].height;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.recordsPossibleCount;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    RecordCell* cell = [self.tableView
        dequeueReusableCellWithIdentifier:NSStringFromClass([RecordCell class])];

    [cell setupWithTitle:[self dateTextForIndexpath:indexPath]
                  record:[self recordTextForIndexpath:indexPath]
                   color:[self colorWithIndex:indexPath.row]];

    // if last cell, add cells on bottom
    if (indexPath.row == (self.recordsPossibleCount - 1)) {
        self.recordsPossibleCount += kItemsCountStep;
        [self.tableView reloadData];
    }

    return cell;
}

- (void)tableView:(UITableView*)tableView
    didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    UIStoryboard* storyboard = self.navigationController.storyboard;
    DiaryEditViewController* viewController = [storyboard
        instantiateViewControllerWithIdentifier:@"DiaryEditViewController"];

    __weak typeof(self) wself = self;
    BOOL newRecord = NO;
    Record* record = [self recordForIndexpath:indexPath];
    if (nil == record) {
        record = [[Record alloc] init];
        record.recordDate = [[[NSDate date] ext_zeroTimeToday]
            dateByAddingTimeInterval:(-kOneDayInterval * indexPath.row)];
        newRecord = YES;
    }
    viewController.record = [record copy];
    viewController.recordColor = [self colorWithIndex:indexPath.row];
    viewController.editCompletionBlock = ^(BOOL success, Record* theRecord) {
        // save changes
        if (success) {
            if (newRecord) {
                [wself.records addObject:theRecord];
                [wself.records sortUsingDescriptors:@[
                    [NSSortDescriptor sortDescriptorWithKey:@"recordDate"
                                                  ascending:NO]
                ]];
            }
            else {
                wself.records[[wself.records indexOfObject:record]] = theRecord;
            }
            [wself.tableView reloadData];

            // save to model
            wself.model.records = [wself.records copy];
            [wself.model saveToDefaultPath];
        }
        // undo changes
        else {
            DLog(@"Returned without saving");
        }
    };

    [self.navigationController pushViewController:viewController animated:YES];
}

@end
