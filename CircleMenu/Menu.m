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
static CGFloat const MIN_RADIUS = 50.0;
static CGFloat const MAX_RADIUS = 300.0;
static CGFloat const BOUNCE_DISTANCE = 20.0;

@interface Menu()

@property (nonatomic) BOOL menuOn;
@property (nonatomic) CGFloat initialRadius;

@end

@implementation Menu

@synthesize radius = _radius;
@synthesize minRadius = _minRadius;
@synthesize maxRadius = _maxRadius;
@synthesize bounceDistance = _bounceDistance;
@synthesize items = _items;
@synthesize delegate = _delegate;

@synthesize menuOn = _menuOn;
@synthesize initialRadius = _initialRadius;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void) layoutSubviews {
  UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDidOccur:)];
  [self.window addGestureRecognizer:pinch];
}

- (void)pinchDidOccur:(UIPinchGestureRecognizer *)gesture {
  switch (gesture.state) {
    case UIGestureRecognizerStateBegan:
      self.initialRadius = self.radius;
      break;
    case UIGestureRecognizerStateChanged:
      self.radius *= gesture.scale;
      if (self.menuOn) [self dragMenuWithScale:gesture.scale];
      gesture.scale = 1;
      break;
    case UIGestureRecognizerStateEnded:
      if (self.radius < self.initialRadius) [self showMenu];
      else if (self.radius > self.initialRadius) [self hideMenu];
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

- (CGFloat) bounceDistance {
  if (!_bounceDistance) _bounceDistance = BOUNCE_DISTANCE;
  return _bounceDistance;
}

- (void) setRadius:(CGFloat)radius {
  if (radius > self.maxRadius || radius < 0) return;
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
      CGPoint innerBounce = [self makeItemCoordinates:item forRadius:self.minRadius - self.bounceDistance];
      CGPoint outerBounce = [self makeItemCoordinates:item forRadius:self.minRadius + self.bounceDistance];
      item.startPoint = startPoint;
      item.endPoint = endPoint;
      item.innerBounce = innerBounce;
      item.outerBounce = outerBounce;
      [item setDelegate:self];
      [self addSubview:item];
    }
  }
}

- (void) dragMenuWithScale:(CGFloat)scale {
  for (MenuItem *item in self.items) {
    CGPoint origin = [self makeItemCoordinates:item forRadius:self.radius];
    item.center = origin;
  }
}

- (void) showMenu {
  for (MenuItem *item in self.items) {
    float i = [self.items indexOfObject:item];
    SEL selector = @selector(showItem:);
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    [invocation setTarget:self];
    [invocation setArgument:(MenuItem **)&item atIndex:2];
    [NSTimer scheduledTimerWithTimeInterval:i*.03 invocation:invocation repeats:NO];
  }
  self.radius = self.minRadius;
  [self setMenuOn:YES];
}

- (void) showItem:(MenuItem *)item {
  CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  positionAnimation.duration = .25f;
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathMoveToPoint(path, NULL, item.center.x, item.center.y);
  CGPathAddLineToPoint(path, NULL, item.innerBounce.x, item.innerBounce.y);
  CGPathAddLineToPoint(path, NULL, item.outerBounce.x, item.outerBounce.y);
  CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
  positionAnimation.path = path;
  [item.layer addAnimation:positionAnimation forKey:@"showMenu"];
  [item setCenter:item.endPoint];
}

- (void) hideMenu {
  for (MenuItem *item in self.items) [self hideItem:item];
  self.radius = self.maxRadius;
  [self setMenuOn:NO];
}

- (void) hideItem:(MenuItem *)item {
  CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  positionAnimation.duration = .2f;
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathMoveToPoint(path, NULL, item.center.x, item.center.y);
  CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
  positionAnimation.path = path;
  [item.layer addAnimation:positionAnimation forKey:@"hideMenu"];
  [item setCenter:item.startPoint];
}

- (void) menuItemDidSelect:(MenuItem *)item withEvent:(UIEvent *)event {
  [self.delegate menuItemDidSelectAtIndex:[self.items indexOfObject:item]];
  [self hideMenu];
}

@end








