//
//  Menu.m
//  MenuTest
//
//  Created by Richard Calahan on 5/17/12.
//  Copyright (c) 2012 All Day Everyday. All rights reserved.
//

#import "Menu.h"
#import "MenuItem.h"

static CGFloat const MIN_RADIUS = 100.0;
static CGFloat const MAX_RADIUS = 300.0;

@implementation Menu

@synthesize radius = _radius;
@synthesize center = _center;
@synthesize items = _items;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
    // Set Center of Menu
    CGFloat centerX = (self.frame.size.width / 2);
    CGFloat centerY = (self.frame.size.height / 2);
    self.center = CGPointMake(centerX, centerY);
    
    // Set Background Color
    self.backgroundColor = [UIColor clearColor];
    
  }
  return self;
}

- (void)pinchDidOccur:(UIPinchGestureRecognizer *)gesture {
  self.radius *= gesture.scale;
  for (MenuItem *item in self.items) {
    CGPoint origin = [self makeItemCoordinates:item];
    CGRect frame = CGRectMake(origin.x, origin.y, item.frame.size.width, item.frame.size.height);
    [item setFrame:frame];
  }
  gesture.scale = 1;
  [self setNeedsDisplay];
}

- (CGFloat) radius {
  if (!_radius) _radius = MAX_RADIUS;
  return _radius;
}

- (void) setRadius:(CGFloat)radius {
  if (radius > MAX_RADIUS || radius < MIN_RADIUS) return;
  _radius = radius;
}

- (CGPoint) makeItemCoordinates:(MenuItem *)item {
  CGFloat rad = (M_PI * 2) / [self.items count];
  int i = [self.items indexOfObject:item];
  CGFloat xCoord = (cosf(rad * i) * self.radius) + self.center.x - (item.frame.size.width / 2);
  CGFloat yCoord = (sinf(rad * i) * self.radius) + self.center.y - (item.frame.size.height / 2);
  return CGPointMake(xCoord, yCoord);
}

- (void) setItems:(NSArray *)items {
  if (_items != items) {
    _items = items;
    int count = [_items count];
    for (int i = 0; i < count; i++) {
      MenuItem *item = [_items objectAtIndex:i];
      CGPoint origin = [self makeItemCoordinates:item];
      item.frame = CGRectMake(origin.x, origin.y, item.frame.size.width, item.frame.size.height);
      [self addSubview:item];
    }
  }
}

- (void) drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextAddArc(context, self.center.x, self.center.y, self.radius, 0, M_PI * 2, YES);
  CGContextDrawPath(context, kCGPathStroke);
}


@end