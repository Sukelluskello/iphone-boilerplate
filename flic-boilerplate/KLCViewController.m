//
//   _    _      _ _       _
//  | |  | |    | | |     | |
//  | |__| | ___| | | ___ | |
//  |  __  |/ _ \ | |/ _ \| |
//  | |  | |  __/ | | (_) |_|
//  |_|  |_|\___|_|_|\___/(_)
//  =========================
//
//  Welcome to the Klarna + Flic = Klic Hackathon!
//
//  IMPORTANT!
//  Before you can scan your Flic, you have to add its id to the allow list.
//  In [viewDidLoad] you can add the id of your button. You can find the ID
//  on the back of the Flic.
//
//  This example project contains some basic functionality to get you started.
//  Once you have your Flic connected, you will start to recieve events.
//  The first thing you want to do is probably to add some logic to this method:
//  - (void)flicButton:(SCLFlicButton *)button didReceiveButtonClick:(BOOL)queued age:(NSInteger)age;
//
//  Detailed documentation can be found at: https://developers.flic.io/documentation	
//
//  Good luck and have fun!

#import "KLCViewController.h"
#import "FlicTableViewCell.h"

@interface KLCViewController ()

@end

@implementation KLCViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// this is to limit the scanning to buttons that are somewhat close to you
	// 0 is closest -100 is farthest
	// once the button is connected, this will not affect range at all
	AppDelegate.flicManager.minAllowedRSSI = @(-40);
}

- (void)viewDidAppear:(BOOL)animated;
{
	// for simplicitys sake, we can only have one button delegate at a time
	// this delegate will recieve all events about connectivity and button events
	AppDelegate.buttonDelegate = self;
}

- (IBAction)search:(id)sender;
{
	[self startScanningWithCompletionHandler:^(FLCPopOverViewController *popOverViewController, BOOL cancelled, SCLFlicButton *button, NSError *error) {
		
		// popOverViewController: the view containing the scan wizard, not important
		// error: will contain an error if the scan was unsuccessful, describing the problem
		// cancelled: if the user aborted the scan, this will be YES
		// button: if a button was found, this is it. the button can also be found in AppDelegate.flicManager.knownButtons
		
		AppDelegate.buttonDelegate = self; // the button scanner becomes main button delegate so we need to set it back to recieve events
		
		// there are a couple of different modes for button
		// this mode will have decent response time and will reconnect buttons automatically
		// if you want faster response time you can set this to SCLFlicButtonModeSuperActive
		// you can read more about these in the documentation
		[button setMode:SCLFlicButtonModeActiveKeepAlive withOptions:nil];
		
		// this tells the button which events to listen for
		// it is now set to detect all three event types: Click, DoubleClick and Hold
		// this makes some events a bit slower since the button has to wait and make sure it wasn't a double click before sending the event
		// so to make Click faster you can set this to SCLFlicButtonTriggerBehaviorClickAndHold
		button.triggerBehavior = SCLFlicButtonTriggerBehaviorClickAndDoubleClickAndHold;

		
		[self.tableView reloadData];
	}];
}

#pragma mark - SCLFlicButtonDelegate

- (void)flicButton:(SCLFlicButton *)button didReceiveButtonClick:(BOOL)queued age:(NSInteger)age;
{
	// you probably want to start here!
}

- (void)flicButton:(SCLFlicButton *)button didReceiveButtonDown:(BOOL)queued age:(NSInteger)age;
{
	// this is the fastest way to detect a button event, so if you are making something that needs fast response time, here is the place to be
	
	// for now we use this to boing the icon in the button list, for funsies
	NSUInteger index = [AppDelegate.flicManager.knownButtons.allValues indexOfObject:button];
	if(index != NSNotFound)
	{
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
	 	FlicTableViewCell *cell = (FlicTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
		[cell boing];
	}
}

- (void)flicButton:(SCLFlicButton *)button didReceiveButtonUp:(BOOL)queued age:(NSInteger)age;
{
	
}

- (void)flicButton:(SCLFlicButton *)button didReceiveButtonDoubleClick:(BOOL)queued age:(NSInteger)age;
{
	
}

- (void)flicButton:(SCLFlicButton *)button didReceiveButtonHold:(BOOL)queued age:(NSInteger)age;
{
	
}

@end
