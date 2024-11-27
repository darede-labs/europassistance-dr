#!/bin/bash

## Variáveis
ACCOUNT_ID="123456789"                                                                  # ID da conta AWS onde o repositório está
AWS_REGION="us-east-1"                                                                  # Região da conta AWS onde o repositório está
ECR_REPOSITORY="repo-teste"                                                             # Nome do repositório específico
ECR_REPOSITORY_URI="$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY"      # URI do repositório
IMAGE_FILE="image-names.txt"                                                            # Arquivo com os nomes das imagens

## Login no ECR
echo "Realizando login no ECR..."
aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
if [ $? -ne 0 ]; then                                                                   # Verificação no login 
    echo "Erro: Falha no login no ECR."
    exit 1
fi

## Verificar e criar repositório se não existir
aws ecr describe-repositories --repository-names "$ECR_REPOSITORY" --region "$AWS_REGION" >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Erro: Repositório '$ECR_REPOSITORY' não encontrado. Criando..."
    aws ecr create-repository --repository-name "$ECR_REPOSITORY" --region "$AWS_REGION"
fi

## Executar docker PUSH c/ o arquivo de imagens
while IFS= read -r IMAGEM; do
    echo "Processando imagem: $IMAGEM"

    # Verifica se a imagem existe localmente pelo nome simples
    if ! docker image inspect "$IMAGEM" >/dev/null 2>&1; then
        echo "Erro: Imagem '$IMAGEM' não encontrada localmente. Pulando..."
        continue
    fi

    # Cria uma tag única baseada no nome da imagem
    IMAGE_TAG=$(echo "$IMAGEM" | tr ":" "-") # Substitui ":" por "-" para tags válidas
    docker tag "$IMAGEM" "$ECR_REPOSITORY_URI:$IMAGE_TAG"
    if [ $? -ne 0 ]; then
        echo "Erro ao taguear a imagem '$IMAGEM'."
        continue
    fi

    # Fazendo o push
    docker push "$ECR_REPOSITORY_URI:$IMAGE_TAG"
    if [ $? -ne 0 ]; then
        echo "Erro ao fazer push da imagem '$IMAGEM'."
        continue
    fi
    echo "Imagem '$IMAGEM' enviada com sucesso como tag '$IMAGE_TAG'."
done < "$IMAGE_FILE"

echo "---------------------------------------------"
echo "Processo de push concluído com sucesso!"
echo "Repositório: $ECR_REPOSITORY_URI"
echo "---------------------------------------------"
