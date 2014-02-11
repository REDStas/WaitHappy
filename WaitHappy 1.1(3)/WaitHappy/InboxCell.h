//
//  SearchCell.h
//  WaitHappy
//
//  Created by gelgard on 17.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxCell : UITableViewCell
{
    IBOutlet UIImageView *bgIm;
}

@property (nonatomic,strong) IBOutlet UILabel *nameLbl;
@property (nonatomic,strong) IBOutlet UILabel *labelLbl;


-(void)setRoundedImRed;
-(void)setRectangleImRed;
-(void)setRectangleSelectedImRed;
-(void)setRoundedSelectedImRed;

-(void)setRoundedImGreen;
-(void)setRectangleImGreen;
-(void)setRectangleSelectedImGreen;
-(void)setRoundedSelectedImGreen;

@end
