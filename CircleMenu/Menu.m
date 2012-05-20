//
//  Menu.m
//  MenuTest
//
//  Created by Richard Calahan on 5/17/12.
//  Copyright (c) 2012 All Day Everyday. All rights reserved.
//

#import "Menu.h"
#import "MenuItem.h"

// Default config vars if not set
static CGFloat const MIN_RADIUS = 80.0;
static CGFloat const MAX_RADIUS = 300.0;

@interface Menu()

@property (nonatomic) BOOL menuOn;
@property (nonatomic) CGFloat initialRadius;

@end

@implementation Menu

@synthesize minRadius = _minRadius;
@synthesize maxRadius = _maxRadius;
@synthesize radius = _radius;
@synthesize center = _center;
@synthesize items = _items;
@synthesize menuOn = _menuOn;
@synthesize initialRadius = _initialRadius;

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
  switch (gesture.state) {
    case UIGestureRecognizerStateBegan:
      self.initialRadius = self.radius;
      break;
    case UIGestureRecognizerStateChanged:
      self.radius *= gesture.scale;
      gesture.scale = 1;
      break;
    case UIGestureRecognizerStateEnded:
      if (self.radius < self.initialRadius) [self showMenu];
      else if (self.radius > self.initialRadius) [self hideMenu];
//      for (MenuItem *item in self.items) {
//        CGPoint origin = [self makeItemCoordinates:item];
//        CGRect frame = CGRectMake(origin.x, origin.y, item.frame.size.width, item.frame.size.height);
//        [item setFrame:frame];
//      }
      break;
    case UIGestureRecognizerStateFailed:
    case UIGestureRecognizerStatePossible:
    case UIGestureRecognizerStateCancelled:
      break;
  }
}

- (CGFloat) radius {
  if (!_radius) _radius = MAX_RADIUS;
  return _radius;
}

- (CGFloat) maxRadius {
  if (!_maxRadius) _maxRadius = MAX_RADIUS;
  return _maxRadius;
}

- (CGFloat) minRadius {
  if (!_minRadius) _minRadius = MIN_RADIUS;
  return _minRadius;
}

- (void) setRadius:(CGFloat)radius {
  if (radius > self.maxRadius || radius < self.minRadius) return;
  _radius = radius;
}

- (CGPoint) makeItemCoordinates:(MenuItem *)item forRadius:(CGFloat)radius {
  CGFloat rad = (M_PI * 2) / [self.items count];
  float radianOffset = -M_PI / 2;
  int i = [self.items indexOfObject:item];
  CGFloat xCoord = (cosf((rad * i) + radianOffset) * radius) + self.center.x;
  CGFloat yCoord = (sinf((rad * i) + radianOffset) * radius) + self.center.y;
  return CGPointMake(xCoord, yCoord);
}

- (void) setItems:(NSArray *)items {
  if (_items != items) {
    _items = items;
    for (MenuItem *item in _items) {
      CGPoint startPoint = [self makeItemCoordinates:item forRadius:self.maxRadius];
      CGPoint endPoint = [self makeItemCoordinates:item forRadius:self.minRadius];
      CGPoint innerBounce = [self makeItemCoordinates:item forRadius:self.minRadius - 20];
      CGPoint outerBounce = [self makeItemCoordinates:item forRadius:self.minRadius + 20];
      item.startPoint = startPoint;
      item.endPoint = endPoint;
      item.innerBounce = innerBounce;
      item.outerBounce = outerBounce;
      [item setDelegate:self];
      [self addSubview:item];
    }
  }
}

- (void) menuItemDidSelect:(MenuItem *)item withEvent:(UIEvent *)event {
  NSLog(@"indexOf: %i", [self.items indexOfObject:item]);
}

- (void) showMenu {
  for (MenuItem *item in self.items) {
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = .3f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.center.x, item.center.y);
    CGPathAddLineToPoint(path, NULL, item.innerBounce.x, item.innerBounce.y);
    CGPathAddLineToPoint(path, NULL, item.outerBounce.x, item.outerBounce.y);
    CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    positionAnimation.path = path;
    [item.layer addAnimation:positionAnimation forKey:@"showMenu"];
    [item setCenter:item.endPoint];
  }
}

- (void) hideMenu {
  for (MenuItem *item in self.items) {
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = .3f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.center.x, item.center.y);
    CGPathAddLineToPoint(path, NULL, item.innerBounce.x, item.innerBounce.y);
    CGPathAddLineToPoint(path, NULL, item.outerBounce.x, item.outerBounce.y);
    CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    positionAnimation.path = path;
    [item.layer addAnimation:positionAnimation forKey:@"showMenu"];
    [item setCenter:item.startPoint];
  }
}

@end








