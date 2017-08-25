//
//  HSMenu.m
//  HSArrowMenu
//
//  Created by dengyouhua on 19/07/2017.
//  Copyright © 2017 cc | ccworld1000@gmail.com. All rights reserved.
//  [some adjust for new]https://github.com/ccworld1000/HSArrowMenu
//  [reference 1]https://github.com/kolyvan/kxmenu
//  [reference 2]https://github.com/zpz1237/NirKxMenu

#import "HSMenu.h"
#import "HSArrowMenu.h"
#import "HSArrowMenuOverlay.h"

static HSMenu *gMenu;
static UIColor *gTintColor;
static UIFont *gTitleFont;
static HSArrowMenuPriority gArrowMenuPriority;

@interface HSMenu () {
    HSArrowMenu *_menuView;
    BOOL        _observing;
}

@end

@implementation HSMenu

+ (instancetype) sharedMenu
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        gMenu = [[HSMenu alloc] init];
    });
    return gMenu;
}

- (id) init
{
    NSAssert(!gMenu, @"singleton object");
    
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) dealloc
{
    if (_observing) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems
            withOptions:(HSArrowMenuConfig) options
{
    NSParameterAssert(view);
    NSParameterAssert(menuItems.count);
    
    if (_menuView) {
        
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    if (!_observing) {
        
        _observing = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationWillChange:)
                                                     name:UIApplicationWillChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    
    
    _menuView = [[HSArrowMenu alloc] init];
    [_menuView showMenuInView:view fromRect:rect menuItems:menuItems withOptions:options];
}

- (void) dismissMenu
{
    if (_menuView) {
        
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    if (_observing) {
        
        _observing = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void) orientationWillChange: (NSNotification *) n
{
    [self dismissMenu];
}

+ (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems
            withOptions:(HSArrowMenuConfig) options
{
    [[self sharedMenu] showMenuInView:view fromRect:rect menuItems:menuItems withOptions:options];
}

+ (void) dismissMenu
{
    [[self sharedMenu] dismissMenu];
}

+ (UIColor *) tintColor
{
    return gTintColor;
}

+ (void) setTintColor: (UIColor *) tintColor
{
    if (tintColor != gTintColor) {
        gTintColor = tintColor;
    }
}

+ (UIFont *) titleFont
{
    return gTitleFont;
}

+ (void) setTitleFont: (UIFont *) titleFont
{
    if (titleFont != gTitleFont) {
        gTitleFont = titleFont;
    }
}

+ (HSArrowMenuPriority) arrowMenuPriority {
    return gArrowMenuPriority;
}

+ (void) setHSArrowMenuPriority: (HSArrowMenuPriority) priority {
    if (priority < HSArrowMenuPriorityFirst && priority > HSArrowMenuPriorityLast) {
        NSLog(@"ill priority");
        return;
    }
    
    if (gArrowMenuPriority == priority) {
        return;
    }

    gArrowMenuPriority = priority;
}


@end
