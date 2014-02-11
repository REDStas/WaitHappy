//
//  SearchCell.m
//  WaitHappy
//
//  Created by gelgard on 17.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

@synthesize nameLbl = _nameLbl;
@synthesize labelLbl = _labelLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRoundedIm
{
    //
    [bgIm setImage:[UIImage imageNamed:@"search_cell_rounded.png"]];

    [bgIm setHighlightedImage:[UIImage imageNamed:@"search_cell_rounded_select.png"]];
    
    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_cell_rounded.png"]];
    [iv setHighlightedImage:[UIImage imageNamed:@"search_cell_rounded_select.png"]];
    self.selectedBackgroundView = iv;
    
}

-(void)setRectangleIm
{
    [bgIm setImage:[UIImage imageNamed:@"search_cell.png"]];
    [bgIm setHighlightedImage:[UIImage imageNamed:@"search_cell_selected.png"]];

    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_cell.png"]];
    [iv setHighlightedImage:[UIImage imageNamed:@"search_cell_selected.png"]];
    self.selectedBackgroundView = iv;
}

-(void)setRectangleSelectedIm
{
    [bgIm setImage:[UIImage imageNamed:@"search_cell_selected.png"]];
}

-(void)setRoundedSelectedIm
{
    [bgIm setImage:[UIImage imageNamed:@"search_cell_rounded_select.png"]];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}

@end
