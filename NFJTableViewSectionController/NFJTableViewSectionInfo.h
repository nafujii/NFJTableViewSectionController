//
//  NFJTableViewSectionInfo.h
//  NFJTableViewSectionController
//
//  Created by fujioki on 2014/03/08.
//  Copyright (c) 2014年 fujioki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFJTableViewSectionInfo : NSObject
@property (nonatomic, readonly, getter = isOpen) BOOL    open;
@property (nonatomic, readonly)       NSInteger          section;
@property (nonatomic, readonly)       NSUInteger         numberOfObjects;
@property (nonatomic, readonly)       NSArray            *objects;
@end
