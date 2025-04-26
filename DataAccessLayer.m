//
//  DataAccessLayer.m
//  RMH Console
//
//  Created by Randy Robinson on 1/23/14.
//  Copyright (c) 2014 RMH Development. All rights reserved.
//

#include <wchar.h>  // includes support for wide characters
#import "DataAccessLayer.h"
#import "RecipientDataClass.h"

@implementation DataAccessLayer


-(BOOL) openDatabaseConnection {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    const char *databaseName = [[defaults objectForKey:@"DatabaseName"] UTF8String];
    mySqlObj = mysql_init(NULL);
    // set UTF8 default here
    mysql_options(mySqlObj, MYSQL_SET_CHARSET_NAME, "utf8");
    if (mysql_real_connect(mySqlObj, "rmhdevelopment.com", "rmhdev5", "TurdBurgler007",
                           databaseName, 0, NULL, 0) == NULL)
    {
        const char *errorMessage = mysql_error(mySqlObj);
        NSString *nsErrorMessage = [NSString stringWithUTF8String:errorMessage];
        NSLog(@"MySql Connection Error: %@",nsErrorMessage);
        [self closeDatabaseConnection];
        return false;
    }
    else
    {
        NSLog(@"MySql Connection successful");
        return true;
    }
}

-(void) closeDatabaseConnection {
    mysql_close(mySqlObj);
}

