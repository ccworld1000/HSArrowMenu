# HSArrowMenu
HSArrowMenu : A popup menu.

some adjust for new [https://github.com/ccworld1000/HSArrowMenu](https://github.com/ccworld1000/HSArrowMenu)



## Pod

```ruby
pod 'HSArrowMenu'
```

# Usage

```objective-c
#import <HSMenu.h>
```
or

```objective-c
#import "HSMenu.h"
```

```objective-c
- (void) pushMenuItem:(HSArrowMenuItem *) item
{
    NSLog(@"CC tag : %ld", item.tag);
}

- (IBAction)showMenu:(UIButton *) b {
    NSMutableArray *menuItems = [NSMutableArray arrayWithCapacity:0];
    NSArray *menuItemsArray = @[@"CC 1", @"CC 2", @"CC 3", @"CC 4", @"CC 5", @"CC 6"];
    for (NSString *title in menuItemsArray) {
        HSArrowMenuItem *item = [HSArrowMenuItem menuItem: title image: [UIImage imageNamed:@"Touch"] target: self action:@selector(pushMenuItem:)];
        item.alignment = NSTextAlignmentCenter;
        item.foreColor = [UIColor blueColor];
        [menuItems addObject: item];
        
    }
    
    HSArrowMenuConfig o = { 9,
        7,
        9,
        25,
        6.5,
        true,
        false,
        true,
        false,
        {0, 0, 0},
        {1,1,1}
    };
    
    [HSMenu showMenuInView:self.view fromRect:b.frame menuItems:menuItems withOptions:o];
    
    NSLog(@"b : %@", b.titleLabel.text);
}
```

# Reference

reference 1 [https://github.com/kolyvan/kxmenu](https://github.com/kolyvan/kxmenu)

reference 2 [https://github.com/zpz1237/NirKxMenu](https://github.com/zpz1237/NirKxMenu)

# ScreenShots
## Menu1
![Menu1 Screenshot](https://raw.github.com/ccworld1000/HSArrowMenu/master/Documentation/menu1.gif)

## Menu2
![Menu2 Screenshot](https://raw.github.com/ccworld1000/HSArrowMenu/master/Documentation/menu2.gif)

## Menu3
![Menu3 Screenshot](https://raw.github.com/ccworld1000/HSArrowMenu/master/Documentation/menu3.gif)


