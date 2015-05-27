//
//  DiaryEditViewController.h
//  MyDiary
//
//  Created by Eduard Panasiuk on 18.03.14.
//  Copyright (c) 2014 Eduard Panasiuk. All rights reserved.
//

#import "Record.h"

@class SmilesKeyboardView;

@interface DiaryEditViewController : UIViewController

@property (nonatomic, strong) Record* record;
@property (nonatomic, strong) UIColor* recordColor;
@property (nonatomic, copy) void (^editCompletionBlock)(BOOL success, Record* record);

@end
