//
//  CSEditViewController.m
//  ChefSpecial
//
//  Created by WozniBob on 3/15/14.
//  Copyright (c) 2014 Bob_Burns. All rights reserved.
//

#import "CSEditViewController.h"
#import "CSDetailViewController.h"
#import "CSInfoViewController.h"

@interface CSEditViewController ()
- (void)configureView;
- (void)configureViewForDish:(Dish *)theDish;

@end

@implementation CSEditViewController

@synthesize dishDetailID;
@synthesize itemToEdit;

- (void)setDetailItem:(id)newDetailItem
{
    if (dishDetailID != newDetailItem) {
        dishDetailID = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.dishDetailID) {
        
        Dish *theDish = (Dish *)[kAppDelegate.managedObjectContext objectWithID:self.dishDetailID];
        
        [self configureViewForDish:theDish];
    }
}
- (void)configureViewForDish:(Dish *)theDish

{
    
    self.navigationItem.title = theDish.name;
    NSNumber *suggested = [theDish chefRecommends];
    self.costLabel.text = [NSString stringWithFormat:@"$%.02f", [suggested doubleValue]];
    
    
    switch ([itemToEdit integerValue]) {
        case 0:
            self.navigationItem.title = @"Name";
            [self.editDishItemTextField setKeyboardType:UIKeyboardTypeDefault];
            self.editDishItemTextField.text = theDish.name;
            [self.costStepper setHidden:YES];
            break;
        case 1:
            self.navigationItem.title = @"Per Pound";
            self.costStepper.value = [theDish.pricePerPound doubleValue];
            self.costStepper.stepValue = .01;
            self.editDishItemTextField.text = [NSString stringWithFormat:@"$%.02f", _costStepper.value];
            break;
        case 2:
            self.navigationItem.title = @"Food Cost";
            self.costStepper.value = [theDish.foodCostPercent doubleValue];
            self.costStepper.stepValue = .1;
            self.editDishItemTextField.text = [NSString stringWithFormat:@"%.01f%%", _costStepper.value];
            break;
        case 3:
            self.navigationItem.title = @"Portion Size";
            self.costStepper.value = [theDish.portionSize doubleValue];
            self.costStepper.stepValue = .1;
            self.editDishItemTextField.text = [NSString stringWithFormat:@"%.01f oz", _costStepper.value];
            break;
        case 4:
            self.navigationItem.title = @"Waste";
            self.costStepper.value = [theDish.wastePercent doubleValue];
            self.costStepper.stepValue = .1;
            [self.wasteInfoButton setHidden:NO];
            self.editDishItemTextField.text = [NSString stringWithFormat:@"%.01f%%", _costStepper.value];
            break;
        case 5:
            self.navigationItem.title = @"Add'l Cost";
            self.costStepper.value = [theDish.additionalPlateCost doubleValue];
            self.costStepper.stepValue = .01;
            self.editDishItemTextField.text = [NSString stringWithFormat:@"$%.02f", _costStepper.value];
            break;
        default:
            self.editDishItemTextField.text = @"oops!";
            break;
    }
}

#pragma mark - text field delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_costStepper setEnabled:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _editDishItemTextField) {
        if ([itemToEdit integerValue] > 0)
        {
            if ([itemToEdit integerValue] == 2 && [textField.text doubleValue] <= 0) {
                [self alertNoZero];
                return YES;
            }
            _costStepper.value = [textField.text doubleValue];
        }
        [self updateViews];
        [textField resignFirstResponder];
        [_costStepper setEnabled:YES];
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    self.navigationItem.backBarButtonItem = UIBarButtonSystemItemDone;
    // Do any additional setup after loading the view.
    self.editDishItemTextField.delegate = (id)self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)unwindToDetail:(UIStoryboardSegue *)segue
{
    
}
#pragma mark - views

- (void)updateViews
{
    Dish *theDish = (Dish *)[kAppDelegate.managedObjectContext objectWithID:self.dishDetailID];
    switch ([itemToEdit integerValue]) {
        case 0:
            theDish.name = self.editDishItemTextField.text;
            break;
        case 1:
            self.editDishItemTextField.text = [NSString stringWithFormat:@"$%.02f", _costStepper.value];
            theDish.pricePerPound = [NSNumber numberWithDouble:_costStepper.value];
            break;
        case 2:
            self.editDishItemTextField.text = [NSString stringWithFormat:@"%.01f%%", _costStepper.value];
            theDish.foodCostPercent = [NSNumber numberWithDouble:_costStepper.value];
            break;
        case 3:
            self.editDishItemTextField.text = [NSString stringWithFormat:@"%.01f oz", _costStepper.value];
            theDish.portionSize = [NSNumber numberWithDouble:_costStepper.value];
            break;
        case 4:
            self.editDishItemTextField.text = [NSString stringWithFormat:@"%.01f%%", _costStepper.value];
            theDish.wastePercent = [NSNumber numberWithDouble:_costStepper.value];
            break;
            
        case 5:
            self.editDishItemTextField.text = [NSString stringWithFormat:@"$%.02f", _costStepper.value];
            theDish.additionalPlateCost = [NSNumber numberWithDouble:_costStepper.value];
            break;
            
        default:
            break;
    }
    NSNumber *suggested = [theDish chefRecommends];
    self.costLabel.text = [NSString stringWithFormat:@"$%.02f", [suggested doubleValue]];
}
#pragma mark - save

- (IBAction)saveButtonTouched:(id)sender {
    if ([_editDishItemTextField isFirstResponder] ) {
        [self didnotReturn];
    }
    
    NSError *saveError = nil;
    [kAppDelegate.managedObjectContext save:&saveError];
    if (saveError) {
        
        UIAlertView *alert =
        [[UIAlertView alloc]
         initWithTitle:@"Error saving dish"
         message:[saveError localizedDescription]
         delegate:nil
         cancelButtonTitle:@"Dismiss"
         otherButtonTitles:nil];
        
        [alert show];
    }
    else{
        NSLog(@"Changes to Dish saved.");
    }
    Dish *theDish = (Dish *)[kAppDelegate.managedObjectContext objectWithID:self.dishDetailID];
    
    [self.delegate dishChanged:theDish];
}
- (void)didnotReturn
{
    // method when user hits save or info before return
    NSLog(@"is first responder");
    if ([itemToEdit integerValue] > 0)
    {
        if ([itemToEdit integerValue] == 2 && [_editDishItemTextField.text doubleValue] <= 0) {
            [self alertNoZero];
            return;
        }
        _costStepper.value = [_editDishItemTextField.text doubleValue];
    }
    [self updateViews];
    [_editDishItemTextField resignFirstResponder];
    [_costStepper setEnabled:YES];
}

#pragma mark - Stepper

- (IBAction)takeStep:(id)sender {
    if ([itemToEdit integerValue] == 2 && _costStepper.value == 0) {
        [self alertNoZero];
        return;
    }
    
    [self updateViews];
}

- (void)alertNoZero
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Hey Chef!"
                                                 message:@"Please enter a number greater than zero"
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil, nil];
    [av show];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        CSDetailViewController *dVC = [segue destinationViewController];
        [dVC setDetailItem:self.dishDetailID];
        
    }
    if ([[segue identifier] isEqualToString:@"infoSegue"]) {
        if ([_editDishItemTextField isFirstResponder] ) {
            [self didnotReturn];
        }
        CSInfoViewController *iVC = [segue destinationViewController];
        [iVC setDetailItem:(id)self.dishDetailID];
        [iVC setItemToEdit:self.itemToEdit];
    }
}


@end
