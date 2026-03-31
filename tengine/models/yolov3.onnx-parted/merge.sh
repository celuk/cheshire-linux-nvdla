# split -b 95M "yolov3.onnx" "yolov3.onnx.part-"
cat "yolov3.onnx.part-"* > "yolov3.onnx"
