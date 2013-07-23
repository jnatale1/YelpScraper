//
//  AllListingsTableView.m
//  YelpScraper
//
//  Created by Jonathan Natale on 7/12/13.
//  Copyright (c) 2013 Jonathan Natale. All rights reserved.
//

#import "AllListingsTableView.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"

@interface AllListingsTableView ()

@end

@implementation AllListingsTableView
@synthesize navBarTitle;

-(IBAction)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
} //end close

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //access view controller
    viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    //category headers
    headers = [NSArray arrayWithObjects:@"Restaurants",@"Food",@"Nightlife",@"Shopping",@"Bars",
                                        @"Mexican",@"Chinese",@"Japanese",@"Beauty & Spas",@"Automotive",
                                        @"Health & Medical",@"Home Services",@"Local Services",
                                        @"Arts & Entertainment",@"Event Planning & Services",
                                        @"Active Life",@"Hotels & Travel",@"Pets",@"Public Services & Gov",
                                        @"Local Flavor",@"Education",@"Professional Services",@"Real Estate",
                                        @"Financial Services",@"Religious Organizations",@"Mass Media",nil];
    //objects
    allListingsArray = [[NSMutableArray alloc] init];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    allListingsArray = appDelegate->allListingsArray;
    
    //all arrays must be initialized in order to fill them
    [self initializeArrays];
    
    //each tableView subcategory must have its own array
    [self createArrays];
    
    //tableView sections
    sections = [NSArray arrayWithObjects:restaurantsArray,foodArray,nightlifeArray,shoppingArray,barsArray,mexicanArray,
                                         chineseArray,japaneseArray,beautyArray,automotiveArray,healthArray,homeArray,
                                         localServicesArray,artArray,eventsArray,activeArray,hotelsArray,petsArray,publicservicesArray,
                                         localFlavorArray,educationArray,proArray,realestateArray,financialArray,religiousArray,
                                         massmediaArray,nil];

    //background attributes
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    //back button (not currently utilized)
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @" Home ";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;

}
-(void)initializeArrays
{
    //init arrays
    allArrays = [[NSMutableArray alloc] init];
    restaurantsArray = [[NSMutableArray alloc] init];
    foodArray = [[NSMutableArray alloc] init];
    nightlifeArray = [[NSMutableArray alloc] init];
    shoppingArray = [[NSMutableArray alloc] init];
    barsArray = [[NSMutableArray alloc] init];
    mexicanArray = [[NSMutableArray alloc] init];
    chineseArray = [[NSMutableArray alloc] init];
    japaneseArray = [[NSMutableArray alloc] init];
    beautyArray = [[NSMutableArray alloc] init];
    automotiveArray = [[NSMutableArray alloc] init];
    healthArray = [[NSMutableArray alloc] init];
    homeArray = [[NSMutableArray alloc] init];
    localServicesArray = [[NSMutableArray alloc] init];
    artArray = [[NSMutableArray alloc] init];
    eventsArray = [[NSMutableArray alloc] init];
    activeArray = [[NSMutableArray alloc] init];
    hotelsArray = [[NSMutableArray alloc] init];
    petsArray = [[NSMutableArray alloc] init];
    publicservicesArray = [[NSMutableArray alloc] init];
    localFlavorArray = [[NSMutableArray alloc] init];
    educationArray = [[NSMutableArray alloc] init];
    proArray = [[NSMutableArray alloc] init];
    realestateArray = [[NSMutableArray alloc] init];
    financialArray = [[NSMutableArray alloc] init];
    religiousArray = [[NSMutableArray alloc] init];
    massmediaArray = [[NSMutableArray alloc] init];
    
    //create an array of arrays
    [allArrays addObject:restaurantsArray];
    [allArrays addObject:foodArray];
    [allArrays addObject:nightlifeArray];
    [allArrays addObject:shoppingArray];
    [allArrays addObject:barsArray];
    [allArrays addObject:mexicanArray];
    [allArrays addObject:chineseArray];
    [allArrays addObject:japaneseArray];
    [allArrays addObject:beautyArray];
    [allArrays addObject:automotiveArray];
    [allArrays addObject:healthArray];
    [allArrays addObject:homeArray];
    [allArrays addObject:localServicesArray];
    [allArrays addObject:artArray];
    [allArrays addObject:eventsArray];
    [allArrays addObject:activeArray];
    [allArrays addObject:hotelsArray];
    [allArrays addObject:petsArray];
    [allArrays addObject:publicservicesArray];
    [allArrays addObject:localFlavorArray];
    [allArrays addObject:educationArray];
    [allArrays addObject:proArray];
    [allArrays addObject:realestateArray];
    [allArrays addObject:financialArray];
    [allArrays addObject:religiousArray];
    [allArrays addObject:massmediaArray];
} //end initializeArrays

-(void)createArrays
{
    int y  = 0;
    for(int x = 0; x < [allArrays count]; x++)
      {
          for (int z = 0; y < [allListingsArray count]; y++,z++)
          {
            if (z == 8) break; //(8 is the max number of listings yelp will return)
            [allArrays[x] addObject:[allListingsArray objectAtIndex:y]];
          } //end for y
                        NSLog(@"size: %i",[allArrays[x] count]);
      } //end for x
} //end createArrays

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [headers count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // return [allListingsArray count];
   // return 8; //there are 8 items in each category
    return [[sections objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [headers objectAtIndex:section];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	cell.textLabel.text = (NSString*)[[sections objectAtIndex:indexPath.section]
                                      objectAtIndex:indexPath.row];
   	[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
	cell.textLabel.textColor = [UIColor darkGrayColor];

    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate->globalBusinessName = (NSString*)[[sections objectAtIndex:indexPath.section]
                                                  objectAtIndex:indexPath.row];
    
    [viewController informationReceived];
    DetailViewController *vc = [[DetailViewController alloc] init];
    [self presentViewController:vc animated:TRUE completion:nil];
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate->globalBusinessName = (NSString*)[[sections objectAtIndex:indexPath.section]
                                                  objectAtIndex:indexPath.row];
    
    [viewController informationReceived];
    [self formatNumber];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [tableView cellForRowAtIndexPath:indexPath].textLabel.textColor = [UIColor lightGrayColor];
    
    /*
    //mark listings that have been called
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (NSInteger j = 0; j < [tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [tableView numberOfRowsInSection:j]; ++i)
        {
            if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqual:
                 [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]].textLabel.text])
            {
                [cells addObject:[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]]];
               [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]].textLabel.textColor = [UIColor lightGrayColor];
            } //end if
        } //end inner for
    } //end outer for
    for (UITableViewCell *cell in cells)
    {
        [cell textLabel].textColor = [UIColor lightGrayColor];
    }
    */
} //end didSelectRowAtIndexPath

-(void)formatNumber
{
    //format number if needed
    NSString *phoneString = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSLog(@"called!, %@",phoneString);
    
    //call number
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                [NSString stringWithFormat:@"telprompt://%@",phoneString]]];
} //end formatNumber

@end
