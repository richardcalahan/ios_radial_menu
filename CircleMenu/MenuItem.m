//
//  MenuItem.m
//  MenuTest
//
//  Created by Richard Calahan on 5/17/12.
//  Copyright (c) 2012 All Day Everyday. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

@synthesize delegate = _delegate;
@synthesize startPoint = _startPoint;
@synthesize endPoint = _endPoint;
@synthesize innerBounce = _innerBounce;
@synthesize outerBounce = _outerBounce;


- (id)initWithImage:(UIImage *)image {
  self = [super init];
  if (self) {
    self.image = image;
    self.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    self.userInteractionEnabled = YES;
  }
  return self;
}

- (void) setStartPoint:(CGPoint)startPoint {
  _startPoint = startPoint;
  self.center = startPoint;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.delegate menuItemDidSelect:self withEvent:event];
}

@end
