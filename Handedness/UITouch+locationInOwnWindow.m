//
//  UITouch+locationInOwnWindow.m
//  Handedness
//
//  Created by Matt on 5/20/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "UITouch+locationInOwnWindow.h"

@implementation UITouch (locationInOwnWindow)

- (CGPoint)locationInOwnWindow
{
	return [self locationInView:self.window];
}

@end
