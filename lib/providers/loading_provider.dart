import 'package:flutter/material.dart';

class LoadingProvider with ChangeNotifier {
  bool _isRegister = true;
  bool _isObscureText = true;
  bool _isObscureIconVisible = false;
  bool _isAllFieldCompleted = false;
  bool _isImageUploading = false;
  bool _isDataUploadingToDB = false;
  bool _isGoogleLogin = false;

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

  get isRegister => _isRegister;
  get isObscureText => _isObscureText;
  get isObscureIconVisible => _isObscureIconVisible;
  get isAllFieldCompleted => _isAllFieldCompleted;
  get isImageUploading => _isImageUploading;
  get isDataUploadingToDB => _isDataUploadingToDB;
  get isGoogleLogin => _isGoogleLogin;
}
