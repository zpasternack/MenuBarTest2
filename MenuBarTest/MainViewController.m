//
//  MainViewController.m
//  MenuBarTest
//
//  Created by Zacharias Pasternack on 6/19/15.
//  Copyright (c) 2015 Fat Apps, LLC. All rights reserved.
//

@import QuartzCore;
#import "MainViewController.h"


@interface MainViewController ()

@property( strong, nonatomic ) NSPopover* popover;
@property( assign, nonatomic ) BOOL showingIcon;
@property( weak, nonatomic ) IBOutlet NSTextField* titleLabel;
@property( weak, nonatomic ) IBOutlet NSTextField* descriptionLabel;
@property( weak, nonatomic ) IBOutlet NSImageView* imageView;

@end


@implementation MainViewController


- (void) toggleWindow:(id)sender
{
	if( !self.popover.shown ) {
		[self showPopover:sender];
	}
	else {
		[self closePopover];
	}
}


- (void) showPopover:(id)sender
{
	NSRect aRect = [sender bounds];
	[self.popover showRelativeToRect:aRect
							  ofView:sender
					   preferredEdge:NSMaxYEdge];
}


- (void) closePopover
{
	[self.popover performClose:self];
}


- (void) viewDidLoad
{
	[super viewDidLoad];

	self.imageView.image = [[NSWorkspace sharedWorkspace] iconForFile:NSHomeDirectory()];
	self.showingIcon = YES;
	
#if 0
	// HACK to try to make this work.
	self.titleLabel.drawsBackground = YES;
	self.titleLabel.backgroundColor = [NSColor clearColor];
//	self.titleLabel.textColor = [NSColor textColor];
	self.descriptionLabel.drawsBackground = YES;
	self.descriptionLabel.backgroundColor = [NSColor clearColor];
	self.descriptionLabel.textColor = [NSColor textColor];
#endif
}


#pragma mark - IBActions


- (IBAction) toggleIcon:(id)sender
{
	NSTimeInterval imageAnimationDuration = 0.5;
	if( [[self.view.window currentEvent] modifierFlags] & NSShiftKeyMask ) {
		imageAnimationDuration *= 10.0;
	}

	CGPoint fromPoint = self.imageView.layer.position;
	CGPoint toPoint;
	
	if( self.showingIcon ) {
		// Transition it up offscreen.
		toPoint = CGPointMake( fromPoint.x, self.view.frame.size.height + 10 );
		
		self.showingIcon = NO;
	}
	else {
		// Transition it back onscreen.
		toPoint = CGPointMake( fromPoint.x, 33 );
		
		self.showingIcon = YES;
	}
	
	CABasicAnimation* positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	positionAnimation.fromValue = [NSValue valueWithPoint:fromPoint];
	positionAnimation.toValue = [NSValue valueWithPoint:toPoint];
	positionAnimation.duration = imageAnimationDuration;
	[self.imageView.layer addAnimation:positionAnimation forKey:@"position"];
	self.imageView.layer.position = toPoint;
}


#pragma mark - Properties


- (NSPopover*) popover
{
	if( _popover == nil ) {
		_popover = [[NSPopover alloc] init];
		_popover.contentViewController = self;
		_popover.behavior = NSPopoverBehaviorTransient;
		_popover.animates = NO;
	}
	return _popover;
}


@end
