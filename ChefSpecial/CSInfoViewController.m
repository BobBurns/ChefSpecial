//
//  CSInfoViewController.m
//  ChefSpecial
//
//  Created by WozniBob on 3/29/14.
//  Copyright (c) 2014 Bob_Burns. All rights reserved.
//

#import "CSInfoViewController.h"
#import "CSEditViewController.h"

@interface CSInfoViewController ()


@end

@implementation CSInfoViewController

@synthesize infoDishDetailID;
@synthesize itemToEdit;

- (void)setDetailItem:(id)newDetailItem
{
    if (infoDishDetailID != newDetailItem) {
        infoDishDetailID = newDetailItem;
    }
}

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
    
    _wasteTextView.text = @"Waste percentage is the proportion of scraps you have from butchering meat or fileting fish.\n\nThe more waste you have, the more expensive your dish is.\n\nYou can find your waste percentage by dividing your waste weight by the original weight of your meat or fish.";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showEdit"]) {
        CSEditViewController *eDVC = [segue destinationViewController];
        [eDVC setDetailItem:self.infoDishDetailID];
        [eDVC setItemToEdit:self.itemToEdit];
    }
}


@end
