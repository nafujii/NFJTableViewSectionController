//
//  Person.h
//  NFJTableViewSectionController
//
//  Created by Naoki Fujii on 2014/10/12.
//  Copyright (c) 2014年 nfujii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic, copy, readonly) NSString *firstName;
@property (nonatomic, copy, readonly) NSString *lastName;

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;
- (NSString *)fullName;
@end
