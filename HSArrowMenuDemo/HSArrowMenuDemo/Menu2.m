//
//  Menu2.m
//  HSArrowMenuDemo
//
//  Created by dengyouhua on 20/07/2017.
//  Copyright © 2017 cc | ccworld1000@gmail.com. All rights reserved.
//

#import "Menu2.h"
#import <HSMenu.h>

@interface Menu2 ()

@end

@implementation Menu2

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
    
    HSArrowMenuConfig o = { 12,
        7,
        9,
        25,
        0,
        YES,
        NO,
        YES,
        NO,
        {0, 0, 0},
        {1,1,1}
    };
    
    [HSMenu showMenuInView:self.view fromRect:b.frame menuItems:menuItems withOptions:o];
    
    NSLog(@"b : %@", b.titleLabel.text);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
