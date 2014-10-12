//
//  NFJTableViewSectionInfo.m
//  NFJTableViewSectionController
//
//  Created by fujioki on 2014/03/08.
//  Copyright (c) 2014年 fujioki. All rights reserved.
//

#import "NFJTableViewSectionInfo.h"
#import "NFJTableViewSectionInfo_p.h"

@implementation NFJTableViewSectionInfo
- (NSUInteger)numberOfObjects
{
    if (self.open) {
        return self.objects.count;
    }
    return 0;
}

@end
