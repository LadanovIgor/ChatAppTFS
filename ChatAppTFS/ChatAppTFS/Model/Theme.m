//
//  Theme.m
//  ChatAppTFS
//
//  Created by Ladanov Igor on 11.10.2021.
//

#import "Theme.h"

@implementation Theme
@synthesize lightColor = _lightColor;
@synthesize champagneColor = _champagneColor;
@synthesize darkColor = _darkColor;

- (instancetype)init
{
	self = [super init];
	if (self) {
		_darkColor = [[UIColor alloc] initWithRed:0.184 green:0.310 blue:0.310 alpha:1.0];
		_champagneColor = [[UIColor alloc] initWithRed:0.969 green:0.906 blue:0.598 alpha:1.0];
		_lightColor = [[UIColor alloc] initWithRed:0.969 green:0.969 blue:0.969 alpha:1.0];
	}
	return self;
}

- (void) setLightColor:(UIColor *)lightColor {
	_lightColor = lightColor;
}

- (void) setDarkColor:(UIColor *)darkColor {
	_darkColor = darkColor;
}

- (void) setChampagneColor:(UIColor *)champagneColor {
	_champagneColor = champagneColor;
}

- (UIColor *)lightColor {
	return _lightColor;
}

- (UIColor *)darkColor {
	return _darkColor;
}

- (UIColor *)champagneColor {
	return _champagneColor;
}


- (void)dealloc {
	
	
//	[_darkColor release];
//	[_lightColor release];
//	[_champagneColor release];
//	NSLog(@"object is deallocated");
//	[super dealloc];
}
@end
