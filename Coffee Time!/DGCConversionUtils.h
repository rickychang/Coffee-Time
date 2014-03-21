//
//  DGCConversionUtils.h
//  Coffee Time!
//
//  Created by RIcky Chang on 3/20/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DGCGramsUnit = 0,
    DGCFluidOuncesUnit,
    DGCTableSpoonsUnit
}DGCUnits;

@interface DGCConversionUtils : NSObject

+(NSInteger)convertGramsToFluidOunces:(NSInteger)grams;

+(NSInteger)convertFluidOuncesToGrams:(NSInteger)fluidOunces;

+(float)convertGramsToTablespoons:(NSInteger)grams;

+(NSInteger)convertTablespoonsToGrams:(float)tbls;

@end
