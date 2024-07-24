import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:uuvpn/pages/accountPage.dart';
import 'package:uuvpn/pages/home/home_page.dart';
import 'package:uuvpn/pages/404/not_find_page.dart';
import 'package:uuvpn/pages/login/login_page.dart';
import 'package:uuvpn/pages/plan/plan_page.dart';
import 'package:uuvpn/pages/server_list.dart';
import 'package:uuvpn/pages/webview_widget.dart';
import 'dart:convert';

/// 入口
Handler homeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const HomePage();
});

/// 404页面
Handler notFindHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const NotFindPage();
});

/// 登录页
Handler loginHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const LoginPage();
});

/// 套餐页
Handler planHandle = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const PlanPage();
});

/// 服务器节点页
Handler serverListHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const ServerListPage();
});

/// WebView页
Handler webViewHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  var title = jsonDecode(parameters["titleName"]!.first);
  var url = jsonDecode(parameters["url"]!.first);
  return WebViewWidget(name: title, url: url);
});

///个人中心
Handler accountHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const AccountPage();
});
