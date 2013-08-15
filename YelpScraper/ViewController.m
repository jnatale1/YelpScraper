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
@synthesize currentCity,locationManager;

-(void)getCurrentLocation
{
    //get current location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    locationManager.pausesLocationUpdatesAutomatically = YES;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locationManager.location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       NSLog(@"Completion Handler called!");
                       
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                           
                       }
                       
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       
                       //  NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
                       //  NSLog(@"placemark.country %@",placemark.country);
                       //  NSLog(@"placemark.postalCode %@",placemark.postalCode);
                       //  NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
                       //  NSLog(@"placemark.locality %@",placemark.locality);
                       //  NSLog(@"placemark.subLocality %@",placemark.subLocality);
                       //  NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);
                       
                       NSString *localCityString = [NSString stringWithFormat:@"%@", placemark.locality];
                       NSString *localStateString = [self codeFromState:[NSString stringWithFormat:@"%@", placemark.administrativeArea]];
                       currentCity.text = [NSString stringWithFormat:@"%@, %@",localCityString,localStateString];
                   }]; //end reverse geocode
    
} //end getCurrentLocation

-(NSString *)codeFromState:(NSString *)state {
    NSArray *map = [NSArray arrayWithObjects:@"Alabama",@"al", @"Alaska",@"ak",@"Arizona",@"az",@"Arkansas",@"ar",
                    @"California",@"ca",@"Colorado",@"co",@"Connecticut",@"ct",@"Delaware",@"de",@"District of Columbia",@"dc",
                    @"Florida",@"fl",@"Georgia",@"ga",@"Hawaii",@"hi",@"Idaho",@"id",@"Illinois",@"il",@"Indiana",@"in",@"Iowa",
                    @"ia",@"Kansas",@"ks",@"Kentucky",@"ky",@"Louisiana",@"la",@"Maine",@"me",@"Maryland",@"md",@"Massachusetts",@"ma",
                    @"Michigan",@"mi",@"Minnesota",@"mn",@"Mississippi",@"ms",@"Missouri",@"mo",@"Montana",@"mt",@"Nebraska",@"ne",
                    @"Nevada",@"nv",@"New Hampshire",@"nh",@"New Jersey",@"nj",@"New Mexico",@"nm",@"New York",@"ny",@"North Carolina",@"nc",
                    @"North Dakota",@"nd",@"Ohio",@"oh",@"Oklahoma",@"ok",@"Oregon",@"or",@"Pennsylvania",@"pa",@"Rhode Island",@"ri",
                    @"South Carolina",@"sc",@"South Dakota",@"sd",@"Tennessee",@"tn",@"Texas",@"tx",@"Utah",@"ut",@"Vermont",@"vt",
                    @"Virginia",@"va",@"Washington",@"wa",@"West Virginia",@"wv",@"Wisconsin",@"wi",@"Wyoming", @"wy", nil];
    for (int i = 0; i <[map count]; i+=2) {
        if ([state compare:[map objectAtIndex:i]] == NSOrderedSame) {
            return [map objectAtIndex:i+1];
        }
    }
    return state;
}

-(IBAction)nearMe
{
    
    //reset scanner
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate->allListingsArray removeAllObjects];
    lastPoint = 0;
    counter = 0;
    category = @"restaurants";
    
    
    //save the city
    cityString = currentCity.text;
    [[NSUserDefaults standardUserDefaults] setObject:[[NSString alloc] initWithString:[cityString substringToIndex:[cityString length]-4]] forKey:@"city"];
    
    //show activity indicator
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    loadingView.alpha = 1.0;
    [UIView commitAnimations];
    
    //get the listings
    [self performSelector:@selector(getAllListings) withObject:nil afterDelay:0.1];
} //end near me

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

//search by city
-(IBAction)enterDesiredLocation:(id)sender
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enter a City", @"new_list_dialog")
                                                          message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
    [cityTextField setBackgroundColor:[UIColor whiteColor]];
    [cityTextField setPlaceholder:@"Example: Las Vegas, nv"];
    [cityTextField becomeFirstResponder];
    [myAlertView addSubview:cityTextField];
    [myAlertView show];
    myAlertView.tag = 1;
    
    //reset scanner
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate->allListingsArray removeAllObjects];
    lastPoint = 0;
    counter = 0;
    category = @"restaurants";
    
    
} //enterDesiredLocation