-(NSMutableArray *) getAppData {

    NSLog(@"getAppData starting...");
    db_appData = [[NSMutableArray alloc] init];
    
    // connect to database
    if (![self openDatabaseConnection])
        return nil;
    
    const char *cntQueryString = "select count(*) from rmh_app";
    
    mysql_query(mySqlObj, cntQueryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    
    MYSQL_ROW row = mysql_fetch_row(queryResponse);

    numberOfRows = atol(row[0]);
    
    const char *queryString = "select app_id, app_number, bundle_id, app_version, apple_id, sku, type, pricing_tier, create_timestamp, update_timestamp from rmh_app order by bundle_id,app_version";
    
    mysql_query(mySqlObj, queryString);
    queryResponse = mysql_store_result(mySqlObj);
    
    if (numberOfRows == 0)
    {
        [self closeDatabaseConnection];
        return nil;
    }
    
    NSInteger i = 0;
    NSLog(@"Number of rows: %ld", numberOfRows);
    
    while (i < numberOfRows)
    {
        row = mysql_fetch_row(queryResponse);
        // instantiate the data class
        appsDataClass = [[AppsDataClass alloc] init];
        
        // convert to C data types, then to Objective-C data types
        NSNumber *app_id = [NSNumber numberWithLong:atol(row[0])];
        NSNumber *app_number = [NSNumber numberWithLong:atol(row[1])];
        NSString *bundle_id = [NSString stringWithUTF8String:row[2]];
        NSString *app_version = [NSString stringWithUTF8String:row[3]];
        NSString *apple_id = [NSString stringWithUTF8String:row[4]];
        NSString *sku = [NSString stringWithUTF8String:row[5]];
        NSString *type = [NSString stringWithUTF8String:row[6]];
        NSNumber *pricing_tier = [NSNumber numberWithLong:atol(row[7])];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date_created = [dateFormat dateFromString:[NSString stringWithUTF8String:row[8]]];
        NSDate *date_updated = [dateFormat dateFromString:[NSString stringWithUTF8String:row[9]]];
        
        // init the dataclass elements
        appsDataClass.db_app_id = app_id;
        appsDataClass.db_app_number = app_number;
        appsDataClass.db_bundle_id = bundle_id;
        appsDataClass.db_app_version = app_version;
        appsDataClass.db_apple_id = apple_id;
        appsDataClass.db_sku = sku;
        appsDataClass.db_type = type;
        appsDataClass.db_pricing_tier = pricing_tier;
        appsDataClass.db_dateCreated = date_created;
        appsDataClass.db_lastUpdated = date_updated;
        
        [db_appData insertObject:appsDataClass atIndex:i]; // add a pointer to the appsDataClass to my NSMutableArray
        i++;


        NSLog(@"i=%ld",(long)i);
        @try
        {
            row = mysql_fetch_row(queryResponse);
            
            // instantiate the data class
            appsDataClass = [[AppsDataClass alloc] init];
            
            // convert to C data types, then to Objective-C data types
            NSNumber *app_id = [NSNumber numberWithLong:atol(row[0])];
            NSNumber *app_number = [NSNumber numberWithLong:atol(row[1])];
            NSString *bundle_id = [NSString stringWithUTF8String:row[2]];
            NSString *app_version = [NSString stringWithUTF8String:row[3]];
            NSString *apple_id = [NSString stringWithUTF8String:row[4]];
            NSString *sku = [NSString stringWithUTF8String:row[5]];
            NSString *type = [NSString stringWithUTF8String:row[6]];
            NSNumber *pricing_tier = [NSNumber numberWithLong:atol(row[7])];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date_created = [dateFormat dateFromString:[NSString stringWithUTF8String:row[8]]];
            NSDate *date_updated = [dateFormat dateFromString:[NSString stringWithUTF8String:row[9]]];
            
            // init the dataclass elements
            appsDataClass.db_app_id = app_id;
            appsDataClass.db_app_number = app_number;
            appsDataClass.db_bundle_id = bundle_id;
            appsDataClass.db_app_version = app_version;
            appsDataClass.db_apple_id = apple_id;
            appsDataClass.db_sku = sku;
            appsDataClass.db_type = type;
            appsDataClass.db_pricing_tier = pricing_tier;
            appsDataClass.db_dateCreated = date_created;
            appsDataClass.db_lastUpdated = date_updated;
            
            [db_appData insertObject:appsDataClass atIndex:i]; // add a pointer to the appsDataClass to my NSMutableArray
            i++;
        }
        @catch (NSException *e)
        {
            NSLog(@"***** SQL ERROR ***** %@",e);
            i = numberOfRows;
        }
        @finally
        {
            //NSLog(@"Finally...");
        }

    }
    
    [self closeDatabaseConnection];
    NSLog(@"getAppData executed without trapping");
    return db_appData;
}

-(NSMutableArray *) getIAPData {
    
    db_iapData = [[NSMutableArray alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *databaseName = [defaults objectForKey:@"DatabaseName"];
    
    // connect to database
    if (![self openDatabaseConnection])
    {
        appsDataClass.errorMessage = [NSString stringWithFormat:@"Unable to open database %@", databaseName];
        return nil;
    }
    
    const char *queryString = "select in_app_purchase_id, reference_name, product_id, type, free, create_timestamp, update_timestamp, pricing_tier from rmh_in_app_purchases order by reference_name,in_app_purchase_id";
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row;
    
    if (numberOfRows == 0)
    {
        appsDataClass.errorMessage = [NSString stringWithFormat:@"Query returned no results."];
        [self closeDatabaseConnection];
        return nil;
    }
    NSInteger i = 0;
    
    while ((row = mysql_fetch_row(queryResponse)))
    {
        // instantiate the data class
        iapDataClass = [[IAPDataClass alloc] init];
        
        // convert to C data types, then to Objective-C data types
        NSNumber *purchase_id = [NSNumber numberWithLong:atol(row[0])];
        NSString *reference_name = [NSString stringWithUTF8String:row[1]];
        NSString *product_id = [NSString stringWithUTF8String:row[2]];
        NSString *type = [NSString stringWithUTF8String:row[3]];
        NSString *free = [NSString stringWithUTF8String:row[4]];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date_created = [dateFormat dateFromString:[NSString stringWithUTF8String:row[5]]];
        NSDate *date_updated = [dateFormat dateFromString:[NSString stringWithUTF8String:row[6]]];
        NSNumber *pricing_tier = [NSNumber numberWithLong:atol(row[7])];
        
        // init the dataclass elements
        iapDataClass.db_purchase_id = purchase_id;
        iapDataClass.db_reference_name = reference_name;
        iapDataClass.db_product_id = product_id;
        iapDataClass.db_type = type;
        iapDataClass.db_free = free;
        iapDataClass.db_dateCreated = date_created;
        iapDataClass.db_lastUpdated = date_updated;
        iapDataClass.db_pricing_tier = pricing_tier;
        
        [db_iapData insertObject:iapDataClass atIndex:i]; // add a pointer to the appsDataClass to my NSMutableArray
        i++;
        
    }

    [self closeDatabaseConnection];
    
    return db_iapData;
}


-(NSMutableArray *) getLangData {
    
    db_langData = [[NSMutableArray alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *databaseName = [defaults objectForKey:@"DatabaseName"];
    
    // connect to database
    if (![self openDatabaseConnection])
    {
        appsDataClass.errorMessage = [NSString stringWithFormat:@"Unable to open database %@", databaseName];
        return nil;
    }
    
    const char *queryString = "select language_id, apple_code, google_code, language from rmh_languages order by language";
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row;
    
    if (numberOfRows == 0)
    {
        appsDataClass.errorMessage = [NSString stringWithFormat:@"Query returned no results."];
        [self closeDatabaseConnection];
        return nil;
    }
    NSInteger i = 0;
    
    while ((row = mysql_fetch_row(queryResponse)))
    {
        // instantiate the data class
        LanguageDataClass *languageDataClass = [[LanguageDataClass alloc] init];
        
        // convert to C data types, then to Objective-C data types
        NSNumber *language_id = [NSNumber numberWithLong:atol(row[0])];
        NSString *apple_code = [NSString stringWithUTF8String:row[1]];
        NSString *google_code = [NSString stringWithUTF8String:row[2]];
        NSString *language = [NSString stringWithUTF8String:row[3]];
        
        // init the dataclass elements
        languageDataClass.db_language_id = language_id;
        languageDataClass.db_apple_code = apple_code;
        languageDataClass.db_google_code = google_code;
        languageDataClass.db_language = language;
        [db_langData insertObject:languageDataClass atIndex:i]; // add a pointer to the appsDataClass to my NSMutableArray
        i++;
        
    }
    
    [self closeDatabaseConnection];
    
    return db_langData;
}

-(NSMutableArray *) getDeviceTypes {
    
    db_deviceTypes = [[NSMutableArray alloc] init];
    
    // connect to database
    if (![self openDatabaseConnection])
        return nil;
    
    
    const char *queryString = "select distinct device_model from rmh_app_users order by device_model";
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row;
    
    if (numberOfRows == 0)
    {
        [self closeDatabaseConnection];
        return nil;
    }
    
    NSInteger i = 0;
    
    while ((row = mysql_fetch_row(queryResponse)))
    {
        [db_deviceTypes insertObject:[NSString stringWithUTF8String:row[0]] atIndex:i];
        i++;        
    }
    
    [self closeDatabaseConnection];
    
    return db_deviceTypes;
}


-(NSMutableArray *) getSystemVersions {
    
    db_systemVersions = [[NSMutableArray alloc] init];
    
    // connect to database
    if (![self openDatabaseConnection])
        return nil;
    
    
    const char *queryString = "select distinct system_version from rmh_app_users order by system_version";
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row;
    
    if (numberOfRows == 0)
    {
        [self closeDatabaseConnection];
        return nil;
    }
    
    NSInteger i = 0;
    
    while ((row = mysql_fetch_row(queryResponse)))
    {
        [db_systemVersions insertObject:[NSString stringWithUTF8String:row[0]] atIndex:i];
        i++;
    }
    
    [self closeDatabaseConnection];
    
    return db_systemVersions;
}


-(NSMutableArray *) getSystemTypes {
    
    db_systemTypes = [[NSMutableArray alloc] init];
    
    // connect to database
    if (![self openDatabaseConnection])
        return nil;
    
    
    const char *queryString = "select distinct system_name from rmh_app_users order by system_name";
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row;
    
    if (numberOfRows == 0)
    {
        [self closeDatabaseConnection];
        return nil;
    }
    
    NSInteger i = 0;
    
    while ((row = mysql_fetch_row(queryResponse)))
    {
        [db_systemTypes insertObject:[NSString stringWithUTF8String:row[0]] atIndex:i];
        i++;
    }
    
    [self closeDatabaseConnection];
    
    return db_systemTypes;
}


-(NSMutableArray *) getPreferredLanguages {
    
    db_preferredLanguages = [[NSMutableArray alloc] init];
    
    // connect to database
    if (![self openDatabaseConnection])
        return nil;
    
    
    const char *queryString = "select distinct language from rmh_languages inner join rmh_app_users on rmh_languages.apple_code=rmh_app_users.preferred_language order by language";
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row;
    
    if (numberOfRows == 0)
    {
        [self closeDatabaseConnection];
        return nil;
    }
    
    NSInteger i = 0;
    
    while ((row = mysql_fetch_row(queryResponse)))
    {
        [db_preferredLanguages insertObject:[NSString stringWithUTF8String:row[0]] atIndex:i];
        i++;
    }
    
    [self closeDatabaseConnection];
    
    return db_preferredLanguages;
}


-(NSMutableArray *) getAppNames {
    
    db_appNames = [[NSMutableArray alloc] init];
    
    // connect to database
    if (![self openDatabaseConnection])
        return nil;
    
    
    const char *queryString = "select distinct app_name from rmh_app_names order by app_name";
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row;
    
    if (numberOfRows == 0)
    {
        [self closeDatabaseConnection];
        return nil;
    }
    
    NSInteger i = 0;
    
    while ((row = mysql_fetch_row(queryResponse)))
    {
        [db_appNames insertObject:[NSString stringWithUTF8String:row[0]] atIndex:i];
        i++;
    }
    
    [self closeDatabaseConnection];
    
    return db_appNames;
}

-(NSString *) getAppleLanguageCode : (NSString *)language{
    
    // connect to database
    if (![self openDatabaseConnection])
        return nil;
    
    NSString *nsQueryString = [NSString stringWithFormat:@"select apple_code from rmh_languages where language ='%@'", language];
    const char *queryString = [nsQueryString cStringUsingEncoding:NSASCIIStringEncoding];
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row = NULL;
    
    if (numberOfRows == 0)
    {
        [self closeDatabaseConnection];
        return nil;
    }
    
    row = mysql_fetch_row(queryResponse);
    [self closeDatabaseConnection];
    
    NSString *appleCode = [NSString stringWithFormat:@"%s",row[0]];
    
    return appleCode;
}

-(NSMutableArray *) getAppleCodes
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    // connect to database
    if (![self openDatabaseConnection])
        return nil;
    
    
    const char *queryString = "select language, google_code, apple_code from rmh_languages order by language";
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row;
    
    if (numberOfRows == 0)
    {
        [self closeDatabaseConnection];
        return nil;
    }
    
    NSInteger i = 0;
    
    while ((row = mysql_fetch_row(queryResponse)))
    {
        [results insertObject:[NSString stringWithUTF8String:row[2]] atIndex:i];
        i++;
    }
    
    [self closeDatabaseConnection];
    
    return results;
}

-(NSMutableArray *) getGoogleCodes
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    // connect to database
    if (![self openDatabaseConnection])
        return nil;
    
    
    const char *queryString = "select language, google_code, apple_code from rmh_languages order by language";
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row;
    
    if (numberOfRows == 0)
    {
        [self closeDatabaseConnection];
        return nil;
    }
    
    NSInteger i = 0;
    
    while ((row = mysql_fetch_row(queryResponse)))
    {
        [results insertObject:[NSString stringWithUTF8String:row[1]] atIndex:i];
        i++;
    }
    
    [self closeDatabaseConnection];
    
    return results;
    
}

-(NSMutableArray *) getLanguageList
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    // connect to database
    if (![self openDatabaseConnection])
        return nil;
    
    
    const char *queryString = "select language, google_code, apple_code from rmh_languages order by language";
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row;
    
    if (numberOfRows == 0)
    {
        [self closeDatabaseConnection];
        return nil;
    }
    
    NSInteger i = 0;
    
    while ((row = mysql_fetch_row(queryResponse)))
    {
        [results insertObject:[NSString stringWithUTF8String:row[0]] atIndex:i];
        i++;
    }
    
    [self closeDatabaseConnection];
    
    return results;
}

-(NSNumber *) getAppNumber : (NSString *)appName{
    
    
    NSString *nsQueryString = [NSString stringWithFormat:@"select app_number from rmh_app_names where app_name ='%@'", appName];
    const char *queryString = [nsQueryString cStringUsingEncoding:NSASCIIStringEncoding];
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row = NULL;
    
    if (numberOfRows == 0)
    {
        return nil;
    }
    
    row = mysql_fetch_row(queryResponse);

    NSNumber *appNumber = (NSNumber*)[NSString stringWithFormat:@"%s",row[0]];

    return appNumber;
}

-(NSString *) getAppName : (NSString *)appNumber
{
    // connect to database
    //if (![self openDatabaseConnection])
    //    return nil;
    
    NSString *nsQueryString = [NSString stringWithFormat:@"select app_name from rmh_app_names where app_number ='%@'", appNumber];
    const char *queryString = [nsQueryString cStringUsingEncoding:NSASCIIStringEncoding];
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row = NULL;
    
    if (numberOfRows == 0)
    {
        //[self closeDatabaseConnection];
        return @"no value";
    }
    
    row = mysql_fetch_row(queryResponse);
    //[self closeDatabaseConnection];
    
    NSString *appName = [NSString stringWithFormat:@"%s",row[0]];
    
    return appName;
}

-(NSString *) getLanguageCode: (NSString *)language{
    // connect to database
    //if (![self openDatabaseConnection])
        return nil;
    
    NSString *nsQueryString = [NSString stringWithFormat:@"select apple_code from rmh_languages where language ='%@'", language];
    const char *queryString = [nsQueryString cStringUsingEncoding:NSASCIIStringEncoding];
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row = NULL;
    
    if (numberOfRows == 0)
    {
        [self closeDatabaseConnection];
        return nil;
    }
    
    row = mysql_fetch_row(queryResponse);
    //[self closeDatabaseConnection];
    
    NSString *languageCode = [NSString stringWithFormat:@"%s",row[0]];
    
    return languageCode;
}

-(int) createMessageQueueEntries :(DefineRecipientsWindowController *)ownerWindow :(NSString *)sqlString :(NSString *)msgNumber :(NSString *)msgType :(NSString *)prod_dev_ind
{
    
    // connect to database
    if (![self openDatabaseConnection])
        return -1;
    
    const char *queryString = [sqlString cStringUsingEncoding:NSUTF8StringEncoding];
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row;
    
    if (numberOfRows == 0)
    {
        [self closeDatabaseConnection];
        return -2;
    }
    int i = 0;
    
    while ((row = mysql_fetch_row(queryResponse)))
    {
        //select user_id, user_name, device_model, system_version, system_name, device_token, preferred_language, app_number, create_timestamp, update_timestamp from rmh_app_users where
        
        NSString *userid = [NSString stringWithUTF8String:row[0]];
        NSString *appNumber = [NSString stringWithFormat:@"%s",row[7]];
        
        NSString *sqlInsertString = [NSString stringWithFormat:@"insert into rmh_app_push_message_queue (queue_process_status, message_number, message_type, user_status, user_id, app_number, prod_dev, create_timestamp) VALUES ('Not Processed', %@, '%@', 'Not Processed', %@, %@, '%@', now())", msgNumber, msgType, userid, appNumber, prod_dev_ind];
        const char *queryString5 = [sqlInsertString cStringUsingEncoding:NSUTF8StringEncoding];
        if (mysql_query(mySqlObj, queryString5))
        {
            NSLog(@"SQL Insert Error: %@", sqlInsertString);
            [self closeDatabaseConnection];
            return -3;
        }
        i++;
        [ownerWindow.errorMessageProperties setStringValue:[NSString stringWithFormat:@"Processed record %d out of %lu.", i, numberOfRows]];
    }
    
    [self closeDatabaseConnection];
    
    return 0;
}

-(NSMutableArray *) confirmRecipients :(DefineRecipientsWindowController *)ownerWindow :(NSString *)sqlString :(NSString *)msgNumber :(NSString *)msgType :(NSString *)prod_dev_ind
{
    NSMutableArray *recipientList = [[NSMutableArray alloc] init];
    // connect to database
    if (![self openDatabaseConnection])
        return nil;
    
    const char *queryString = [sqlString cStringUsingEncoding:NSUTF8StringEncoding];
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row;
    
    if (numberOfRows == 0)
    {
        [self closeDatabaseConnection];
        return nil;
    }
    int i = 0;
    
    while ((row = mysql_fetch_row(queryResponse)))
    {
        //select user_id, user_name, device_model, system_version, system_name, device_token, preferred_language, app_number, create_timestamp, update_timestamp from rmh_app_users where
        
        NSString *userName = [NSString stringWithUTF8String:row[1]];
        NSString *deviceModel = [NSString stringWithUTF8String:row[2]];
        NSString *appNumber = [NSString stringWithFormat:@"%s",row[7]];
        NSString *appName = [self getAppName: appNumber];
        
        RecipientDataClass *recipientsDataClass = [[RecipientDataClass alloc] init];
        recipientsDataClass.db_app_name = appName;
        recipientsDataClass.db_device_model = deviceModel;
        recipientsDataClass.db_prod_dev_ind = prod_dev_ind;
        recipientsDataClass.db_user_name = userName;
        
        [recipientList insertObject:recipientsDataClass atIndex:i]; // add a pointer to the appsDataClass to my NSMutableArray

        i++;
        [ownerWindow.errorMessageProperties setStringValue:[NSString stringWithFormat:@"Processed record %d out of %lu.", i, numberOfRows]];
    }
    
    [self closeDatabaseConnection];
    
    return recipientList;
}



- (int) addIAPData:(IAPDataClass *) iapDataClassParm
{
    IAPDataClass *_iapDataClass = [[IAPDataClass alloc] init];
    _iapDataClass = iapDataClassParm;
    
    // connect to database
    if (![self openDatabaseConnection])
        return -1;
    
    const char *queryString = "select max(in_app_purchase_id) from rmh_in_app_purchases";
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row;
    NSNumber *purchase_id;
    NSString *reference_name = _iapDataClass.db_reference_name;
    NSString *product_id = _iapDataClass.db_product_id;
    NSString *type = _iapDataClass.db_type;
    NSString *free = _iapDataClass.db_free;
    NSNumber *pricing_tier = _iapDataClass.db_pricing_tier;
    NSDate *current_timestamp = _iapDataClass.db_dateCreated;

    NSString *nsQueryString;

    if (numberOfRows == 0)
        purchase_id = 0;
    else
    {
        row = mysql_fetch_row(queryResponse);
        purchase_id = [NSNumber numberWithLong:atol(row[0])];  // increment appNumber
        int i = [purchase_id intValue];
        i++;
        purchase_id = [NSNumber numberWithInt:i];  // increment appID
    }
    
    nsQueryString = [NSString stringWithFormat:@"INSERT INTO rmh_in_app_purchases (in_app_purchase_id, reference_name, product_id, type, pricing_tier, free, create_timestamp) VALUES (%@,\"%@\",%@,\"%@\",\"%@\",\"%@\", \"%@\")", purchase_id, reference_name, product_id, type, pricing_tier, free, current_timestamp];
    const char *queryString5 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
    if (mysql_query(mySqlObj, queryString5))
    {
        [self closeDatabaseConnection];
        return -2;
    }
    
    [self closeDatabaseConnection];
    
    return 0;
    
}

- (int) delIAPData:(IAPDataClass *) iapDataClassParm
{
    IAPDataClass *_iapDataClass = [[IAPDataClass alloc] init];
    _iapDataClass = iapDataClassParm;
    
    // connect to database
    if (![self openDatabaseConnection])
        return -1;
    
    NSNumber *purchase_id = iapDataClass.db_purchase_id;
    NSString *nsQueryString;
    
   nsQueryString = [NSString stringWithFormat:@"delete from rmh_in_app_purchases where in_app_purchase_id = %@", purchase_id];
    const char *queryString4 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
    if (mysql_query(mySqlObj, queryString4))
    {
        [self closeDatabaseConnection];
        return -2;
    }

    
    [self closeDatabaseConnection];
    
    return 0;
    
}

- (int) updIAPData:(IAPDataClass *) iapDataClassParm
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    IAPDataClass *_iapDataClass = [[IAPDataClass alloc] init];
    _iapDataClass = iapDataClassParm;
    
    // connect to database
    if (![self openDatabaseConnection])
        return -1;
    

    NSString *nsQueryString;
    
    nsQueryString = [NSString stringWithFormat:@"UPDATE rmh_in_app_purchases SET reference_name = \"%@\", product_id = \"%@\", type = \"%@\", pricing_tier = %@, free = \"%@\", create_timestamp = \"%@\" where in_app_purchase_id = \"%@\"", _iapDataClass.db_reference_name, _iapDataClass.db_product_id, _iapDataClass.db_type, _iapDataClass.db_pricing_tier, _iapDataClass.db_free, [dateFormat stringFromDate:_iapDataClass.db_dateCreated], _iapDataClass.db_purchase_id];
    const char *queryString2 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", nsQueryString);
    if (mysql_query(mySqlObj, queryString2))
    {
        [self closeDatabaseConnection];
        return -3;
    }
    
    [self closeDatabaseConnection];
    
    return 0;
    
}

-(int) addLangData:(LanguageDataClass *) languageDataClassParm
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    LanguageDataClass *_languageDataClass = [[LanguageDataClass alloc] init];
    _languageDataClass = languageDataClassParm;
    
    // connect to database
    if (![self openDatabaseConnection])
        return -1;
    
    
    NSString *nsQueryString;
    
    nsQueryString = [NSString stringWithFormat:@"INSERT INTO rmh_languages (apple_code, google_code, language, update_timestamp) VALUES (\"%@\", \"%@\", \"%@\", now())", _languageDataClass.db_apple_code, _languageDataClass.db_google_code, _languageDataClass.db_language];
    const char *queryString2 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", nsQueryString);
    if (mysql_query(mySqlObj, queryString2))
    {
        [self closeDatabaseConnection];
        return -3;
    }
    
    [self closeDatabaseConnection];
    
    return 0;
    
}


