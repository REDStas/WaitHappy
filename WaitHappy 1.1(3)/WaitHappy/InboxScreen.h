//
//  SpecialScreen.h
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxScreen : UIViewController
{
   // NSMutableArray *searchArray;
 
    IBOutlet UITableView *resultTable;
    
    IBOutlet UIButton *startSearchBtn;
    IBOutlet UILabel *myFavoritesLbl;
}

- (IBAction)startSearchPress:(id)sender;
- (IBAction)backBtn:(id)sender;
- (void)loadDataFromDB;

//- (IBAction)goToInbox:(id)sender;


@end

