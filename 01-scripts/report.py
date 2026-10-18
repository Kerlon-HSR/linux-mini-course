#!/usr/bin/env python3
"""report.py — Gerador de relatório do sistema.

Exemplo didático do mini-curso "Demystifying Linux".

O que este script demonstra:
  1. Funções e organização do código
  2. Leitura de arquivos do sistema (/proc)
  3. Uso da biblioteca padrão (platform, os, shutil)
  4. Formatação de saída com f-strings

Uso: python3 report.py
"""

import os
import platform
import shutil


def ler_memoria():
    """Lê MemTotal e MemAvailable em kB direto de /proc/meminfo."""
    with open("/proc/meminfo") as arquivo:
        campos = {
            linha.split(":")[0]: int(linha.split()[1])
            for linha in arquivo
        }
    return campos["MemTotal"], campos["MemAvailable"]


def ler_uptime():
    """Lê o tempo ligado (uptime) de /proc/uptime e formata hh:mm."""
    with open("/proc/uptime") as arquivo:
        segundos = float(arquivo.read().split()[0])
    horas = int(segundos // 3600)
    minutos = int((segundos % 3600) // 60)
    return f"{horas}h {minutos}min"


def info_disco(caminho="/"):
    """ Retorna (total, usado, livre) em GB e percentual de uso. """
    total, usado, livre = shutil.disk_usage(caminho)
    gb = 1024 ** 3
    percentual = usado / total * 100
    return total / gb, usado / gb, livre / gb, percentual


def coletar_dados():
    """Reúne todas as informações do sistema num dicionário."""
    mem_total, mem_livre = ler_memoria()
    disco_total, disco_usado, disco_livre, disco_perc = info_disco()
    return {
        "hostname": platform.node(),
        "usuario": os.getlogin(),
        "sistema": f"{platform.system()} {platform.release()}",
        "distribuicao": platform.freedesktop_os_release().get("PRETTY_NAME", "desconhecida"),
        "arquitetura": platform.machine(),
        "cpus": os.cpu_count(),
        "memoria_total_gb": mem_total / 1024 ** 2,
        "memoria_livre_gb": mem_livre / 1024 ** 2,
        "disco_total_gb": disco_total,
        "disco_usado_gb": disco_usado,
        "disco_livre_gb": disco_livre,
        "disco_percentual": disco_perc,
        "uptime": ler_uptime(),
    }


def imprimir_relatorio(dados):
    """Imprime o relatório formatado no terminal."""
    print("=" * 50)
    print(" RELATÓRIO DO SISTEMA")
    print("=" * 50)
    print(f"Hostname:        {dados['hostname']}")
    print(f"Usuário:         {dados['usuario']}")
    print(f"Distribuição:    {dados['distribuicao']}")
    print(f"Kernel:          {dados['sistema']}")
    print(f"Arquitetura:     {dados['arquitetura']}")
    print(f"CPUs lógicas:    {dados['cpus']}")
    print(f"Tempo ligado:    {dados['uptime']}")
    print("-" * 50)
    print(
        f"Memória RAM:     {dados['memoria_livre_gb']:.1f} livres"
        f" de {dados['memoria_total_gb']:.1f} GB"
    )
    print(
        f"Disco (/):       {dados['disco_livre_gb']:.1f} livres"
        f" de {dados['disco_total_gb']:.1f} GB"
        f" ({dados['disco_percentual']:.0f}% usado)"
    )
    print("=" * 50)


def main():
    imprimir_relatorio(coletar_dados())


# Só executa o main quando o script é chamado diretamente
# (e não quando é importado por outro módulo)
if __name__ == "__main__":
    main()
