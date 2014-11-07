//
//  GBFlatButton.m
//  GBFlatButtonExample
//
//  Created by Gustavo Barbosa on 4/15/14.
//  Copyright (c) 2014 Gustavo Barbosa. All rights reserved.
//

#import "GBFlatButton.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const kHorizontalPadding = 14.0f;

@implementation GBFlatButton
@synthesize buttonColor = _buttonColor;//如果自己写setter和getter就要显式synthesize,因为自己写就不会由编译器给你auto synthesize，自然也不会有对应的实例变量(例如_buttonColor)
#pragma mark - Constructors

- (id)init
{
    self = [super init];
    if (self) {
        [self customizeAppearance];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customizeAppearance];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customizeAppearance];
    }
    return self;
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    BOOL containsEdgeInsets = ! UIEdgeInsetsEqualToEdgeInsets(self.contentEdgeInsets, UIEdgeInsetsZero);
    self.contentEdgeInsets = containsEdgeInsets ? self.contentEdgeInsets : UIEdgeInsetsMake(0, kHorizontalPadding, 0, kHorizontalPadding);
    self.layer.borderWidth = self.layer.borderWidth ?: 1.0f;
    self.layer.cornerRadius = self.layer.cornerRadius ?: CGRectGetHeight(self.frame) / 2.0f;
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
        self.backgroundColor = self.buttonColor;
    else
        self.backgroundColor = [UIColor whiteColor];
}

- (void)drawRect:(CGRect)rect
{
    self.layer.borderColor = self.buttonColor.CGColor;
    [self setTitleColor:self.buttonColor
               forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor]
               forState:UIControlStateSelected];
}

#pragma mark - Acessors
- (void)setButtonColor:(UIColor *)newColor
{
    _buttonColor = newColor;
    [self setNeedsDisplay];
}

- (UIColor *)buttonColor
{
    return _buttonColor? _buttonColor:self.tintColor;
}



@end
