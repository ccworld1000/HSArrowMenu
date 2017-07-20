//
//  HSMenu.h
//  HSArrowMenu
//
//  Created by dengyouhua on 19/07/2017.
//  Copyright © 2017 cc | ccworld1000@gmail.com. All rights reserved.
//  [some adjust for new]https://github.com/ccworld1000/HSArrowMenu
//  [reference 1]https://github.com/kolyvan/kxmenu
//  [reference 2]https://github.com/zpz1237/NirKxMenu


#import <Foundation/Foundation.h>
#import "HSArrowMenu.h"
#import "HSArrowMenuItem.h"

@interface HSMenu : NSObject

+ (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems
            withOptions:(HSArrowMenuConfig) options;

+ (void) dismissMenu;

+ (UIColor *) tintColor;
+ (void) setTintColor: (UIColor *) tintColor;

+ (UIFont *) titleFont;
+ (void) setTitleFont: (UIFont *) titleFont;

@end
