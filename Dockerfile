FROM tiangolo/uwsgi-nginx-flask:python3.8

ARG ssh_prv_key
ARG ssh_pub_key

WORKDIR /

COPY requirements.txt .
#COPY deploy_ml.sh .
RUN pip install -r requirements.txt

#Install git and download repositories
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    apt-get install -y emacs

# add credentials on build
RUN mkdir -p ~/.ssh && \
    chmod 0700 ~/.ssh


# Add the keys and set permissions
RUN echo "$ssh_prv_key" > ~/.ssh/id_rsa && \
    echo "$ssh_pub_key" > ~/.ssh/id_rsa.pub && \
    chmod 600 ~/.ssh/id_rsa && \
    chmod 600 ~/.ssh/id_rsa.pub


# make sure your domain is accepted
RUN touch ~/.ssh/known_hosts
RUN ssh-keyscan -t rsa github.com | tee github-key-temp | ssh-keygen -lf -
RUN cat github-key-temp >> ~/.ssh/known_hosts

#Clone repos
RUN git clone git@github.com:dlaredorazo/ml_api.git
RUN git clone git@github.com:dlaredorazo/models_and_data.git

RUN rm -rf app
RUN mv ml_api app
RUN cp app/deploy_ml.sh .
RUN mkdir app/web_app/LogFiles
