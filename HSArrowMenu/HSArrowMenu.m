//
//  HSArrowMenu.m
//  HSArrowMenu
//
//  Created by dengyouhua on 19/07/2017.
//  Copyright © 2017 cc | ccworld1000@gmail.com. All rights reserved.
//  [some adjust for new]https://github.com/ccworld1000/HSArrowMenu
//  [reference 1]https://github.com/kolyvan/kxmenu
//  [reference 2]https://github.com/zpz1237/NirKxMenu

#import "HSArrowMenu.h"
#import "HSArrowMenuItem.h"
#import "HSArrowMenuOverlay.h"
#import "HSMenu.h"


@interface HSArrowMenu () {
    CGFloat                     _arrowPosition;
    UIView                      *_contentView;
    NSArray                     *_menuItems;
}

@end

@implementation HSArrowMenu

+ (HSArrowMenu *) shareArrowMenu {
    static HSArrowMenu *hsArrowMenu;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hsArrowMenu = [HSArrowMenu new];
    });
    
    return hsArrowMenu;
}


- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if(self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.opaque = YES;
        self.alpha = 0;
        
    }
    
    return self;
}


- (void) setupFrameInView:(UIView *)view
                 fromRect:(CGRect)fromRect
{
    const CGSize contentSize = _contentView.frame.size;
    
    const CGFloat outerWidth = view.bounds.size.width;
    const CGFloat outerHeight = view.bounds.size.height;
    
    const CGFloat rectX0 = fromRect.origin.x;
    const CGFloat rectX1 = fromRect.origin.x + fromRect.size.width;
    const CGFloat rectXM = fromRect.origin.x + fromRect.size.width * 0.5f;
    const CGFloat rectY0 = fromRect.origin.y;
    const CGFloat rectY1 = fromRect.origin.y + fromRect.size.height;
    const CGFloat rectYM = fromRect.origin.y + fromRect.size.height * 0.5f;;
    
    const CGFloat widthPlusArrow = contentSize.width + self.kxMenuViewOptions.arrowSize;
    const CGFloat heightPlusArrow = contentSize.height + self.kxMenuViewOptions.arrowSize;
    const CGFloat widthHalf = contentSize.width * 0.5f;
    const CGFloat heightHalf = contentSize.height * 0.5f;
    
    const CGFloat kMargin = 5.f;
    
    //此处设置阴影
    if (self.kxMenuViewOptions.shadowOfMenu) {
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(2, 2);
        self.layer.shadowRadius = 2;
        
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
    }
    
    if (heightPlusArrow < (outerHeight - rectY1)) {
        
        _arrowDirection = HSArrowMenuDirectionTypeUp;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY1
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        //_arrowPosition = MAX(16, MIN(_arrowPosition, contentSize.width - 16));
        _contentView.frame = (CGRect){0, self.kxMenuViewOptions.arrowSize, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width,
            contentSize.height + self.kxMenuViewOptions.arrowSize
        };
        
    } else if (heightPlusArrow < rectY0) {
        
        _arrowDirection = HSArrowMenuDirectionTypeDown;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY0 - heightPlusArrow
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width,
            contentSize.height + self.kxMenuViewOptions.arrowSize
        };
        
    } else if (widthPlusArrow < (outerWidth - rectX1)) {
        
        _arrowDirection = HSArrowMenuDirectionTypeLeft;
        CGPoint point = (CGPoint){
            rectX1,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + kMargin) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){self.kxMenuViewOptions.arrowSize, 0, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width + self.kxMenuViewOptions.arrowSize,
            contentSize.height
        };
        
    } else if (widthPlusArrow < rectX0) {
        
        _arrowDirection = HSArrowMenuDirectionTypeRight;
        CGPoint point = (CGPoint){
            rectX0 - widthPlusArrow,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + 5) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width  + self.kxMenuViewOptions.arrowSize,
            contentSize.height
        };
        
    } else {
        
        _arrowDirection = HSArrowMenuDirectionTypeNone;
        
        self.frame = (CGRect) {
            
            (outerWidth - contentSize.width)   * 0.5f,
            (outerHeight - contentSize.height) * 0.5f,
            contentSize,
        };
    }
}

