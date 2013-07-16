//
//  ViewController.m
//  YelpScraper
//
//  Created by Jonathan Natale on 7/9/13.
//  Copyright (c) 2013 Jonathan Natale. All rights reserved.
//

#import "ViewController.h"
#import "BusinessesTableView.h"
#import "AppDelegate.h"
#import "AllListingsTableView.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize name,phone,city,address;

-(IBAction)callNumber
{
    //format number if needed
    phoneString = phone.text;
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSLog(@"phone run, %@",phoneString);
    
    //call number
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                               [NSString stringWithFormat:@"telprompt://%@",phoneString]]];
} //end callNumber

-(IBAction)enterDesiredLocation:(id)sender
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enter a City", @"new_list_dialog")
                                                          message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
    [cityTextField setBackgroundColor:[UIColor whiteColor]];
    [cityTextField becomeFirstResponder];
    [myAlertView addSubview:cityTextField];
    [myAlertView show];
    myAlertView.tag = 1;
}
-(IBAction)enterDesiredBusiness:(id)sender
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enter a Business Name", @"new_list_dialog")
                                                          message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
    [nameTextField setBackgroundColor:[UIColor whiteColor]];
    [nameTextField becomeFirstResponder];
    [myAlertView addSubview:nameTextField];
    [myAlertView show];
    myAlertView.tag = 2;
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(actionSheet.tag == 1) {

        if(buttonIndex == 1) {
        if ([cityTextField.text isEqual: @""] || [cityTextField.text isEqual:NULL])
        {
            //do nothing
        }
        cityString = cityTextField.text;
        [[NSUserDefaults standardUserDefaults] setObject:cityTextField.text forKey:@"city"];
        } //end buttonIndex
    } //end action sheet
    if(actionSheet.tag == 2) {

        if(buttonIndex == 1) {
        if ([nameTextField.text isEqual: @""] || [nameTextField.text isEqual:NULL])
        {
            //do nothing
        }
        nameString = nameTextField.text;
        [self inputBusiness];
        } //end buttonIndex
    } //end action sheet
} //end alert view

-(void)inputBusiness
{
    [[NSUserDefaults standardUserDefaults] setObject:nameString forKey:@"name"];
    [self formatInput];
} //end input business

-(IBAction)loadRestaurants
{
    BusinessesTableView *table = [[BusinessesTableView alloc] initWithNibName:@"BusinessesTableView" bundle:nil];
    [self presentViewController:table animated:TRUE completion:nil];
}

-(void)formatInput
{
    nameString = [nameString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    nameString = [nameString stringByReplacingOccurrencesOfString:@"'" withString:@""];
    cityString = [cityString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    nameString = [nameString stringByAppendingFormat:@"-%@",cityString];
    [self getRestaurantInfo:nameString];
}

-(IBAction)getRestaurantInfo:(NSString *)string
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSLog(@"NAME: %@",string);
    
    //url of site to be scraped
    NSString *tempString = [@"http://www.yelp.com/biz/" stringByAppendingString:string];
    [request setURL:[NSURL URLWithString:tempString]];
    
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL];
    html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    scanner = [NSScanner scannerWithString:html];
    tempToken = nil;
    
    //get information
    [self getName:tempToken];
    [self getPhone:tempToken];
    [self getCity:tempToken];
    [self getAddress:tempToken];
    
    //save search to recent searches
    [self saveSearch];
    
} //end getRestaurantInfo

