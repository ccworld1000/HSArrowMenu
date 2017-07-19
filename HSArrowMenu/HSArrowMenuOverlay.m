//
//  HSArrowMenuOverlay.m
//  HSArrowMenu
//
//  Created by dengyouhua on 19/07/2017.
//  Copyright © 2017 cc | ccworld1000@gmail.com. All rights reserved.
//  [some adjust for new]https://github.com/ccworld1000/HSArrowMenu
//  [reference 1]https://github.com/kolyvan/kxmenu
//  [reference 2]https://github.com/zpz1237/NirKxMenu

#import "HSArrowMenuOverlay.h"
#import "HSArrowMenu.h"

@implementation HSArrowMenuOverlay

- (instancetype) initWithFrame:(CGRect)frame maskSetting:(BOOL)mask {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        if (mask) {
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.17];
        } else {
            self.backgroundColor = [UIColor clearColor];
        }
        
        UITapGestureRecognizer *gestureRecognizer;
        gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(singleTap:)];
        
        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

// thank horaceho https://github.com/horaceho
// for his solution described in https://github.com/kolyvan/kxmenu/issues/9

- (void)singleTap:(UITapGestureRecognizer *)recognizer {
    for (UIView *v in self.subviews) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([v isKindOfClass:[HSArrowMenu class]] && [v respondsToSelector:@selector(dismissMenu:)]) {
            [v performSelector:@selector(dismissMenu:) withObject:@(YES)];
        }
#pragma clang diagnostic pop
    }
}


@end
