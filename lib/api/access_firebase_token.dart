import 'package:googleapis_auth/auth_io.dart';

class AccessFirebaseToken {
  static const String fMessagingScope =
      "https://www.googleapis.com/auth/firebase.messaging";

  Future<String> getAccessToken() async {
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        // PASTE YOUR GENERATED JSON FILE CONTENT HERE
        "type": "service_account",
        "project_id": "harisfirebase-bbce4",
        "private_key_id": "d0fe14605cb83b8346cd5e448d7db1fb7c41f2c5",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCpuWB5MUGPcbtR\nO6zXGmHxoQ4yGP2p0vUrG9qr5cd7nm7G8jGaNMwA7kpn/n+O9tHrgtLo0FO3mtW2\nMykSV+ooDxggBIgRWENNnDhA4Og90o8xXx2SF2xue+Ep8cMVBJTUS+f8Zckue9Hs\nD7hdE8xlwschphXDRPpj41DAAwIt3Psnbe0LilDp6sYASWBKOVLe0eaIli5ma2oE\nor9r3+1XjV6DF4nhT5uNdyEgwQNlDTSPSP+yTctmmPKYQ+xgB6cCMkdqush4sjly\n9KZcsHYOpF7SvAbLsumLM1n1UD2ARSHf5TIfeFXcQK8BCP4eu+hiEeXnFKTOVIAg\nFIQfsUuZAgMBAAECggEAOLl3uFmRh08kI1S2AhhTts20sGKw2OLkRNmk3oHIB5Ve\ngchtcpQFwKPjo1koKdBtPXC2a9BAwqMRnTkBF5vhay0MS5soHN/qcpRtKqXgiNUI\nPaCEAhEpEM3/ZaTjJfGnikKqUK12LT593Q8t95HH5RTRt/nJ2T8DDoJpORtoTYo6\nzza313H9db+pTaUk0AUwdbQkatvSgiBr1+nW2HiATkgFqzviiBRF/UKVUMpbsx+n\n0hHC0tvkmIhPIxLFQAH1hM5l75cF+yw6oOCVl/wk37lamHDeLscDSpKlebqBMJmm\nQZ8OdALGa/WQEcXGnDXibPsoAxpqP+wCS6PK8dU3rwKBgQDsCuf1lThKav6Veuk+\nABuyAdTBR0SEOhu8IEzp4yUmyMoSs/1zih2O8GcFQztbVRSH9kMxaTTNnwWgsAe7\noJz8tuYknYpghawnzune93gTq4D2KpX8+a33pKfAyjRCe9z0C8ysW/RFxo0alhfi\nb+3y62goH1Ql0EU8sYV0kzNj+wKBgQC4EwVcdXyZQqpmNdv+fQbrZwBDxATa7bsM\nS3t6GSBPBOXJcrFqZIKPB5DLa7wyajgXiXQsYBopHkIE0SK2pNAsBhKSUDa3b0FB\n5FVRLJjEnJSSEApU1fMtzfSL/HhUz+J2Z8/lC92Px/Se/zl/MQQ3kgFbk+mM8wkA\njDQWzismewKBgCMXT/q7j13I4EY6upgkDfn9ubJuNOpvdRYXuzd+NFS6vwfeyEw3\n+UL5zGcE4rsmP+Iio0SiPl5fSMflw5CKRSxwyHAjF6JX3QsiALTMF4bdFVQDar7s\nI4fQa7wGk5Ras7N4WZo6JWuGJA4SyEQ6naZiht6IIctpVhG61ntJMvenAoGAEdaO\nC3K7O2LxfmwzwIq/M+rMZMTHL6wgF0XtVly++8let1HtDYFmAZRbHMt49m3Ct80z\nO+WoQ1nSTgMyWP7Jyapg/FrXopkeetM0zWQD/fGqmCkDx0rggQzXaQVzZ8ypho3y\n4KBwvTFEbHARU1kdroDwrr47wNQAiFQN7DPYjKcCgYBwRFL6hM6DZlq+7Hgp855Q\n9VCLGFylPmC2YhzSaOhTiP5KaGqDsGXd/p2B1scphEy0p1DhksbKTic6E5GF6JB7\nWv71zSCA1zHbUmhjiwtRSRzlwAqdq8CrM4PnTGUeYanTpTG/3CUzw/4m3sr5aObL\nYEr5nNzl/cTzCGYNlhXBDw==\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-m1dmq@harisfirebase-bbce4.iam.gserviceaccount.com",
        "client_id": "104797853187112563931",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-m1dmq%40harisfirebase-bbce4.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      }),
      [fMessagingScope],
    );

    final accessToken = client.credentials.accessToken.data;
    return accessToken;
  }
}