//search by business
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
} //end enterDesiredBusiness

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(actionSheet.tag == 1) {

        if(buttonIndex == 1) {
            if ([cityTextField.text isEqual: @""] || [cityTextField.text isEqual:NULL])
            {
                //do nothing
            }
            
            //save the city
            cityString = cityTextField.text;
            [cityTextField resignFirstResponder];
            [[NSUserDefaults standardUserDefaults] setObject:[[NSString alloc] initWithString:[cityString substringToIndex:[cityString length]-4]] forKey:@"city"];
            
            //show activity indicator
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            loadingView.alpha = 1.0;
            [UIView commitAnimations];
            
            //get the listings
            [self performSelector:@selector(getAllListings) withObject:nil afterDelay:0.1];
            
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
} //end loadRestaurants

-(void)formatInput
{
    nameString = [nameString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    nameString = [nameString stringByReplacingOccurrencesOfString:@"'" withString:@""];
    cityString = [cityString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    nameString = [nameString stringByAppendingFormat:@"-%@",cityString];
    [self getRestaurantInfo:nameString];
} //end formatInput

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
        [[NSUserDefaults standardUserDefaults] setObject:[[NSString alloc] initWithString:[tempStringTwo substringFromIndex:31]] forKey:@"name"];
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
        [[NSUserDefaults standardUserDefaults] setObject:[[NSString alloc] initWithString:[tempStringTwo substringFromIndex:11]] forKey:@"phone"];
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
        [[NSUserDefaults standardUserDefaults] setObject:[[NSString alloc] initWithString:[tempStringTwo substringFromIndex:18]] forKey:@"cityState"];
        
        
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
        [[NSUserDefaults standardUserDefaults] setObject:[[NSString alloc] initWithString:[tempStringTwo substringFromIndex:22]] forKey:@"address"];
    } //end else
} //end getAddress

-(IBAction)getAllListings
{
    
    //format city
    NSString *allListingsString = cityString;
    allListingsString = [allListingsString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    allListingsString = [allListingsString stringByReplacingOccurrencesOfString:@"," withString:@""];
    allListingsString = [allListingsString stringByAppendingString:@"-us"];
    
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
    
    //hide activity indicator
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    loadingView.alpha = 0.0;
    [UIView commitAnimations];
    
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
        
        //replace &amp html code with an actual &
        NSString *tempStringthree = [tempStringTwo stringByReplacingOccurrencesOfString:@"&amp;" withString:@"and"];
        
        //add to array
        listingString = [[NSString alloc] initWithString:[tempStringthree substringFromIndex:53]];
        if(![listingString isEqualToString:@"Listing not found."])
        {
            [allListingsArray addObject:[NSString stringWithFormat:@"%@",listingString]];
            AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate->allListingsArray = allListingsArray;

            lastPoint = [scanner scanLocation];
        } //end listing not found checker
      } //end else
        i++; //update loop counter
    } // end while loop
    [self scrapeAllCategories];
} //end scrapeAllRestaurants

-(void)scrapeAllCategories
{
 
    NSArray *categoryArray = [NSArray arrayWithObjects:@"food",@"nightlife",@"shopping",
                              @"bars",@"mexican",@"chinese",@"japanese",@"beautysvc",
                              @"automotive",@"health",@"homeservices",@"localservices",
                              @"arts",@"eventservices",@"active",@"hotelstravel",
                              @"pets",@"publicservicesgovt",@"localflavor",@"education",
                              @"professional",@"realestate",@"financialservices",@"religiousorgs",
                              @"massmedia",nil];
    if (counter < [categoryArray count])
    {
        category = categoryArray[counter];
        lastPoint = 0;
        counter++;
        [self getAllListings];
    } //end if
    else {
        
        //show all listings
        AllListingsTableView *table = [[AllListingsTableView alloc] initWithNibName:@"AllListingsTableView" bundle:nil];
        [self presentViewController:table animated:TRUE completion:nil];
    } //end else
} //end scrapeAllCategories

-(void)saveSearch
{
    if(![name.text isEqualToString:@"Name not found."])
    {
        [searchesArray addObject:[NSString stringWithFormat:@"%@",name.text]];
        AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate->searchesArray = searchesArray;
       // NSLog(@"From String: %@", searchesArray[0]);
    } //end name not found checker
} //end saveSearch

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //getCurrentLocation
    [self getCurrentLocation];
    [self performSelector:@selector(getCurrentLocation) withObject:nil afterDelay:10.0];
    
    //reset scanner
    lastPoint = 0;
    counter = 0;
    
    //initialize category
    category = @"restaurants";
    
    searchesArray = [[NSMutableArray alloc] init];
    allListingsArray = [[NSMutableArray alloc] init];
    
	// Do any additional setup after loading the view, typically from a nib.
} //end viewDidLoad

- (void)informationReceived
{
    //show information on selection from all listings or recents
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    nameString = appDelegate->globalBusinessName;
    cityString = [[NSUserDefaults standardUserDefaults] stringForKey:@"city"];
    if(nameString.length > 0) {[self inputBusiness];}
    counter = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