- (void)showMenuInView:(UIView *)view
              fromRect:(CGRect)rect
             menuItems:(NSArray *)menuItems
           withOptions:(HSArrowMenuConfig) options
{
    
    self.kxMenuViewOptions = options;
    
    _menuItems = menuItems;
    
    _contentView = [self mkContentView];
    [self addSubview:_contentView];
    
    [self setupFrameInView:view fromRect:rect];
    
    HSArrowMenuOverlay *overlay = [[HSArrowMenuOverlay alloc] initWithFrame:view.bounds maskSetting:self.kxMenuViewOptions.maskToBackground];
    
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    _contentView.hidden = YES;
    const CGRect toFrame = self.frame;
    self.frame = (CGRect){self.arrowPoint, 1, 1};
    
    
    //Menu弹出动画
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         self.alpha = 1.0f;
                         self.frame = toFrame;
                         
                     } completion:^(BOOL completed) {
                         _contentView.hidden = NO;
                     }];
    
}

- (void)dismissMenu:(BOOL) noAnimated
{
    if (self.superview) {
        
        if (!noAnimated) {
            
            const CGRect toFrame = (CGRect){self.arrowPoint, 1, 1};
            _contentView.hidden = YES;
            
            //Menu收回动画
            [UIView animateWithDuration:0.1
                             animations:^(void) {
                                 
                                 self.alpha = 0;
                                 self.frame = toFrame;
                                 
                             } completion:^(BOOL finished) {
                                 
                                 if ([self.superview isKindOfClass:[HSArrowMenuOverlay class]])
                                     [self.superview removeFromSuperview];
                                 [self removeFromSuperview];
                             }];
            
        } else {
            
            if ([self.superview isKindOfClass:[HSArrowMenuOverlay class]])
                [self.superview removeFromSuperview];
            [self removeFromSuperview];
        }
    }
}

- (void)performAction:(id)sender
{
    [self dismissMenu:YES];
    
    UIButton *button = (UIButton *)sender;
    HSArrowMenuItem *menuItem = _menuItems[button.tag];
    [menuItem performAction];
}

