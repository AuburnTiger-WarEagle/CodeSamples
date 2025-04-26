//
//  DataAccessLayer.h
//  RMH Console
//
//  Created by Randy Robinson on 1/23/14.
//  Copyright (c) 2014 RMH Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppsDataClass.h"
#import "IAPDataClass.h"
#import "LanguageDataClass.h"
#import "DefineRecipientsWindowController.h"
#import <mysql.h>

@interface DataAccessLayer : NSObject
{
    MYSQL *mySqlObj;
    AppsDataClass *appsDataClass;
    IAPDataClass *iapDataClass;

    NSMutableArray *db_appData;
    NSMutableArray *db_iapData;
    NSMutableArray *db_langData;
    NSMutableArray *db_deviceTypes;
    NSMutableArray *db_systemVersions;
    NSMutableArray *db_systemTypes;
    NSMutableArray *db_preferredLanguages;
    NSMutableArray *db_appNames;
}

-(BOOL) openDatabaseConnection;
-(void) closeDatabaseConnection;
-(int) getNextMsgNumber;
-(NSMutableArray *) getAppData;
-(NSMutableArray *) getIAPData;
-(NSMutableArray *) getLangData;
-(NSMutableArray *) getDeviceTypes;
-(NSMutableArray *) getSystemVersions;
-(NSMutableArray *) getSystemTypes;
-(NSMutableArray *) getPreferredLanguages;
-(NSMutableArray *) getAppNames;
-(NSString *) getAppleLanguageCode : (NSString *)language;
-(NSMutableArray *) getAppleCodes;
-(NSMutableArray *) getGoogleCodes;
-(NSMutableArray *) getLanguageList;
-(NSString *) getAppNumber : (NSString *)appName;
-(NSString *) getAppName : (NSString *)appNumber;

-(NSString *) getLanguageCode: (NSString *)language;

- (int) addAppData:(AppsDataClass *) appsDataClass;
- (int) delAppData:(AppsDataClass *) appsDataClass;
- (int) updAppData:(AppsDataClass *) appsDataClass;

-(int) addIAPData:(IAPDataClass *) iapDataClass;
-(int) delIAPData:(IAPDataClass *) iapDataClass;
-(int) updIAPData:(IAPDataClass *) iapDataClass;

-(int) addLangData:(LanguageDataClass *) languageDataClass;
-(int) delLangData:(LanguageDataClass *) languageDataClass;
-(int) updLangData:(LanguageDataClass *) languageDataClass;

-(int) storeMessage: (NSString *)messageNumber : (NSString *)msgTitle : (NSString *)msgBody : (NSString *)language : (NSString *)newMessageReceived : (NSString *)urlText : (NSString *)startDate : (NSString *)endDate;

-(int) createMessageQueueEntries :(DefineRecipientsWindowController *)ownerWindow :(NSString *)sqlString :(NSString *)msgNumber :(NSString *)msgType :(NSString *)prod_dev_ind;

-(NSMutableArray *) confirmRecipients :(DefineRecipientsWindowController *)ownerWindow :(NSString *)sqlString :(NSString *)msgNumber :(NSString *)msgType :(NSString *)prod_dev_ind;

@end
