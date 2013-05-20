//
//  MTZHandyPinchGestureRecognizer.h
//  Handedness
//
//  Created by Matt on 5/16/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	MTZHandednessUnknown,
	MTZHandednessLeft,
	MTZHandednessRight
} MTZHandedness;

@interface MTZHandyPinchGestureRecognizer : UIPinchGestureRecognizer

@property (nonatomic, readonly) MTZHandedness hand;

@end
