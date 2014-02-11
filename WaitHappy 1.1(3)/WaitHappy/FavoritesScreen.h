//
//  SpecialScreen.h
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesScreen : UIViewController
{
    NSMutableArray *searchArray;
 
    IBOutlet UITableView *resultTable;
   
    IBOutlet UILabel *myFavoritesLbl;
}

-(IBAction)backBtn:(id)sender;
@end

