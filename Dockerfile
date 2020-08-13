ARG terraform_image_name

FROM $terraform_image_name

RUN apk add --update python3 py3-pip

RUN pip3 install boto3

RUN ln -s $(which python3) /usr/bin/python

ENTRYPOINT ["terraform"]