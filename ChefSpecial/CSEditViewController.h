//
//  CSEditViewController.h
//  ChefSpecial
//
//  Created by WozniBob on 3/15/14.
//  Copyright (c) 2014 Bob_Burns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"

@protocol CSEditDishDelegate <NSObject>
- (void)dishChanged:(Dish *)dish;
@end

@interface CSEditViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSManagedObjectID *dishDetailID;
@property (nonatomic, strong) NSNumber* itemToEdit;
@property (weak, nonatomic) IBOutlet UITextField *editDishItemTextField;
@property (nonatomic, weak) id<CSEditDishDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIStepper *costStepper;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UIButton *wasteInfoButton;

- (IBAction)saveButtonTouched:(id)sender;
- (IBAction)takeStep:(id)sender;

@end
