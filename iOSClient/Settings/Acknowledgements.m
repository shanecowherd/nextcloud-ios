//
//  Acknowledgements.m
//  Nextcloud
//
//  Created by Marino Faggiana on 14/11/14.
//  Copyright (c) 2017 Marino Faggiana. All rights reserved.
//
//  Author Marino Faggiana <marino.faggiana@nextcloud.com>
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "Acknowledgements.h"
#import "AppDelegate.h"

@interface Acknowledgements ()
{
    AppDelegate *appDelegate;
}
@end

@implementation Acknowledgements

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSURL *rtfPath;
    
    //NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    //if ([language isEqualToString:@"it"]) rtfPath = [[NSBundle mainBundle]  URLForResource:@"terminicondizioni_it" withExtension:@"rtf"];
    //else rtfPath = [[NSBundle mainBundle]  URLForResource:@"terminicondizioni_en" withExtension:@"rtf"];
    
    rtfPath = [[NSBundle mainBundle]  URLForResource:@"Acknowledgements" withExtension:@"rtf"];
    
    NSAttributedString *attributedStringWithRtf = [[NSAttributedString alloc] initWithURL:rtfPath options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:nil];
    self.txtTermini.attributedText = attributedStringWithRtf;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"_acknowledgements_", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelPressed)];
    self.txtTermini.hidden = true;
    
    // changeTheming
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheming) name:@"changeTheming" object:nil];
    [self changeTheming];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.txtTermini setContentOffset:CGPointZero animated:NO];
    self.txtTermini.hidden = false;
}

- (void)changeTheming
{
    [appDelegate changeTheming:self tableView:nil collectionView:nil form:false];
}

- (void)cancelPressed
{
    [self dismissViewControllerAnimated:true completion:nil];
}

@end

