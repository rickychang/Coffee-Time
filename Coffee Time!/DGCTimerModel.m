//
//  DGCTimerModel.m
//  Coffee Time!
//
//  Created by RIcky Chang on 3/12/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import "DGCTimerModel.h"

@implementation DGCTimerModel

-(id)initWithCoffeeName:(NSString *)coffeeName
               duration:(NSInteger)duration
{
    self = [super init];
    if (self == nil) return nil;
    
    self.coffeeName = coffeeName;
    self.duration = duration;
    
    return self;
}

@end
