//
//  SpecialScreen.h
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivacyScreen : UIViewController
{
    NSMutableArray *searchArray;
 
    IBOutlet UITableView *resultTable;
    
    IBOutlet UIButton *startSearchBtn;
    IBOutlet UILabel *myFavoritesLbl;
}

- (IBAction)goToLink:(id)sender;

- (IBAction)backBtn:(id)sender;

@end

