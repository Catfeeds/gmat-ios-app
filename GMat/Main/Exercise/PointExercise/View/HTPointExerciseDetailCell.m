//
//  HTPointExerciseDetailCell.m
//  GMat
//
//  Created by hublot on 2016/11/29.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTPointExerciseDetailCell.h"
#import "HTExerciseModel.h"
#import <UIButton+HTButtonCategory.h>

@interface HTPointExerciseDetailCell ()

@property (nonatomic, strong) UIView *topContentView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UIView *bottomContentView;

@property (nonatomic, strong) UILabel *completePeopleLabel;

@property (nonatomic, strong) UILabel *avagePersentLabel;

@property (nonatomic, strong) UILabel *avageTimeLabel;

@property (nonatomic, strong) UIButton *startButton;

@property (nonatomic, strong) UIButton *continueButton;

@end

@implementation HTPointExerciseDetailCell

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
	[self addSubview:self.topContentView];
	[self.topContentView addSubview:self.titleNameLabel];
	[self addSubview:self.bottomContentView];
	[self.topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.top.mas_equalTo(self);
		make.height.mas_equalTo(self).multipliedBy(0.35);
	}];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.top.bottom.mas_equalTo(self.topContentView);
		make.left.mas_equalTo(self.topContentView).offset(HTADAPT568(20));
	}];
	[self.bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.topContentView.mas_bottom).offset(1);
		make.left.right.bottom.mas_equalTo(self);
	}];
	
	[self.bottomContentView ht_addStackDistanceWithSubViews:@[self.completePeopleLabel, self.avagePersentLabel, self.avageTimeLabel, self.startButton] foreSpaceDistance:HTADAPT568(20) backSpaceDistance:HTADAPT568(20) stackDistanceDirection:HTStackDistanceDirectionHorizontal];
	[self.startButton ht_makeEdgeWithDirection:HTButtonEdgeDirectionVertical imageViewToTitleLabelSpeceOffset:10];
	
	CGFloat width = HTADAPT568(72);
	CGFloat height = HTADAPT568(21);
	[self.bottomContentView addSubview:self.continueButton];
	[self.bottomContentView addSubview:self.lookScoreButton];
	[self.continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(self.startButton);
		make.top.mas_equalTo(HTADAPT568(6));
		make.width.mas_equalTo(width);
		make.height.mas_equalTo(height);
	}];
	[self.lookScoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(self.startButton);
		make.width.mas_equalTo(width);
		make.height.mas_equalTo(height);
		make.bottom.mas_equalTo(HTADAPT568(- 6));
	}];
}

- (void)setModel:(HTExerciseModel *)model row:(NSInteger)row {
	NSDictionary *normalDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
									   NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]};
	NSDictionary *selectedDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:13],
										 NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle]};
	NSMutableAttributedString *attributedString = [[[NSMutableAttributedString alloc] initWithString:model.stname attributes:normalDictionary] mutableCopy];
	NSAttributedString *appendAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  已做 %@ / %ld", model.userlowertk, model.lowertknumb] attributes:selectedDictionary];
	[attributedString appendAttributedString:appendAttributedString];
	self.titleNameLabel.attributedText = attributedString;
	
	NSArray *topStringArray = @[[NSString stringWithFormat:@"%ld", model.num], [NSString stringWithFormat:@"%ld%%", model.correct], [NSString stringWithFormat:@"%ldm", model.meanTime]];
	NSArray *bottomStringArray = @[@"完成人数", @"平均正确率", @"平均耗时"];
	NSArray <UILabel *> *attributedLabel = @[self.completePeopleLabel, self.avagePersentLabel, self.avageTimeLabel];
	[topStringArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", obj, bottomStringArray[idx]] attributes:nil];
		[attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTitle], NSFontAttributeName:[UIFont ht_fontStyle:HTFontStyleTitleLarge]} range:NSMakeRange(0, [obj length])];
		attributedLabel[idx].attributedText = attributedString;
	}];
	NSString *startTitleString = @"开始做题";
	UIColor *startButtonColor;
	BOOL hiddenStartButton = false;
	if (model.userlowertk.integerValue >= model.lowertknumb) {
		startTitleString = @"查看结果";
		startButtonColor = [UIColor ht_colorString:@"4bc93a"];
	} else if (model.userlowertk.integerValue == 0) {
		startTitleString = @"开始做题";
		startButtonColor = [UIColor ht_colorString:@"197fed"];
	} else {
		hiddenStartButton = true;
		startTitleString = @"继续做题";
		startButtonColor = [UIColor ht_colorString:@"ef921a"];
	}
	[self.startButton setTitle:startTitleString forState:UIControlStateNormal];
	[self.startButton setTitleColor:startButtonColor forState:UIControlStateNormal];
	self.startButton.tintColor = startButtonColor;
	
	self.startButton.hidden = hiddenStartButton;
	self.continueButton.hidden = self.lookScoreButton.hidden = !self.startButton.hidden;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [self setHighlighted:selected animated:animated];
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self.topContentView ht_setBackgroundColor:highlighted ? [UIColor colorWithWhite:0.85 alpha:1] : [UIColor whiteColor]];
    [self.bottomContentView ht_setBackgroundColor:highlighted ? [UIColor colorWithWhite:0.85 alpha:1] : [UIColor whiteColor]];
}

