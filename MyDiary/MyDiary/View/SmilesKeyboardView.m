//
//  SmilesKeyboardView.m
//  MyDiary
//
//  Created by Eduard Panasiuk on 22.03.14.
//  Copyright (c) 2014 Eduard Panasiuk. All rights reserved.
//

#import "SmilesKeyboardView.h"

@implementation SmilesKeyboardView

- (IBAction)smileButtonTouched:(UIButton*)sender
{
    if (self.smileToushedBlock) {
        self.smileToushedBlock(sender.tag);
    }
}

@end
