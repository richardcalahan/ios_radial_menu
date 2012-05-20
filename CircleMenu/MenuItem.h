//
//  MenuItem.h
//  MenuTest
//
//  Created by Richard Calahan on 5/17/12.
//  Copyright (c) 2012 All Day Everyday. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuItem;

@protocol MenuItemDelegate <NSObject>
- (void) menuItemDidSelect:(MenuItem *)item withEvent:(UIEvent *)event;
@end

@interface MenuItem : UIImageView

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) CGPoint innerBounce;
@property (nonatomic) CGPoint outerBounce;

@property (nonatomic, weak) id <MenuItemDelegate> delegate;

@end
