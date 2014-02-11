//
//  SearchCell.h
//  WaitHappy
//
//  Created by gelgard on 17.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleItemCell : UITableViewCell
{
    IBOutlet UIImageView *bgIm;
}
@property (strong, nonatomic) IBOutlet UIImageView *leftImage;
@property (strong, nonatomic) IBOutlet UILabel *numberLbl;
@property (strong, nonatomic) IBOutlet UILabel *centerLabelnonHere;
@property (strong, nonatomic) IBOutlet UILabel *topLblHere;
@property (strong, nonatomic) IBOutlet UILabel *bottomLblOne;
@property (strong, nonatomic) IBOutlet UILabel *pendingLbl;




-(void)setRoundedIm;
-(void)setRectangleIm;
-(void)setRectangleSelectedIm;
-(void)setRoundedSelectedIm;

-(void)setRoundedImWhite;
-(void)setRectangleImWhite;

@end
