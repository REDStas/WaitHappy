//
//  SpecialScreen.h
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountSettings.h"

@interface SettingsScreen : UIViewController
{
    IBOutlet UIButton *startSearchBtn;
    IBOutlet UILabel *myFavoritesLbl;
    
    AccountSettings *accountSettingsView;
}


- (IBAction)myInformationPress:(id)sender;
- (IBAction)commentsPress:(id)sender;
- (IBAction)privacyPress:(id)sender;
- (IBAction)aboutPress:(id)sender;



@end

