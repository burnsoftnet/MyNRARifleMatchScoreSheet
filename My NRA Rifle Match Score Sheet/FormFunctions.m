//
//  FormFunctions.m
//  MyEssentialOilRemedies
//
//  Created by burnsoft on 8/23/16.
//  Copyright © 2016 burnsoft. All rights reserved.
//

#import "FormFunctions.h"

@implementation FormFunctions

#pragma mark Set Highlite color
/*! @brief  Set the color of the highlight that you want to use
 */
+(UIColor *) setHighlightColor
{
    return [UIColor greenColor];
}
#pragma mark Set Text Color
/*! @brief  Set the color of what you want the text to be
 */
+(UIColor *) setTextColor
{
    return [UIColor whiteColor];
}

/*!
 @brief Set the color of the edit button
 */
+(UIColor *) setEditColor
{
    return [UIColor systemBlueColor];
}
/*!
@brief Set the color of the delete button
*/
+(UIColor *) setDeleteColor
{
    return [UIColor systemRedColor];
}
/*!
@brief Set the color of the Cart button
*/
+(UIColor *) setCartColor
{
    return [UIColor systemGrayColor];
}

#pragma mark Textbox View Layouts
/*!
 @brief: Creates a border around a Textview
 */
+(void) setBordersTextView :(UITextView *) myObj
{
    [[myObj layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[myObj layer] setBorderWidth:2.3];
    [[myObj layer] setCornerRadius:2];
}

#pragma mark Textbox Layout
/*!
 @brief: Creates a border around a regular text box
 */
+(void) setBorderTextBox :(UITextField *) myObj
{
    [[myObj layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[myObj layer] setBorderWidth:2.3];
    [[myObj layer] setCornerRadius:2];
}

#pragma mark Label Borders
/*!
 @brief:Creates a border around the label
 */
+(void) setBorderLabel :(UILabel *) myObj
{
    [[myObj layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[myObj layer] setBorderWidth:2.3];
    [[myObj layer] setCornerRadius:2];
}
#pragma mark Button Border
/*!
 @brief:Breates a border around the label
 */
+(void) setBorderButton :(UIButton *) myObj
{
    [[myObj layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[myObj layer] setBorderWidth:2.3];
    [[myObj layer] setCornerRadius:10];
    myObj.clipsToBounds = YES;
    //[[myObj layer] setStyle:UIButtonTypeRoundedRect];
}

#pragma mark Common Alert/Message Handling
/*!
 @brief:Send a Message box from the View controller that you are currently on. It's easier then copying this function all over the place
 */
-(void)sendMessage:(NSString *) msg MyTitle:(NSString *) mytitle ViewController:(UIViewController *) MyViewController
{
    //Send MessageBox Alert message to screen
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:mytitle message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * Action) {}];
    [alert addAction:defaultAction];
    [MyViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark Common Alert/Message Handling
/*!
 @brief:Send a Message box from the View controller that you are currently on. It's easier then copying this function all over the place
 */
+(void)sendMessage:(NSString *) msg MyTitle:(NSString *) mytitle ViewController:(UIViewController *) MyViewController;
{
    FormFunctions *myObj = [FormFunctions new];
    [myObj sendMessage:msg MyTitle:mytitle ViewController:MyViewController];
}

#pragma mark Alert on Limit
/*!
 @brief:Alert on limit reached and give the option to buy the full verion from the app sotre.
 */
+(void) AlertonLimitForViewController:(UIViewController *) MyVewController
{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Limit Reached!"
                                                                  message:@"You Have reached your limit on the Lite Version!\n Please Purchase the Regular Version for Unlimited access!"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Purchase"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    NSURL *AppStore = [NSURL URLWithString:@"https://itunes.apple.com/us/app/my-nra-rifle-match-score-sheet/id1241521195?ls=1&mt=8"];
                                    UIApplication *application = [UIApplication sharedApplication];
                                    [application openURL:AppStore options:@{} completionHandler:nil];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No Thanks"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                                   // call method whatever u need
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [MyVewController presentViewController:alert animated:YES completion:nil];
}


#pragma mark Check For Error in Message via MessageBog
/*!
 @brief:This will check the message to see if something is in it, if not it will not alert via MessageBox
 */
-(void)checkForError :(NSString *) errorMsg MyTitle:(NSString *) errTitle ViewController:(UIViewController *) MyViewController
{
    if (![errorMsg  isEqual: @""])
    {
        [self doBuggermeMessage:errorMsg FromSubFunction:[NSString stringWithFormat:@"CheckForError.%@",errTitle]];

        NSString *mytitle = [NSString stringWithFormat:@"%@ Error",errTitle];
        [self sendMessage:errorMsg MyTitle:mytitle ViewController:MyViewController];
        
    }
}

#pragma mark Check For Error in Message via MessageBox Method
/*!
 @brief:This will check the message to see if something is in it, if not it will not alert via MessageBox
 */
+(void)checkForError :(NSString *) errorMsg MyTitle:(NSString *) errTitle ViewController:(UIViewController *) MyViewController
{
    FormFunctions *myObj = [FormFunctions new];
    [myObj checkForError:errorMsg MyTitle:errTitle ViewController:MyViewController];
    myObj = nil;
}

#pragma mark Check for Error in Message via NSLOG
/*!
 @brief: This will check the message to see if something is in it, if not it will not alert via NSLog
 */
-(void)checkForErrorLogOnly :(NSString *) errorMsg MyTitle:(NSString *) errTitle
{
    if (![errorMsg  isEqual: @""])
    {
        [self doBuggermeMessage:errorMsg FromSubFunction:[NSString stringWithFormat:@"CheckForError.%@",errTitle]];
        NSLog(@"%@",errorMsg);
    }

}

#pragma mark NSLog Debug Message
/*!
 @brief: Mostly used for runtime debugging by sending message of information back to the output window.
        Only when the Global Var BUGGERME is true will it write out message
 */
-(void)doBuggermeMessage :(NSString *) msg FromSubFunction:(NSString *) fromlocation
{
    if (BUGGERME) {
        NSLog(@"DEBUG MESSAGE: %@ - %@",fromlocation,msg);
    }
}

#pragma mark NSLog Debug Message
/*!
 @brief:Mostly used for runtime debugging by sending message of information back to the output window.
        Only when the Global Var BUGGERME is true will it write out message
 */
+(void)doBuggermeMessage :(NSString *) msg FromSubFunction:(NSString *) fromlocation
{
    if (BUGGERME) {
            NSLog(@"DEBUG MESSAGE: %@ - %@",fromlocation,msg);
    }

}
#pragma mark Log Exception Error from Location
/*!
 @brief  General Method on catching and displaying errors
 @param location - the location of the function that it came from
 @param ex - the exception that occured
 */
+(void)LogExceptionErrorfromLocation:(NSString *) location ErrorMessage:(NSException *) ex
{
    NSLog(@"Exception Error from %@  - %@", location, [ex reason]);
}
@end
