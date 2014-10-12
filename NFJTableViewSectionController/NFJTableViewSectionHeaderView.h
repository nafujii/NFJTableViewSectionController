//
//  NFJTableViewSectionHeaderView.h
//  NFJTableViewSectionController
//
//  Created by Naoki Fujii on 2014/10/12.
//  Copyright (c) 2014年 nfujii. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NFJTableViewSectionHeaderView;
@protocol NFTableViewSectionHeaderViewDelegate <NSObject>
@optional
- (void)sectionHeaderViewSelected:(NFJTableViewSectionHeaderView *)sectionHeaderView;
@end

@interface NFJTableViewSectionHeaderView : UITableViewHeaderFooterView
@property (nonatomic, weak)  id <NFTableViewSectionHeaderViewDelegate> delegate;
@property (nonatomic, readonly)      UILabel      *titleLabel;
@property (nonatomic, getter=isOpen) BOOL         open;
@property (nonatomic)                NSInteger    section;
@property (nonatomic)                UIEdgeInsets separatorInsets;
@property (nonatomic)                UIColor      *separatorColor;
@property (nonatomic)                UIColor      *disclosureColor;
@end
