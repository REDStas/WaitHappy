//
//  SpecialScreen.h
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleItemScreen.h"


@interface WaitListsScreen : UIViewController
{
    SingleItemScreen *screen;
    IBOutlet UILabel *restaurantName;
    NSMutableArray *searchArray;
    
    IBOutlet UIButton *refreshButton;
    IBOutlet UIButton *startSearchBtn;    
    
    IBOutlet UITableView *resultTable;
}

@property (nonatomic,strong) NSString *restaurantId;
@property (nonatomic,strong) IBOutlet UILabel *topLabel;
//@property (nonatomic,strong) IBOutlet UILabel *restaurantLabel;
- (IBAction)startSearchTap:(id)sender;
//- (IBAction)refreshBtnTap:(id)sender;
-(void)loadDataFromDB;
-(IBAction)backBtn:(id)sender;
@end
