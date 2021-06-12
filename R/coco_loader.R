
load_train_batch <- function(config)
{
  anno_path <- config$input_json

  annotations <- fromJSON(file = anno_path)
  image_path <- config$image_path
  if (length(image_path) <= 0)
  {
    tmp <- strsplit(anno_path, split = '/')
    lentmp <- length(tmp[[1]])
    list_tmp <- tmp[[1]][-c(lentmp, lentmp - 1)]
    anno_parent <- paste(list_tmp[[1]], collapse = "/");
    image_path <- sprintf("%s/%s%s", anno_parent, config$type, config$subtype)
  }


}

#img <- image_draw(img_magick)
#rect(20, 20, 200, 100, border = "red", lty = "dashed", lwd = 5)
#abline(h = 300, col = 'blue', lwd = '10', lty = "dotted")
#text(30, 250, "Hoiven-Glaven", family = "monospace", cex = 4, srt = 90)
#palette(rainbow(11, end = 0.9))
#symbols(rep(200, 11), seq(0, 400, 40), circles = runif(11, 5, 35),
#        bg = 1:11, inches = FALSE, add = TRUE)
#dev.off()
#
#image <- ocv_read(full_path)
#plot(image)

#library(keras)
cifar_demo <- function(){
# Parameters --------------------------------------------------------------

batch_size <- 32
epochs <- 200
data_augmentation <- TRUE


# Data Preparation --------------------------------------------------------

# See ?dataset_cifar10 for more info
cifar10 <- dataset_cifar10()

# Feature scale RGB values in test and train inputs  
x_train <- cifar10$train$x/255
x_test <- cifar10$test$x/255
y_train <- to_categorical(cifar10$train$y, num_classes = 10)
y_test <- to_categorical(cifar10$test$y, num_classes = 10)


# Defining Model ----------------------------------------------------------

# Initialize sequential model
model <- keras_model_sequential()

model %>%
 
  # Start with hidden 2D convolutional layer being fed 32x32 pixel images
  layer_conv_2d(
    filter = 32, kernel_size = c(3,3), padding = "same", 
    input_shape = c(32, 32, 3)
  ) %>%
  layer_activation("relu") %>%

  # Second hidden layer
  layer_conv_2d(filter = 32, kernel_size = c(3,3)) %>%
  layer_activation("relu") %>%

  # Use max pooling
  layer_max_pooling_2d(pool_size = c(2,2)) %>%
  layer_dropout(0.25) %>%
  
  # 2 additional hidden 2D convolutional layers
  layer_conv_2d(filter = 32, kernel_size = c(3,3), padding = "same") %>%
  layer_activation("relu") %>%
  layer_conv_2d(filter = 32, kernel_size = c(3,3)) %>%
  layer_activation("relu") %>%

  # Use max pooling once more
  layer_max_pooling_2d(pool_size = c(2,2)) %>%
  layer_dropout(0.25) %>%
  
  # Flatten max filtered output into feature vector 
  # and feed into dense layer
  layer_flatten() %>%
  layer_dense(512) %>%
  layer_activation("relu") %>%
  layer_dropout(0.5) %>%

  # Outputs from dense layer are projected onto 10 unit output layer
  layer_dense(10) %>%
  layer_activation("softmax")

opt <- optimizer_rmsprop(lr = 0.0001, decay = 1e-6)

model %>% compile(
  loss = "categorical_crossentropy",
  optimizer = opt,
  metrics = "accuracy"
)


# Training ----------------------------------------------------------------

if(!data_augmentation){
  
  model %>% fit(
    x_train, y_train,
    batch_size = batch_size,
    epochs = epochs,
    validation_data = list(x_test, y_test),
    shuffle = TRUE
  )
  
} else {
  
  datagen <- image_data_generator(
    rotation_range = 20,
    width_shift_range = 0.2,
    height_shift_range = 0.2,
    horizontal_flip = TRUE
  )
  
  datagen %>% fit_image_data_generator(x_train)
  
  model %>% fit_generator(
    flow_images_from_data(x_train, y_train, datagen, batch_size = batch_size),
    steps_per_epoch = as.integer(50000/batch_size), 
    epochs = epochs, 
    validation_data = list(x_test, y_test)
  )
  
}
}
