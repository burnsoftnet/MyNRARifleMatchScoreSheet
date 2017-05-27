//
//  BurnSoftGeneral.h
//  BurnSoftGeneral
//
//  Created by burnsoft on 1/31/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BurnSoftGeneral : NSObject

#pragma mark Fluff Content String
//This will Fluff/Prep the string for inserting value into a database
//It will mostly take out things that can conflict, such as the single qoute
+(NSString *) FCString:(NSString *) sValue;
#pragma mark Fluff Content String to Long
//This will convert a string into a long value
+(unsigned long) FCLong:(NSString *) sValue;
#pragma mark Get Value from Long String
//This will get the value that is store in a long string
//Pass the string, the common seperater, and the ares it should be located at
//EXAMPE:
//sValue = @"brown,cow,how,two"
//mySeperator = @","
//myIndex = 2
//Result = @"how"
+(NSString *)getValueFromLongString:(NSString *)sValue :(NSString *)mySeparater :(NSInteger) myIndex;
#pragma mark Count Characters
//This will return the number of characters in a string
+(unsigned long) CountCharacters:(NSString *) sValue;
#pragma mark Is Numeric
//This will return true if the value is a number, false if it isn't
+(BOOL) isNumeric :(NSString *) sValue;
#pragma mark Format Date
//Format date to mm/dd/yyyy
+(NSString *)formatDate:(NSDate *)date;
#pragma mark Format Date and Time Long By Provided DateTime
// Pass a Date and Time Stampe and have it returned in a connected format
+(NSString *)formatLongConnectedByDateAndTIme:(NSDate *)mydate;
#pragma mark Format Date and Time Long By Current DateTime
// Get the Current Date and Time Stampe and have it returned in a connected format
+(NSString *)formatLongConnectedDateTimeStamp;
#pragma mark CopyFile
// Simplify the copy and replace method with overwriteoption
+(BOOL) copyFileFromFilePath:(NSString *) fromPath ToNewPath:(NSString *) toPath ErrorMessage:(NSString **) msg;
#pragma mark Delete File byPath
// Pass the path and file to delete that file
+(BOOL)DeleteFileByPath:(NSString *) sPath ErrorMessage:(NSString **) msg;
#pragma mark Load Files in Path by Extension
//Load all the files in the target path that have a certain type of extension
+(NSArray *) getCertainFilefromPath:(NSString *) sPath ByExtension:(NSString *) myExt;
#pragma mark Load Files in Local Directory by Extension
// Load all the files in the Local docuemtns directory by a certain extention
+(NSArray *) getCertainFilesFromDocumentsByExtension:(NSString *) myExt;
#pragma mark Return Full Path of App Documents with file name
//Return Full Path of App Documents with file name attached
+(NSString *) returnFullPathwithFileName:(NSString *) myFile;
#pragma mark CopyFile 2
// Simplify the copy and replace method with overwriteoption
+(BOOL) copyFileFrom:(NSString *) sFrom To:(NSString *) sTo ErrorMessage:(NSString **) errorMessage;
#pragma mark Create a Directory
//Create a directory if it doesn't already exist
+(BOOL)createDirectoryIfNotExists:(NSString *) sPath ErrorMessage:(NSString **) errMsg;
#pragma mark Convert Bool to String
//Convert a boolean value to string Yes or No
+(NSString *) convertBOOLtoString:(BOOL) bValue;
#pragma mark Get File Exteension From File Path
// Get the extension of the file from the full path
+(NSString *) getFileExtensionbyPath:(NSString *) filePath;
@end