-(void)getName:(NSString *)token
{
    //find the unique html code BEFORE the news headline
    [scanner scanUpToString:@"<meta name=\"keywords\" content=\"" intoString:NULL];
    
    //find the unique html code AFTER the news headline
    [scanner scanUpToString:@"," intoString:&token];
    
    if (token == NULL) {
        name.text = @"Name not found.";
    } //end if
    else {
        //replace &quot html code with an actual quote mark > "
        NSString *tempStringOne = [token stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        
        //replace &#39 html code with an actual '
        NSString *tempStringTwo = [tempStringOne stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
        
        //PRINT TO LABEL
        name.text = [[NSString alloc] initWithString:[tempStringTwo substringFromIndex:31]];
    } //end else
    
} //end getName

-(void)getPhone:(NSString *)token
{
    //find the unique html code BEFORE the news headline
    [scanner scanUpToString:@"telephone\">" intoString:NULL];
    
    //find the unique html code AFTER the news headline
    [scanner scanUpToString:@"</span>" intoString:&token];
    
    if (token == NULL) {
        phone.text = @"Phone not found.";
    } //end if
    else {
        //replace &quot html code with an actual quote mark > "
        NSString *tempStringOne = [token stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        
        //replace &#39 html code with an actual '
        NSString *tempStringTwo = [tempStringOne stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
        
        //PRINT TO LABEL
        phone.text = [[NSString alloc] initWithString:[tempStringTwo substringFromIndex:11]];
        phoneString = phone.text;
    } //end else
    
} //end getPhone

-(void)getCity:(NSString *)token
{
    //find the unique html code BEFORE the news headline
    [scanner scanUpToString:@"formatted_city" intoString:NULL];
    
    //find the unique html code AFTER the news headline
    [scanner scanUpToString:@"\"," intoString:&token];
    
    if (token == NULL) {
        city.text = @"City not found.";
    } //end if
    else {
        //replace &quot html code with an actual quote mark > "
        NSString *tempStringOne = [token stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        
        //replace &#39 html code with an actual '
        NSString *tempStringTwo = [tempStringOne stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
        
        //PRINT TO LABEL
        city.text = [[NSString alloc] initWithString:[tempStringTwo substringFromIndex:18]];
    } //end else
} //end getCity

-(void)getAddress:(NSString *)token
{
    //find the unique html code BEFORE the news headline
    [scanner scanUpToString:@"formatted_address" intoString:NULL];
    
    //find the unique html code AFTER the news headline
    [scanner scanUpToString:@"\"," intoString:&token];
    
    if (token == NULL) {
        address.text = @"Address not found.";
    } //end if
    else {
        //replace &quot html code with an actual quote mark > "
        NSString *tempStringOne = [token stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        
        //replace &#39 html code with an actual '
        NSString *tempStringTwo = [tempStringOne stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
        
        //PRINT TO LABEL
        address.text = [[NSString alloc] initWithString:[tempStringTwo substringFromIndex:22]];
    } //end else
} //end getAddress

-(IBAction)getAllListings
{
    //format city
    NSString *allListingsString = cityString;
    allListingsString = [allListingsString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    allListingsString = [allListingsString stringByReplacingOccurrencesOfString:@"," withString:@"-ca"];
    allListingsString = [allListingsString stringByAppendingString:@"-ca-us"];
    
    //set up scanner
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //url of site to be scraped
    NSString *tempString = [NSString stringWithFormat:@"http://www.yelp.com/c/%@/%@",allListingsString,category];
    NSLog(@"tempString: %@",tempString);
    [request setURL:[NSURL URLWithString:tempString]];
    
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL];
    html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    scanner = [NSScanner scannerWithString:html];
    tempToken = nil;
    
    //fetch results
    [self scrapeAllRestaurants:tempToken];
    
    //show all listings
    AllListingsTableView *table = [[AllListingsTableView alloc] initWithNibName:@"AllListingsTableView" bundle:nil];
    [self presentViewController:table animated:TRUE completion:nil];
} //end getAllListings

-(void)scrapeAllRestaurants:(NSString *)token
{
    //initialize counters
    int i = 0;
    
    //store the business city
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate->globalBusinessCity = cityString;
    
    //scrape the best five yelp entries
    while (i < 8 )
    {
    //start scanning where the previous scanner left off
    [scanner setScanLocation:lastPoint];
    
    //find the unique html code BEFORE the news headline
    [scanner scanUpToString:@"biz-name\" data-hovercard-id=\"" intoString:NULL];
    
    //find the unique html code AFTER the news headline
    [scanner scanUpToString:@"</a>" intoString:&token];
    
    if (token == NULL) {
        listingString = @"Listing not found.";
    } //end if
    else {
        //replace &quot html code with an actual quote mark > "
        NSString *tempStringOne = [token stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        
        //replace &#39 html code with an actual '
        NSString *tempStringTwo = [tempStringOne stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
        
        //add to array
        listingString = [[NSString alloc] initWithString:[tempStringTwo substringFromIndex:53]];
        if(![listingString isEqualToString:@"Listing not found."])
        {
            [allListingsArray addObject:[NSString stringWithFormat:@"%@",listingString]];
            AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate->allListingsArray = allListingsArray;
          //  NSLog(@"All Listings Array: %@", allListingsArray[0]);
            lastPoint = [scanner scanLocation];
        } //end listing not found checker
      } //end else
        i++; //update loop counter
    } // end while loop
    [self scrapeAllShopping];
} //end scrapeAllRestaurants

-(void)scrapeAllShopping
{
    if(counter == 0)
    {
        category = @"food";
        lastPoint = 0;
        counter++;
        [self getAllListings];
    }
    else if(counter == 1)
    {
        category = @"nightlife";
        lastPoint = 0;
        counter++;
        [self getAllListings];
    }
    else if(counter == 2)
    {
        category = @"shopping";
        lastPoint = 0;
        counter++;
        [self getAllListings];
    }
    else if(counter == 3)
    {
        category = @"bars";
        lastPoint = 0;
        counter++;
        [self getAllListings];
    }
    else if(counter == 4)
    {
        category = @"mexican";
        lastPoint = 0;
        counter++;
        [self getAllListings];
    }
    
   // AllListingsTableView *table = [[AllListingsTableView alloc] initWithNibName:@"AllListingsTableView" bundle:nil];
  //  [self presentViewController:table animated:TRUE completion:nil];
     
}

-(void)saveSearch
{
    if(![name.text isEqualToString:@"Name not found."])
    {
        [searchesArray addObject:[NSString stringWithFormat:@"%@",name.text]];
        AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate->searchesArray = searchesArray;
       // NSLog(@"From String: %@", searchesArray[0]);
    } //end name not found checker
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //reset scanner
    lastPoint = 0;
    counter = 0;
    
    //initialize category
    category = @"restaurants";
    
    searchesArray = [[NSMutableArray alloc] init];
    allListingsArray = [[NSMutableArray alloc] init];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    
    //show information on selection from all listings or recents
    if (counter != 0)
    {
        AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
        nameString = appDelegate->globalBusinessName;
        if(nameString.length > 0) {[self inputBusiness];}
        counter = 1;
    } //end counter if
} //end viewDidAppear

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
