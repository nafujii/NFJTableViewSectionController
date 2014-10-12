//
//  Person.m
//  NFJTableViewSectionController
//
//  Created by Naoki Fujii on 2014/10/12.
//  Copyright (c) 2014年 nfujii. All rights reserved.
//

#import "Person.h"

@implementation Person {
    NSString *_fullName;
}

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName
{
    if (self = [super init]) {
        _firstName = [firstName copy];
        _lastName = [lastName copy];
    }
    return self;
}

- (NSString *)fullName
{
    if (!_fullName) {
        _fullName = [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
    }
    return _fullName;
}
@end
