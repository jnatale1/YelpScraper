//
//  DetailViewController.m
//  YelpScraper
//
//  Created by Jonathan Natale on 7/20/13.
//  Copyright (c) 2013 Jonathan Natale. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize name,phone,address,city;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)call
{
    NSString *phoneString = phone.text;
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    //call number
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                [NSString stringWithFormat:@"telprompt://%@",phoneString]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    name.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
    phone.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];
    address.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"address"];
    city.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"cityState"];
    [name setEditable:false];
    [phone setEditable:false];
    [address setEditable:false];
    [city setEditable:false];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
