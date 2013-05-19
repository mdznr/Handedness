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

- (void)hide
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDidStopSelector:@selector(setHidden)];
	[self setHidden:YES];
	[UIView commitAnimations];
}

- (void)setHidden
{
	[self setHidden:YES];
}

- (void)setZoomLevel:(CGFloat)zoomLevel
{
	// Update text
	[_label setText:[NSString stringWithFormat:@"%.0f%%", 100 * zoomLevel]];
	
	// Make sure it fits
	[_label sizeToFit];
	CGRect rect = [_label textRectForBounds:(CGRect){0,0,FLT_MAX,FLT_MAX} limitedToNumberOfLines:1];
	CGPoint center = self.center;
	[self setFrame:(CGRect){self.frame.origin.x, self.frame.origin.y, round(rect.size.width) + 16, round(rect.size.height) + 10}];
	[self setCenter:(CGPoint){round(center.x), round(center.y)}];
	[_label setCenter:(CGPoint){round(self.bounds.size.width/2), round(self.bounds.size.height/2)}];
	
	_zoomLevel = zoomLevel;
}

@end
