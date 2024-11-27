#!/bin/bash

## Variáveis
AWS_REGION="us-east-1"
ECR_REPOSITORY_URI="123456789.dkr.ecr.$AWS_REGION.amazonaws.com"
IMAGE_FILE="image-names.txt"  # Arquivo com o nome das imagens


## Login no ECR
echo "Realizando login no ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPOSITORY_URI

## Executar docker PULL com o arquivo de imagens
while IFS= read -r IMAGE; do
  echo "Puxando a imagem $IMAGE..."
  docker pull "$ECR_REPOSITORY_URI/$IMAGE"
done < "$IMAGE_FILE"

echo "Pull das imagens concluído."
