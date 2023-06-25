import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sail/model/themeCollection.dart';
import 'package:sail/models/login_model.dart';
import 'package:sail/models/user_model.dart';
import 'package:sail/router/application.dart';
import 'package:sail/service/user_service.dart';
import 'package:sail/utils/l10n.dart';
import 'package:sail/utils/navigator_util.dart';
import 'package:sail/constant/app_strings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  Duration get loginTime => const Duration(milliseconds: 2250);

  late UserModel _userModel;
  late LoginModel _loginModel;

  static String? _emailValidator(value) {
    if (value.isEmpty ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
      return Application.navigatorKey.currentState?.context.l10n.pleaseenter;
    }

    return null;
  }

  static String? _passwordValidator(String? value) {
    if (value?.isEmpty == true) {
      return Application.navigatorKey.currentState?.context.l10n.passwordcan;
    }
    if (value?.length == null || value!.length < 6) {
      return Application.navigatorKey.currentState?.context.l10n.passwordcannot;
    }
    return null;
  }

  Future<String?> _login(LoginData data) async {
    String? result;

    try {
      await _loginModel.login(data.name, data.password);
    } catch (error) {
      result = Application.navigatorKey.currentState?.context.l10n.loginfailed;
    }

    return result;
  }

  Future<String?> _register(SignupData data) async {
    String? result;

    try {
      await UserService()
          .register({'email': data.name, 'password': data.password});

      await _loginModel.login(data.name, data.password);
    } catch (error) {
      result = Application
          .navigatorKey.currentState?.context.l10n.registrationfailed;
    }

    return result;
  }

  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    _loginModel = LoginModel(_userModel);
    bool isDarkTheme = Provider.of<ThemeCollection>(context).isDarkActive;
    return FlutterLogin(
      // title: AppStrings.appName,
      theme: LoginTheme(
          pageColorLight: Color.fromARGB(255, 28, 57, 15),
          pageColorDark: const Color.fromARGB(255, 33, 107, 35)),
      logo: AssetImage('assets/logo2.png'),
      onLogin: _login,
      onSignup: _register,
      messages: LoginMessages(
          userHint: Application.navigatorKey.currentState!.context.l10n.mail,
          passwordHint:
              Application.navigatorKey.currentState!.context.l10n.password,
          confirmPasswordHint: Application
              .navigatorKey.currentState!.context.l10n.confirmpassword,
          confirmPasswordError:
              Application.navigatorKey.currentState!.context.l10n.twopasswords,
          forgotPasswordButton: Application
              .navigatorKey.currentState!.context.l10n.forgetthepassword,
          loginButton:
              Application.navigatorKey.currentState!.context.l10n.login,
          signupButton:
              Application.navigatorKey.currentState!.context.l10n.register,
          recoverPasswordIntro:
              Application.navigatorKey.currentState!.context.l10n.resetpassword,
          recoverPasswordButton:
              Application.navigatorKey.currentState!.context.l10n.sure,
          recoverPasswordDescription:
              Application.navigatorKey.currentState!.context.l10n.thesystemwill,
          recoverPasswordSuccess: Application
              .navigatorKey.currentState!.context.l10n.sentsuccessfully,
          goBackButton:
              Application.navigatorKey.currentState!.context.l10n.returnstring),
      onSubmitAnimationCompleted: () {
        NavigatorUtil.goHomePage(context);
      },
      onRecoverPassword: _recoverPassword,
      userValidator: _emailValidator,
      passwordValidator: _passwordValidator,
    );
  }
}
