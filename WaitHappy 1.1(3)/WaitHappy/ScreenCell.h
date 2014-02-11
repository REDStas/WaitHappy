//
//  ScreenCell.h
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenCell : UITableViewCell
{
    
}

-(void)setDescriptionLabelText:(NSString*)text;

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic,strong) IBOutlet UILabel *nameLbl;
@property (nonatomic,strong) IBOutlet UILabel *labelLbl;
@property (nonatomic,strong) IBOutlet UILabel *descLbl;
@property (strong, nonatomic) IBOutlet UILabel *priceLbl;

@end
