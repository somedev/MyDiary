//
// Created by Eduard Panasiuk on 23.03.14.
// Copyright (c) 2014 Eduard Panasiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Record : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSDate* recordDate;
@property (nonatomic, strong) NSAttributedString* smilesText;
@property (nonatomic, strong) NSAttributedString* recordText;

- (NSAttributedString*)generateSmilesString;

@end