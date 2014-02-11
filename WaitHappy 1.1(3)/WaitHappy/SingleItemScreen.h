//
//  SpecialScreen.h
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleItemScreen : UIViewController<UIAlertViewDelegate>
{
    NSMutableArray *searchArray;
    IBOutlet UIButton *refreshButton;
    IBOutlet UITableView *resultTable;
    IBOutlet UIImageView *red_green_line;
    IBOutlet UILabel *quotedLabel;
    IBOutlet UILabel *waitedLabel;
    IBOutlet UIButton *removeBtn;
    IBOutlet UIScrollView *myScrollView;    
}
@property (strong, nonatomic) IBOutlet UILabel *waitListLabel;

@property (strong, nonatomic) IBOutlet UILabel *businessNameLbl;
@property (nonatomic,strong) NSString *restaurantId;
@property (nonatomic,strong) IBOutlet UILabel *topLabel;



//@property (nonatomic,strong) IBOutlet UILabel *restaurantLabel;
- (IBAction)startSearchTap:(id)sender;
- (IBAction)refreshBtnTap:(id)sender;
//-(void)loadDataFromDB;
-(void)loadData;
- (IBAction)removeBtnPress:(id)sender;
-(IBAction)backBtn:(id)sender;
- (void)doSomething;
@end
