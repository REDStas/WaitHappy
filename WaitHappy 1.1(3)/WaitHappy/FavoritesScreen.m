//
//  SpecialScreen.m
//  WaitHappy
//
//  Created by gelgard on 02.04.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "FavoritesScreen.h"
#import "MySingleton.h"
//#import "ScreenCell.h"
#import "SearchCell.h"
#import "DatabaseSingleton.h"
#import "WaitList.h"
#import "Buisness.h"
#import "SearchByName.h"


@interface FavoritesScreen ()
{
    UIImageView *im;
    UIImageView *favoriteButtonImage;
    UIButton *startSearchingButton;
 //   WaitList *element;
}

@end

@implementation FavoritesScreen

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
//    element = [[WaitList alloc] init];
     searchArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    
    [myFavoritesLbl setFont:[UIFont fontWithName:@"LeagueGothic-Regular" size:27.0f]];
    im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_result_bg.png"]];
    favoriteButtonImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rest_btn_fav.png"]];
    startSearchingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startSearchingButton setImage:[UIImage imageNamed:@"start_searching_btn.png"] forState:UIControlStateNormal];
    [startSearchingButton setFrame:CGRectMake(64, 195, 193, 38)];
    [startSearchingButton addTarget:self action:@selector(startSearchTap) forControlEvents:UIControlEventTouchUpInside];
    
    //  [im setFrame:CGRectMake(8, 55, im.frame.size.width,im.frame.size.height)];
    [im setFrame:CGRectMake(8, 55, im.frame.size.width,124)];    
    
    
    [favoriteButtonImage setFrame:CGRectMake(135, 65, favoriteButtonImage.frame.size.width,favoriteButtonImage.frame.size.height)];
    
    
    UILabel *label1 = [[UILabel alloc] init];
    UILabel *label2 = [[UILabel alloc] init];
    
    label1.text = @"No favorites yet.";
    [label1 setFrame:CGRectMake(35, 22, 180, 24)];
    [label1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22.0]];
    [label1 setTextAlignment:NSTextAlignmentLeft];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setTextColor:[UIColor colorWithRed:69/255.0 green:68/255.0 blue:68/255.0 alpha:1]];
    
    label2.text = @"It's easy. Visit your favorite places and click on the                 button.";
    [label2 setFrame:CGRectMake(35, 15, 232, 100)];
    label2.numberOfLines = 3;
    [label2 setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    [label2 setTextAlignment:NSTextAlignmentLeft];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
    
    
    
    [im addSubview:label1];
    [im addSubview:label2];
    [im addSubview:favoriteButtonImage];
    [self.view addSubview:im];
    [self.view addSubview:startSearchingButton];
    im.hidden = YES;
    startSearchingButton.hidden = YES;
}






-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [searchArray removeAllObjects];
    
//    [self loadData];
    [self loadDataFromDB];
    [resultTable reloadData];
}
 


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)startSearchTap
{
    SearchByName *sbn = [[SearchByName alloc] init];
    [[MySingleton sharedMySingleton] popNewView:sbn];
}


-(IBAction)backBtn:(id)sender
{
    [[MySingleton sharedMySingleton] backController];
}


-(void)loadDataFromDB
{
   // searchArray = [[DatabaseSingleton sharedDBSingleton] getDataFromWaitList];
    
    
    searchArray = [[DatabaseSingleton sharedDBSingleton] getDataFromBusinessDB];
    
    NSLog(@"search count %d",[searchArray count]);
 
    NSLog(@"search description %@",[searchArray description]);
    
    if ([searchArray count])
    {
        [resultTable setHidden:NO];
        [im setHidden:YES];
        startSearchingButton.hidden = YES;
        [resultTable reloadData];
    }
    else
    {  // выводим вьюху что список пуст 
        [resultTable setHidden:YES];
        [im setHidden:NO];
        startSearchingButton.hidden = NO;
    }
}


#pragma mark Table View
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SearchCell";
    
    SearchCell *cell = (SearchCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Buisness *bus = [searchArray objectAtIndex:indexPath.row];
    
    NSLog(@"name %@",bus.name);
    NSLog(@"name %@",bus.label);
    
    
    cell.nameLbl.text = bus.name;
    
    cell.labelLbl.text = bus.label;
   
    if (indexPath.row == [searchArray count]-1) {
        [cell setRoundedIm];
        //[cell sethi]
    }
    else
    {
        [cell setRectangleIm];
    }
    return cell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"searchArray count %i", [searchArray count]);
    return [searchArray count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     // преход на DetailleScreen
 
    Buisness *bus = [searchArray objectAtIndex:indexPath.row];
    
  //  NSString *str = bus.buisID;
    
    NSLog(@"ID %@",bus.buisID);
    
   // NSLog(@"strID %@",str);
    
    
     [[MySingleton sharedMySingleton] showRestaurantDetaile:bus.buisID];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}



-(void)viewDidDisappear:(BOOL)animated
{
    //[im removeFromSuperview];
}


- (void)viewDidUnload
{
    myFavoritesLbl = nil;
    [super viewDidUnload];
}
@end
