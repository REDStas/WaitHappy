//
//  SearchByName.h
//  WaitHappy
//
//  Created by gelgard on 16.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchByName : UIViewController
{
    IBOutlet UIButton *searchBtn;
    IBOutlet UIButton *cancelBtn;
    IBOutlet UITextField *queryField;
    IBOutlet UITableView *resultTable;
    NSMutableArray *searchArray;
    
    IBOutlet UIImageView *topImage;
    IBOutlet UIView *noResultView;
    IBOutlet UILabel *sorryLabel;
    IBOutlet UILabel *sorryBottomLabel;
}

-(IBAction)startSearch:(id)sender;
-(IBAction)backgroundTap:(id)sender;
-(IBAction)clearField:(id)sender;

@end
