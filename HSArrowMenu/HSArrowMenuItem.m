//
//  HSArrowMenuItem.m
//  HSArrowMenu
//
//  Created by dengyouhua on 19/07/2017.
//  Copyright © 2017 cc | ccworld1000@gmail.com. All rights reserved.
//  [some adjust for new]https://github.com/ccworld1000/HSArrowMenu
//  [reference 1]https://github.com/kolyvan/kxmenu
//  [reference 2]https://github.com/zpz1237/NirKxMenu

#import "HSArrowMenuItem.h"

@implementation HSArrowMenuItem


+ (instancetype) menuItem:(NSString *) title
                    image:(UIImage *) image
                   target:(id)target
                   action:(SEL) action
{
    return [[HSArrowMenuItem alloc] init:title
                              image:image
                             target:target
                             action:action];
}

- (id) init:(NSString *) title
      image:(UIImage *) image
     target:(id)target
     action:(SEL) action
{
    NSParameterAssert(title.length || image);
    
    self = [super init];
    if (self) {
        
        _title = title;
        _image = image;
        _target = target;
        _action = action;
    }
    return self;
}

- (BOOL) enabled
{
    return _target != nil && _action != NULL;
}

- (void) performAction
{
    __strong id target = self.target;
    
    if (target && [target respondsToSelector:_action]) {
        
        [target performSelectorOnMainThread:_action withObject:self waitUntilDone:YES];
    }
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"<%@ #%p %@>", [self class], self, _title];
}

@end
