//
//  Macros.h
//  MyDiary
//
//  Created by Eduard Panasiuk on 18.03.14.
//  Copyright (c) 2014 Eduard Panasiuk. All rights reserved.
//

#ifndef MyDiary_Macros____FILEEXTENSION___
#define MyDiary_Macros____FILEEXTENSION___

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#ifdef DEBUG
#define DAssert(A, B, ...) NSAssert(A, B, ##__VA_ARGS__);
#else
#define DAssert(...)
#endif

#endif