- (UIView *) mkContentView
{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    if (!_menuItems.count)
        return nil;
    
    const CGFloat kMinMenuItemHeight = 32.f;
    const CGFloat kMinMenuItemWidth = 32.f;
    //配置：左右边距
    const CGFloat kMarginX = self.kxMenuViewOptions.marginXSpacing;
    //配置：上下边距
    const CGFloat kMarginY = self.kxMenuViewOptions.marginYSpacing;
    
    UIFont *titleFont = [HSMenu titleFont];
    if (!titleFont) titleFont = [UIFont boldSystemFontOfSize:16];
    
    CGFloat maxImageWidth = 0;
    CGFloat maxItemHeight = 0;
    CGFloat maxItemWidth = 0;
    
    for (HSArrowMenuItem *menuItem in _menuItems) {
        
        const CGSize imageSize = menuItem.image.size;
        if (imageSize.width > maxImageWidth)
            maxImageWidth = imageSize.width;
    }
    
    if (maxImageWidth) {
        maxImageWidth += kMarginX;
    }
    
    for (HSArrowMenuItem *menuItem in _menuItems) {
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        const CGSize titleSize = [menuItem.title sizeWithAttributes:@{NSFontAttributeName: titleFont}];
#else
        const CGSize titleSize = [menuItem.title sizeWithFont:titleFont];
#endif
        const CGSize imageSize = menuItem.image.size;
        
        //这个地方为header和Footer预留了高度
        const CGFloat itemHeight = MAX(titleSize.height, imageSize.height) + kMarginY * 2;
        
        //这个地方设置item宽度
        const CGFloat itemWidth = ((!menuItem.enabled && !menuItem.image) ? titleSize.width : maxImageWidth + titleSize.width) + kMarginX * 2 + self.kxMenuViewOptions.intervalSpacing;
        
        if (itemHeight > maxItemHeight)
            maxItemHeight = itemHeight;
        
        if (itemWidth > maxItemWidth)
            maxItemWidth = itemWidth;
    }
    
    maxItemWidth  = MAX(maxItemWidth, kMinMenuItemWidth);
    maxItemHeight = MAX(maxItemHeight, kMinMenuItemHeight);
    
    //这个地方设置字图间距
    //const CGFloat titleX = kMarginX * 2 + maxImageWidth;
    const CGFloat titleX = maxImageWidth + self.kxMenuViewOptions.intervalSpacing;
    
    const CGFloat titleWidth = maxItemWidth - titleX - kMarginX *2;
    
    UIImage *selectedImage = [HSArrowMenu selectedImage:(CGSize){maxItemWidth, maxItemHeight + 2}];
    //配置：分隔线是与内容等宽还是与菜单等宽
    int insets = 0;
    
    if (self.kxMenuViewOptions.seperatorLineHasInsets) {
        insets = 4;
    }
    
    UIImage *gradientLine = [HSArrowMenu gradientLine: (CGSize){maxItemWidth- kMarginX * insets, 0.4}];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.autoresizingMask = UIViewAutoresizingNone;
    
    contentView.backgroundColor = [UIColor clearColor];
    
    contentView.opaque = NO;
    
    CGFloat itemY = kMarginY * 2;
    
    NSUInteger itemNum = 0;
    NSUInteger step = 0;
    
    for (HSArrowMenuItem *menuItem in _menuItems) {
        menuItem.tag = step;
        
        const CGRect itemFrame = (CGRect){0, itemY-kMarginY * 2 + self.kxMenuViewOptions.menuCornerRadius, maxItemWidth, maxItemHeight};
        
        UIView *itemView = [[UIView alloc] initWithFrame:itemFrame];
        itemView.autoresizingMask = UIViewAutoresizingNone;
        
        itemView.opaque = NO;
        
        [contentView addSubview:itemView];
        
        if (menuItem.enabled) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = itemNum;
            button.frame = itemView.bounds;
            button.enabled = menuItem.enabled;
            
            button.backgroundColor = [UIColor clearColor];
            
            button.opaque = NO;
            button.autoresizingMask = UIViewAutoresizingNone;
            
            [button addTarget:self
                       action:@selector(performAction:)
             forControlEvents:UIControlEventTouchUpInside];
            
            [button setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
            
            [itemView addSubview:button];
        }
        
        if (menuItem.title.length) {
            
            CGRect titleFrame;
            
            if (!menuItem.enabled && !menuItem.image) {
                
                titleFrame = (CGRect){
                    kMarginX * 2,
                    kMarginY,
                    maxItemWidth - kMarginX * 4,
                    maxItemHeight - kMarginY * 2
                };
                
            } else {
                
                titleFrame = (CGRect){
                    titleX,
                    kMarginY,
                    titleWidth,
                    maxItemHeight - kMarginY * 2
                };
            }
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
            titleLabel.text = menuItem.title;
            titleLabel.font = titleFont;
            titleLabel.textAlignment = menuItem.alignment;
            
            //配置：menuItem字体颜色
            //titleLabel.textColor = menuItem.foreColor ? menuItem.foreColor : [UIColor blackColor];
            titleLabel.textColor = [UIColor colorWithRed:self.kxMenuViewOptions.textColor.R green:self.kxMenuViewOptions.textColor.G blue:self.kxMenuViewOptions.textColor.B alpha:1];
            
            titleLabel.backgroundColor = [UIColor clearColor];
            
            titleLabel.autoresizingMask = UIViewAutoresizingNone;
            
            [itemView addSubview:titleLabel];
        }
        
        if (menuItem.image) {
            
            const CGRect imageFrame = {kMarginX * 2, kMarginY, maxImageWidth, maxItemHeight - kMarginY * 2};
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
            imageView.image = menuItem.image;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeCenter;
            imageView.autoresizingMask = UIViewAutoresizingNone;
            [itemView addSubview:imageView];
        }
        
        if (itemNum < _menuItems.count - 1) {
            
            UIImageView *gradientView = [[UIImageView alloc] initWithImage:gradientLine];
            
            //配置：分隔线是与内容等宽还是与菜单等宽
            if (self.kxMenuViewOptions.seperatorLineHasInsets) {
                gradientView.frame = (CGRect){kMarginX * 2, maxItemHeight + 1, gradientLine.size};
            } else {
                gradientView.frame = (CGRect){0, maxItemHeight + 1 , gradientLine.size};
            }
            
            gradientView.contentMode = UIViewContentModeLeft;
            
            //配置：有无分隔线
            if (self.kxMenuViewOptions.hasSeperatorLine) {
                [itemView addSubview:gradientView];
                itemY += 2;
            }
            
            itemY += maxItemHeight;
        }
        
        ++itemNum;
        ++step;
    }
    
    itemY += self.kxMenuViewOptions.menuCornerRadius;
    
    contentView.frame = (CGRect){0, 0, maxItemWidth, itemY + kMarginY * 2 + 5.5 + self.kxMenuViewOptions.menuCornerRadius};
    
    return contentView;
}