-(int) delLangData:(LanguageDataClass *) languageDataClassParm
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    LanguageDataClass *_languageDataClass = [[LanguageDataClass alloc] init];
    _languageDataClass = languageDataClassParm;
    
    // connect to database
    if (![self openDatabaseConnection])
        return -1;
    
    
    NSString *nsQueryString;
    
    nsQueryString = [NSString stringWithFormat:@"DELETE FROM rmh_languages WHERE language_id = %@", _languageDataClass.db_language_id];
    const char *queryString2 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", nsQueryString);
    if (mysql_query(mySqlObj, queryString2))
    {
        [self closeDatabaseConnection];
        return -3;
    }
    
    [self closeDatabaseConnection];
    
    return 0;
}

-(int) updLangData:(LanguageDataClass *) languageDataClassParm
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    LanguageDataClass *_languageDataClass = [[LanguageDataClass alloc] init];
    _languageDataClass = languageDataClassParm;
    
    // connect to database
    if (![self openDatabaseConnection])
        return -1;
    
    
    NSString *nsQueryString;
    
    nsQueryString = [NSString stringWithFormat:@"UPDATE rmh_languages SET apple_code=\"%@\", google_code=\"%@\", language=\"%@\" WHERE language_id=%@", _languageDataClass.db_apple_code, _languageDataClass.db_google_code, _languageDataClass.db_language, _languageDataClass.db_language_id];
    const char *queryString2 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", nsQueryString);
    if (mysql_query(mySqlObj, queryString2))
    {
        [self closeDatabaseConnection];
        return -3;
    }
    
    [self closeDatabaseConnection];
    
    return 0;
}

