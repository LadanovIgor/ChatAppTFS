//
//  ThemesViewController.m
//  ChatAppTFS
//
//  Created by Ladanov Igor on 11.10.2021.
//

#import "ThemesViewController.h"

@interface ThemesViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *lightThemeButton;
@property (weak, nonatomic) IBOutlet UIButton *darkThemeButton;
@property (weak, nonatomic) IBOutlet UIButton *champagneThemeButton;

@end

@implementation ThemesViewController
@synthesize theme = _theme;

- (void) viewDidLoad {
	[super viewDidLoad];
	[self setUpThemesButtons];
	[self addTargets];
}

- (void)setTheme:(Theme *)theme {
	[_theme release];
	_theme = theme;
	[_theme retain];
}

- (Theme *)theme {
	return _theme;
}

- (void) setUpThemesButtons {
	self.lightThemeButton.layer.cornerRadius = 14.0;
	self.darkThemeButton.layer.cornerRadius = 14.0;
	self.champagneThemeButton.layer.cornerRadius = 14.0;
}

- (void) addTargets {
	[self.closeButton addTarget:self action:@selector(didCloseButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[self.lightThemeButton addTarget:self action:@selector(didThemeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.darkThemeButton addTarget:self action:@selector(didThemeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.champagneThemeButton addTarget:self action:@selector(didThemeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) didCloseButtonTapped {
	[self dismissViewControllerAnimated:true completion:nil];
}

- (void) didThemeButtonTapped:(UIButton*) button {
	if (button == self.lightThemeButton) {
		_theme = [[Theme alloc] initWithThemeType:ThemeTypeLight];
	} else if (button == self.darkThemeButton) {
		_theme = [[Theme alloc] initWithThemeType:ThemeTypeDark];
	} else if (button == self.champagneThemeButton) {
		_theme = [[Theme alloc] initWithThemeType:ThemeTypeChampagne];
	} else {
		return;
	}
	[self.delegate themesViewController:self didSelectTheme:_theme];
	[self dismissViewControllerAnimated:true completion:nil];
}

- (void) dealloc {
	[_theme release];
	_theme = nil;
	NSLog(@"%s %@ deallocated", __PRETTY_FUNCTION__, self);
	[super dealloc];
}

@end
