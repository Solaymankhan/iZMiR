import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../consts/consts.dart';
import '../shapes/snack_bar.dart';
class phone_auth_controller extends GetxController{

  final _auth=FirebaseAuth.instance;
  var verificationId="".obs;
  late BuildContext context;
  var input_otp="".obs;

  @override
  void onInit() {
    input_otp.value="";
    super.onInit();
  }


  Future<void> phone_auth(String phone_number) async{
    await _auth.verifyPhoneNumber(
      phoneNumber: phone_number,
        verificationCompleted: (credential) async{
        await _auth.signInWithCredential(credential);
        },
        verificationFailed: (e){
          show_snackbar(context, e.message, whiteColor, Colors.red);
        },
        codeSent: (verificationId,resendToken){
        this.verificationId.value=verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId){
          this.verificationId.value=verificationId;
        },
    );
  }

}