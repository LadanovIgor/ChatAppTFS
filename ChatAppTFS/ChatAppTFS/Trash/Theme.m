//
//  Theme.m
//  ChatAppTFS
//
//  Created by Ladanov Igor on 11.10.2021.
//

#import "Theme.h"

@implementation Theme

- (instancetype)initWithThemeType:(ThemeType)type {
	if (self = [super init]) {
		_type = type;
	}
	return self;
}

- (UIColor *)color {
	switch (_type) {
		case ThemeTypeDark:
			return [[[UIColor alloc] initWithRed:0.184 green:0.310 blue:0.310 alpha:1.0] autorelease];
		case ThemeTypeLight:
			return [[[UIColor alloc] initWithRed:0.969 green:0.969 blue:0.969 alpha:1.0] autorelease];
		case ThemeTypeChampagne:
			return [[[UIColor alloc] initWithRed:0.969 green:0.906 blue:0.598 alpha:1.0] autorelease];
	}
}

- (NSString *)description {
	switch (_type) {
		case ThemeTypeDark:
			return @"Dark";
		case ThemeTypeLight:
			return @"Light";
		case ThemeTypeChampagne:
			return @"Champagne";
	}
}

- (void)dealloc {
//	NSLog(@"%s %@ deallocated", __PRETTY_FUNCTION__, self);
	[super dealloc];
}
@end
