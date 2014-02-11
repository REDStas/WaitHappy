//
//  SearchByDistance.m
//  WaitHappy
//
//  Created by gelgard on 16.02.13.
//  Copyright (c) 2013 dogitalkozak. All rights reserved.
//

#import "SearchByDistance.h"
#import "MySingleton.h"
#import "SearchCell.h"

@interface SearchByDistance ()
{
    NSMutableArray *distanceArr;
}

@end

@implementation SearchByDistance
@synthesize current_dist;
@synthesize subtype_id;
@synthesize subtype_name;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.current_dist = 2;
        self.subtype_id = [NSString stringWithFormat:@"%@",@""];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    distance_lbls = [[NSArray alloc] initWithObjects:@"1",@"3",@"5",@"10",@"20", nil];
    searchArray = [[NSMutableArray alloc] init];
    distanceArr = [[NSMutableArray alloc] init];
    
    [distanceSegmentControll setFrame:CGRectMake(distanceSegmentControll.frame.origin.x, distanceSegmentControll.frame.origin.y, distanceSegmentControll.frame.size.width, 38)];
    [distanceSegmentControll setBackgroundImage:[UIImage imageNamed:@"distanceSegmentControll_bg.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [distanceSegmentControll setBackgroundImage:[UIImage imageNamed:@"distanceSegmentControll_bg_selected.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [distanceSegmentControll setDividerImage:[UIImage imageNamed:@"distanceSegmentControll_divider.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [distanceSegmentControll setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
    [distanceSegmentControll setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0], UITextAttributeFont,nil] forState:UIControlStateSelected];
    [distanceSegmentControll setSelectedSegmentIndex:4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.current_dist = distanceSegmentControll.selectedSegmentIndex;
    //
    
    [super viewWillAppear:YES];
    [noResultView setAlpha:0];
    [sorryLabel setText:NSLocalizedString(@"no_result_top", nil)];
    [[[MySingleton sharedMySingleton] getSearchPanel].view setFrame:CGRectMake(0, 8, [[MySingleton sharedMySingleton] getSearchPanel].view.bounds.size.width, [[MySingleton sharedMySingleton] getSearchPanel].view.bounds.size.height)];
    [self.view addSubview:[[MySingleton sharedMySingleton] getSearchPanel].view];
    [((SearchPanel *)[[MySingleton sharedMySingleton] getSearchPanel]) setTextsOnLabels];
    NSLog(@"SUBTYPE %@",self.subtype_id);
    [distanceArr removeAllObjects];
    [searchArray removeAllObjects];
    [resultTable reloadData];
    if ([self.subtype_id length]>0) {
        [top_label setText:[NSString stringWithFormat:@"Restaurants: %@",self.subtype_name]];
        [top_label setAlpha:1];
        [topPic setImage:[UIImage imageNamed:@"top_search_by_dist.png"]];
        [centerView setFrame:CGRectMake(0, 96, 320, self.view.frame.size.height - 96)];
        [noResultView setFrame:CGRectMake(0, 32, 320, 155)];
        [self searchFromtype];
    } else
    {
        [top_label setAlpha:0];
        [topPic setImage:[UIImage imageNamed:@"top_search_by_dist_nored.png"]];
        [centerView setFrame:CGRectMake(0, 60, 320, self.view.frame.size.height - 60)];
        NSLog(@"view height %f",self.view.frame.size.height);
        [noResultView setFrame:CGRectMake(0, 32, 320, 155)];
        [self searchRadius];
        // здесь view
        NSLog(@"view height %f",self.view.frame.size.height);
    }
    [resultTable reloadData];
}


-(void)setDistLabels
{
    
    for (int i=0; i<5; i++) {
        UILabel *temp = (UILabel *)[self.view viewWithTag:(i+100)];
        [temp setText:[NSString stringWithFormat:@"%i mi",[[distance_lbls objectAtIndex:i] intValue]]];
        
        if (self.current_dist == i) {
            [temp setTextColor:[UIColor  colorWithRed:0.8f green:0.2f blue:0.2f alpha:1]];
            [temp setBackgroundColor:[UIColor  colorWithRed:0.8f green:0.2f blue:0.2f alpha:1]];
        }else
          [temp setTextColor:[UIColor  whiteColor]];
    }
}

-(IBAction)distanceBtn:(id)sender
{
    self.current_dist = ((UIButton *)sender).tag-200;
    [searchArray removeAllObjects];
    [resultTable reloadData];
    //[self setDistLabels];
    if ([self.subtype_id length]>0) {
        [self searchFromtype];
    } else
        [self searchRadius];
}


-(void)clearTable
{
    [searchArray removeAllObjects];
    [resultTable reloadData];
}

- (IBAction)distanceSegmentControll_action:(id)sender  // поиск по расстоянию
{
    self.current_dist = distanceSegmentControll.selectedSegmentIndex;
    [searchArray removeAllObjects];
    [resultTable reloadData];
    //[self setDistLabels];
    if ([self.subtype_id length]>0) {
        [self searchFromtype];
    } else{
        [self searchRadius];
    }
}


-(void)searchFromtype
{
    [self setDistLabels];
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"lat",@"lng",@"distance",@"businessTypeId",@"businessSubtypeId", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:[[[[MySingleton sharedMySingleton] getMainScreen] getCoordinates] objectForKey:@"latitude"] , [[[[MySingleton sharedMySingleton] getMainScreen] getCoordinates] objectForKey:@"longitude"] ,[NSString stringWithFormat:@"%i",[[distance_lbls objectAtIndex:self.current_dist] intValue] ],@"2",self.subtype_id,nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kBusinessTypeSearch];
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
    NSLog(@"-- %@",[params description]);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:kMainUrl]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kBusinessTypeSearch parameters:params];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"%@", JSON);
        for (NSDictionary * dict in JSON) {
            NSString *restName = [dict objectForKey:@"name"];
            NSString *restLabel = [dict objectForKey:@"label"];
            NSString *restId = [dict objectForKey:@"id"];
            NSArray *sub_keys = [[NSArray alloc] initWithObjects:@"name",@"label",@"id", nil];
            NSArray *sub_values = [[NSArray alloc] initWithObjects:restName,restLabel,restId ,nil];
            NSDictionary *sub_dict = [[NSDictionary alloc] initWithObjects:sub_values forKeys:sub_keys];
            [searchArray addObject:sub_dict];
            [distanceArr addObject:[dict objectForKey:@"distance"]];
        }
        
        if ([searchArray count]==0) {
            
            [top_label setText:@"Restaurants"];
            [resultTable setAlpha:0];
            NSString *bottomTxt =[NSString stringWithFormat:@"%@",NSLocalizedString(@"no_result_bottom_fromtype", nil)];
            bottomTxt = [bottomTxt stringByReplacingOccurrencesOfString:@"#MMM#" withString:[distance_lbls objectAtIndex:self.current_dist]] ;
            bottomTxt = [bottomTxt stringByReplacingOccurrencesOfString:@"#SSS#" withString:self.subtype_name];
            NSLog(@"current dist: %d",current_dist);
            NSLog(@"bottom txt: %@",bottomTxt);
            [sorryBottomLabel  setText:bottomTxt];
            [noResultView setAlpha:1];
        } else
        {
            [top_label setText:[NSString stringWithFormat:@"Restaurants: %@",self.subtype_name]];
            [resultTable reloadData];
            [resultTable setAlpha:1];
            [noResultView setAlpha:0];
        }
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        //NSArray *initArr = [[NSArray alloc] initWithObjects:[request URL],[error localizedDescription],JSON, nil];
        //[[MySingleton sharedMySingleton] showFailureMessage:self parametrsMsg:initArr];
    }];
    
    [operation start];
}

