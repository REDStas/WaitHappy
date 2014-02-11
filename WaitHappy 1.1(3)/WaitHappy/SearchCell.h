//
//  SearchCell.h
//  WaitHappy
//
//  Created by gelgard on 17.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell : UITableViewCell
{
    IBOutlet UIImageView *bgIm;
}

@property (nonatomic,strong) IBOutlet UILabel *nameLbl;
@property (nonatomic,strong) IBOutlet UILabel *labelLbl;


-(void)setRoundedIm;
-(void)setRectangleIm;
-(void)setRectangleSelectedIm;
-(void)setRoundedSelectedIm;


@end
