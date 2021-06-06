
annotations <- fromJSON(file = '/dataset/coco-2017/annotations/instances_train2017.json')
image_path <- '/dataset/coco-2017/train2017'
full_path <- sprintf("%s/%012d.jpg", image_path, annotations$annotations[[1]]$image_id)

image <- ocv_read(full_path)
plot(image)
