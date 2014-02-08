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
//  MTZViewController.m
//  Handedness
//
//  Created by Matt on 5/16/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "MTZViewController.h"
#import "MTZHandyPinchGestureRecognizer.h"
#import "MTZZoomLevelPopover.h"

@interface MTZViewController ()

@property (strong, nonatomic) UIView *viewToScale;
@property CGSize fullSize;
@property CGSize gestureStartSize;

@property (strong, nonatomic) MTZZoomLevelPopover *zoomPercentage;
@property CGFloat labelOffset;

@property (nonatomic) BOOL movePopoverContinuouslyWithGesture;

@end

@implementation MTZViewController


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.view.backgroundColor = [UIColor underPageBackgroundColor];
	
	CGRect rect = self.view.bounds;
	rect.origin.y += 20;
	rect.origin.x += 20;
	rect.size.width -= 40;
	rect.size.height -= 40;
	_viewToScale = [[UIView alloc] initWithFrame:rect];
	_viewToScale.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  |
									UIViewAutoresizingFlexibleRightMargin |
									UIViewAutoresizingFlexibleTopMargin   |
									UIViewAutoresizingFlexibleBottomMargin;
	_viewToScale.backgroundColor = [UIColor whiteColor];
	_viewToScale.layer.shadowColor = [UIColor blackColor].CGColor;
	_viewToScale.layer.shadowOpacity = 0.15f;
	_viewToScale.layer.shadowOffset = (CGSize){0,1};
	_viewToScale.layer.shadowRadius = 1;
	_fullSize = _viewToScale.bounds.size;
	[self.view addSubview:_viewToScale];
	
	MTZHandyPinchGestureRecognizer *pinch = [[MTZHandyPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)];
	[self.view addGestureRecognizer:pinch];
	
	_zoomPercentage = [[MTZZoomLevelPopover alloc] init];
	[self.view addSubview:_zoomPercentage];
	
	_labelOffset = 128;
	
	_movePopoverContinuouslyWithGesture = YES;
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}


#pragma mark - Gesture

- (void)didPinch:(id)sender
{
	if ( [sender isKindOfClass:[MTZHandyPinchGestureRecognizer class]] ) {
		MTZHandyPinchGestureRecognizer *sendr = (MTZHandyPinchGestureRecognizer *) sender;
		switch ( sendr.state ) {
			case UIGestureRecognizerStateBegan:
				_gestureStartSize = _viewToScale.bounds.size;
			case UIGestureRecognizerStateChanged:
				[self scaleThatView:sendr.scale];
			case UIGestureRecognizerStateCancelled:
			case UIGestureRecognizerStateEnded:
			case UIGestureRecognizerStateFailed:
				[self showScaleForPinch:sendr];
			default:
				break;
		}
	}
}

- (void)scaleThatView:(CGFloat)scale
{	
	CGFloat w = _gestureStartSize.width  * scale;
	CGFloat h = _gestureStartSize.height * scale;
	CGFloat x = _viewToScale.center.x - (w/2);
	CGFloat y = _viewToScale.center.y - (h/2);
	_viewToScale.frame = (CGRect){x, y, w, h};
}

- (CGRect)getRectWithinScreen:(CGRect)rect
{	
	CGFloat padding = 10;
	
	CGSize screen = [UIScreen mainScreen].bounds.size;
#pragma mark There has to be a better way of finding screen size for orientation
	if ( UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation]) ) {
		screen = (CGSize){screen.height, screen.width};
	}
	
	if ( rect.origin.x < padding ) {
		rect.origin.x = padding;
	} else if ( screen.width - (rect.origin.x + rect.size.width) < padding ) {
		rect.origin.x = screen.width - rect.size.width - padding;
	}
	
	if ( rect.origin.y < padding ) {
		rect.origin.y = padding;
	} else if ( screen.height - (rect.origin.y + rect.size.height) < padding ) {
		rect.origin.y = screen.height - rect.size.height - padding;
	}
	
	return rect;
}

- (void)showScaleForPinch:(MTZHandyPinchGestureRecognizer *)sender
{
	switch ( sender.state ) {
		case UIGestureRecognizerStateBegan:
#ifdef DEBUG
			// Print out hand for debugging
			switch ( sender.hand ) {
				case MTZHandednessLeft: NSLog(@"Left"); break;
				case MTZHandednessRight:  NSLog(@"Right"); break;
				case MTZHandednessUnknown: NSLog(@"Unknown"); break;
			}
#endif
			// Show popover
			[_zoomPercentage show];
			
			// Move popover at the beginning
			if ( !_movePopoverContinuouslyWithGesture ) {
				[self movePopoverAwayFromPoint:[sender locationInView:self.view]
								 forHandedness:sender.hand];
			}
			
		case UIGestureRecognizerStateChanged:
			// Set zoom level
			_zoomPercentage.zoomLevel = _viewToScale.bounds.size.width / _fullSize.width;
			
			// Move popover, if desired
			if ( _movePopoverContinuouslyWithGesture ) {
				[self movePopoverAwayFromPoint:[sender locationInView:self.view]
								 forHandedness:sender.hand];
			}
			
			break;
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
		default:
			// Hide the popover
			[_zoomPercentage hide];
			break;
	}
	
}

- (void)movePopoverAwayFromPoint:(CGPoint)point
				   forHandedness:(MTZHandedness)handedness
{
	// Start at center point
	CGPoint center = point;
	
	// Check handedness and adjust center accordingly
	switch ( handedness ) {
		case MTZHandednessLeft:
			center.x += _labelOffset;
			center.y -= _labelOffset;
			break;
		case MTZHandednessRight:
			center.x -= _labelOffset;
			center.y -= _labelOffset;
			break;
		case MTZHandednessUnknown:
			break;
	}
	
	// Show it at the appropriate place
	_zoomPercentage.center = center;
	
	// Make sure it's an appropriate distance away from edges
	_zoomPercentage.frame = [self getRectWithinScreen:_zoomPercentage.frame];
}


#pragma mark - UIViewController Misc.

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
