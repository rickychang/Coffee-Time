//
//  DGCTimerModel.h
//  Coffee Time!
//
//  Created by RIcky Chang on 3/12/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DGCTimerModel : NSObject

@property (nonatomic, strong) NSString *coffeeName;
@property (nonatomic, assign) NSInteger duration;

-(id)initWithCoffeeName:(NSString *)coffeeName
               duration:(NSInteger)duration;

@end
