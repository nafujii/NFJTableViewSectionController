//
//  NFJTableViewSectionHeaderView.m
//  NFJTableViewSectionController
//
//  Created by Naoki Fujii on 2014/10/12.
//  Copyright (c) 2014年 nfujii. All rights reserved.
//

#import "NFJTableViewSectionHeaderView.h"

@interface NFJTableViewSectionHeaderView ()
@property (nonatomic) CAShapeLayer *disclosure;
@property (nonatomic) CAShapeLayer *separatorLayer;
@end
@implementation NFJTableViewSectionHeaderView

#pragma mark - Initialize
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _disclosureColor = _separatorColor = [UIColor lightGrayColor];
        _separatorInsets = UIEdgeInsetsZero;
        
        // Separator
        _separatorLayer = [self p_createSeparatorLayer];
        _separatorLayer.strokeColor = _separatorColor.CGColor;
        [self.contentView.layer addSublayer:_separatorLayer];

        // Disclosure
        _disclosure = [self p_createDisclosure];
        _disclosure.strokeColor = _disclosureColor.CGColor;
        [self.contentView.layer addSublayer:_disclosure];

        // Title Label
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_titleLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(p_handleTap:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (CAShapeLayer *)p_createSeparatorLayer
{
    CAShapeLayer *separator;
    separator = [CAShapeLayer layer];
    separator.contentsScale = [UIScreen mainScreen].scale;
    separator.fillColor = nil;
    separator.lineWidth = 1.0 / separator.contentsScale;
    return separator;
}

- (CAShapeLayer *)p_createDisclosure
{
    CAShapeLayer *disclosure;
    disclosure = [CAShapeLayer layer];
    disclosure.contentsScale = [UIScreen mainScreen].scale;
    disclosure.fillColor = nil;
    disclosure.lineWidth = 1.f;
    disclosure.lineJoin = kCALineJoinRound;
    return disclosure;
}

#pragma mark - Setting Property
- (void)setSeparatorColor:(UIColor *)separatorColor
{
    _separatorColor = separatorColor;
    _separatorLayer.strokeColor = separatorColor.CGColor;
    [_separatorLayer setNeedsDisplay];
}

- (void)setSeparatorInsets:(UIEdgeInsets)separatorInsets
{
    _separatorInsets = separatorInsets;
    [self p_updateSeparatorPath];
    [_separatorLayer setNeedsDisplay];
}

- (void)setDisclosureColor:(UIColor *)disclosureColor
{
    _disclosureColor = disclosureColor;
    _disclosure.strokeColor = disclosureColor.CGColor;
    [_disclosure setNeedsDisplay];
}

- (void)setOpen:(BOOL)open
{
    if (_open != open) {
        _open = open;
        _disclosure.transform = CATransform3DRotate(_disclosure.transform, M_PI, 0, 0, 1);
    }
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect contentFrame = self.contentView.bounds;

    // Separator
    _separatorLayer.frame = contentFrame;
    [self p_updateSeparatorPath];
    
    // Disclosure
    CGSize size = CGSizeMake(CGRectGetHeight(contentFrame)*0.5, CGRectGetHeight(contentFrame)*0.3);
    CGRect frame = _disclosure.frame;
    frame.size = size;
    _disclosure.frame = frame;
    _disclosure.position = CGPointMake(CGRectGetMaxX(contentFrame) - size.width * 1.5, CGRectGetHeight(contentFrame)/2);
    [self p_updateDiscrosurePath];
    
    // Title Label
    CGFloat originX = CGRectGetHeight(contentFrame)/2;
    _titleLabel.frame = CGRectMake(originX, 0, CGRectGetWidth(contentFrame) - originX, CGRectGetHeight(contentFrame));
    _titleLabel.font = [_titleLabel.font fontWithSize:CGRectGetHeight(contentFrame)*0.6];
}

- (void)p_updateDiscrosurePath
{
    CGSize size = _disclosure.frame.size;
    CGFloat halfLineWidth = _disclosure.lineWidth * 0.5f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, halfLineWidth, size.height - halfLineWidth);
    CGPathAddLineToPoint(path, NULL, size.width/2, halfLineWidth);
    CGPathAddLineToPoint(path, NULL, size.width - halfLineWidth, size.height - halfLineWidth);
    _disclosure.path = path;
    CFRelease(path);
}

- (void)p_updateSeparatorPath
{
    CGRect rect = _separatorLayer.bounds;
    CGFloat lineWidth = 1.0 / _separatorLayer.contentsScale;
    CGFloat y = CGRectGetMaxY(rect) - lineWidth*0.5;
    
    CGPoint points[2] = {
        CGPointMake(_separatorInsets.left, y),
        CGPointMake(CGRectGetMaxX(rect) - _separatorInsets.right, y),
    };
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
    CGPathAddLineToPoint(path, NULL, points[1].x, points[1].y);
    _separatorLayer.path = path;
    CFRelease(path);
}

#pragma mark - User Action
- (void)p_handleTap:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(sectionHeaderViewSelected:)]) {
        [self.delegate sectionHeaderViewSelected:self];
    }
}
@end
