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
@synthesize information;

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
    NSString *phoneString = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];
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
    
    information.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",
                        [[NSUserDefaults standardUserDefaults] stringForKey:@"name"],
                        [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"],
                        [[NSUserDefaults standardUserDefaults] stringForKey:@"address"],
                        [[NSUserDefaults standardUserDefaults] stringForKey:@"cityState"],nil];
    [information setEditable:false];


    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
