//
//  LanguageDataClass.h
//  RMH Console
//
//  Created by Randy Robinson on 4/4/14.
//  Copyright (c) 2014 RMH Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageDataClass : NSObject{
    
}
@property (nonatomic, strong) NSNumber *db_language_id;
@property (nonatomic, strong) NSString *db_language;
@property (nonatomic, strong) NSString *db_apple_code;
@property (nonatomic, strong) NSString *db_google_code;
@property (nonatomic, strong) NSString *errorMessage;

@end
