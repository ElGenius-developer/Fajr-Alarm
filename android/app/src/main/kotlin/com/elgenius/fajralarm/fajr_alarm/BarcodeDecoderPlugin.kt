package com.elgenius.fajralarm.fajr_alarm

import android.os.Handler
import android.os.Looper
import com.google.zxing.BarcodeFormat
import com.google.zxing.BinaryBitmap
import com.google.zxing.DecodeHintType
import com.google.zxing.MultiFormatReader
import com.google.zxing.NotFoundException
import com.google.zxing.PlanarYUVLuminanceSource
import com.google.zxing.common.HybridBinarizer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.RejectedExecutionException

/**
 * Pure FOSS ZXing barcode decoder exposed over `com.elgenius.fajralarm/barcode_decoder`.
 */
class BarcodeDecoderPlugin : MethodChannel.MethodCallHandler {
    private val mainHandler = Handler(Looper.getMainLooper())
    private val executor: ExecutorService = Executors.newSingleThreadExecutor()
    @Volatile
    private var isDisposed = false

    private val decodeHints: Map<DecodeHintType, Any> = mapOf(
        DecodeHintType.TRY_HARDER to true,
        DecodeHintType.POSSIBLE_FORMATS to listOf(
            BarcodeFormat.EAN_13,
            BarcodeFormat.EAN_8,
            BarcodeFormat.UPC_A,
            BarcodeFormat.UPC_E,
            BarcodeFormat.CODE_128,
            BarcodeFormat.CODE_39,
            BarcodeFormat.CODE_93,
            BarcodeFormat.ITF,
            BarcodeFormat.CODABAR,
            BarcodeFormat.QR_CODE,
            BarcodeFormat.DATA_MATRIX,
            BarcodeFormat.AZTEC,
            BarcodeFormat.PDF_417,
        ),
    )

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method != "decodeFrame") {
            result.notImplemented()
            return
        }
        if (isDisposed) {
            result.success(null)
            return
        }

        val bytes = call.argument<ByteArray>("bytes")
        val width = call.argument<Number>("width")?.toInt() ?: 0
        val height = call.argument<Number>("height")?.toInt() ?: 0
        val bytesPerRow = call.argument<Number>("bytesPerRow")?.toInt() ?: 0

        if (bytes == null || bytes.isEmpty() || width <= 0 || height <= 0 || bytesPerRow < width) {
            result.success(null)
            return
        }

        try {
            executor.execute {
                val decoded = decodeSafely(bytes, width, height, bytesPerRow)
                mainHandler.post {
                    result.success(decoded)
                }
            }
        } catch (_: RejectedExecutionException) {
            result.success(null)
        }
    }

    fun dispose() {
        isDisposed = true
        executor.shutdownNow()
    }

    private fun decodeSafely(
        bytes: ByteArray,
        width: Int,
        height: Int,
        bytesPerRow: Int,
    ): String? {
        val luminance = extractLuminance(bytes, width, height, bytesPerRow) ?: return null
        val reader = MultiFormatReader().apply { setHints(decodeHints) }
        return try {
            decodeLuminance(reader, luminance, width, height)
                ?: decodeLuminance(reader, rotateClockwise90(luminance, width, height), height, width)
        } finally {
            reader.reset()
        }
    }

    private fun decodeLuminance(
        reader: MultiFormatReader,
        luminance: ByteArray,
        width: Int,
        height: Int,
    ): String? {
        val source = PlanarYUVLuminanceSource(
            luminance,
            width,
            height,
            0,
            0,
            width,
            height,
            false,
        )
        val bitmap = BinaryBitmap(HybridBinarizer(source))
        return try {
            val text = reader.decodeWithState(bitmap).text?.trim()
            if (text.isNullOrEmpty()) null else text
        } catch (_: NotFoundException) {
            null
        } finally {
            reader.reset()
        }
    }

    /**
     * Compacts YUV luminance rows cleanly when CameraX provides stride padding or an unpadded tail row.
     */
    private fun extractLuminance(
        bytes: ByteArray,
        width: Int,
        height: Int,
        bytesPerRow: Int,
    ): ByteArray? {
        if (width <= 0 || height <= 0 || bytesPerRow < width || bytes.isEmpty()) {
            return null
        }
        val compact = ByteArray(width * height)
        for (row in 0 until height) {
            val srcOffset = row * bytesPerRow
            if (srcOffset >= bytes.size) break
            val copyLen = minOf(width, bytes.size - srcOffset)
            System.arraycopy(bytes, srcOffset, compact, row * width, copyLen)
        }
        return compact
    }

    private fun rotateClockwise90(
        luminance: ByteArray,
        width: Int,
        height: Int,
    ): ByteArray {
        val rotated = ByteArray(width * height)
        for (y in 0 until height) {
            val rowOffset = y * width
            val destCol = height - 1 - y
            for (x in 0 until width) {
                rotated[x * height + destCol] = luminance[rowOffset + x]
            }
        }
        return rotated
    }

    companion object {
        const val CHANNEL_NAME = "com.elgenius.fajralarm/barcode_decoder"
    }
}
