ARG terraform_image_name

FROM $terraform_image_name

RUN apk add --update py3-boto3

ENTRYPOINT ["terraform"]