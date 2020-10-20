dockerized_training

To run the container follow these instructions:

1. Build the docker container by running:
 docker build --no-cache --build-arg ssh_prv_key="$(cat keys/id_rsa)" --build-arg ssh_pub_key="$(cat keys/id_rsa.pub)" --tag api_test .

2. Run the docker image
 docker run --publish 8080:80 --name api_test api_test 

3. Specify the model you want to deploy using the config.json file

4. Copy the config.json file to the docker image using the command:
 docker cp models_list.json api_test:.

5. Run the pipeline with:
 docker exec -ti api_test sh deploy_ml.sh 

6. If everything was successfull the model will be deployed via a flask api though 0.0.0.0:8080/api/predict

config.json description

config.json is a file used to instruct the python script which models and versions of the models to deploy. N models can be deployed at the same time (keeping in mind A/B testing). The .json has the following fields

{
  "model1": {"model_tag": Specifies the name of the model to train (rf_clf/lnsvc_clf),
  "model_version":  Specifies the version (git commit) of the model to train}
}