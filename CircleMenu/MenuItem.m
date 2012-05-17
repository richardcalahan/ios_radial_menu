//
//  MenuItem.m
//  MenuTest
//
//  Created by Richard Calahan on 5/17/12.
//  Copyright (c) 2012 All Day Everyday. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

- (id)initWithImage:(UIImage *)image {
  self = [super init];
  if (self) {
    self.image = image;
    self.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    NSLog(@"image init with frame %f %f", self.frame.origin.x, self.frame.origin.y);
  }
  return self;
}

@end
