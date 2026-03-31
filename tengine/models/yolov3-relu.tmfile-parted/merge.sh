# split -b 95M "yolov3-relu.tmfile" "yolov3-relu.tmfile.part-"
cat "yolov3-relu.tmfile.part-"* > "yolov3-relu.tmfile"
