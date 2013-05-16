//
//  MTZViewController.m
//  Handedness
//
//  Created by Matt on 5/16/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZViewController.h"
#import "MTZHandyPinchGestureRecognizer.h"

@interface MTZViewController ()

@property (strong, nonatomic) UIView *viewToScale;
@property CGSize fullSize;
@property CGSize gestureStartSize;

@property UILabel *zoomPercentage;
@property CGFloat labelOffset;

@end

@implementation MTZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	_viewToScale = [[UIView alloc] initWithFrame:self.view.bounds];
	[_viewToScale setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_viewToScale setBackgroundColor:[UIColor lightGrayColor]];
	_fullSize = _viewToScale.bounds.size;
	[self.view addSubview:_viewToScale];
	
	MTZHandyPinchGestureRecognizer *pinch = [[MTZHandyPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)];
	[self.view addGestureRecognizer:pinch];
	
	_zoomPercentage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 128, 50)];
	[_zoomPercentage setUserInteractionEnabled:NO];
	[_zoomPercentage setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.75f]];
	[_zoomPercentage setTextAlignment:NSTextAlignmentCenter];
	[_zoomPercentage setTextColor:[UIColor whiteColor]];
	[_zoomPercentage setNumberOfLines:1];
	[_zoomPercentage setHidden:YES];
	[self.view addSubview:_zoomPercentage];
	
	_labelOffset = 100;
}

- (void)didPinch:(id)sender
{
	if ( [sender isKindOfClass:[UIPinchGestureRecognizer class]] ) {
		UIPinchGestureRecognizer *sendr = (UIPinchGestureRecognizer *) sender;
		switch ( sendr.state ) {
			case UIGestureRecognizerStateBegan:
				_gestureStartSize = _viewToScale.bounds.size;
			default:
				[self scaleThatView:sendr.scale];
				[self showScaleForPinch:sendr];
		}
	}
}

- (void)scaleThatView:(CGFloat)scale
{
	CGFloat w = _gestureStartSize.width * scale;
	CGFloat h = _gestureStartSize.height * scale;
	CGFloat x = _viewToScale.center.x - (w/2);
	CGFloat y = _viewToScale.center.y - (h/2);
	[_viewToScale setFrame:(CGRect){x, y, w, h}];
	[_viewToScale setCenter:self.view.center];
}

- (void)showScaleForPinch:(MTZHandyPinchGestureRecognizer *)sender
{
	switch ( sender.state ) {
		case UIGestureRecognizerStateBegan:
			// Show popover
			[_zoomPercentage setHidden:NO];
			// Find center
			CGPoint center = [sender locationInView:self.view];
			// Check handedness and adjust center accordingly
			if ( sender.hand == MTZHandidnessLeft ) {
				center.x += _labelOffset;
				NSLog(@"left");
			} else {
				center.x -= _labelOffset;
				NSLog(@"right");
			}
			center.y -= _labelOffset/2;
			// Show it at the appropriate place
			[_zoomPercentage setCenter:center];
		case UIGestureRecognizerStateChanged:
			// Update text
			[_zoomPercentage setText:[NSString stringWithFormat:@"%.0f%%", 100 * sender.scale]];
			// Make sure it fits
			[_zoomPercentage sizeToFit];
			break;
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
			[_zoomPercentage setHidden:YES];	// Hide popover
		default:
			break;
	}
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
