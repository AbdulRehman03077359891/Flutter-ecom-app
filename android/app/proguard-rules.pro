-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider

# Firebase Firestore
-keepattributes Signature
-keepattributes *Annotation*
-keepclassmembers class com.yourpackage.** { *; }
-dontwarn com.google.firebase.**
-keep class com.google.firebase.** { *; }