- (UIView *)topContentView {
	if (!_topContentView) {
		_topContentView = [[UIView alloc] init];
		_topContentView.backgroundColor = [UIColor whiteColor];
	}
	return _topContentView;
}


- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
	}
	return _titleNameLabel;
}

- (UIView *)bottomContentView {
	if (!_bottomContentView) {
		_bottomContentView = [[UIView alloc] init];
		_bottomContentView.backgroundColor = [UIColor whiteColor];
	}
	return _bottomContentView;
}


- (UILabel *)completePeopleLabel {
	if (!_completePeopleLabel) {
		_completePeopleLabel = [self customLabel];
	}
	return _completePeopleLabel;
}

- (UILabel *)avagePersentLabel {
	if (!_avagePersentLabel) {
		_avagePersentLabel = [self customLabel];
	}
	return _avagePersentLabel;
}

- (UILabel *)avageTimeLabel {
	if (!_avageTimeLabel) {
		_avageTimeLabel = [self customLabel];
	}
	return _avageTimeLabel;
}

- (UILabel *)customLabel {
	UILabel *titleNameLabel = [[UILabel alloc] init];
	titleNameLabel.textAlignment = NSTextAlignmentCenter;
	titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
	titleNameLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailSmall];
	titleNameLabel.numberOfLines = 0;
	return titleNameLabel;
}

- (UIButton *)startButton {
	if (!_startButton) {
		_startButton = [[UIButton alloc] init];
		[_startButton setTitleColor:[UIColor ht_colorStyle:HTColorStyleAnswerRight] forState:UIControlStateNormal];
		_startButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleDetailSmall];
		_startButton.tintColor = [UIColor ht_colorStyle:HTColorStyleAnswerRight];
		[_startButton setImage:[[UIImage imageNamed:@"Community1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
		_startButton.userInteractionEnabled = false;
	}
	return _startButton;
}

- (UIButton *)continueButton {
	if (!_continueButton) {
		_continueButton = [[UIButton alloc] init];
		[_continueButton setTitle:@"继续做题" forState:UIControlStateNormal];
		[_continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_continueButton.titleLabel.font = [UIFont systemFontOfSize:12];
		[_continueButton setBackgroundColor:[UIColor ht_colorString:@"ef921a"]];
		_continueButton.layer.cornerRadius = 3;
		_continueButton.layer.masksToBounds = true;
		_continueButton.userInteractionEnabled = false;
	}
	return _continueButton;
}

- (UIButton *)lookScoreButton {
	if (!_lookScoreButton) {
		_lookScoreButton = [[UIButton alloc] init];
		[_lookScoreButton setTitle:@"查看结果" forState:UIControlStateNormal];
		_lookScoreButton.titleLabel.font = [UIFont systemFontOfSize:12];
		[_lookScoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_lookScoreButton setBackgroundColor:[UIColor ht_colorString:@"4bc93a"]];
		_lookScoreButton.layer.cornerRadius = 3;
		_lookScoreButton.layer.masksToBounds = true;
	}
	return _lookScoreButton;
}

- (void)setFrame:(CGRect)frame {
	frame.origin.x += HTADAPT568(15);
	frame.size.width -= HTADAPT568(30);
	frame.origin.y += HTADAPT568(15);
	frame.size.height -= HTADAPT568(15);
	self.layer.cornerRadius = 5;
	self.layer.masksToBounds = true;
	[super setFrame:frame];
}

@end
