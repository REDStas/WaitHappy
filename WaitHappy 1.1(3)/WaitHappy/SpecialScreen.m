//
//  SpecialScreen.m
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "SpecialScreen.h"
#import "MySingleton.h"
#import "ScreenCell.h"

@interface SpecialScreen ()
{
    UIImageView *im;
    ScreenCell *tempCell;
}

@end

@implementation SpecialScreen

@synthesize restaurantId, restaurantName, restaurantLabel;

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
   
    tempCell = [[ScreenCell alloc] init];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScreenCell" owner:self options:nil];
    tempCell = [nib objectAtIndex:0];
    searchArray = [[NSMutableArray alloc] init];
    //[restaurantName setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:28.0f]];
    [restaurantName setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:28.0f]];
    
    
    
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];    
    [searchArray removeAllObjects];
    [resultTable reloadData];
  
    [self loadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backBtn:(id)sender
{
    [[MySingleton sharedMySingleton] backController];
}

-(void)loadData
{
   
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"id", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:self.restaurantId, nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kSpecialScreen];
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
    NSLog(@"-- %@",[params description]);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kMainUrl]];
   // NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kSearchByName parameters:params];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kSpecialScreen parameters:params];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"%@", JSON);
        [searchArray removeAllObjects];

        for (NSDictionary * dict in JSON) {
            [searchArray addObject:dict];
        }
        NSLog(@"search count %i",[searchArray count]);
        
        if ([searchArray count]==0)
        {
            [resultTable setAlpha:0];
            // если запрос ничео не возвращает
            im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_result_bg.png"]];
            [im setFrame:CGRectMake(8, 55, im.frame.size.width,124)];
            UILabel *label1 = [[UILabel alloc] init];
            UILabel *label2 = [[UILabel alloc] init];
            label1.text = @"Sorry!";
            [label1 setFrame:CGRectMake(35, 22, 180, 24)];
            [label1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22.0]];
            [label1 setTextAlignment:NSTextAlignmentLeft];
            [label1 setBackgroundColor:[UIColor clearColor]];
            //[label1 setTextColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:1]];
            [label1 setTextColor:[UIColor colorWithRed:69/255.0 green:68/255.0 blue:68/255.0 alpha:1]];
            
            label2.text = @"There are currently no specials posted for this business. Please check back soon.";
            [label2 setFrame:CGRectMake(35, 24, 232, 100)];
            label2.numberOfLines = 3;
            [label2 setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
            [label2 setTextAlignment:NSTextAlignmentLeft];
            [label2 setBackgroundColor:[UIColor clearColor]];
            [label2 setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
          
            [im addSubview:label1];            
            [im addSubview:label2];
            [self.view addSubview:im];
        } else
        {
            [resultTable setAlpha:1];
            [resultTable reloadData];
        }
        
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
      //  NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
      //  [resultTable setAlpha:0];
        
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        //NSArray *initArr = [[NSArray alloc] initWithObjects:[request URL],[error localizedDescription],JSON, nil];
        //[[MySingleton sharedMySingleton] showFailureMessage:self parametrsMsg:initArr];
    }];
    
    [operation start];
}


#pragma mark Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ScreenCell";
    
    ScreenCell *cell = (ScreenCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScreenCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.nameLbl.text = [[searchArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    [cell setDescriptionLabelText:[[searchArray objectAtIndex:indexPath.row] objectForKey:@"description"]];
    cell.priceLbl.text = [[searchArray objectAtIndex:indexPath.row] objectForKey:@"offer"];

    if (indexPath.row == [searchArray count]-1) {
        [cell.image setImage:[[UIImage imageNamed:@"special_cell_round_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(100.0, 0.0, 35.0, 0.0)]];
    }
    else
    {
        [cell.image setImage:[UIImage imageNamed:@"special_cell_bg.png"]];
    }

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float cellHeight;
    NSString *description = [[searchArray objectAtIndex:indexPath.row] objectForKey:@"description"];
    CGSize newSize = [description sizeWithFont:tempCell.labelLbl.font constrainedToSize:CGSizeMake(tempCell.labelLbl.frame.size.width, 500) lineBreakMode:UILineBreakModeWordWrap];
    NSLog(@"labelSize %f",newSize.height);
    
    CGSize nameLblSize =[[[searchArray objectAtIndex:indexPath.row] objectForKey:@"name"] sizeWithFont:tempCell.nameLbl.font constrainedToSize:CGSizeMake(tempCell.nameLbl.frame.size.width, 300) lineBreakMode:UILineBreakModeWordWrap];
    cellHeight = tempCell.labelLbl.frame.origin.y + newSize.height  + 10;
    if(nameLblSize.height <30) {
        cellHeight -= 10;
    }
    NSLog(@"cellHeight %f",cellHeight);
    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchArray count];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [im removeFromSuperview];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
