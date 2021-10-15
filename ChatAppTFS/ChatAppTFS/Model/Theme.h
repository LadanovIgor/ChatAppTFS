//
//  Theme.h
//  ChatAppTFS
//
//  Created by Ladanov Igor on 11.10.2021.
//

#import "Foundation/Foundation.h"
#import "UIKit/UIKit.h"

typedef NS_ENUM(unsigned char, ThemeType) {
	ThemeTypeLight,
	ThemeTypeDark,
	ThemeTypeChampagne
};

@interface Theme : NSObject

@property (assign) ThemeType type;
- (UIColor *)color;
- (NSString *) description;
- (instancetype)initWithThemeType:(ThemeType)type;

@end
