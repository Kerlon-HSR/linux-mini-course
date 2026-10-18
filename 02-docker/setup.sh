#!/usr/bin/env bash
# ============================================================
#  setup.sh — Build e execução da imagem Docker
#  Exemplo didático do mini-curso "Demystifying Linux"
# ============================================================
#
#  O que este script faz:
#    1. Verifica se o Docker está instalado e acessível
#    2. Remove um container antigo (se existir)
#    3. Builda a imagem a partir do Dockerfile
#    4. Executa o container em background com a porta 8080
#       do host apontando para a porta 80 do container
#
#  Uso: ./setup.sh
#

# -e aborta no primeiro erro | -u aborta com variável indefinida
# -o pipefail considera erro em qualquer etapa da pipeline
set -euo pipefail

# ---------- Variáveis ---------------------------------------

IMAGEM="linux-course-app:1.0"
CONTAINER="linux-course-app"
# ${VAR:-padrao} usa o valor já definido (se houver) ou o padrão.
# Permite rodar assim: PORTA_HOST=8090 ./setup.sh
PORTA_HOST="${PORTA_HOST:-8080}"
PORTA_CONTAINER=80

# Diretório onde o próprio script está, para que o build funcione
# mesmo se o script for chamado de outra pasta.
#   BASH_SOURCE[0]  = caminho do script
#   dirname         = pasta que o contém
#   cd ... && pwd   = resolve para caminho absoluto (sem "./")
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------- Verificações ------------------------------------

# command -v procura o comando no PATH; >/dev/null esconde a saída
if ! command -v docker >/dev/null 2>&1; then
    echo "ERRO: docker não encontrado."
    echo "Instale com: sudo apt install docker.io"
    exit 1
fi

# docker info conversa com o daemon — falha se ele estiver parado
# ou se o usuário não tiver permissão de acesso
if ! docker info >/dev/null 2>&1; then
    echo "ERRO: não consegui falar com o daemon do Docker."
    echo "Dica: adicione seu usuário ao grupo docker e relogue:"
    echo "  sudo usermod -aG docker \$USER"
    exit 1
fi

# Verifica se a porta escolhida está livre no host.
# `ss -tln` lista portas TCP escutando; o grep procura a nossa porta.
if ss -tln | grep -q ":${PORTA_HOST} "; then
    echo "ERRO: a porta ${PORTA_HOST} já está em uso nesta máquina."
    echo "Descubra o que a ocupa com:  ss -tlnp | grep :${PORTA_HOST}"
    echo "Ou escolha outra porta:      PORTA_HOST=8090 ./setup.sh"
    exit 1
fi

# ---------- Build da imagem ---------------------------------

# Se já existir um container com esse nome (parado ou rodando),
# removemos antes para não conflitar na hora de criar outro novo
if docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER"; then
    echo ">> Removendo container antigo '${CONTAINER}'..."
    docker rm -f "$CONTAINER" >/dev/null
fi

echo ">> Buildando a imagem ${IMAGEM}..."
#   -t           dá o nome/tag à imagem
#   $SCRIPT_DIR  é o contexto do build (a pasta com Dockerfile e index.html)
docker build -t "$IMAGEM" "$SCRIPT_DIR"

# ---------- Execução ----------------------------------------

echo ">> Iniciando o container..."
#   -d            roda em background (detached)
#   -p host:cont  mapeia a porta: localhost:8080 -> container:80
#   --name        dá um nome amigável ao container
docker run -d -p "${PORTA_HOST}:${PORTA_CONTAINER}" --name "$CONTAINER" "$IMAGEM" >/dev/null

echo ""
echo "=============================================="
echo " Site no ar! Abra no navegador:"
echo "   http://localhost:${PORTA_HOST}"
echo "=============================================="
echo " Comandos úteis:"
echo "   docker ps                # ver o container rodando"
echo "   docker logs ${CONTAINER}     # ver os logs do nginx"
echo "   docker stop ${CONTAINER}     # parar o container"
echo "   docker rm ${CONTAINER}       # remover o container"
