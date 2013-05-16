//
//  MTZHandyPinchGestureRecognizer.h
//  Handedness
//
//  Created by Matt on 5/16/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	MTZHandidnessLeft,
	MTZHandidnessRight
} MTZHandidness;

@interface MTZHandyPinchGestureRecognizer : UIPinchGestureRecognizer

@property (nonatomic, readonly) MTZHandidness hand;

@end
