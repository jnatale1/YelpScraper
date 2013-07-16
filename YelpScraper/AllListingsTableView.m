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
    
    //populate the table view
    graphicsSections=[[NSMutableArray alloc] initWithObjects:@"Restaurants",@"Food", nil];
    allListingsArray = [[NSMutableArray alloc] init];
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    allListingsArray = appDelegate->allListingsArray;
    graphicsData=[[NSMutableArray alloc] initWithObjects:allListingsArray, nil];
    
    //background attributes
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //back button (not currently utilized)
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @" Home ";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    //nav bar title
    navBarTitle.text = [NSString stringWithFormat:@"Best of %@", appDelegate->globalBusinessCity];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [graphicsSections count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allListingsArray count];
    //return [[graphicsData objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [graphicsSections objectAtIndex:section];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	[cell setText:[allListingsArray objectAtIndex:indexPath.row]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	cell.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
	cell.textColor = [UIColor darkGrayColor];
	
	
    return cell;
}





// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate->globalBusinessName = [allListingsArray objectAtIndex:indexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
    
  /*  if ([[allListingsArray objectAtIndex:indexPath.row] isEqual:@"Test"])
	{
        
		
	}
   */ 
}

@end
