package ardrawing.sketch.paint
//
import android.os.Bundle
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
//import org.opencv.android.OpenCVLoader
//import org.opencv.core.Core
//import org.opencv.core.CvType
//import org.opencv.core.Imgproc
//import org.opencv.core.Mat
//import org.opencv.imgcodecs.Imgcodecs
//import org.opencv.imgproc.Imgproc
//import java.io.ByteArrayOutputStream
//
class MainActivity : FlutterActivity()
//    , FlutterPlugin ,
//    ActivityAware {
//    private var flutterEngine: FlutterEngine? = null
//    private var activityPluginBinding: ActivityPluginBinding? = null
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        this.flutterEngine = flutterEngine
//    }
//
//    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
//        val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "your_method_channel")
//        channel.setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
//            if (call.method == "convertToLineArt") {
//                val filePath = call.argument<String>("filePath")
//                if (filePath != null) {
//                    val lineArtData = convertToLineArt(filePath)
//                    if (lineArtData != null) {
//                        result.success(lineArtData)
//                    } else {
//                        result.error(
//                            "CONVERSION_FAILED",
//                            "Failed to convert image to line art",
//                            null
//                        )
//                    }
//                } else {
//                    result.error("INVALID_ARGUMENT", "File path is null", null)
//                }
//            } else {
//                result.notImplemented()
//            }
//        }
//    }
//
//    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
//        TODO("Not yet implemented")
//    }
//
//    private fun convertToLineArt(filePath: String): ByteArray? {
//        if (!OpenCVLoader.initDebug()) {
//            Log.e(TAG, "Error initializing OpenCV!")
//            return null
//        }
//        val image: Mat = Imgcodecs.imread(filePath, Imgcodecs.IMREAD_GRAYSCALE) // Load in grayscale
//
//        // Apply Canny edge detection (adjust parameters as needed)
//        val edges = Mat()
//        Imgproc.Canny(image, edges, 50.0, 150.0)
//
//        // Optional: Morphological operations for noise removal (adjust parameters)
//        val kernel: Mat = Mat.ones(3, 3, CvType.CV_8U)
//        Imgproc.morphologyEx(edges, edges, Imgproc.MORPH_CLOSE, kernel)
//
//        // Invert the image for clearer line art
//        Core.bitwise_not(edges, edges)
//
//        // Convert to PNG with transparency channel
//        val rgba = Mat()
//        Imgproc.cvtColor(edges, rgba, Imgproc.COLOR_GRAY2RGBA) // Convert to RGBA for transparency
//        val byteArrayOutputStream = ByteArrayOutputStream()
//        Imgcodecs.imencode(".png", rgba, byteArrayOutputStream)
//        return byteArrayOutputStream.toByteArray()
//    }
//
//    fun onActivityCreated(activityPluginBinding: ActivityPluginBinding?) {
//        this.activityPluginBinding = activityPluginBinding
//    }
//
//    fun onActivityDestroyed() {
//        activityPluginBinding = null
//    }
//
//    fun onActivitySaveInstanceState(
//        activityPluginBinding: ActivityPluginBinding?,
//        outState: Bundle?
//    ) {
//    }
//
//    companion object {
//        private const val TAG = "LineArtPlugin"
//    }
//
//    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
//        TODO("Not yet implemented")
//    }
//
//    override fun onDetachedFromActivityForConfigChanges() {
//        TODO("Not yet implemented")
//    }
//
//    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
//        TODO("Not yet implemented")
//    }
//
//    override fun onDetachedFromActivity() {
//        TODO("Not yet implemented")
//    }
//}
