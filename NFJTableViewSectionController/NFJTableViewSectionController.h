//
//  NFJTableViewSectionController.h
//  NFJTableViewSectionController
//
//  Created by fujioki on 2014/03/09.
//  Copyright (c) 2014 fujioki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NFJTableViewSectionController;
@class NFJTableViewSectionHeaderView;
@protocol NFJTableViewSectionControllerDelegate <NSObject>
@optional
- (BOOL)sectionController:(NFJTableViewSectionController *)controller shouldCloseSection:(NSInteger)section;
- (BOOL)sectionController:(NFJTableViewSectionController *)controller shouldOpenSection:(NSInteger)section;
- (void)sectionController:(NFJTableViewSectionController *)controller willCloseSection:(NSInteger)section;
- (void)sectionController:(NFJTableViewSectionController *)controller didCloseSection:(NSInteger)section;
- (void)sectionController:(NFJTableViewSectionController *)controller willOpenSection:(NSInteger)section;
- (void)sectionController:(NFJTableViewSectionController *)controller didOpenSection:(NSInteger)section;
@end

@protocol NFJTableViewSectionControllerDataSource <NSObject>
@required
- (NSInteger)numberOfSectionsInSectionController:(NFJTableViewSectionController *)controller;
- (NSInteger)sectionController:(NFJTableViewSectionController *)controller numberOfObjectsInSection:(NSInteger)section;
- (id)sectionController:(NFJTableViewSectionController *)controller objectAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)sectionController:(NFJTableViewSectionController *)controller isOpenedSection:(NSInteger)section;
@end

@interface NFJTableViewSectionController : NSObject
@property (nonatomic, weak)           id <NFJTableViewSectionControllerDataSource> dataSource;
@property (nonatomic, weak)           id <NFJTableViewSectionControllerDelegate>   delegate;
@property (nonatomic, weak, readonly) UITableView                                  *tableView;
@property (nonatomic, readonly)       NSArray                                      *sections;

- (instancetype)initWithTableView:(UITableView *)tableView;
- (void)registerHeaderViewClass:(Class)class;
- (NSIndexPath *)indexPathForObject:(id)object;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NFJTableViewSectionHeaderView *)headerViewForSection:(NSInteger)section;

- (void)reloadData;

- (void)openSection:(NSInteger)section;
- (void)closeSection:(NSInteger)section;
@end
