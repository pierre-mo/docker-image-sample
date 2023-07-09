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
ARG USER=dev
USER root
RUN apt-get update && apt-get install -y sudp git wget gzip tar jq python3-pip
RUN pip install azure-cli==${AZURE_CLI_VERSION} poetry==${POETRY_VERSION} pre-commit==${PRE_COMMIT_VERSION}
RUN wget -qO- https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${TARGETOS}_${TARGETARCH}.zip | zcat >> /usr/local/bin/terraform && chmod +x /usr/local/bin/terraform
RUN wget -qO- https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz | tar -xz -C /usr/local/bin --exclude='*.md' --exclude 'LICENSE'
RUN wget -qO- https://github.com/aquasecurity/tfsec/releases/download/v$TFSEC_VERSION/tfsec_${TFSEC_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz | tar -xz -C /usr/local/bin
RUN wget -qO- https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_${TARGETOS}_${TARGETARCH}.zip | zcat >> /usr/local/bin/tflint && chmod +x /usr/local/bin/tflint
RUN wget -qO- https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_${TARGETOS}_${TARGETARCH} >> /usr/local/bin/terragrunt && chmod +x /usr/local/bin/terragrunt
RUN wget -qO- https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/powershell_${POWERSHELL_VERSION}-1.deb_${TARGETARCH}.deb >> powershell.deb && dpkg -i powershell.deb || apt-get install -f -y && rm powershell.deb
RUN wget -qO- https://github.com/microsoft/go-sqlcmd/releases/download/v${SQLCMD_VERSION}/sqlcmd-v${SQLCMD_VERSION}-${TARGETOS}-${TARGETARCH}.tar.bz2 | tar -xj -C /usr/local/bin --exclude='*.md'
RUN id ${USER} || adduser --disabled-password --gecos "" ${USER} && usermod -aG sudo ${USER}
USER $USER
