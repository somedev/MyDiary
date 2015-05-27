//
// Created by Eduard Panasiuk on 21.03.14.
// Copyright (c) 2014 Eduard Panasiuk. All rights reserved.
//

#import "IconLoader.h"

@implementation IconLoader

+ (NSURL*)smallIconURLWithTag:(NSInteger)tag
{
    NSString* imgName = [NSString stringWithFormat:@"icon_small_%02ld", (long)tag];
    return [[NSBundle mainBundle] URLForResource:imgName
                                   withExtension:@"png"];
}

@end