#!/usr/bin/env bash
# ============================================================
#  log-report.sh — Gerador e analisador de logs
#  Exemplo didático do mini-curso "Demystifying Linux"
# ============================================================
#
#  O que este script demonstra:
#    1. Variáveis, arrays e interpolação de strings
#    2. Funções (definição e chamada)
#    3. Laços (for) e condicionais (if/elif)
#    4. Pipelines clássicas: grep, awk, sort, uniq, wc, cut
#
#  O que ele faz na prática:
#    Passo 1 — gera um arquivo de log falso (access.log) simulando
#              requisições a um site
#    Passo 2 — analisa esse arquivo e imprime um relatório
#
#  Uso: ./log-report.sh
#

# `set -euo pipefail` deixa o script mais seguro:
#   -e         aborta no primeiro erro encontrado
#   -u         aborta se alguma variável não estiver definida
#   -o pipefail  considera erro em QUALQUER etapa da pipeline
set -euo pipefail

# ---------- Variáveis globais -------------------------------

ARQUIVO_LOG="access.log"
NUM_ENTRADAS=500

# Arrays com exemplos de dados para o log falso
IPS=(10.0.0.15 10.0.0.23 192.168.1.42 172.16.0.7 203.0.113.9)
PAGINAS=("/index.html" "/login" "/produtos" "/api/v1/users" "/imagens/logo.png")

# ---------- Funções -----------------------------------------

# Retorna um elemento aleatório de um array.
# Uso: sorteia elem1 elem2 elem3 ...
sorteia() {
    local elementos=("$@")
    echo "${elementos[$((RANDOM % ${#elementos[@]}))]}"
}

# Passo 1: gera o arquivo de log falso
gerar_log() {
    echo ">> Gerando ${NUM_ENTRADAS} requisições falsas em ${ARQUIVO_LOG}..."
    : >"$ARQUIVO_LOG" # `:` é o "comando true": cria/trunca o arquivo vazio

    for ((i = 1; i <= NUM_ENTRADAS; i++)); do
        ip=$(sorteia "${IPS[@]}")
        pagina=$(sorteia "${PAGINAS[@]}")

        # Sorteia o código HTTP com pesos:
        #   70% -> 200 (OK) | 20% -> 404 (não encontrado) | 10% -> 500 (erro)
        sorteio=$((RANDOM % 10))
        if ((sorteio < 7)); then
            codigo=200
        elif ((sorteio < 9)); then
            codigo=404
        else
            codigo=500
        fi

        hora=$((RANDOM % 24))
        minuto=$((RANDOM % 60))

        # printf monta cada linha no formato de um log de web server:
        # 10.0.0.15 - - [18/Oct/2026:07:23:00] "GET /login" 404 4321
        printf '%s - - [18/Oct/2026:%02d:%02d:00] "GET %s" %s 4321\n' \
            "$ip" "$hora" "$minuto" "$pagina" "$codigo" >>"$ARQUIVO_LOG"
    done
}

# Passo 2: relatório — total de requisições
relatorio_total() {
    # `wc -l` conta linhas; `<` redireciona a leitura do arquivo
    local total
    total=$(wc -l <"$ARQUIVO_LOG")
    echo "Total de requisições: ${total}"
}

# Passo 2: relatório — requisições por código HTTP
relatorio_codigos() {
    echo ""
    echo "Requisições por código HTTP:"
    # `$(NF-1)` no awk = penúltimo campo da linha (o código HTTP)
    for codigo in 200 404 500; do
        local quantidade
        quantidade=$(awk -v cod="$codigo" '$(NF - 1) == cod {n++} END {print n + 0}' "$ARQUIVO_LOG")
        printf '  %s: %s\n' "$codigo" "$quantidade"
    done
}

# Passo 2: relatório — top 5 IPs mais ativos
relatorio_top_ips() {
    echo ""
    echo "Top 5 IPs mais ativos:"
    # Pipeline explicada passo a passo:
    #   awk   '{print $1}'  -> extrai o 1º campo (o IP)
    #   sort                 -> ordena alfabeticamente
    #   uniq -c              -> conta ocorrências iguais adjacentes
    #   sort -rn             -> reordena pelo número, decrescente
    #   head -5              -> fica só com os 5 primeiros
    awk '{print $1}' "$ARQUIVO_LOG" \
        | sort \
        | uniq -c \
        | sort -rn \
        | head -5
}

# Passo 2: relatório — erros 500 distribuídos por hora
relatorio_erros_por_hora() {
    echo ""
    echo "Erros 500 por hora do dia:"
    # `{ ...; }` agrupa o grep para que o `|| true` valha para a
    # pipeline inteira — assim o set -e não aborta o script caso
    # não exista nenhum erro 500 no log.
    # `cut -d: -f2` extrai a hora de [18/Oct/2026:07:23:00]
    { grep ' 500 ' "$ARQUIVO_LOG" || true; } \
        | cut -d: -f2 \
        | sort \
        | uniq -c \
        | sort -k2 -n
}

# ---------- Fluxo principal ---------------------------------

main() {
    echo "=============================================="
    echo " Analisador de logs — relatório"
    echo "=============================================="

    gerar_log

    echo ""
    relatorio_total
    relatorio_codigos
    relatorio_top_ips
    relatorio_erros_por_hora

    echo ""
    echo ">> Log completo disponível em: $(pwd)/${ARQUIVO_LOG}"
}

# `"$@"` repassa os argumentos recebidos pelo script para o main
main "$@"
