import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:push_notifs/provider/userModel.dart';
import 'package:push_notifs/screen_one.dart';
import 'package:http/http.dart' as http;
import 'package:push_notifs/screen_two.dart';
import 'package:push_notifs/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

