//
//  MTZHandyPinchGestureRecognizer.m
//  Handedness
//
//  Created by Matt on 5/16/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZHandyPinchGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface MTZHandyPinchGestureRecognizer ()

@property (nonatomic, readwrite) MTZHandidness hand;

@end

@implementation MTZHandyPinchGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	
	// Must have two touches, if not what are you doing here!?
	if ( touches.count != 2 ) return;
	
	// Get UITouch
	UITouch *fingerOne = touches.allObjects[0];
	UITouch *fingerTwo = touches.allObjects[1];
	
	// Get the points of each finger
	CGPoint one = [fingerOne locationInView:fingerOne.view];
	CGPoint two = [fingerTwo locationInView:fingerTwo.view];
	
	// Find which finger is on top
	CGFloat topFinger, bottomFinger;
	if ( one.y < two.y ) {
		// One is on top
		topFinger = one.x;
		bottomFinger = two.x;
	} else {
		// Two is on top
		topFinger = two.x;
		bottomFinger = one.x;
	}
	
	// Find if it's left or right
	if ( topFinger < bottomFinger ) {
		self.hand = MTZHandidnessLeft;
	} else {
		self.hand = MTZHandidnessRight;
	}
}

@end