- (int) addAppData:(AppsDataClass *) appsDataClassParm
{
    AppsDataClass *_appsDataClass = [[AppsDataClass alloc] init];
    _appsDataClass = appsDataClassParm;
    
    // connect to database
    if (![self openDatabaseConnection])
        return -1;
    
    const char *queryString = "select max(app_id) from rmh_app";
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row;
    NSNumber *app_id;
    NSNumber *app_number;
    NSString *app_name = _appsDataClass.db_app_name;
    NSString *nsQueryString;
    
    if (numberOfRows == 0)
        app_id = 0;
    else
    {
        row = mysql_fetch_row(queryResponse);
        app_id = [NSNumber numberWithLong:atol(row[0])];  // increment appNumber
        int i = [app_id intValue];
        i++;
        app_id = [NSNumber numberWithInt:i];  // increment appID
    }

    nsQueryString = [NSString stringWithFormat:@"select app_number from rmh_app_names where app_name = \"%@\"", app_name];
    const char *queryString2 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
    
    mysql_query(mySqlObj, queryString2);
    queryResponse = mysql_store_result(mySqlObj);
    numberOfRows = mysql_num_rows(queryResponse);
    
    if (numberOfRows == 0)
    {
        const char *queryString3 = "select max(app_number) from rmh_app_names";
        
        mysql_query(mySqlObj, queryString3);
        queryResponse = mysql_store_result(mySqlObj);
        numberOfRows = mysql_num_rows(queryResponse);
        row = mysql_fetch_row(queryResponse);
        app_number = [NSNumber numberWithLong:atol(row[0])];  // increment appNumber
        if (app_number == nil) // first app with this name, so increment app number
            app_number = 0;
        else
        {
            int i = [app_number intValue];
            i++;
            app_number = [NSNumber numberWithInt:i];  // increment appID
        }
        
        nsQueryString = [NSString stringWithFormat:@"INSERT INTO rmh_app_names (app_number, app_name, created_date) VALUES (%@, \"%@\", now())", app_number, app_name];
        const char *queryString4 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
        if (mysql_query(mySqlObj, queryString4))
        {
            [self closeDatabaseConnection];
            return -2;
        }
    }
    else
    {
        row = mysql_fetch_row(queryResponse);
        app_number = [NSNumber numberWithLong:atol(row[0])];  // increment appNumber
    }

    nsQueryString = [NSString stringWithFormat:@"INSERT INTO rmh_app (app_id, app_number, bundle_id, app_version, apple_id, sku, type, pricing_tier, create_timestamp) VALUES (%@,%@,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",%@, now())", app_id, app_number, _appsDataClass.db_bundle_id, _appsDataClass.db_app_version, _appsDataClass.db_apple_id, _appsDataClass.db_sku, _appsDataClass.db_type, _appsDataClass.db_pricing_tier];
    const char *queryString5 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
    if (mysql_query(mySqlObj, queryString5))
    {
        [self closeDatabaseConnection];
        return -3;
    }
    
    nsQueryString = [NSString stringWithFormat:@"INSERT INTO rmh_app_pricing_tier_relationship (app_id, alt_pricing_start_date, alt_pricing_tier, create_timestamp) VALUES (%@,now(), %@, now())", app_id, _appsDataClass.db_pricing_tier];
    const char *queryString6 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
    if (mysql_query(mySqlObj, queryString6))
    {
        [self closeDatabaseConnection];
        return -4;
    }
    
    [self closeDatabaseConnection];
    
    return 0;
    
}

