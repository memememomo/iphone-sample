//
//  HTTPServer.m
//  UnZipTest
//
//  Created by Your Name on 11/01/27.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "HTTPServerController.h"
#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "localhostAddresses.h"

@class HTTPServer;

@implementation HTTPServerController


- (void)dealloc
{
	[httpServer_ release];
	[address_ release];
	[super dealloc];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	NSString *root = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	httpServer_ = [[HTTPServer alloc] init];
	[httpServer_ setType:@"_http._tcp"];
	[httpServer_ setConnectionClass:[MyHTTPConnection class]];
	[httpServer_ setDocumentRoot:[NSURL fileURLWithPath:root]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayInfo:) name:@"LocalhostAdressesResolved" object:nil];
	[localhostAddresses performSelectorInBackground:@selector(list) withObject:nil];
}


- (void)displayInfo:(NSNotification *)notification
{
	if (notification) {
		[address_ release];
		address_ = [[notification object] copy];
	}
	
	if (address_ == nil) {
		return;
	}
	
	NSString *info;
	UInt16 port = [httpServer_ port];
	
	NSString *localIP = nil;
	
	localIP = [address_ objectForKey:@"en0"];

	if (!localIP) {
		localIP = [address_ objectForKey:@"en1"];
	}
	
	if (!localIP) {
		info = @"Wifi: No Connection\n";
	} else {
		info = [NSString stringWithFormat:@"http://%@:%d\n", localIP, port];
	}

	NSString *wwwIP = [address_ objectForKey:@"www"];
	
	if (wwwIP) {
		info = [info stringByAppendingFormat:@"Web: %@:%d\n", wwwIP, port];
	} else {
		info = [info stringByAppendingFormat:@"Web: Unable to determine external IP\n"];
	}
	
	displayInfo_.text = info;
}
	
- (IBAction)startStopServer:(id)sender
{
	if ([sender isOn]) {
		NSError *error;
		if (![httpServer_ start:&error]) {
			NSLog(@"Error starting HTTP Server: %@", error);
		}
		
		[self displayInfo:nil];
	} else {
		[httpServer_ stop];
	}
}
	

@end
