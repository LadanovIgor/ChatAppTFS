//
//  ThemesViewControllerDelegate.h
//  ChatAppTFS
//
//  Created by Ladanov Igor on 11.10.2021.
//

#import "Foundation/Foundation.h"
#import "UIKit/UIKit.h"

@protocol ThemesViewControllerDelegate <NSObject>

- (void)themesViewController: (UIViewController *)controller didSelectTheme:(Theme*)selectedTheme;

@end
