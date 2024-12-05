# europassistance-dr
Repositório dedicado aos códigos do projeto de disaster recovery da Europ Assistance.

# Scripts para Gerenciar Imagens Docker no Amazon ECR 🐋

Este repositório contém shell scripts desenvolvidos para utilização em massa no Docker, podendo ser utilizados para enviar (push) e baixar (pull) imagens Docker de um repositório no Amazon ECR, sendo aplicável em cenários de multi-account.

---

## Pré-requisitos
1. **AWS CLI** configurado com credenciais válidas. [Guia rápido](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html).
2. **Docker** instalado na máquina. [Instale aqui](https://docs.docker.com/get-docker/).
3. Repositório de destino no Amazon ECR (se não tiver, o script de push cria um automáticamente).

---

## Alterando para seu uso
- Edite as variáveis no início dos scripts (`ACCOUNT_ID`, `AWS_REGION`, `ECR_REPOSITORY`, etc.) para refletirem o seu ambiente.
- Crie um arquivo chamado `.txt` listando os nomes das imagens que você quer enviar ou baixar do repositório.
