//
//  SearchCell.m
//  WaitHappy
//
//  Created by gelgard on 17.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "SingleItemCell.h"

@implementation SingleItemCell

@synthesize leftImage,numberLbl,centerLabelnonHere,topLblHere,bottomLblOne,pendingLbl;

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
    [bgIm setImage:[UIImage imageNamed:@"single_item_cell_rounded.png"]];
    [bgIm setHighlightedImage:[UIImage imageNamed:@"single_item_cell_rounded_select.png"]];    
    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_item_cell_rounded.png"]];
    [iv setHighlightedImage:[UIImage imageNamed:@"single_item_cell_rounded_select.png"]];
    self.selectedBackgroundView = iv;
    
}

-(void)setRectangleIm
{
    [bgIm setImage:[UIImage imageNamed:@"single_item_cell.png"]];
    [bgIm setHighlightedImage:[UIImage imageNamed:@"single_item_cell_selected.png"]];
    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_item_cell.png"]];
    [iv setHighlightedImage:[UIImage imageNamed:@"single_item_cell_selected.png"]];
    self.selectedBackgroundView = iv;
}

// ==============
-(void)setRoundedImWhite
{
    //
    [bgIm setImage:[UIImage imageNamed:@"single_item_cell_round_white.png"]];
   // [bgIm setHighlightedImage:[UIImage imageNamed:@"single_item_cell_rounded_select.png"]];
   // UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_item_cell_rounded.png"]];
   // [iv setHighlightedImage:[UIImage imageNamed:@"single_item_cell_rounded_select.png"]];
   // self.selectedBackgroundView = iv;
    
}

-(void)setRectangleImWhite
{
    [bgIm setImage:[UIImage imageNamed:@"single_item_cell_white.png"]];
//    [bgIm setHighlightedImage:[UIImage imageNamed:@"single_item_cell_selected.png"]];
//    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_item_cell.png"]];
//    [iv setHighlightedImage:[UIImage imageNamed:@"single_item_cell_selected.png"]];
//    self.selectedBackgroundView = iv;
}


-(void)setRectangleSelectedIm
{
    [bgIm setImage:[UIImage imageNamed:@"single_item_cell_selected.png"]];
}

-(void)setRoundedSelectedIm
{
    [bgIm setImage:[UIImage imageNamed:@"single_item_cell_rounded_select.png"]];
}


@end
