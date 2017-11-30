//
//  THMinePreferenceController.m
//  TingApp
//
//  Created by hublot on 16/8/22.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THMinePreferenceController.h"
#import "THMinePreferenceCell.h"
#import "THMinePreferenceModel.h"
#import <UITableView+HTSeparate.h>
#import "THTableButton.h"
#import "HTLoginManager.h"
#import "THMinePreferenceInputController.h"
#import <HTCacheManager.h>
#import "HTDevicePermissionManager.h"
#import "HTMineFontSizeController.h"
#import "HTNetworkManager+HTNetworkCache.h"
#import "HTVideoWiFIManager.h"
#import "HTIssueManager.h"

@interface THMinePreferenceController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) THTableButton *exitButton;

@end

@implementation THMinePreferenceController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	[self LoginChange];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginChange) name:kHTLoginNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginChange) name:kHTFontChangeNotification object:nil];
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"更多设置";
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.exitButton];
}

- (void)LoginChange {
	[self.tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		sectionMaker.modelArray([THMinePreferenceModel packPrimaryModelArray]);
	}];
	[self.tableView ht_updateSection:1 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		sectionMaker.modelArray([THMinePreferenceModel packSecondModelArray]);
	}];
	[self.tableView ht_updateSection:2 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
		sectionMaker.modelArray([THMinePreferenceModel packThirdModelArray]);
	}];
//    if ([HTUserManager currentUser].permission >= HTUserPermissionExerciseNotFullThreeUser) {
	if ([HTUserManager currentUser].permission >= HTUserPermissionExerciseAbleUser) {
        self.exitButton.hidden = false;
        self.tableView.ht_h = self.view.ht_h - 49;
    } else {
        self.exitButton.hidden = true;
        self.tableView.ht_h = self.view.ht_h;
    }
}

- (void)changeHeadImageWithCell:(UITableViewCell *)cell {
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.allowsEditing = true;
    imagePickerController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    imagePickerController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
	imagePickerController.navigationBar.titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak THMinePreferenceController *weakSelf = self;
	[alertController addAction:[UIAlertAction actionWithTitle:@"拍摄照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
		[HTDevicePermissionManager ht_sureDevicePermissionStyle:HTDevicePermissionStyleCamera authorized:^{
			[weakSelf willPresentImagePickerController:imagePickerController];
		} everDenied:^(void (^openUrlBlock)(void)) {
			if (openUrlBlock) {
				[HTAlert title:@"没有相机访问权限哦😲" sureAction:^{
					openUrlBlock();
				}];
			}
		} nowDenied:^(void (^openUrlBlock)(void)) {
			if (openUrlBlock) {
				[HTAlert title:@"没有相机访问权限哦😲" sureAction:^{
					openUrlBlock();
				}];
			}
		} restricted:^{
			[HTAlert title:@"没有相机访问权限哦😲" sureAction:^{
				
			}];
		}];
	}]];
	[alertController addAction:[UIAlertAction actionWithTitle:@"选择已有照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[HTDevicePermissionManager ht_sureDevicePermissionStyle:HTDevicePermissionStylePhotos authorized:^{
			[weakSelf willPresentImagePickerController:imagePickerController];
		} everDenied:^(void (^openUrlBlock)(void)) {
			if (openUrlBlock) {
				[HTAlert title:@"没有相册访问权限哦😲" sureAction:^{
					openUrlBlock();
				}];
			}
		} nowDenied:^(void (^openUrlBlock)(void)) {
			if (openUrlBlock) {
				[HTAlert title:@"没有相册访问权限哦😲" sureAction:^{
					openUrlBlock();
				}];
			}
		} restricted:^{
			[HTAlert title:@"没有相册访问权限哦😲" sureAction:^{
				
			}];
		}];
	}]];
	[alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
	}]];
	UIPopoverPresentationController *popover = alertController.popoverPresentationController;
	if (popover) {
		popover.sourceView = cell;
		popover.sourceRect = cell.bounds;
	}
	[self presentViewController:alertController animated:true completion:nil];
}

- (void)willPresentImagePickerController:(UIImagePickerController *)imagePickerController {
	[imagePickerController setBk_didFinishPickingMediaBlock:^(UIImagePickerController *imagePickerController, NSDictionary *dictionary) {
		UIImage *image = dictionary[UIImagePickerControllerEditedImage];
		NSData *imageData = UIImageJPEGRepresentation(image, 1);
		HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
		networkModel.autoAlertString = @"更新用户信息中";
		networkModel.offlineCacheStyle = HTCacheStyleNone;
		networkModel.autoShowError = true;
		
		HTUploadModel *uploadModel = [[HTUploadModel alloc] init];
		uploadModel.uploadData = imageData;
		uploadModel.uploadType = HTUploadFileDataTypeJpg;
		networkModel.uploadModelArray = @[uploadModel];
		[HTRequestManager requestUploadUserHeadImageWithNetworkModel:networkModel complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				return;
			}
			[imagePickerController dismissViewControllerAnimated:true completion:nil];
			[HTUserManager updateUserDetailComplete:^(BOOL success) {
				if (!success) {
					[HTAlert title:@"更新用户信息失败"];
				}
			}];
		}];
	}];
	[imagePickerController setBk_didCancelBlock:^(UIImagePickerController *imagePickerController) {
		[imagePickerController dismissViewControllerAnimated:true completion:^{
            
        }];
	}];
	[self presentViewController:imagePickerController animated:true completion:nil];
}

