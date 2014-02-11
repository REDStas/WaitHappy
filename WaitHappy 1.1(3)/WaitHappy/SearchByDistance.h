//
//  SearchByDistance.h
//  WaitHappy
//
//  Created by gelgard on 16.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchByDistance : UIViewController
{
    NSArray *distance_lbls;
    //IBOutlet UILabel *lbl_0;
    //IBOutlet UILabel *lbl_1;
    //IBOutlet UILabel *lbl_2;
    //IBOutlet UILabel *lbl_3;
    //IBOutlet UILabel *lbl_4;
    
    IBOutlet UIView *noResultView;
    IBOutlet UILabel *sorryLabel;
    IBOutlet UILabel *sorryBottomLabel;
    IBOutlet UIView *centerView;
    IBOutlet UIImageView *topPic;
    
    IBOutlet UISegmentedControl *distanceSegmentControll;
    NSMutableArray *searchArray;
    IBOutlet UILabel *top_label;
    IBOutlet UITableView *resultTable;
    int deltaRed;
    
}

@property int current_dist;
@property (nonatomic, strong) NSString *subtype_id;
@property (nonatomic, strong) NSString *subtype_name;

-(void)setDistLabels;
-(void)searchRadius;
-(void)searchFromtype;
-(void)clearTable;
- (IBAction)distanceSegmentControll_action:(id)sender;


-(IBAction)distanceBtn:(id)sender;

@end
