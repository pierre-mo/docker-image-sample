ARG BASE_IMAGE=ubuntu:22.04
FROM $BASE_IMAGE
ARG AZURE_CLI_VERSION=2.50.0
ARG POETRY_VERSION=1.5.1
ARG PRE_COMMIT_VERSION=3.3.3
ARG TERRAFORM_VERSION=1.5.2
ARG TERRAFORM_DOCS_VERSION=0.16.0
ARG TFSEC_VERSION=1.28.1
ARG TFLINT_VERSION=0.47.0
ARG TERRAGRUNT_VERSION=0.48.1
ARG POWERSHELL_VERSION=7.3.5
ARG SQLCMD_VERSION=1.2.0

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETOS
ARG TARGETARCH
RUN [ "$EUID" -eq 0 ] && apt-get -y install sudo
RUN sudo apt-get update && apt-get install -y git wget gzip bzip2 tar jq python3-pip
RUN sudo pip install azure-cli==${AZURE_CLI_VERSION} poetry==${POETRY_VERSION} pre-commit==${PRE_COMMIT_VERSION}
RUN wget -qO- https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${TARGETOS}_${TARGETARCH}.zip | zcat | sudo tee /usr/local/bin/terraform > /dev/null && sudo chmod +x /usr/local/bin/terraform
RUN wget -qO- https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz | sudo tar -xz -C /usr/local/bin --exclude='*.md' --exclude 'LICENSE'
RUN wget -qO- https://github.com/aquasecurity/tfsec/releases/download/v$TFSEC_VERSION/tfsec_${TFSEC_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz | sudo tar -xz -C /usr/local/bin
RUN wget -qO- https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_${TARGETOS}_${TARGETARCH}.zip | zcat | sudo tee /usr/local/bin/tflint > /dev/null && sudo chmod +x /usr/local/bin/tflint
RUN wget -qO- https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_${TARGETOS}_${TARGETARCH} | sudo tee /usr/local/bin/terragrunt > /dev/null && sudo chmod +x /usr/local/bin/terragrunt
RUN wget -qO- https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/powershell_${POWERSHELL_VERSION}-1.deb_${TARGETARCH}.deb >> powershell.deb && sudo dpkg -i powershell.deb || sudo apt-get install -f -y && rm powershell.deb
RUN wget -qO- https://github.com/microsoft/go-sqlcmd/releases/download/v${SQLCMD_VERSION}/sqlcmd-v${SQLCMD_VERSION}-${TARGETOS}-${TARGETARCH}.tar.bz2 | sudo tar -xj -C /usr/local/bin --exclude='*.md'
