//
//  SliderViewController.m
//  WaitHappy
//
//  Created by user on 13.05.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "SliderViewController.h"

@interface SliderViewController ()
{
    UIImage *thumbImage1;
    UIImage *thumbImage2;
    UIImage *thumbImage3;
    UIImage *thumbImage4;
    UIImage *thumbImage5;
}

@end

@implementation SliderViewController

@synthesize questionID,rating;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //  ---- slider ---
    UIImage *minImage = [[UIImage imageNamed:@"slider_min.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    UIImage *maxImage = [[UIImage imageNamed:@"slider_max.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    
    [[UISlider appearance] setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [[UISlider appearance] setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    
    thumbImage1 = [UIImage imageNamed:@"slider_1"];
    thumbImage2 = [UIImage imageNamed:@"slider_2"];
    thumbImage3 = [UIImage imageNamed:@"slider_3"];
    thumbImage4 = [UIImage imageNamed:@"slider_4"];
    thumbImage5 = [UIImage imageNamed:@"slider_5"];
    
    //[[UISlider appearance] setThumbImage:thumbImage1 forState:UIControlStateNormal];
    //[[UISlider appearance] setThumbImage:thumbImage1 forState:UIControlStateHighlighted];
    
    
    
    
    
    NSLog(@"width of scroll %f", mySlider.frame.size.width);
    NSLog(@"x of frame slider %f",mySlider.frame.origin.x);

    [mySlider setMinimumValue:0.5];
    [mySlider setMaximumValue:5.5];
    
    
    //  --- выставляем посередине ---
    [mySlider setValue:3];
    [label3 setText:@"AVERAGE"];
    [label3 setTextAlignment:NSTextAlignmentCenter];
    [label3 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [[UISlider appearance] setThumbImage:thumbImage3 forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage3 forState:UIControlStateHighlighted];
 
    rating = @"3";
    
    //[mySlider setValue:1];
    //  ---- slider ---
    
    [label1 setFrame:CGRectMake(26 - 16, label1.frame.origin.y, 80, 15)];
    [label2 setFrame:CGRectMake(26*3 - 17, label1.frame.origin.y, 80, 15)];
    [label3 setFrame:CGRectMake(26*5 - 18, label1.frame.origin.y, 80, 15)];
    [label4 setFrame:CGRectMake(26*7 - 19, label1.frame.origin.y, 80, 15)];
    [label5 setFrame:CGRectMake(26*9 - 20, label1.frame.origin.y, 80, 15)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)setLabel:(NSString*)text
{
    //[mainLabel setText:@"hello world"];
    
  
  //  NSLog(@"label x %f label y %f",textSize.width,textSize.height);
    
    
    CGRect temp;
    temp = CGRectMake(mainLabel.frame.origin.x, mainLabel.frame.origin.y, mainLabel.frame.size.width, mainLabel.frame.size.height);
    
    /*
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height + mainLabel.frame.size.height + temp.size.height)];
    
     */
     
    [mainLabel setText:text];
    
    CGSize textSize = [text sizeWithFont:mainLabel.font constrainedToSize:CGSizeMake(mainLabel.frame.size.width, 300) lineBreakMode:UILineBreakModeWordWrap];
   
    [mainLabel setFrame:CGRectMake(mainLabel.frame.origin.x, mainLabel.frame.origin.y, mainLabel.frame.size.width, textSize.height)];
    
    NSLog(@"label x %f label y %f",textSize.width,textSize.height);
    
    //NSLog(@"label x %f label y %f",textSize.width,textSize.height);
    
    NSLog(@" шрифт %@",  mainLabel.font);
    
    
    [mySlider setFrame:CGRectMake(mySlider.frame.origin.x, mainLabel.frame.size.height + 22, mySlider.frame.size.width, mySlider.frame.size.height)];
    
    [label1 setFrame:CGRectMake(label1.frame.origin.x, mySlider.frame.origin.y + mySlider.frame.size.height+ 9, label1.frame.size.width, label1.frame.size.height)];
    [label2 setFrame:CGRectMake(label2.frame.origin.x, mySlider.frame.origin.y + mySlider.frame.size.height+ 9, label2.frame.size.width, label2.frame.size.height)];
    [label3 setFrame:CGRectMake(label3.frame.origin.x, mySlider.frame.origin.y + mySlider.frame.size.height+ 9, label3.frame.size.width, label3.frame.size.height)];
    [label4 setFrame:CGRectMake(label4.frame.origin.x, mySlider.frame.origin.y + mySlider.frame.size.height+ 9, label4.frame.size.width, label4.frame.size.height)];
    [label5 setFrame:CGRectMake(label5.frame.origin.x, mySlider.frame.origin.y + mySlider.frame.size.height+ 9, label5.frame.size.width, label5.frame.size.height)];
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, label5.frame.origin.y + label5.frame.size.height)];
    
}


- (IBAction)sliderValueChanged:(id)sender
{
    int roundValue = lroundf(((UISlider*)sender).value);
    
    switch (roundValue) {
        case 1:
            [sender setThumbImage:thumbImage1 forState:UIControlStateHighlighted];
            [((UISlider*)sender) setValue:1];
            
            [label1 setText:@"VERY POOR"];
            [label1 setTextAlignment:NSTextAlignmentCenter];
            [label1 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            [label2 setText:@""];
            [label3 setText:@""];
            [label4 setText:@""];
            [label5 setText:@""];
            

            
            break;
        case 2:
            [sender setThumbImage:thumbImage2 forState:UIControlStateHighlighted];
            [((UISlider*)sender) setValue:2];
            
            [label2 setText:@"POOR"];
            [label2 setTextAlignment:NSTextAlignmentCenter];
            [label2 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            [label1 setText:@""];
            [label3 setText:@""];
            [label4 setText:@""];
            [label5 setText:@""];
            
            break;
        case 3:
            [sender setThumbImage:thumbImage3 forState:UIControlStateHighlighted];
            [((UISlider*)sender) setValue:3];
            
            [label3 setText:@"AVERAGE"];
            [label3 setTextAlignment:NSTextAlignmentCenter];
            [label3 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            [label1 setText:@""];
            [label2 setText:@""];
            [label4 setText:@""];
            [label5 setText:@""];
            
            break;
        case 4:
            [sender setThumbImage:thumbImage4 forState:UIControlStateHighlighted];
            [((UISlider*)sender) setValue:4];
            
            [label4 setText:@"GOOD"];
            [label4 setTextAlignment:NSTextAlignmentCenter];
            [label4 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            [label1 setText:@""];
            [label2 setText:@""];
            [label3 setText:@""];
            [label5 setText:@""];
            
            break;
        case 5:
            [sender setThumbImage:thumbImage5 forState:UIControlStateHighlighted];
            [((UISlider*)sender) setValue:5];
            
            
            [label5 setText:@"GREAT"];
            [label5 setTextAlignment:NSTextAlignmentCenter];
            [label5 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            
            [label1 setText:@""];
            [label2 setText:@""];
            [label3 setText:@""];
            [label4 setText:@""];
            
            
            
            break;
        case 6:
            [sender setThumbImage:thumbImage5 forState:UIControlStateHighlighted];
            [((UISlider*)sender) setValue:5];
            
            
            
            [label5 setText:@"GREAT"];
            [label5 setTextAlignment:NSTextAlignmentCenter];
            [label5 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            
            [label1 setText:@""];
            [label2 setText:@""];
            [label3 setText:@""];
            [label4 setText:@""];
            
            
            break;
            
        default:
            break;
    }
}



- (IBAction)sliderTouchInside:(id)sender
{
    
    NSLog(@"width of scroll %f",((UISlider*)sender).frame.size.width);
    NSLog(@"x of frame slider %f",((UISlider*)sender).frame.origin.x);    
    
    
    int roundValue = lroundf(((UISlider*)sender).value);
    NSLog(@"round value %d",roundValue);
    
    switch (roundValue) {
        case 1:
            [sender setThumbImage:thumbImage1 forState:UIControlStateNormal];
            [((UISlider*)sender) setValue:1];
            //============
            
            [label1 setText:@"VERY POOR"];
            [label1 setTextAlignment:NSTextAlignmentCenter];
            [label1 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            [label2 setText:@""];
            [label3 setText:@""];
            [label4 setText:@""];
            [label5 setText:@""];
            
            
            
            //[sliderLabel setFrame:CGRectMake(((UISlider*)sender).frame.origin.x + ((UISlider*)sender).frame.size.width/10, ((UISlider*)sender).frame.origin.y + 25, 100, 12)];
            
            /*
            [sliderLabel setFrame:CGRectMake(((UISlider*)sender).frame.origin.x + ((UISlider*)sender).frame.size.width/10.0 - 40.0, ((UISlider*)sender).frame.origin.y + 25, 80, 12)];
            
            NSLog(@"width of scroll %f",((UISlider*)sender).frame.size.width);
            NSLog(@"x of frame slider %f",((UISlider*)sender).frame.origin.x);
            
            
            NSLog(@"x of scroll %f",((UISlider*)sender).frame.origin.x + ((UISlider*)sender).frame.size.width/10.0 - 40.0);
            NSLog(@"label width %f",sliderLabel.frame.size.width);
            
            //[sliderLabel.layer setBorderColor:(__bridge CGColorRef)([UIColor redColor])];
            */
            
            rating = @"1";
            
            break;
        case 2:
          
            [sender setThumbImage:thumbImage2 forState:UIControlStateNormal];
            [((UISlider*)sender) setValue:2];
            //============
           
            [label2 setText:@"POOR"];
            [label2 setTextAlignment:NSTextAlignmentCenter];
            [label2 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            [label1 setText:@""];
            [label3 setText:@""];
            [label4 setText:@""];
            [label5 setText:@""];
            
            
            /*
            [sliderLabel setFrame:CGRectMake(((UISlider*)sender).frame.origin.x + (((UISlider*)sender).frame.size.width/10.0)*3 - 40.0, ((UISlider*)sender).frame.origin.y + 25, 80, 12)];
            
            [sliderLabel setTextAlignment:NSTextAlignmentCenter];
            
            
            NSLog(@"width of scroll %f",((UISlider*)sender).frame.size.width);
            
            NSLog(@"x of frame slider %f",((UISlider*)sender).frame.origin.x);
            
            
            NSLog(@"x of scroll %f",((UISlider*)sender).frame.origin.x + (((UISlider*)sender).frame.size.width/10.0)*3 - 40.0);
            NSLog(@"label width %f",sliderLabel.frame.size.width);
            
            */
            
            
            rating = @"2";
            
            
             break;
      
        case 3:
            [sender setThumbImage:thumbImage3 forState:UIControlStateNormal];
            [((UISlider*)sender) setValue:3];
            //============
            [label3 setText:@"AVERAGE"];
            [label3 setTextAlignment:NSTextAlignmentCenter];
            [label3 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            [label1 setText:@""];
            [label2 setText:@""];
            [label4 setText:@""];
            [label5 setText:@""];
            
            
            /*
            [sliderLabel setFrame:CGRectMake(((UISlider*)sender).frame.origin.x + (((UISlider*)sender).frame.size.width/10.0)*5 - 40, ((UISlider*)sender).frame.origin.y + 25, 80, 12)];
            
            
            NSLog(@"width of scroll %f",((UISlider*)sender).frame.size.width);
            NSLog(@"x of frame slider %f",((UISlider*)sender).frame.origin.x);
            
            
            NSLog(@"x of scroll %f",((UISlider*)sender).frame.origin.x + (((UISlider*)sender).frame.size.width/10.0)*5 - 40);
            NSLog(@"label width %f",sliderLabel.frame.size.width);
            */
            
            
            rating = @"3";
            
            break;
        case 4:
            //  [sliderLabel removeFromSuperview];
            [sender setThumbImage:thumbImage4 forState:UIControlStateNormal];
            [((UISlider*)sender) setValue:4];
            // ===========
            [label4 setText:@"GOOD"];
            [label4 setTextAlignment:NSTextAlignmentCenter];
            [label4 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
           
            [label1 setText:@""];
            [label2 setText:@""];
            [label3 setText:@""];
            [label5 setText:@""];
            
            
            /*
            [sliderLabel setFrame:CGRectMake(((UISlider*)sender).frame.origin.x + (((UISlider*)sender).frame.size.width/10.0)*7 - 40, ((UISlider*)sender).frame.origin.y + 25, 80, 12)];
            
            
            NSLog(@"width of scroll %f",((UISlider*)sender).frame.size.width);
            NSLog(@"x of frame slider %f",((UISlider*)sender).frame.origin.x);
            
            
            NSLog(@"x of scroll %f",((UISlider*)sender).frame.origin.x + (((UISlider*)sender).frame.size.width/10.0)*7 - 40);
            NSLog(@"label width %f",sliderLabel.frame.size.width);
         
             */
            
            
            rating = @"4";
            
            break;
        case 5:
            //   [sliderLabel removeFromSuperview];
            [sender setThumbImage:thumbImage5 forState:UIControlStateNormal];
            [((UISlider*)sender) setValue:5];
            // ============
            
            [label5 setText:@"GREAT"];
            [label5 setTextAlignment:NSTextAlignmentCenter];
            [label5 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            
            [label1 setText:@""];
            [label2 setText:@""];
            [label3 setText:@""];
            [label4 setText:@""];
            
            
            /*
            [sliderLabel setFrame:CGRectMake(((UISlider*)sender).frame.origin.x + (((UISlider*)sender).frame.size.width/10.0)*9 - 40, ((UISlider*)sender).frame.origin.y + 25, 60, 12)];
            
            
            NSLog(@"x of scroll %f",((UISlider*)sender).frame.origin.x + (((UISlider*)sender).frame.size.width/10.0)*9 - 40);
            
            
            NSLog(@"label width %f",sliderLabel.frame.size.width);
            */
            
            
            rating = @"5";
            
            break;
        default:
            break;
    }
}


- (void)viewDidUnload {
    label1 = nil;
    label2 = nil;
    label3 = nil;
    label4 = nil;
    label5 = nil;
    label5 = nil;
    mainLabel = nil;
    [super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}

@end
