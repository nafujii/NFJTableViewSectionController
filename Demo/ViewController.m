//
//  ViewController.m
//  NFJTableViewSectionController
//
//  Created by Naoki Fujii on 2014/10/12.
//  Copyright (c) 2014年 nfujii. All rights reserved.
//

#import "ViewController.h"
#import "NFJTableViewSectionController.h"
#import "NFJTableViewSectionInfo.h"
#import "NFJTableViewSectionHeaderView.h"
#import "Person.h"
#import "Group.h"

static NSString *const kName = @"name";
static const NSInteger kCannotCloseIndex  = 0;
static const NSInteger kDefaultOpenIndex  = 1;
static const NSInteger kCannotOpenIndex   = 2;

@interface ViewController ()<NFJTableViewSectionControllerDataSource, NFJTableViewSectionControllerDelegate>
@property (nonatomic, strong) NFJTableViewSectionController *sectionController;
@property (nonatomic, copy)   NSArray *groups;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    NFJTableViewSectionController *controller = [[NFJTableViewSectionController alloc] initWithTableView:self.tableView];
    controller.dataSource = self;
    controller.delegate   = self;
    self.sectionController = controller;
    self.groups = [self generateGropus];
    
    [_sectionController reloadData];
}

- (NSArray *)generateGropus
{
    NSInteger count = 10;
    NSMutableArray *groups = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSInteger memCnt = arc4random()%5 + 1;
        NSMutableArray *members = [[NSMutableArray alloc] initWithCapacity:memCnt];
        for (int j = 0; j < memCnt; j++) {
            NSString *fn = [NSString stringWithFormat:@"first%02d", j];
            NSString *ln = [NSString stringWithFormat:@"last%02d", j];
            [members addObject:[[Person alloc] initWithFirstName:fn lastName:ln]];
        }
        Group *g = [[Group alloc] init];
        g.members = members;
        g.name = [self groupNameWithIndex:i];
        [groups addObject:g];
    }
    return groups;
}

- (NSString *)groupNameWithIndex:(NSInteger)index
{
    if (index == kCannotOpenIndex) {
        return [NSString stringWithFormat:@"Group %02ld can't be opened", (long)index];
    } else if (index == kDefaultOpenIndex) {
        return [NSString stringWithFormat:@"Group %02ld is opened from the start", (long)index];
    } else if (index == kCannotCloseIndex) {
        return [NSString stringWithFormat:@"Group %02ld can't be closed", (long)index];
    }
    return [NSString stringWithFormat:@"Group %02ld", (long)index];
}

#pragma mark - Action
- (IBAction)toggleSection04:(id)sender
{
    [self toggleSectionAtIndex:4];
}

- (IBAction)toggleSection05:(id)sender
{
    [self toggleSectionAtIndex:5];
}

- (void)toggleSectionAtIndex:(NSInteger)section
{
    NFJTableViewSectionInfo *info = _sectionController.sections[section];
    if (info.open) {
        [_sectionController closeSection:section];
    } else {
        [_sectionController openSection:section];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NFJTableViewSectionInfo *info = _sectionController.sections[section];
    return info.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Person *p = [_sectionController objectAtIndexPath:indexPath];
    cell.textLabel.text = [p fullName];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Group *g = _groups[section];
    NFJTableViewSectionHeaderView *view = [_sectionController headerViewForSection:section];
    view.titleLabel.text = g.name;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}

#pragma mark - NFJSectionControllerDataSource
- (NSInteger)numberOfSectionsInSectionController:(NFJTableViewSectionController *)controller
{
    return _groups.count;
}

- (NSInteger)sectionController:(NFJTableViewSectionController *)controller numberOfObjectsInSection:(NSInteger)section
{
    Group *g = _groups[section];
    return g.members.count;
}

- (id)sectionController:(NFJTableViewSectionController *)controller objectAtIndexPath:(NSIndexPath *)indexPath
{
    Group *g = _groups[indexPath.section];
    return g.members[indexPath.row];
}

- (NSString *)sectionController:(NFJTableViewSectionController *)controller sectionNameForSection:(NSInteger)section
{
    Group *g = _groups[section];
    return g.name;
}

- (BOOL)sectionController:(NFJTableViewSectionController *)controller isOpenedSection:(NSInteger)section
{
    if (section == kCannotCloseIndex || section == kDefaultOpenIndex) {
        return YES;
    }
    return NO;
}

#pragma mark - NFJSectionControllerDelegate
- (BOOL)sectionController:(NFJTableViewSectionController *)controller shouldCloseSection:(NSInteger)section
{
    if (section == kCannotCloseIndex) {
        return NO;
    }
    return YES;
}

- (BOOL)sectionController:(NFJTableViewSectionController *)controller shouldOpenSection:(NSInteger)section
{
    if (section == kCannotOpenIndex) {
        return NO;
    }
    return YES;
}

- (void)sectionController:(NFJTableViewSectionController *)controller willCloseSection:(NSInteger)section
{
    NSLog(@"section %02ld will be closed", section);
}

- (void)sectionController:(NFJTableViewSectionController *)controller didCloseSection:(NSInteger)section
{
    NSLog(@"section %02ld was     closed", section);

}

- (void)sectionController:(NFJTableViewSectionController *)controller willOpenSection:(NSInteger)section
{
    NSLog(@"section %02ld will be opened", section);
}

- (void)sectionController:(NFJTableViewSectionController *)controller didOpenSection:(NSInteger)section
{
    NSLog(@"section %02ld was     opened", section);
}


@end
