//
//  SearchByType.h
//  WaitHappy
//
//  Created by gelgard on 16.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchByType : UIViewController
{
    NSMutableArray *searchArray;
    IBOutlet UITableView *resultTable;
    IBOutlet UILabel *section_lbl;
    
    IBOutlet UIView *centerView;
    
    IBOutlet UIView *noResultView;
    
    IBOutlet UILabel *sorryLabel;
    
    IBOutlet UILabel *sorryBottomLabel;
    
}

-(void)getList;



@end
