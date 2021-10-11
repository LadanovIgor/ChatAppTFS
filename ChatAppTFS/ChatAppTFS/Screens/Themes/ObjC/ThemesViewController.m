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
	_theme = theme;
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
	UIColor* color = [[UIColor alloc] init];
	if (button == self.lightThemeButton) {
		color = self.theme.lightColor;
	} else if (button == self.darkThemeButton) {
		color = self.theme.darkColor;
	} else if (button == self.champagneThemeButton) {
		color = self.theme.champagneColor;
	} else {
		return;
	}
	[self.delegate themesViewController:self didSelectTheme:color];
	[self dismissViewControllerAnimated:true completion:nil];
}


@end