- (CGPoint) arrowPoint
{
    CGPoint point;
    
    if (_arrowDirection == HSArrowMenuDirectionTypeUp) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMinY(self.frame) };
        
    } else if (_arrowDirection == HSArrowMenuDirectionTypeDown) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMaxY(self.frame) };
        
    } else if (_arrowDirection == HSArrowMenuDirectionTypeLeft) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
        
    } else if (_arrowDirection == HSArrowMenuDirectionTypeRight) {
        
        point = (CGPoint){ CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
        
    } else {
        
        point = self.center;
    }
    
    return point;
}

+ (UIImage *) selectedImage: (CGSize) size
{
    
    const CGFloat locations[] = {0,1};
    //配置：选中时阴影的颜色  -- 隐藏属性
    const CGFloat components[] = {
        0.890,0.890,0.890,1,
        0.890,0.890,0.890,1
    };
    
    return [self gradientImageWithSize:size locations:locations components:components count:2];
}

+ (UIImage *) gradientLine: (CGSize) size
{
    const CGFloat locations[5] = {0,0.2,0.5,0.8,1};
    
    const CGFloat R = 0.890f, G = 0.890f, B = 0.890f; //分隔线的颜色 -- 隐藏属性
    
    const CGFloat components[20] = {
        R,G,B,1,
        R,G,B,1,
        R,G,B,1,
        R,G,B,1,
        R,G,B,1
    };
    
    return [self gradientImageWithSize:size locations:locations components:components count:5];
}




+ (UIImage *) gradientImageWithSize:(CGSize) size
                          locations:(const CGFloat []) locations
                         components:(const CGFloat []) components
                              count:(NSUInteger)count
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawLinearGradient(context, colorGradient, (CGPoint){0, 0}, (CGPoint){size.width, 0}, 0);
    CGGradientRelease(colorGradient);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void) drawRect:(CGRect)rect
{
    [self drawBackground:self.bounds
               inContext:UIGraphicsGetCurrentContext()];
}

