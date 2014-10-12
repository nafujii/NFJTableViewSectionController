//
//  NFJTableViewSectionController.m
//  NFJTableViewSectionController
//
//  Created by fujioki on 2014/03/09.
//  Copyright (c) 2014 fujioki. All rights reserved.
//

#import "NFJTableViewSectionController.h"
#import "NFJTableViewSectionHeaderView.h"
#import "NFJTableViewSectionInfo.h"
#import "NFJTableViewSectionInfo_p.h"
static NSString *const kSectionHeaderViewIdentifier = @"NFJTableViewSectionHeaderViewIdentifier";

@interface NFJTableViewSectionController ()<NFTableViewSectionHeaderViewDelegate>
@end
@implementation NFJTableViewSectionController {
    NSMutableArray *_sections;
}
@synthesize sections = _sections;

- (instancetype)initWithTableView:(UITableView *)tableView
{
    if (self = [super init]) {
        _tableView = tableView;
        _sections = [[NSMutableArray alloc] init];
        [self.tableView registerClass:[NFJTableViewSectionHeaderView class] forHeaderFooterViewReuseIdentifier:kSectionHeaderViewIdentifier];
    }
    return self;
}

- (void)registerHeaderViewClass:(Class)class
{
    [self.tableView registerClass:class forHeaderFooterViewReuseIdentifier:kSectionHeaderViewIdentifier];
}

- (void)setSections:(NSArray *)sections
{
    _sections = [sections mutableCopy];
}

#pragma mark - Getting Section Info
- (NSIndexPath *)indexPathForObject:(id)object
{
    for (NFJTableViewSectionInfo *info in self.sections) {
        NSInteger index = [info.objects indexOfObject:object];
        if (index != NSNotFound) {
            return [NSIndexPath indexPathForRow:index inSection:info.section];
        }
    }
    return nil;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sections.count <= indexPath.section) {
        return nil;
    }

    NFJTableViewSectionInfo *info = self.sections[indexPath.section];
    if (info.objects.count <= indexPath.row) {
        return nil;
    }
    return info.objects[indexPath.row];
}

- (NFJTableViewSectionHeaderView *)headerViewForSection:(NSInteger)section
{
    if (self.sections.count <= section) {
        return nil;
    }
    
    NFJTableViewSectionHeaderView *view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:kSectionHeaderViewIdentifier];
    NFJTableViewSectionInfo *info = self.sections[section];
    view.open = info.open;
    view.delegate = self;
    view.section = section;

    return view;
}


#pragma mark - Reload Controller
- (void)reloadData
{
    [_sections removeAllObjects];
    NSInteger numberOfSections;
    numberOfSections = [self.dataSource numberOfSectionsInSectionController:self];
    for (int i = 0; i < numberOfSections; i++) {
        NFJTableViewSectionInfo *sectionInfo = [self p_sectionInfoForSection:i];
        [_sections addObject:sectionInfo];
    }
}

- (NFJTableViewSectionInfo *)p_sectionInfoForSection:(NSInteger)section
{
    NFJTableViewSectionInfo *sectionInfo = [[NFJTableViewSectionInfo alloc] init];
    sectionInfo.section = section;
    
    NSUInteger numberOfObjects = [self.dataSource sectionController:self numberOfObjectsInSection:section];
    NSMutableArray    *objects = [[NSMutableArray alloc] initWithCapacity:numberOfObjects];
    sectionInfo.objects = objects;
    
    for (int j = 0; j < numberOfObjects; j++) {
        [objects addObject:[self.dataSource sectionController:self objectAtIndexPath:[NSIndexPath indexPathForRow:j inSection:section]]];
    }
    
    sectionInfo.open = [self.dataSource sectionController:self isOpenedSection:section];
    return sectionInfo;
}


#pragma mark - Open and Close Section
- (void)openSection:(NSInteger)section
{
    if (section < 0 || _sections.count <= section) {
        return;
    }
    
    NFJTableViewSectionInfo *sectionInfo = _sections[section];
    if (sectionInfo.open) {
        return;
    }
    
    NFJTableViewSectionHeaderView *headerView = (NFJTableViewSectionHeaderView *)[self.tableView headerViewForSection:section];
    headerView.open = YES;
    sectionInfo.open = YES;
    
    if ([self.delegate respondsToSelector:@selector(sectionController:willOpenSection:)]) {
        [self.delegate sectionController:self willOpenSection:section];
    }
    
    [self p_insertRowsInSection:section];
    
    if ([self.delegate respondsToSelector:@selector(sectionController:didOpenSection:)]) {
        [self.delegate sectionController:self didOpenSection:section];
    }
}

- (void)closeSection:(NSInteger)section
{
    if (section < 0 || _sections.count <= section) {
        return;
    }
    
    NFJTableViewSectionInfo *sectionInfo = _sections[section];
    if (!sectionInfo.open) {
        return;
    }
   
    NFJTableViewSectionHeaderView *headerView = (NFJTableViewSectionHeaderView *)[self.tableView headerViewForSection:section];
    headerView.open = NO;
    sectionInfo.open = NO;

    if ([self.delegate respondsToSelector:@selector(sectionController:willCloseSection:)]) {
        [self.delegate sectionController:self willCloseSection:section];
    }
    
    [self p_deleteRowsInSection:section];
    
    if ([self.delegate respondsToSelector:@selector(sectionController:didCloseSection:)]) {
        [self.delegate sectionController:self didCloseSection:section];
    }
}


#pragma mark - NFJTableViewSectionHeaderViewDelegate
- (void)sectionHeaderViewSelected:(NFJTableViewSectionHeaderView *)sectionHeaderView
{
    NSInteger section = sectionHeaderView.section;
    if (sectionHeaderView.open) {
        if ([self.delegate respondsToSelector:@selector(sectionController:shouldCloseSection:)] &&
            ![self.delegate sectionController:self shouldCloseSection:section]) {
            return;
        }
        
        [self closeSection:section];
    } else {
        if ([self.delegate respondsToSelector:@selector(sectionController:shouldOpenSection:)] &&
            ![self.delegate sectionController:self shouldOpenSection:section]) {
            return;
        }

        [self openSection:section];
    }
}

- (void)p_insertRowsInSection:(NSInteger)section
{
    NFJTableViewSectionInfo *sectionInfo = _sections[section];
    NSInteger countOfRows = [sectionInfo.objects count];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRows; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
}


- (void)p_deleteRowsInSection:(NSInteger)section
{
    NSInteger countOfRows = [self.tableView numberOfRowsInSection:section];
    if (0 < countOfRows) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRows; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}

@end
