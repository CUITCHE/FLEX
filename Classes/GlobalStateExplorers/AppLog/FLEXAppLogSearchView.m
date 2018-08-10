//
//  FLEXAppLogSearchView.m
//  FLEX
//
//  Created by He,Junqiu on 2018/8/10.
//  Copyright © 2018年 Flipboard. All rights reserved.
//

#import "FLEXAppLogSearchView.h"

@interface FLEXAppLogSearchView()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *previous;
@property (nonatomic, strong) UIButton *next;

@end

@implementation FLEXAppLogSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:206/255.0 alpha:1];
        _searchBar = ({
            UISearchBar *searchBar = [[UISearchBar alloc] init];
            searchBar.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:searchBar];

            [NSLayoutConstraint constraintWithItem:searchBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:searchBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0].active = YES;
            [NSLayoutConstraint constraintWithItem:searchBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0].active = YES;
            searchBar;
        });
        _previous = [self makeButtonWithTittle:@"❮"];
        _next = [self makeButtonWithTittle:@"❯"];
        [NSLayoutConstraint constraintWithItem:_previous attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:_previous attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:48].active = YES;

        [NSLayoutConstraint constraintWithItem:_next attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:_next attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:48].active = YES;

        [NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_previous attribute:NSLayoutAttributeLeading multiplier:1 constant:-8].active = YES;
        [NSLayoutConstraint constraintWithItem:_previous attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_next attribute:NSLayoutAttributeLeading multiplier:1 constant:-4].active = YES;
        [NSLayoutConstraint constraintWithItem:_next attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:-4].active = YES;

        [NSLayoutConstraint constraintWithItem:_previous attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:_next attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0].active = YES;
    }
    return self;
}

- (UIButton *)makeButtonWithTittle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:button];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 1;
    return button;
}
@end
