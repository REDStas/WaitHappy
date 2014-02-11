//
//  ScreenCell.m
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "ScreenCell.h"

@implementation ScreenCell

@synthesize nameLbl, labelLbl, descLbl, image, priceLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    [labelLbl sizeToFit];
    return self;
}



-(void)setDescriptionLabelText:(NSString*)text
{
    CGSize textLablSize =[nameLbl.text sizeWithFont:nameLbl.font constrainedToSize:CGSizeMake(nameLbl.frame.size.width, 300) lineBreakMode:UILineBreakModeWordWrap];
    
    CGSize priceLablSize = [priceLbl.text sizeWithFont:priceLbl.font constrainedToSize:CGSizeMake(priceLbl.frame.size.width, 300) lineBreakMode:UILineBreakModeWordWrap];
    
    if ((textLablSize.height < 30) && (priceLablSize.height < 30))
    {
        [labelLbl setFrame:CGRectMake(labelLbl.frame.origin.x, labelLbl.frame.origin.y - 10, labelLbl.frame.size.width, labelLbl.frame.size.height)];
    }
    [labelLbl setText:text];
   // [labelLbl sizeToFit];
    CGSize newSize = [labelLbl.text sizeWithFont:labelLbl.font constrainedToSize:CGSizeMake(labelLbl.frame.size.width, 500) lineBreakMode:labelLbl.lineBreakMode];
    [labelLbl setFrame:CGRectMake(labelLbl.frame.origin.x, labelLbl.frame.origin.y, newSize.width, newSize.height)];
    [self.contentView setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, labelLbl.frame.origin.y + labelLbl.frame.size.height + 10)];
    [image setFrame:self.contentView.frame];
    NSLog(@"cell height %f",self.contentView.frame.size.height);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

        // Configure the view for the selected state
}
- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
