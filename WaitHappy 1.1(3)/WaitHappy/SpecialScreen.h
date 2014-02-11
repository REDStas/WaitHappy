//
//  SpecialScreen.h
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialScreen : UIViewController
{
    IBOutlet UILabel *restaurantName;
    NSMutableArray *searchArray;
    
    IBOutlet UITableView *resultTable;
}

@property (nonatomic,strong) NSString *restaurantId;
@property (nonatomic,strong) IBOutlet UILabel *restaurantName;
@property (nonatomic,strong) IBOutlet UILabel *restaurantLabel;

-(IBAction)backBtn:(id)sender;
@end
