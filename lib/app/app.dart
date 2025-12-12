import 'package:plumora/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:plumora/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:plumora/ui/views/home/home_view.dart';
import 'package:plumora/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:plumora/services/auth_service.dart';
import 'package:plumora/ui/views/login/login_view.dart';
import 'package:plumora/ui/views/register/register_view.dart';
import 'package:plumora/services/user_service.dart';
import 'package:plumora/services/manuscript_service.dart';
import 'package:plumora/ui/views/newmanuscript/newmanuscript_view.dart';
import 'package:plumora/ui/views/manuscript/manuscript_view.dart';
import 'package:plumora/ui/views/profile/profile_view.dart';
import 'package:plumora/ui/views/reading/reading_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: NewmanuscriptView),
    MaterialRoute(page: ManuscriptView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: ReadingView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: ManuscriptService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
