//
//  Utility.h
//  Brochure
//
//  Created by Akshat Mittal on 27/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
+(BOOL)isInternetWorking;
@end
