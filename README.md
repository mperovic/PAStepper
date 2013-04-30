PAStepper
=========

PAStepper is easy to use replacement for UIStepper control.

Properties
==========

minimumValue - The lowest possible numeric value for the stepper.
------------

Must be numerically less than maximumValue. If you attempt to set a value equal to or greater than maximumValue, the system raises an NSInvalidArgumentException exception.

The default value for this property is 0.


maximumValue - The highest possible numeric value for the stepper.
------------

Must be numerically greater than minimumValue. If you attempt to set a value equal to or lower than minimumValue, the system raises an NSInvalidArgumentException exception.

The default value of this property is 100.


stepValue - The step, or increment, value for the stepper.
---------

Must be numerically greater than 0. If you attempt to set this property’s value to 0 or to a negative number, the system raises an NSInvalidArgumentException exception.

The default value for this property is 1.


value - The numeric value of the stepper.
-----

When the value changes, the stepper sends the UIControlEventValueChanged flag to its target (see addTarget:action:forControlEvents:). Refer to the description of the continuous property for information about whether value change events are sent continuously or when user interaction ends.

The default value for this property is 0. This property is clamped at its lower extreme to minimumValue and is clamped at its upper extreme to maximumValue.


continuous - The continuous vs. noncontinuous state of the stepper.
----------

If YES, value change events are sent immediately when the value changes during user interaction. If NO, a value change event is sent when user interaction ends.

The default value for this property is YES.


autorepeat - The automatic vs. nonautomatic repeat state of the stepper.
----------

If YES, the user pressing and holding on the stepper repeatedly alters value.

The default value for this property is YES.


autorepeatInterval - The interval in which the stepper changes value (in seconds).
------------------

If autorepeat is YES, the user pressing and holding on the stepper repeatedly alters value by autorepeatIntreval value.

The default value for this property is 0.5.


wraps - The wrap vs. no-wrap state of the stepper.
-----

If YES, incrementing beyond maximumValue sets value to minimumValue; likewise, decrementing below minimumValue sets value to maximumValue. If NO, the stepper does not increment beyond maximumValue nor does it decrement below minimumValue but rather holds at those values.

The default value for this property is NO.


tintColor - The tint color for the stepper control.
---------

The value of this property is white by default.


textColor - The color for the label.
---------

The value of this property is black by default.


Instance Methods
================

backgroundImageForState: Returns the background image associated with the specified control state.
------------------------

- (UIImage *)backgroundImageForState:(UIControlState)state

Parameters
- state: The control state in which the image is displayed.

Return Value
- The background image used by the control when it is in the specified state.


setBackgroundImage:forState: - Sets the background image for the control when it is in the specified state.
----------------------------

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state

Parameters
- image: The background image to use for the specified state.
- state: The control state in which you want to display the image.

Note
For good results, image must be a stretchable image.


decrementImageForState: Returns the image used for the decrement glyph of the control.
-----------------------

- (UIImage *)decrementImageForState:(UIControlState)state

Parameters
- state: The control state in which the image is displayed.

Return Value
- The image used for the decrement glyph of the control.


setDecrementImage:forState: Sets the background image to use for the decrement glyph of the control.
---------------------------

- (void)setDecrementImage:(UIImage *)image forState:(UIControlState)state

Parameters
- image: The background image to use for the decrement glyph.
- state: The control state in which you want to display the image.


incrementImageForState: Returns the image used for the increment glyph of the control.
-----------------------

- (UIImage *)incrementImageForState:(UIControlState)state

Parameters
- state: The control state in which the image is displayed.

Return Value
- The image used for the increment glyph of the control.


setIncrementImage:forState: Sets the  background image to use for the increment glyph of the control
---------------------------

- (void)setIncrementImage:(UIImage *)image forState:(UIControlState)state

Parameters
- image: The background image to use for the increment glyph.
- state: The control state.


License: 
---------------------------
PAStepper is released under the GNU GENERAL PUBLIC LICENSE (see the LICENSE file)