- (void)changeInputDetailWithRow:(NSInteger)row {
	THMinePreferenceInputController *inputController = [[THMinePreferenceInputController alloc] init];
	inputController.inputStyle = row;
	[self.navigationController pushViewController:inputController animated:true];
}

- (void)tableSelectedBlockWithTableView:(UITableView *)tableView cell:(UITableViewCell *)cell model:(THMinePreferenceModel *)model {
	switch (model.everyOneStyle) {
		case THMinePreferenceModelEveryOneMineDetail:
			
			break;
		case THMinePreferenceModelEveryOneHeadImage:
			[self changeHeadImageWithCell:cell];
			break;
//		case THMinePreferenceModelEveryOneUsername:
//			
//			break;
		case THMinePreferenceModelEveryOneNickname:
			[self changeInputDetailWithRow:THMinePreferenceInputName];
			break;
		case THMinePreferenceModelEveryOnePhoneCode:
			[self changeInputDetailWithRow:THMinePreferenceInputPhone];
			break;
		case THMinePreferenceModelEveryOneEmailCode:
			[self changeInputDetailWithRow:THMinePreferenceInputEmail];
			break;
		case THMinePreferenceModelEveryOnePassword:
			[self changeInputDetailWithRow:THMinePreferenceInputPassword];
			break;
		case THMinePreferenceModelEveryOneAboutUs:
			
			break;
		case THMinePreferenceModelEveryOneWebSite:
			
			break;
		case THMinePreferenceModelEveryOneWeChat:
			
			break;
		case THMinePreferenceModelEveryOneTencent:
			
			break;
		case THMinePreferenceModelEveryOneComplaint: {
			[HTIssueManager pushIssueControllerFromNavigationController:self.navigationController];
			break;
		}
		case THMinePreferenceModelEveryOneStar: {
			[HTRequestManager requestOpenAppStore];
			break;
		}
		case THMinePreferenceModelEveryOneFontSize: {
			HTMineFontSizeController *fontSizeController = [[HTMineFontSizeController alloc] init];
			[self.navigationController pushViewController:fontSizeController animated:true];
			break;
		}
		case THMinePreferenceModelEveryOneVideoNotWiFI: {
			
			break;
		}
		case THMinePreferenceModelEveryOneClearCache:
			[HTAlert showProgress];
			[HTCacheManager ht_clearCacheComplete:^{
				[HTAlert hideProgress];
				THMinePreferenceCell *subCell = (THMinePreferenceCell *)cell;
				THMinePreferenceModel *subModel = (THMinePreferenceModel *)model;
				subModel.detailName = @"0.0M";
				subCell.detailNameLabel.text = subModel.detailName;
			}];
			break;
	}
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.ht_w, self.view.ht_h - 49) style:UITableViewStyleGrouped];
        _tableView.separatorColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
        __weak THMinePreferenceController *weakSelf = self;
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([THMinePreferenceCell class]) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, UITableViewCell *cell, THMinePreferenceModel *model) {
                [weakSelf tableSelectedBlockWithTableView:tableView cell:cell model:model];
            }];
        }];
        [_tableView ht_updateSection:1 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([THMinePreferenceCell class])
			 .rowHeight(HTADAPT568(45))
			 .headerHeight(15) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, UITableViewCell *cell, id model) {
                [weakSelf tableSelectedBlockWithTableView:tableView cell:cell model:model];
            }];
        }];
        [_tableView ht_updateSection:2 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            [sectionMaker.cellClass([THMinePreferenceCell class])
			 .rowHeight(HTADAPT568(45))
			 .headerHeight(15)
			 .footerHeight(20) didSelectedCellBlock:^(UITableView *tableView, NSInteger row, UITableViewCell *cell, id model) {
                [weakSelf tableSelectedBlockWithTableView:tableView cell:cell model:model];
            }];
        }];
	}
	return _tableView;
}

- (THTableButton *)exitButton {
	if (!_exitButton) {
		_exitButton = [[THTableButton alloc] initWithFrame:CGRectMake(0, self.view.ht_h - 49, self.view.ht_w, 49)];
		[_exitButton setTitle:@"退出当前账户" forState:UIControlStateNormal];
        __weak THMinePreferenceController *weakSelf = self;
		[_exitButton ht_whenTap:^(UIView *view) {
			[HTAlert title:@"确定要退出本次登录吗" sureAction:^{
				[HTLoginManager exitLoginWithComplete:^{
					[weakSelf.navigationController popViewControllerAnimated:true];
				}];
			}];
		}];
	}
	return _exitButton;
}


@end
