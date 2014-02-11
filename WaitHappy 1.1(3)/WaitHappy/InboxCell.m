//
//  SearchCell.m
//  WaitHappy
//
//  Created by gelgard on 17.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "InboxCell.h"

@implementation InboxCell

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


// =================== red ========================

-(void)setRoundedImRed
{
    //
    [bgIm setImage:[UIImage imageNamed:@"inbox_cell_rounded_red.png"]];
    [bgIm setHighlightedImage:[UIImage imageNamed:@"inbox_cell_rounded_select_red.png"]];
 
    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inbox_cell_rounded_red.png"]];
    [iv setHighlightedImage:[UIImage imageNamed:@"inbox_cell_rounded_select_red.png"]];
    self.selectedBackgroundView = iv;
}


-(void)setRectangleImRed
{
    [bgIm setImage:[UIImage imageNamed:@"inbox_cell_red.png"]];
    [bgIm setHighlightedImage:[UIImage imageNamed:@"inbox_cell_selected_red.png"]];
    
    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inbox_cell_red.png"]];
    [iv setHighlightedImage:[UIImage imageNamed:@"inbox_cell_selected_red.png"]];
    self.selectedBackgroundView = iv;
}

-(void)setRectangleSelectedImRed
{
    [bgIm setImage:[UIImage imageNamed:@"inbox_cell_selected_red.png"]];
}

-(void)setRoundedSelectedImRed
{
    [bgIm setImage:[UIImage imageNamed:@"inbox_cell_rounded_select_red.png"]];
}

// ===================== green ======================
 
-(void)setRoundedImGreen
{
//    //[bgIm setImage:[UIImage imageNamed:@"inbox_cell_rounded_green.png"]];
//    [bgIm setImage:[UIImage imageNamed:@"single_item_cell_rounded.png"]];
//    
//    //[bgIm setHighlightedImage:[UIImage imageNamed:@"inbox_cell_rounded_select_green.png"]];
//    
////    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inbox_cell_rounded_green.png"]];
////    [iv setHighlightedImage:[UIImage imageNamed:@"inbox_cell_rounded_select_green.png"]];
//    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_item_cell_rounded.png"]];
//    [iv setHighlightedImage:[UIImage imageNamed:@"single_item_cell_rounded.png"]];
//    self.selectedBackgroundView = iv;
    [bgIm setImage:[UIImage imageNamed:@"search_cell_rounded.png"]];
    
    [bgIm setHighlightedImage:[UIImage imageNamed:@"search_cell_rounded_select.png"]];
    
    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_cell_rounded.png"]];
    [iv setHighlightedImage:[UIImage imageNamed:@"search_cell_rounded_select.png"]];
    self.selectedBackgroundView = iv;
}


-(void)setRectangleImGreen
{    
////    [bgIm setImage:[UIImage imageNamed:@"inbox_cell_green.png"]];
//    [bgIm setImage:[UIImage imageNamed:@"single_item_cell.png"]];
//    //[bgIm setHighlightedImage:[UIImage imageNamed:@"inbox_cell_selected_green.png"]];
//    
////    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inbox_cell_green.png"]];
////    [iv setHighlightedImage:[UIImage imageNamed:@"inbox_cell_selected_green.png"]];
//    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_item_cell.png"]];
//    [iv setHighlightedImage:[UIImage imageNamed:@"single_item_cell.png"]];
//    self.selectedBackgroundView = iv;
    [bgIm setImage:[UIImage imageNamed:@"search_cell.png"]];
    [bgIm setHighlightedImage:[UIImage imageNamed:@"search_cell_selected.png"]];
    
    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_cell.png"]];
    [iv setHighlightedImage:[UIImage imageNamed:@"search_cell_selected.png"]];
    self.selectedBackgroundView = iv;
}

-(void)setRectangleSelectedImGreen
{
    //[bgIm setImage:[UIImage imageNamed:@"inbox_cell_selected_green.png"]];
    [bgIm setImage:[UIImage imageNamed:@"search_cell_selected.png"]];
}

-(void)setRoundedSelectedImGreen
{
    //[bgIm setImage:[UIImage imageNamed:@"inbox_cell_rounded_select_green.png"]];
    [bgIm setImage:[UIImage imageNamed:@"search_cell_rounded_select.png"]];
}



- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}


@end
