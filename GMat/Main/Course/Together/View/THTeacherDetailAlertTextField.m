//
//  THTeacherDetailAlertTextField.m
//  TingApp
//
//  Created by hublot on 16/8/31.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THTeacherDetailAlertTextField.h"

@interface THTeacherDetailAlertTextField ()

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UILabel *helpLabel;

@property (nonatomic, strong) NSString *helpLabelText;

@end

@implementation THTeacherDetailAlertTextField

- (instancetype)initWithFrame:(CGRect)frame helpLabelText:(NSString *)helpLabelText {
	if (self = [super initWithFrame:frame]) {
		self.helpLabelText = helpLabelText;
	}
	return self;
}

- (void)hideKeyBoard {
	[self.textField resignFirstResponder];
	[self.textField endEditing:true];
}

- (void)didMoveToSuperview {
	[self addSubview:self.helpLabel];
	[self addSubview:self.textField];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.helpLabelText] attributes:@{NSFontAttributeName:[UIFont ht_fontStyle:HTFontStyleHeadSmall], NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTitle]}];
	self.helpLabel.attributedText = attributedString;
}

- (UILabel *)helpLabel {
	if (!_helpLabel) {
		_helpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.ht_w, self.ht_h / 2)];
	}
	return _helpLabel;
}

- (NSString *)text {
	return self.textField.text;
}


- (UITextField *)textField {
	if (!_textField) {
		_textField = [[UITextField alloc] initWithFrame:CGRectMake(0, self.ht_h / 2, self.ht_w, self.ht_h / 2)];
		_textField.backgroundColor = [UIColor ht_colorString:@"f0f0f0"];
		_textField.font = [UIFont ht_fontStyle:HTFontStyleTitleLarge];
		_textField.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
		_textField.leftViewMode = UITextFieldViewModeAlways;
		_textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写" attributes:@{NSFontAttributeName:[UIFont ht_fontStyle:HTFontStyleHeadSmall], NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleSpecialTitle]}];
	}
	return _textField;
}


@end
