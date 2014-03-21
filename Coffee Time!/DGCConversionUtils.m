//
//  DGCConversionUtils.m
//  Coffee Time!
//
//  Created by RIcky Chang on 3/20/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import "DGCConversionUtils.h"

@implementation DGCConversionUtils

+(NSInteger)convertGramsToFluidOunces:(NSInteger)grams
{
    return (NSInteger) roundf(grams * 0.0338140225589);
}

+(NSInteger)convertFluidOuncesToGrams:(NSInteger)fluidOunces
{
    return (NSInteger) roundf(fluidOunces * 29.5735296875);
}

+(float)convertGramsToTablespoons:(NSInteger)grams
{
    return grams / 5.0f;
}

+(NSInteger)convertTablespoonsToGrams:(float)tbsp
{
    return (NSInteger) roundf(tbsp * 5);
}

@end
