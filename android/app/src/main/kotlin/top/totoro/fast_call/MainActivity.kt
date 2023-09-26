package top.totoro.fast_call

import android.content.Intent
import android.provider.ContactsContract
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {

    private val openCreateContacts = "top.totoro.fast_call/mainChannel";

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

        super.configureFlutterEngine(flutterEngine)

        try {
            // 注册打开联系人事件
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                openCreateContacts
            ).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->

                if (call.method.equals("openContacts")) {
                    val intent = Intent(Intent.ACTION_INSERT)
                    intent.type = ContactsContract.Contacts.CONTENT_TYPE

                    val name: String? = call.argument("name")
                    val mobile: String? = call.argument("mobile")

                    if (name != null) {
                        intent.putExtra(ContactsContract.Intents.Insert.NAME, name)
                    }
                    if (mobile != null) {
                        intent.putExtra(ContactsContract.Intents.Insert.PHONE, mobile)
                    }

                    context.startActivity(intent)

                    result.success(true)

                } else {
                    result.success(true)
                }

            }
        } catch (err: Exception) {
            //
        }
    }
}
