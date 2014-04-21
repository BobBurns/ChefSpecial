//
//  Dish.m
//  ChefSpecial
//
//  Created by WozniBob on 3/15/14.
//  Copyright (c) 2014 Bob_Burns. All rights reserved.
//

#import "Dish.h"


@implementation Dish

@dynamic name;
@dynamic pricePerPound;
@dynamic portionSize;
@dynamic wastePercent;
@dynamic additionalPlateCost;
@dynamic foodCostPercent;

- (NSNumber *)chefRecommends
{
    double _thePricePerPound = [self.pricePerPound doubleValue];
    double _thePortionSize = [self.portionSize doubleValue];
    double _theWastePercent = [self.wastePercent doubleValue] * .01;
    double _theAdditionalPlateCost = [self.additionalPlateCost doubleValue];
    double _theFoodCostPercent = [self.foodCostPercent doubleValue] * .01;
    
    double whatChefRecommends = (((_thePricePerPound + (_thePricePerPound * _theWastePercent))/16) * _thePortionSize) * (1/(_theFoodCostPercent)) + (_theAdditionalPlateCost * (1/_theFoodCostPercent));
    
    return [NSNumber numberWithDouble:whatChefRecommends];
}

@end