- (int) delAppData:(AppsDataClass *) appsDataClassParm
{
    AppsDataClass *_appsDataClass = [[AppsDataClass alloc] init];
    _appsDataClass = appsDataClassParm;
    
    // connect to database
    if (![self openDatabaseConnection])
        return -1;
    
    MYSQL_RES *queryResponse;
    unsigned long numberOfRows;
    MYSQL_ROW row;
    NSNumber *app_id = _appsDataClass.db_app_id;
    NSNumber *app_number = _appsDataClass.db_app_number;
    NSString *nsQueryString;
    
    nsQueryString = [NSString stringWithFormat:@"select count(*) from rmh_app where app_number = \"%@\"", app_number];
    const char *queryString2 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
    
    mysql_query(mySqlObj, queryString2);
    queryResponse = mysql_store_result(mySqlObj);
    numberOfRows = mysql_num_rows(queryResponse);
    
    row = mysql_fetch_row(queryResponse);
    
    long numRecs = atol(row[0]);
    if (numRecs == 1)  // then remove the rmh_app_names record as well
    {
        nsQueryString = [NSString stringWithFormat:@"delete from rmh_app_names where app_number = %@", app_number];
        const char *queryString3 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
        if (mysql_query(mySqlObj, queryString3))
        {
            [self closeDatabaseConnection];
            return -2;
        }
    }
    
    nsQueryString = [NSString stringWithFormat:@"delete from rmh_app where app_id = %@", app_id];
    const char *queryString4 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
    if (mysql_query(mySqlObj, queryString4))
    {
        [self closeDatabaseConnection];
        return -3;
    }
    
    
    nsQueryString = [NSString stringWithFormat:@"delete from rmh_app_pricing_tier_relationship where app_id = %@", app_id];
    const char *queryString5 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
    if (mysql_query(mySqlObj, queryString5))
    {
        [self closeDatabaseConnection];
        return -4;
    }
    
    [self closeDatabaseConnection];
    
    return 0;
    
}

