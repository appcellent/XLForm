//
//  XLFormSegmentedCell.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2014 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XLFormSegmentedCell.h"

#import "NSObject+XLFormAdditions.h"
#import "UIView+XLFormAdditions.h"

@interface XLFormSegmentedCell()

//@property NSMutableArray * dynamicCustomConstraints;

@end

@implementation XLFormSegmentedCell
@synthesize segmentedControl = _segmentedControl;

#pragma mark - XLFormDescriptorCell

-(void)configure
{
    [super configure];
}

-(void)update
{
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    [self updateSegmentedControl];
    self.segmentedControl.selectedSegmentIndex = [self selectedIndex];
    self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	
	[self formatTextLabel];
}

#pragma mark - Properties

//-(UISegmentedControl *)segmentedControl
//{
//	if (!self.accessoryView)
//	{
//		self.accessoryView = [[UISegmentedControl alloc] initWithItems:@[]];
//		self.accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
//		[self.contentView addSubview:self.accessoryView];
//	}
//	
//	return (UISegmentedControl *)self.accessoryView;
//}

-(UISegmentedControl *)segmentedControl
{
	if (_segmentedControl) return _segmentedControl;
	_segmentedControl = [UISegmentedControl autolayoutView];
	[self.contentView addSubview:_segmentedControl];
	[self.segmentedControl addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
//	[_segmentedControl setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
	return _segmentedControl;
}

#pragma mark - Action

-(void)valueChanged
{
    self.rowDescriptor.value = [self.rowDescriptor.selectorOptions objectAtIndex:self.segmentedControl.selectedSegmentIndex];
}

#pragma mark - Helper

-(NSArray *)getItems
{
    NSMutableArray * result = [[NSMutableArray alloc] init];
    for (id option in self.rowDescriptor.selectorOptions)
        [result addObject:[option displayText]];
    return result;
}

-(void)updateSegmentedControl
{
    [self.segmentedControl removeAllSegments];
    
    [[self getItems] enumerateObjectsUsingBlock:^(id object, NSUInteger idex, __unused BOOL *stop){
        [self.segmentedControl insertSegmentWithTitle:[object displayText] atIndex:idex animated:NO];
    }];
}

-(NSInteger)selectedIndex
{
    if (self.rowDescriptor.value){
        for (id option in self.rowDescriptor.selectorOptions){
            if ([[option valueData] isEqual:[self.rowDescriptor.value valueData]]){
                return [self.rowDescriptor.selectorOptions indexOfObject:option];
            }
        }
    }
    return UISegmentedControlNoSegment;
}

#pragma mark - Layout Constraints

-(NSMutableArray *)defaultConstraints
{
	NSMutableArray* constraints = [NSMutableArray array];
	NSDictionary * views = @{@"label": self.textLabel, @"segmentedControl": self.segmentedControl};
	
	if (self.textLabel.text.length > 0)
		[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[label]-[segmentedControl]-4-|" options:0 metrics:0 views:views]];
	else
		[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[segmentedControl]-4-|" options:0 metrics:0 views:views]];
	
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[label]-12-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:views]];
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[segmentedControl]-6-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:views]];
	
	return constraints;
}

-(void)dealloc
{
	
}

@end
