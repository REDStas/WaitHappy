//
//  UITextField+Placeholder.m
//  WaitHappy
//
//  Created by gelgard on 27.01.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "UITextField+Placeholder.h"
#import <QuartzCore/QuartzCore.h>


@implementation UITextField_Placeholder

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [[UIColor colorWithRed:189/255.0 green:35/255.0 blue:61/255.0 alpha:1] CGColor];
    self.layer.cornerRadius = 2.0;
    self.layer.masksToBounds = YES;
    //self.backgroundColor = [UIColor colorWithRed:189/255.0 green:35/255.0 blue:61/255.0 alpha:0.1];
}


- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 5, bounds.origin.y, bounds.size.width , bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}
/*
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGSize textSize = [@"Tp" sizeWithFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:22.0f] constrainedToSize:CGSizeMake(320, 30) lineBreakMode:UILineBreakModeWordWrap];
    NSLog(@"%f %f",textSize.height,textSize.width);
    NSLog(@"%f %f",bounds.size.height,bounds.size.width);
    return CGRectMake(bounds.origin.x + 10, (bounds.size.height - textSize.height)/2,
                      bounds.size.width - 20, bounds.size.height - (bounds.size.height - textSize.height)/2);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}*/


/*
- (void) drawTextInRect:(CGRect)rect
{
    [[self text] drawInRect:rect withFont:self.font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
}
*/
- (void) drawPlaceholderInRect:(CGRect)rect {
    
    if([[[UIDevice currentDevice] systemVersion] integerValue] >= 7) {
        rect = CGRectMake(rect.origin.x, rect.origin.y + 4, rect.size.width, rect.size.height);
    }
    else
    {
        rect = CGRectMake(rect.origin.x, rect.origin.y-2, rect.size.width, rect.size.height);
    }
    [[UIColor blackColor] setFill];
        
   // [[self placeholder] drawInRect:rect withFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:22.0f] lineBreakMode:NSLineBreakByWordWrapping alignment:self.textAlignment];
   
    [[self placeholder] drawInRect:rect withFont:[UIFont fontWithName:@"LeagueGothic-CondensedRegular" size:21.0f] lineBreakMode:NSLineBreakByWordWrapping alignment:self.textAlignment];
    
    
   

    //self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //[[self placeholder] drawInRect:rect withFont:[UIFont fontWithName:@"LockClock" size:17.0f]];
}

@end