- (int) updAppData:(AppsDataClass *) appsDataClassParm
{
    AppsDataClass *_appsDataClass = [[AppsDataClass alloc] init];
    _appsDataClass = appsDataClassParm;

    
    // connect to database
    if (![self openDatabaseConnection])
        return -1;
    
    NSNumber *app_id = _appsDataClass.db_app_id;
    _appsDataClass.db_app_number = [self getAppNumber:_appsDataClass.db_app_name];
    NSNumber *app_number = _appsDataClass.db_app_number;
    NSString *nsQueryString;
    
    nsQueryString = [NSString stringWithFormat:@"UPDATE rmh_app SET bundle_id = \"%@\", app_version = \"%@\", apple_id = \"%@\", sku = \"%@\", type = \"%@\", pricing_tier = %@ where app_id = %@", _appsDataClass.db_bundle_id, _appsDataClass.db_app_version, _appsDataClass.db_apple_id, _appsDataClass.db_sku, _appsDataClass.db_type, _appsDataClass.db_pricing_tier, app_id];
    
    NSLog(@"%@", nsQueryString);
    
    const char *queryString2 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
    
    if (mysql_query(mySqlObj, queryString2))
    {
        NSLog(@"updAppData rc=-2");
        [self closeDatabaseConnection];
        return -2;
    }
    
    nsQueryString = [NSString stringWithFormat:@"UPDATE rmh_app_names SET app_name = \"%@\" where app_number = %@", _appsDataClass.db_app_name, app_number];
    const char *queryString3 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", nsQueryString);
    
    if (mysql_query(mySqlObj, queryString3))
    {
        NSLog(@"updAppData rc=-3");
        [self closeDatabaseConnection];
        return -3;
    }

    nsQueryString = [NSString stringWithFormat:@"UPDATE rmh_app_pricing_tier_relationship SET alt_pricing_end_date = now() where app_id = %@", app_id];
    const char *queryString4 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", nsQueryString);
    
    if (mysql_query(mySqlObj, queryString4))
    {
        NSLog(@"updAppData rc=-4");
        [self closeDatabaseConnection];
        return -4;
    }
    nsQueryString = [NSString stringWithFormat:@"INSERT INTO rmh_app_pricing_tier_relationship (app_id, alt_pricing_start_date, alt_pricing_tier, create_timestamp) VALUES (\"%@\",now(),\"%@\", now())", app_id, _appsDataClass.db_pricing_tier];
    const char *queryString6 = [nsQueryString cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", nsQueryString);
    
    if (mysql_query(mySqlObj, queryString6))
    {
        NSLog(@"updAppData rc=-5");
        [self closeDatabaseConnection];
        return -5;
    }
    
    [self closeDatabaseConnection];
    NSLog(@"updAppData rc=0");
    return 0;
    
}

- (int) getNextMsgNumber
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *databaseName = [defaults objectForKey:@"DatabaseName"];
    
    // connect to database
    if (![self openDatabaseConnection])
    {
        appsDataClass.errorMessage = [NSString stringWithFormat:@"Unable to open database %@", databaseName];
        return -1;
    }
    
    const char *queryString = "select MAX(message_number) from rmh_app_push_messages";
    
    mysql_query(mySqlObj, queryString);
    MYSQL_RES *queryResponse = mysql_store_result(mySqlObj);
    unsigned long numberOfRows = mysql_num_rows(queryResponse);
    MYSQL_ROW row;
    
    if (numberOfRows == 0)
    {
        appsDataClass.errorMessage = [NSString stringWithFormat:@"Query returned no results."];
        [self closeDatabaseConnection];
        return -1;
    }
    int i = 0;

    row = mysql_fetch_row(queryResponse);
    if (*row == (const char*)NULL)
        i=0;  // meaning there is no message number in the db
    else{
        NSNumber *messageNumber = [NSNumber numberWithLong:atol(row[0])];
        i = (int)[messageNumber integerValue];
    }
    i++; // increment by 1

    [self closeDatabaseConnection];
   
    return i;
}

