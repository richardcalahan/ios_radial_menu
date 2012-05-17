//
//  Menu.h
//  MenuTest
//
//  Created by Richard Calahan on 5/17/12.
//  Copyright (c) 2012 All Day Everyday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Menu : UIView

@property (nonatomic) CGFloat radius;
@property (nonatomic, readwrite) CGPoint center;
@property (strong, nonatomic) NSArray *items;

@end
