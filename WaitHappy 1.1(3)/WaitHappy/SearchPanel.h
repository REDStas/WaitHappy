//
//  SearchPanel.h
//  WaitHappy
//
//  Created by gelgard on 16.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchPanel : UIViewController
{
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *distance_label;
    IBOutlet UILabel *map_label;
    IBOutlet UILabel *type_label;
}

-(void)setTextsOnLabels;
-(IBAction)clickByBtn:(id)sender;
-(IBAction)backBtn:(id)sender;

@end
