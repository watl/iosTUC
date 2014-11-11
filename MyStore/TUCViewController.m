//
//  TUCViewController.m
//  MyStore
//
//  Created by Walter on 2/19/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "TUCViewController.h"

@interface TUCViewController ()
@property (readonly) NSString *res;
@property  (readonly) NSString *tuc;

@end

@implementation TUCViewController

@synthesize txtTUC;
@synthesize btnSEND;
@synthesize txtVar;
@synthesize txtName;
@synthesize device;

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 /*
  
*/
  
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //txtTUC.text=txtName;
    if (self.device) {
            [self.txtTUC setText:[self.device valueForKey:@"version"]];
       }
    
    
    NSString *url = @"http://www.mpeso.net/datos/captcha.php?";
    NSString *deviceRef =@"";
    
    NSString *post = [NSString stringWithFormat:@"device_ref=",deviceRef];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    NSLog(@"Resultado %@",results);
    
    _res =[results objectForKey:@"captcha"];
    NSLog(@"CAPTCHA %@",_res);
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)Send:(id)sender {
    NSString *post = [NSString stringWithFormat:@"_funcion=%@&_captcha=%@& _terminal=%@&_codigo=%@",txtVar.text,_res,txtTUC.text,_res];
    
    NSLog(@"%@",post);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://mpeso.net/datos/consulta.php"]]];
    [request setHTTPMethod:@"POST"];
    NSString *json = @"{}";
    NSMutableData *body = [[NSMutableData alloc] init];
    
    //[request setHTTPBody]
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    //get response
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    
    
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Response Code: %d", [urlResponse statusCode]);
    
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
    {
        NSLog(@"Response: %@", result);
    }
    
    //  NSArray *split =[result componentsSeparatedByString:@">"];
    
    NSLog(@"TUC: %@",[result substringWithRange:NSMakeRange(40,26)]);
    
    NSString *msg=[[NSString alloc] initWithFormat:@"TUC: %@",[result substringWithRange:NSMakeRange(40,26)]];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"SALDO TUC"
                          message:msg delegate:self
                          cancelButtonTitle:@"Aceptar"
                          otherButtonTitles:nil];
    
    [alert show];

}
@end
