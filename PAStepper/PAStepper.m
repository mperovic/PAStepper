//
//  PAStepper.m
//  Leroy Merlin
//
//  Created by Miroslav Perovic on 11/30/12.
//  Copyright (c) 2012 Pure Agency. All rights reserved.
//

#import "PAStepper.h"

@interface ADNoActionTextField : UITextField

@end

@implementation ADNoActionTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO;
}

@end

@interface PAStepper ()<UITextFieldDelegate> {
	UIImageView *backgroundImageView;
	UIButton *incrementButton;
	UIButton *decrementButton;
	UILabel *label;
    ADNoActionTextField *_textField;
    
	UIImage *normalStateImage;
	UIImage *selectedStateImage;
	UIImage *highlightedStateImage;
	UIImage *disabledStateImage;
	
	NSNumber *changingValue;
}

@end

@implementation PAStepper
- (void)awakeFromNib
{
	[self setInitialValues];
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 116.0, 29.0)]) {
		[self setInitialValues];
	}
	
	return self;
}

- (void)setInitialValues
{
	_tintColor = [UIColor whiteColor];
	_textColor = [UIColor blackColor];
	_value = 0;
	_continuous = YES;
	_minimumValue = 0;
	_maximumValue = 100;
	_stepValue = 1;
	_wraps = NO;
	_autorepeat = YES;
	_autorepeatInterval = 0.2;
    _editableManually = YES;
	label.textColor = _textColor;
	
    _numberFormater = [[NSNumberFormatter alloc] init];
    [_numberFormater setFormatterBehavior:NSNumberFormatterBehaviorDefault];
    [_numberFormater setNumberStyle:NSNumberFormatterDecimalStyle];
    _numberFormater.maximumFractionDigits = 0;
    
	// init left button
	decrementButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 25.0, 29.0)];
	[decrementButton setBackgroundImage:[UIImage imageNamed:@"minus_bckg"] forState:UIControlStateNormal];
	[decrementButton setTintColor:_tintColor];
	[decrementButton setTitle:@"-" forState:UIControlStateNormal];
	[decrementButton setAutoresizingMask:UIViewAutoresizingNone];
    [decrementButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
    [decrementButton addTarget:self action:@selector(didBeginLongTap:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [decrementButton addTarget:self action:@selector(didEndLongTap) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel | UIControlEventTouchDragExit];
	[self addSubview:decrementButton];
	
	// background image
	backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25.0, 0.0, 66.0, 29.0)];
	normalStateImage = [UIImage imageNamed:@"stepper_white_bckg"];
	[backgroundImageView setImage:normalStateImage];
	[self addSubview:backgroundImageView];
	
	// label
	label = [[UILabel alloc] initWithFrame:CGRectMake(2.0, 2.0, 62.0, 25.0)];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setFont:[UIFont boldSystemFontOfSize:17.0]];
	[label setTextColor:_textColor];
	[self updateViews];
	[backgroundImageView addSubview:label];
    label.hidden = YES;
    
    //TextField the number
    _textField = [[ADNoActionTextField alloc] init];
    _textField.font = [UIFont boldSystemFontOfSize:17.0];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.backgroundColor = [UIColor clearColor];
    _textField.clearButtonMode = UITextFieldViewModeNever;
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.inputView = nil;
    _textField.placeholder = [self formatedStringForValue:_value];
    _textField.delegate = self;
    [_textField setKeyboardType:UIKeyboardTypeNumberPad];
    _textField.frame = backgroundImageView.frame;
    [_textField addTarget:self action:@selector(didChangeTextField) forControlEvents: UIControlEventEditingChanged];
    [_textField addTarget:self action:@selector(didEndEditingTextField) forControlEvents: UIControlEventEditingDidEnd];
    _textField.autoresizingMask = UIViewAutoresizingNone; // push to none
    _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:_textField];
    
	// init right button
	incrementButton = [[UIButton alloc] initWithFrame:CGRectMake(91.0, 0.0, 25.0, 29.0)];
	[incrementButton setBackgroundImage:[UIImage imageNamed:@"plus_bckg"] forState:UIControlStateNormal];
	[incrementButton setTintColor:_tintColor];
	[incrementButton setTitle:@"+" forState:UIControlStateNormal];
    [incrementButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
    [incrementButton addTarget:self action:@selector(didBeginLongTap:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [incrementButton addTarget:self action:@selector(didEndLongTap) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel | UIControlEventTouchDragExit];
	[self addSubview:incrementButton];
}

- (void)setFrame:(CGRect)frame
{
	// don't allow to change frame
	[super setFrame:CGRectMake(frame.origin.x, frame.origin.y, 116.0, 29.0)];
}

- (NSString *)formatedStringForValue:(double)value{
    
    NSString *formatedValueString = [_numberFormater stringFromNumber:[NSNumber numberWithDouble:value]];
    return formatedValueString;
}

- (void)updateViews
{
    NSString *formatedValueString = [self formatedStringForValue:_value];
	[label setText:formatedValueString];
    _textField.text = formatedValueString;
    
    [self checkButtonState];
    
}

- (void)checkButtonState{
    BOOL canDecrese = (_value > _minimumValue);
    BOOL canIncrese = (_value < _maximumValue);
    
    decrementButton.enabled = canDecrese;
    incrementButton.enabled = canIncrese;
}

#pragma mark - Set Values
- (void)setMinimumValue:(double)minValue
{
	if (minValue > _maximumValue) {
		NSException *ex = [NSException exceptionWithName:NSInvalidArgumentException
												  reason:@"Invalid minimumValue"
												userInfo:nil];
		@throw ex;
	}
    _minimumValue = minValue;
    _textField.placeholder = [self formatedStringForValue:_minimumValue];
    if (_value < _minimumValue) {
        _value = _minimumValue;
        [self updateViews];
    }
}

- (void)setStepValue:(double)stepValue
{
	if (stepValue <= 0) {
		NSException *ex = [NSException exceptionWithName:NSInvalidArgumentException
												  reason:@"Invalid stepValue"
												userInfo:nil];
		@throw ex;
	}
    _stepValue = stepValue;
}

- (void)setMaximumValue:(double)maxValue
{
	if (maxValue < _minimumValue) {
		NSException *ex = [NSException exceptionWithName:NSInvalidArgumentException
												  reason:@"Invalid maximumValue"
												userInfo:nil];
		@throw ex;
	}
    _maximumValue = maxValue;
    if (_value > _maximumValue) {
        _value = _maximumValue;
        [self updateViews];
    }
}

- (void)setValue:(double)val
{
	if (val < _minimumValue) {
		val = _minimumValue;
	} else if (val > _maximumValue) {
		val = _maximumValue;
	}
	_value = val;
	
	if (_value == val) {
		[self sendActionsForControlEvents:UIControlEventValueChanged];
		[self updateViews];
	}
}

- (void)setAutorepeatValue:(double)autorepeatInterval
{
	if (autorepeatInterval > 0.0) {
		_autorepeatInterval = autorepeatInterval;
	} else if (autorepeatInterval == 0) {
		_autorepeatInterval = autorepeatInterval;
		_autorepeat = NO;
	}
}

- (void)setEditableManually:(BOOL)editableManually{
    _editableManually = editableManually;
    _textField.enabled = _editableManually;
    if (!_editableManually) {
        [_textField resignFirstResponder];
    }
}

# pragma mark - Public Methods

- (UIImage *)backgroundImageForState:(UIControlState)state
{
	switch (state) {
		case UIControlStateNormal:
			return normalStateImage;
			break;
			
		case UIControlStateHighlighted:
			if (highlightedStateImage) {
				return highlightedStateImage;
			} else {
				return normalStateImage;
			}
			break;
			
		case UIControlStateDisabled:
			if (disabledStateImage) {
				return disabledStateImage;
			} else {
				return normalStateImage;
			}
			break;
			
		case UIControlStateSelected:
			if (selectedStateImage) {
				return selectedStateImage;
			} else {
				return normalStateImage;
			}
			break;
			
		default:
			return normalStateImage;
			break;
	}
	
	return normalStateImage;
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
{
	switch (state) {
		case UIControlStateNormal:
			normalStateImage = image;
			break;
			
		case UIControlStateHighlighted:
			highlightedStateImage = image;
			break;
			
		case UIControlStateDisabled:
			disabledStateImage = image;
			break;
			
		case UIControlStateSelected:
			selectedStateImage = image;
			break;
			
		default:
			break;
	}
}

- (UIImage *)decrementImageForState:(UIControlState)state
{
	return [decrementButton imageForState:state];
}

- (void)setdDecrementImage:(UIImage *)image forState:(UIControlState)state
{
	[decrementButton setImage:image forState:state];
}

- (UIImage *)incrementImageForState:(UIControlState)state
{
	return [incrementButton imageForState:state];
}

- (void)setdIncrementImage:(UIImage *)image forState:(UIControlState)state
{
	[incrementButton setImage:image forState:state];
}

#pragma mark - Actions

- (void)didPressButton:(id)sender
{
	[self setHighlighted:YES];
	if (changingValue) {
		return;
	}
	
	UIButton *button = (UIButton *)sender;
	double changeValue;
	if (button == decrementButton) {
		changeValue = -1 * _stepValue;
	} else {
		changeValue = _stepValue;
	}
	changingValue = [NSNumber numberWithDouble:changeValue];
	[self performSelector:@selector(changeValue:) withObject:changingValue afterDelay:0.5];
}

- (void)didBeginLongTap:(id)sender
{
	[self setHighlighted:YES];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	UIButton *button = (UIButton *)sender;
	double changeValue;
	if (button == decrementButton) {
		changeValue = -1 * _stepValue;
	} else {
		changeValue = _stepValue;
	}
	changingValue = [NSNumber numberWithDouble:changeValue];
	if (_continuous) {
		[self changeValue:changingValue];
	}
	[self performSelector:@selector(longTapLoop) withObject:nil afterDelay:_autorepeatInterval];
}

- (void)didEndLongTap
{
	[self setHighlighted:NO];

	if (!_continuous) {
		[self performSelectorOnMainThread:@selector(changeValue:) withObject:changingValue waitUntilDone:YES];
	}

	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	changingValue = nil;
}

- (void)longTapLoop
{
	if (_autorepeat) {
		[self performSelector:@selector(longTapLoop) withObject:nil afterDelay:_autorepeatInterval];
		[self performSelectorOnMainThread:@selector(changeValue:) withObject:changingValue waitUntilDone:YES];
	}
}

-(void) didChangeTextField
{
    NSString *text = _textField.text;
    if (text.length > 0) {
        [self setValue:[text doubleValue]];
    }
}

- (void)didEndEditingTextField{
    NSString *text = _textField.text;
    [self setValue:[text doubleValue]];
}

- (BOOL)isValidTextFieldValue:(NSString *)valueString{
    if ([valueString isEqualToString:@""]) {
        return YES;
    }
    double valueDouble = [valueString doubleValue];
    if (valueDouble < _minimumValue || valueDouble > _maximumValue) {
        return NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = textField.text;
    NSString *replacesString = [text stringByReplacingCharactersInRange:range withString:string];
    BOOL validInput = [self isValidTextFieldValue:replacesString];
    if (!validInput) {
        return NO;
    }
    return YES;
}

#pragma mark - Overwrite UIControl methods

- (void)setEnabled:(BOOL)enabled
{
	if (enabled) {
		backgroundImageView.image = normalStateImage;
	} else {
		if (disabledStateImage) {
			backgroundImageView.image = disabledStateImage;
		}
	}
}

- (void)setHighlighted:(BOOL)highlighted
{
	if (highlighted && highlightedStateImage) {
		backgroundImageView.image = highlightedStateImage;
	} else {
		backgroundImageView.image = normalStateImage;
	}
}

- (void)setSelected:(BOOL)selected
{
	if (selected && selectedStateImage) {
		backgroundImageView.image = selectedStateImage;
	} else {
		backgroundImageView.image = normalStateImage;
	}
}


#pragma mark - Other methods
- (void)changeValue:(NSNumber *)change
{
	double toChange = [change doubleValue];
	double newValue = _value + toChange;
	if (toChange < 0) {
		if (newValue < _minimumValue) {
			if (!_wraps) {
				return;
			} else {
				newValue = _maximumValue;
			}
		}
	} else {
		if (newValue > _maximumValue) {
			if (!_wraps) {
				return;
			} else {
				newValue = _minimumValue;
			}
		}
	}
	[self setValue:newValue];
}

@end
