//
//  Menu.h
//  MenuTest
//
//  Created by Richard Calahan on 5/17/12.
//  Copyright (c) 2012 All Day Everyday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@interface Menu : UIView <MenuItemDelegate>

@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat minRadius;
@property (nonatomic) CGFloat maxRadius;
@property (nonatomic, readwrite) CGPoint center;
@property (strong, nonatomic) NSArray *items;

@end
