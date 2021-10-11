//
//  ThemesViewController.h
//  ChatAppTFS
//
//  Created by Ladanov Igor on 11.10.2021.
//

#import "UIKit/UIKit.h"
#import "Theme.h"
#import "ThemesViewControllerDelegate.h"

@interface ThemesViewController : UIViewController
@property (weak, nonatomic) id<ThemesViewControllerDelegate> delegate;
@property (strong, nonatomic) Theme* theme;
@end