-(int) storeMessage: (NSString *)messageNumber : (NSString *)msgTitle : (NSString *)msgBody : (NSString *)language : (NSString *)newMessageRecieved : (NSString *)urlText : (NSString *)startDate : (NSString *)endDate
{
    
    if (![self openDatabaseConnection])
        return -1;
    
    NSString *queryString = [NSString stringWithFormat:@"INSERT INTO rmh_app_push_messages (message_number, language, message_title, message_body, message_type, view_url, badge, start_date, stop_date, create_timestamp) VALUES (%@,\"%@\",\"%@\",\"%@\", \"%@\", \"%@\", 1,\"%@\",\"%@\", now())", messageNumber, language, msgTitle, newMessageRecieved, @"PUSH", @"", startDate, endDate];
    NSLog(@"NSString version: %@",queryString);
    
    char *queryString2 = (char *)[queryString UTF8String];
    
    if (mysql_query(mySqlObj, queryString2))
    {
        [self closeDatabaseConnection];
        return -1;
    }
    
    queryString = [NSString stringWithFormat:@"INSERT INTO rmh_app_push_messages (message_number, language, message_title, message_body, message_type, view_url, badge, start_date, stop_date, create_timestamp) VALUES (%@,\"%@\",\"%@\",\"%@\", \"%@\", \"%@\", 1,\"%@\",\"%@\", now())", messageNumber, language, msgTitle, msgBody, @"RMH", urlText, startDate, endDate];
    NSLog(@"NSString version: %@",queryString);
    
    queryString2 = (char *)[queryString UTF8String];
    
    if (mysql_query(mySqlObj, queryString2))
    {
        [self closeDatabaseConnection];
        return -1;
    }

    [self closeDatabaseConnection];
    return 0;
}
@end
