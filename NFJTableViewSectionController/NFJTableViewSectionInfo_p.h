//
//  NFJTableViewSectionInfo_p.h
//  NFJTableViewSectionController
//
//  Created by fujioki on 2014/03/08.
//  Copyright (c) 2014年 fujioki. All rights reserved.
//

#import "NFJTableViewSectionInfo.h"

@interface NFJTableViewSectionInfo ()
@property (nonatomic, readwrite, getter = isOpen) BOOL    open;
@property (nonatomic, readwrite)       NSInteger          section;
@property (nonatomic, readwrite)       NSArray            *objects;
@end