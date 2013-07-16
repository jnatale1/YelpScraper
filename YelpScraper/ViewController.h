//
//  ViewController.h
//  YelpScraper
//
//  Created by Jonathan Natale on 7/9/13.
//  Copyright (c) 2013 Jonathan Natale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    //all listings
    NSMutableArray *allListingsArray;
    NSString *listingString;
    NSString *category;
    NSUInteger lastPoint;
    int counter;
    
    //recent searches
    NSMutableArray *searchesArray;
    
    //user-input (city)
    UITextField *cityTextField;
    NSString *cityString;
    
    //user-input (business name)
    UITextField *nameTextField;
    NSString *nameString;
    
    //phone
    NSString *phoneString;
    
    //scanner
    NSScanner *scanner;
    NSString *tempToken;
    NSString *html;
    NSData *data;
    
    //business information
    IBOutlet UILabel *name;
    IBOutlet UILabel *phone;
    IBOutlet UILabel *city;
    IBOutlet UILabel *address;
    
}
//restaurant information
@property(nonatomic,strong) IBOutlet UILabel *name;
@property(nonatomic,strong) IBOutlet UILabel *phone;
@property(nonatomic,strong) IBOutlet UILabel *city;
@property(nonatomic,strong) IBOutlet UILabel *address;

-(IBAction)getRestaurantInfo;
-(IBAction)loadRestaurants;
-(IBAction)callNumber;


@end
