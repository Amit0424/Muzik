import 'package:flutter/material.dart';

class LoadingProvider with ChangeNotifier {
  bool _isRegister = true;
  bool _isObscureText = true;
  bool _isObscureIconVisible = false;
  bool _isAllFieldCompleted = false;
  bool _isImageUploading = false;
  bool _isDataUploadingToDB = false;
  bool _isGoogleLogin = false;
  int _currentIndexOfScreen = 2;

  setIsRegister(bool isRegister) {
    _isRegister = isRegister;
    notifyListeners();
  }

  setIsObscureText(bool isObscureText) {
    _isObscureText = isObscureText;
    notifyListeners();
  }

  setIsObscureIconVisible(bool isObscureIconVisible) {
    _isObscureIconVisible = isObscureIconVisible;
    notifyListeners();
  }

  setIsAllFieldCompleted(bool isAllFieldCompleted) {
    _isAllFieldCompleted = isAllFieldCompleted;
    notifyListeners();
  }

  setIsImageUploading(bool isImageUploading) {
    _isImageUploading = isImageUploading;
    notifyListeners();
  }

  setIsDataUploadingToDB(bool isDataUploadingToDB) {
    _isDataUploadingToDB = isDataUploadingToDB;
    notifyListeners();
  }

  setIsGoogleLogin(bool isGoogleLogin) {
    _isGoogleLogin = isGoogleLogin;
  }

  setCurrentIndexOfScreen(int currentIndexOfScreen) {
    _currentIndexOfScreen = currentIndexOfScreen;
    notifyListeners();
  }

  bool get isRegister => _isRegister;

  bool get isObscureText => _isObscureText;

  bool get isObscureIconVisible => _isObscureIconVisible;

  bool get isAllFieldCompleted => _isAllFieldCompleted;

  bool get isImageUploading => _isImageUploading;

  bool get isDataUploadingToDB => _isDataUploadingToDB;

  bool get isGoogleLogin => _isGoogleLogin;

  int get currentIndexOfScreen => _currentIndexOfScreen;
}
