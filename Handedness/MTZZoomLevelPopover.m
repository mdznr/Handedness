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

/// The corner radius to use for the popover.
static const CGFloat cornerRadius = 4.0f;

@interface MTZZoomLevelPopover ()

@property (strong, nonatomic) UILabel *label;

@end

@implementation MTZZoomLevelPopover


#pragma mark - Initialization

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
	self.userInteractionEnabled = NO;
	
	// A rounded-rect semi-transparent black background.
	self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.75];
	self.layer.cornerRadius = cornerRadius;
	
	// Zoom Level label.
	_label = [[UILabel alloc] initWithFrame:self.bounds];
	_label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	_label.textAlignment = NSTextAlignmentCenter;
	_label.textColor = [UIColor whiteColor];
	_label.font = [UIFont boldSystemFontOfSize:18.0f];
	_label.numberOfLines = 1;
	_label.backgroundColor = [UIColor clearColor];
	_label.opaque = NO;
	[self addSubview:_label];
	
	// Hidden by default.
	self.hidden = YES;
}


#pragma mark - Properties

- (void)setZoomLevel:(CGFloat)zoomLevel
{
	// Update property.
	_zoomLevel = zoomLevel;
	
	// Update text (convert to percent).
	_label.text = [NSString stringWithFormat:@"%.0f%%", 100 * zoomLevel];
	
	// Fit and center around label width.
	CGRect textRect = [_label textRectForBounds:CGRectInfinite limitedToNumberOfLines:1];
	
	// Make enough room to fit the text (plus padding).
	CGFloat scale = [UIScreen mainScreen].scale;
	self.bounds = CGRectMake(0, 0,
							 round(textRect.size.width  * scale)/scale + 16,
							 round(textRect.size.height * scale)/scale + 10);
	
	// But round the label to the nearest pixel.
	_label.center = CGPointMake(round((self.bounds.size.width /2) * scale)/scale,
								round((self.bounds.size.height/2) * scale)/scale);
}


#pragma mark - Public API

- (void)show
{
	[self actuallyShow];
}

- (void)hide
{
	// Using spring animation, if available.
	if ( [UIView instancesRespondToSelector:@selector(animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:)] ) {
		[UIView animateWithDuration:0.15f
							  delay:0.0f
			 usingSpringWithDamping:1.0f
			  initialSpringVelocity:1.0f
							options:UIViewAnimationOptionBeginFromCurrentState
						 animations:^{
							 self.alpha = 0.0f;
						 }
						 completion:^(BOOL finished) {
							 [self actuallyHide];
						 }];
	} else {
		[UIView animateWithDuration:0.15f
							  delay:0.0f
							options:UIViewAnimationOptionBeginFromCurrentState
						 animations:^{
							 self.alpha = 0.0f;
						 }
						 completion:^(BOOL finished) {
							 [self actuallyHide];
						 }];
	}
}


#pragma mark - Private API

- (void)actuallyShow
{
	self.alpha = 1.0f;
	self.hidden = NO;
}

- (void)actuallyHide
{
	self.hidden = YES;
	self.alpha = 1.0f;
}

@end
