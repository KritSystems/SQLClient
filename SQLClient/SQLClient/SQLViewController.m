//
//  SQLViewController.m
//  SQLClient
//
//  Created by Martin Rybak on 10/14/13.
//  Copyright (c) 2013 Martin Rybak. All rights reserved.
//

#import "SQLViewController.h"
#import "SQLClient.h"

@interface SQLViewController ()

@property (strong, nonatomic) UITextView* textView;
@property (strong, nonatomic) UIActivityIndicatorView* spinner;

@end

@implementation SQLViewController

#pragma mark - UIViewController

- (void)loadView
{
	self.view = [[UIView alloc] init];
	
	//Load textView
	UITextView* textView = [[UITextView alloc] init];
	textView.editable = NO;
	textView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:textView];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
	self.textView = textView;
	
	//Load spinner
	UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	spinner.hidesWhenStopped = YES;
	spinner.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:spinner];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[spinner]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(spinner)]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[spinner]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(spinner)]];
	self.spinner = spinner;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	[self connect];
}

#pragma mark - Private

- (void)connect
{
	SQLClient* client = [[SQLClient alloc] init];
  client.delegate = self;
	[self.spinner startAnimating];
	[client connect:@"server\\instance:port" username:@"user" password:@"pass" database:@"db" completion:^(BOOL success) {
		[self.spinner stopAnimating];
		if (success) {
			[self execute];
		}
	}];
}

- (void)execute
{
	SQLClient* client = [[SQLClient alloc] init];
	[self.spinner startAnimating];
	[client execute:@"SELECT * FROM Table" completion:^(NSArray* results) {
		[self.spinner stopAnimating];
		[self process:results];
		[client disconnect];
	}];
}

- (void)process:(NSArray*)results
{
	NSMutableString* output = [[NSMutableString alloc] init];
	for (NSArray* table in results) {
		for (NSDictionary* row in table) {
			for (NSString* column in row) {
				[output appendFormat:@"\n%@=%@", column, row[column]];
			}
		}
	}
	self.textView.text = output;
}

#pragma mark - SQLClientDelegate

- (void)message:(nonnull NSString*)message
{
  NSLog(@"Message: %@", message);
}

- (void)error:(nonnull NSString*)error code:(int)code severity:(int)severity
{
  NSLog(@"Error #%@: %d (Severity %d)", code, error, severity);
  [[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

@end
