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
//  MTZZoomLevelPopover.m
//  Handedness
//
//  Created by Matt on 5/18/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZZoomLevelPopover.h"
#import <QuartzCore/QuartzCore.h>

@interface MTZZoomLevelPopover ()

@property (strong, nonatomic) UILabel *label;

@end

@implementation MTZZoomLevelPopover

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setup];
	}
	return self;
}

- (id)init
{
	self = [super init];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)setup
{
	[self setUserInteractionEnabled:NO];
	[self setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.75f]];
	
	[self.layer setCornerRadius:4.0f];
	
	_label = [[UILabel alloc] initWithFrame:self.bounds];
	[_label setAutoresizingMask:UIViewAutoresizingFlexibleHeight |
	                            UIViewAutoresizingFlexibleWidth];
	[_label setTextAlignment:NSTextAlignmentCenter];
	[_label setTextColor:[UIColor whiteColor]];
	[_label setFont:[UIFont boldSystemFontOfSize:24.0f]];
	[_label setNumberOfLines:1];
	[_label setBackgroundColor:[UIColor clearColor]];
	[_label setOpaque:NO];
	[self addSubview:_label];
	
	[self setHidden:YES];
}

- (void)show
{
	[self setAlpha:1.0f];
	[self setHidden:NO];
}

- (void)hide
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.15f];
	[UIView setAnimationDidStopSelector:@selector(setHidden)];
	[self setAlpha:0.0f];
	[UIView commitAnimations];
}

- (void)setHidden
{
	[self setHidden:YES];
	[self setAlpha:1.0f];
}

- (void)setZoomLevel:(CGFloat)zoomLevel
{
	// Update text
	NSString *text = [NSString stringWithFormat:@"%.0f%%", 100 * zoomLevel];
	[_label setText:text];
	
	// Fit and center around label width
	CGRect rect = [_label textRectForBounds:(CGRect){0, 0, FLT_MAX, FLT_MAX} limitedToNumberOfLines:1];
	CGPoint center = self.center;
	[self setFrame:(CGRect){round(self.frame.origin.x), round(self.frame.origin.y), round(rect.size.width) + 16, round(rect.size.height) + 10}];
	[self setCenter:(CGPoint){round(center.x), round(center.y)}];
	[_label setCenter:(CGPoint){round(self.bounds.size.width/2), round(self.bounds.size.height/2)}];
	
	_zoomLevel = zoomLevel;
}

@end