-(void)searchRadius
{
    [self setDistLabels];
    [[[MySingleton sharedMySingleton] getMainScreen].view addSubview:[[MySingleton sharedMySingleton] getBlockerView]];
  
    NSArray *keys = [[NSArray alloc] initWithObjects:@"lat",@"lng",@"distance", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:[[[[MySingleton sharedMySingleton] getMainScreen] getCoordinates] objectForKey:@"latitude"] , [[[[MySingleton sharedMySingleton] getMainScreen] getCoordinates] objectForKey:@"longitude"] ,[NSString stringWithFormat:@"%i",[[distance_lbls objectAtIndex:self.current_dist] intValue] ],nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSString *cur_url;
    cur_url =[NSString stringWithFormat:@"%@%@",kMainUrl,kRadiusSearch];
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys: dict, @"data", nil];
     NSLog(@"-- %@",[params description]);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:kMainUrl]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:kRadiusSearch parameters:params];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@", JSON);
        [searchArray removeAllObjects];
        for (NSDictionary * dict in JSON) {
            CLLocationCoordinate2D restaurantLoc;
            restaurantLoc.latitude = [[[dict objectForKey:@"Business"] objectForKey:@"latitude"] floatValue];
            restaurantLoc.longitude = [[[dict objectForKey:@"Business"] objectForKey:@"longitude"] floatValue];
            NSString *restName = [[dict objectForKey:@"Business"] objectForKey:@"name"];
            NSString *restLabel = [[dict objectForKey:@"Business"] objectForKey:@"label"];
            NSString *restId = [[dict objectForKey:@"Business"] objectForKey:@"id"];            
            NSArray *sub_keys = [[NSArray alloc] initWithObjects:@"name",@"label",@"id", nil];
            NSArray *sub_values = [[NSArray alloc] initWithObjects:restName,restLabel,restId, nil];
            NSDictionary *sub_dict = [[NSDictionary alloc] initWithObjects:sub_values forKeys:sub_keys];
            NSLog(@"# %@", [sub_dict description]);
            [distanceArr addObject:[[dict objectForKey:@"Business"] objectForKey:@"distance"]];
            [searchArray addObject:sub_dict];
        }
        
        if ([searchArray count]==0) {
            NSString *bottomTxt =[NSString stringWithFormat:@"%@",NSLocalizedString(@"no_result_bottom", nil)];
            bottomTxt = [bottomTxt stringByReplacingOccurrencesOfString:@"#MMM#" withString:[distance_lbls objectAtIndex:self.current_dist]] ;
            bottomTxt = [bottomTxt stringByReplacingOccurrencesOfString:@"#SSS#" withString:@""] ;
            [sorryBottomLabel  setText:bottomTxt];
            [resultTable setAlpha:0];
            [noResultView setAlpha:1];
        } else
        {
            [resultTable reloadData];
            [resultTable setAlpha:1];
            [noResultView setAlpha:0];
        }
        
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
    
        NSLog(@"view height %f",self.view.frame.size.height);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"%@ JSON %@", [error localizedDescription], JSON);
        [[[MySingleton sharedMySingleton] getBlockerView] removeFromSuperview];
        //NSArray *initArr = [[NSArray alloc] initWithObjects:[request URL],[error localizedDescription],JSON, nil];
        //[[MySingleton sharedMySingleton] showFailureMessage:self parametrsMsg:initArr];
        NSLog(@"view height %f",self.view.frame.size.height);
    }];
    
    [operation start];
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
    
    
    // округление
    float num = [[distanceArr objectAtIndex:indexPath.row] floatValue];
    
    NSLog(@"исходное %f",num);
    
    num = roundf(10 * num)/10.0;
    
    
    NSLog(@"round %f",num);
    
    NSString *miles = [NSString stringWithFormat:@"%.1f",num];
    
    NSLog(@"miles %@", miles);
    
    NSString *nameLabelTxt = [NSString stringWithFormat:@"%@ (%@ mi)",[[searchArray objectAtIndex:indexPath.row] objectForKey:@"name"],miles];
    
    cell.nameLbl.text = nameLabelTxt;
    
    //cell.nameLbl.text = [[searchArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    cell.labelLbl.text = [[searchArray objectAtIndex:indexPath.row] objectForKey:@"label"];
    
    if (indexPath.row == [searchArray count]-1) {
        [cell setRoundedIm];
    } else
    [cell setRectangleIm];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [[MySingleton sharedMySingleton] showRestaurantDetaile:[[searchArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    SearchCell *cell = (SearchCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == [searchArray count]-1)
        [cell setRoundedSelectedIm];
    else
        [cell setRectangleSelectedIm];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [searchArray count];
}
- (void)viewDidUnload {
    distanceSegmentControll = nil;
    [super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden // hidden status bar in iOS 7
{
    return YES;
}
@end
