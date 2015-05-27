//
//  SmilesKeyboardView.h
//  MyDiary
//
//  Created by Eduard Panasiuk on 22.03.14.
//  Copyright (c) 2014 Eduard Panasiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmilesKeyboardView : UIView

@property (nonatomic, copy) void (^smileToushedBlock)(NSInteger tag);

@end
