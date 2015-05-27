//
// Created by Eduard Panasiuk on 23.03.14.
// Copyright (c) 2014 Eduard Panasiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiaryModel : NSObject <NSCoding>

@property (nonatomic, strong) NSArray* records;

+ (instancetype)loadFromDefaultPath;
+ (instancetype)loadFromPath:(NSString*)path;

- (BOOL)saveToDefaultPath;
- (BOOL)saveToPath:(NSString*)path;

@end