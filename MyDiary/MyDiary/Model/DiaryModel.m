//
// Created by Eduard Panasiuk on 23.03.14.
// Copyright (c) 2014 Eduard Panasiuk. All rights reserved.
//

#import "DiaryModel.h"

static NSString* const kDefaultFileName = @"records.plist";

@implementation DiaryModel

#pragma mark loading
+ (instancetype)loadFromDefaultPath
{
    NSString* fullPath = [[self class] getDefaultPath];
    DiaryModel* result = [[self class] loadFromPath:fullPath];
    if (!result) {
        result = [[DiaryModel alloc] init];
        result.records = [NSArray array];
    }
    return result;
}

+ (instancetype)loadFromPath:(NSString*)path
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

#pragma mark saving
- (BOOL)saveToDefaultPath
{
    NSString* fullPath = [[self class] getDefaultPath];
    return [self saveToPath:fullPath];
}

- (BOOL)saveToPath:(NSString*)path
{
    return [NSKeyedArchiver archiveRootObject:self toFile:path];
}

#pragma mark NSCoding protocol
- (void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:self.records forKey:@"records"];
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.records = [coder decodeObjectForKey:@"records"];
    return self;
}

#pragma mark utils
+ (NSString*)getDefaultPath
{
    NSString* docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* fullPath = [docDirectory stringByAppendingPathComponent:kDefaultFileName];
    return fullPath;
}

@end