- (void)drawBackground:(CGRect)frame
             inContext:(CGContextRef) context
{
    
    //配置：整个Menu的底色 重中之重
    
    CGFloat R0 = self.kxMenuViewOptions.menuBackgroundColor.R, G0 = self.kxMenuViewOptions.menuBackgroundColor.G, B0 = self.kxMenuViewOptions.menuBackgroundColor.B;
    
    CGFloat R1 = R0, G1 = G0, B1 = B0;
    
    UIColor *tintColor = [HSMenu tintColor];
    if (tintColor) {
        
        CGFloat a;
        [tintColor getRed:&R0 green:&G0 blue:&B0 alpha:&a];
    }
    
    CGFloat X0 = frame.origin.x;
    CGFloat X1 = frame.origin.x + frame.size.width;
    CGFloat Y0 = frame.origin.y;
    CGFloat Y1 = frame.origin.y + frame.size.height;
    
    // render arrow
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    // fix the issue with gap of arrow's base if on the edge
    const CGFloat kEmbedFix = 3.f;
    
    if (_arrowDirection == HSArrowMenuDirectionTypeUp) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - self.kxMenuViewOptions.arrowSize;
        const CGFloat arrowX1 = arrowXM + self.kxMenuViewOptions.arrowSize;
        const CGFloat arrowY0 = Y0;
        const CGFloat arrowY1 = Y0 + self.kxMenuViewOptions.arrowSize + kEmbedFix;
        
        if (_arrowDirection == HSArrowMenuDirectionTypeCustom) {
            const CGFloat leftSpace = 9;
            const CGFloat arrowXWidth = 2 * self.kxMenuViewOptions.arrowSize;
            
            [arrowPath moveToPoint:    (CGPoint){X1 - leftSpace - arrowXWidth / 2., arrowY0}];
            [arrowPath addLineToPoint: (CGPoint){X1 - arrowXWidth / 2., self.kxMenuViewOptions.arrowSize}];
            [arrowPath addLineToPoint: (CGPoint){X1 - leftSpace - arrowXWidth, self.kxMenuViewOptions.arrowSize}];
        } else {
            [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY0}];
            [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
            [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY1}];
            [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY0}];
        }

        [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
        
        Y0 += self.kxMenuViewOptions.arrowSize;
        
    } else if (_arrowDirection == HSArrowMenuDirectionTypeDown) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - self.kxMenuViewOptions.arrowSize;
        const CGFloat arrowX1 = arrowXM + self.kxMenuViewOptions.arrowSize;
        const CGFloat arrowY0 = Y1 - self.kxMenuViewOptions.arrowSize - kEmbedFix;
        const CGFloat arrowY1 = Y1;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY1}];
        
        [[UIColor colorWithRed:R1 green:G1 blue:B1 alpha:1] set];
        
        Y1 -= self.kxMenuViewOptions.arrowSize;
        
    } else if (_arrowDirection == HSArrowMenuDirectionTypeLeft) {
        
        const CGFloat arrowYM = _arrowPosition;
        const CGFloat arrowX0 = X0;
        const CGFloat arrowX1 = X0 + self.kxMenuViewOptions.arrowSize + kEmbedFix;
        const CGFloat arrowY0 = arrowYM - self.kxMenuViewOptions.arrowSize;;
        const CGFloat arrowY1 = arrowYM + self.kxMenuViewOptions.arrowSize;
        
        [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
        
        [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
        
        X0 += self.kxMenuViewOptions.arrowSize;
        
    } else if (_arrowDirection == HSArrowMenuDirectionTypeRight) {
        
        const CGFloat arrowYM = _arrowPosition;
        const CGFloat arrowX0 = X1;
        const CGFloat arrowX1 = X1 - self.kxMenuViewOptions.arrowSize - kEmbedFix;
        const CGFloat arrowY0 = arrowYM - self.kxMenuViewOptions.arrowSize;;
        const CGFloat arrowY1 = arrowYM + self.kxMenuViewOptions.arrowSize;
        
        [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
        
        [[UIColor colorWithRed:R1 green:G1 blue:B1 alpha:1] set];
        
        X1 -= self.kxMenuViewOptions.arrowSize;
    }
    
    [arrowPath fill];
    
    // render body
    
    const CGRect bodyFrame = {X0, Y0, X1 - X0, Y1 - Y0};
    
    //配置：这里修改菜单圆角
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:bodyFrame
                                                          cornerRadius:self.kxMenuViewOptions.menuCornerRadius];
    
    const CGFloat locations[] = {0, 1};
    const CGFloat components[] = {
        R0, G0, B0, 1,
        R1, G1, B1, 1,
    };
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
                                                                 components,
                                                                 locations,
                                                                 sizeof(locations)/sizeof(locations[0]));
    CGColorSpaceRelease(colorSpace);
    
    
    [borderPath addClip];
    
    CGPoint start, end;
    
    if (_arrowDirection == HSArrowMenuDirectionTypeLeft ||
        _arrowDirection == HSArrowMenuDirectionTypeRight) {
        
        start = (CGPoint){X0, Y0};
        end = (CGPoint){X1, Y0};
        
    } else {
        
        start = (CGPoint){X0, Y0};
        end = (CGPoint){X0, Y1};
    }
    
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    
    CGGradientRelease(gradient);
}

@end
