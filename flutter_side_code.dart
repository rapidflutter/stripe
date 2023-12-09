 /////// 1 main method code ///////


  Future<void> initPaymentSheet() async {
    try {
      DioClient dioClient = Get.find<DioClient>();
      Response response = await dioClient.insertWithBody('shop/payment-sheet', {});
      final data = await response.data;

      final paymentIntent = data['paymentIntent'];
      final ephemeralKey = data['ephemeralKey'];
      final customer = data['customer'];
      final publishableKey = data['publishableKey'];


      Stripe.publishableKey = publishableKey;
      BillingDetails billingDetails =  BillingDetails(
        address: Address(
          country: 'IN',
          city: '${Get.find<LoginController>().myShop.district}',
          line1: 'addr1',
          line2: 'addr2',
          postalCode: '680681',
          state: 'kerala',
          // Other address details
        ),
        // Other billing details
      );
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'MOBIZATE',
          paymentIntentClientSecret: paymentIntent,
          customerEphemeralKeySecret: ephemeralKey,
          customerId: customer,
          style: ThemeMode.light,
          billingDetails: billingDetails,
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'IN',
            currencyCode: 'inr',
            testEnv: true,
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet().then((value) {
        print('success');
      }).onError((error, stackTrace) {
        if (error is StripeException) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(content: Text('${error.error.localizedMessage}')),
          );
        } else {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(content: Text('Stripe Error: $error')),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Error initializing payment: $e')),
      );
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }




 /////// 2 call the method in your button event ///////



initPaymentSheet();


/////////  3 style sheet  ///////////


<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is off -->
    <style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             Flutter draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running.

         This Theme is only used starting with V2 of Flutter's Android embedding. -->
    <style name="NormalTheme" parent="Theme.MaterialComponents">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>



///////  4 build.gradle file code  add this code in your app/build.gradle ////////

dependencies {
    implementation 'com.google.android.gms:play-services-wallet:19.2.1'
    implementation 'com.stripe:stripe-android:20.34.4'
    def emoji2_version = "1.4.0"
    implementation("androidx.emoji2:emoji2:$emoji2_version")
    implementation("androidx.emoji2:emoji2-views:$emoji2_version")
    implementation("androidx.emoji2:emoji2-views-helper:$emoji2_version")
}

