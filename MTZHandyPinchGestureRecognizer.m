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

// Which hand is being used to perform this pinch?
@property (nonatomic, readwrite) MTZHandidness hand;

// If actually implemented by UIKit, it would be replaced with 'touches'
@property (nonatomic, strong) NSMutableSet *myTouches;

@end

@implementation MTZHandyPinchGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
	self = [super initWithTarget:target action:action];
	if ( self ) {
		// Most likely going to be of size 2.
		_myTouches = [[NSMutableSet alloc] initWithCapacity:2];
	}
	return self;
}

// Expects exactly two touches
- (void)determineHandidnessForTouches:(NSSet *)touches
{
	// Get UITouch objects
	UITouch *fingerOne = touches.allObjects[0];
	UITouch *fingerTwo = touches.allObjects[1];
	
	// Get the points of each finger
	CGPoint one = [fingerOne locationInView:fingerOne.window];
	CGPoint two = [fingerTwo locationInView:fingerTwo.window];
	
	// Find which finger is on top
	CGFloat topFinger, bottomFinger;
	if ( one.y + 24 < two.y ) {
		// One is on top
		topFinger = one.x;
		bottomFinger = two.x;
	} else if ( two.y + 24 < one.y ) {
		// Two is on top
		topFinger = two.x;
		bottomFinger = one.x;
	} else {
		// The fingers are two close together to tell
		_hand = MTZHandidnessUnknown;
		return;
	}
	
	NSLog(@"%f %f", topFinger, bottomFinger);
	
	// Find if it's left or right
	if ( topFinger + 32 < bottomFinger ) {
		_hand = MTZHandidnessLeft;
	} else if ( topFinger > bottomFinger + 32 ) {
		_hand = MTZHandidnessRight;
	} else {
		// The fingers are two close together to tell
		_hand = MTZHandidnessUnknown;
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	[_myTouches unionSet:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	
	if ( self.state == UIGestureRecognizerStateBegan ) {
		[self determineHandidnessForTouches:_myTouches];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	[_myTouches minusSet:touches];
	if ( _myTouches.count == 0 ) {
		_myTouches = [[NSMutableSet alloc] initWithCapacity:2];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
}

- (void)reset
{
	[super reset];
	_hand = MTZHandidnessUnknown;
	_myTouches = [[NSMutableSet alloc] initWithCapacity:2];
}

- (void)ignoreTouch:(UITouch *)touch forEvent:(UIEvent *)event
{
	[super ignoreTouch:touch forEvent:event];
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
	return [super canBePreventedByGestureRecognizer:preventingGestureRecognizer];
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer
{
	return [super canPreventGestureRecognizer:preventedGestureRecognizer];
}

@end
