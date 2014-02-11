//
//  SpecialScreen.h
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutScreen : UIViewController
{
    NSMutableArray *searchArray;
 
    IBOutlet UITableView *resultTable;
    
    IBOutlet UIButton *startSearchBtn;
    IBOutlet UILabel *myFavoritesLbl;
}

- (IBAction)goToWaitHappy:(id)sender;
- (IBAction)goToWaitTraveller:(id)sender;

- (IBAction)backBtn:(id)sender;

@end

