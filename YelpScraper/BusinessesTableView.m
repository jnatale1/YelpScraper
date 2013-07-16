//
//  BusinessesTableView.m
//  YelpScraper
//
//  Created by Jonathan Natale on 7/10/13.
//  Copyright (c) 2013 Jonathan Natale. All rights reserved.
//

#import "BusinessesTableView.h"
#import "AppDelegate.h"

@interface BusinessesTableView ()

@end

@implementation BusinessesTableView
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
    searchesArray = [[NSMutableArray alloc] init];
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    searchesArray = appDelegate->searchesArray;
    
    
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
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchesArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	[cell setText:[searchesArray objectAtIndex:indexPath.row]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	cell.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
	cell.textColor = [UIColor darkGrayColor];
	
	
    return cell;
}





// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate->globalBusinessName = [searchesArray objectAtIndex:indexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
