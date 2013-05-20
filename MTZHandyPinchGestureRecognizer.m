/*
 Copyright (c) 2013, Matt Zanchelli
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the <organization> nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

//
//  MTZHandyPinchGestureRecognizer.m
//  Handedness
//
//  Created by Matt on 5/16/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZHandyPinchGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#import "UITouch+locationInOwnWindow.h"

@interface MTZHandyPinchGestureRecognizer ()

// Which hand is being used to perform this pinch?
@property (nonatomic, readwrite) MTZHandedness hand;

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
- (void)determineHandednessForTouches:(NSSet *)touches
{
	// Get UITouch objects
	UITouch *fingerOne = touches.allObjects[0];
	UITouch *fingerTwo = touches.allObjects[1];
	
	// Get the points of each finger
	CGPoint one = [fingerOne locationInOwnWindow];
	CGPoint two = [fingerTwo locationInOwnWindow];
	
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
		_hand = MTZHandednessUnknown;
		return;
	}
	
	// Find if it's left or right
	if ( topFinger + 32 < bottomFinger ) {
		_hand = MTZHandednessLeft
		;
	} else if ( topFinger > bottomFinger + 32 ) {
		_hand = MTZHandednessRight;
	} else {
		// The fingers are two close together to tell
		_hand = MTZHandednessUnknown;
	}
}

// Expects exactly two touches
// Uses slope to determine handedness
- (void)altDetermineHandednessForTouches:(NSSet *)touches
{
	// Get the points of each finger
	CGPoint one = [touches.allObjects[0] locationInOwnWindow];
	CGPoint two = [touches.allObjects[1] locationInOwnWindow];
	
	// Find which finger is on top
	if ( one.y + 24 < two.y ) {
		// One is on top
	} else if ( two.y + 24 < one.y ) {
		// Two is on top, switch
		CGPoint alt = one;
		one = two;
		two = alt;
	} else {
		// The fingers are two close together to tell
		_hand = MTZHandednessUnknown;
		return;
	}
	
	CGFloat slope = (one.y-two.y)/(one.x-two.x);
	
	// May seem backwards, but remember that going down is increasing y.
	if ( slope > 0 ) {
		_hand = MTZHandednessLeft;
	} else {
		_hand = MTZHandednessRight;
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
		NSDate *now = [NSDate date];
		[self altDetermineHandednessForTouches:_myTouches];
		NSDate *after = [NSDate date];
		[self determineHandednessForTouches:_myTouches];
		NSLog(@"%f %f", [after timeIntervalSinceNow], [now timeIntervalSinceDate:after]);
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
	_hand = MTZHandednessUnknown;
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
