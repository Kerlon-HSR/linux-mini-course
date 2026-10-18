# ============================================================
#  Dockerfile — imagem com um site estático servido por nginx
#  Exemplo didático do mini-curso "Demystifying Linux"
# ============================================================

# FROM define a imagem base. nginx:alpine é o nginx oficial
# em Alpine Linux — pouquíssimo pesada (~20 MB).
FROM nginx:alpine

# LABEL adiciona metadados à imagem (bom para documentação)
LABEL description="Site de demonstracao do mini-curso Demystifying Linux"

# COPY copia um arquivo deste diretório para dentro da imagem.
# /usr/share/nginx/html é a pasta onde o nginx procura as páginas.
COPY index.html /usr/share/nginx/html/index.html

# EXPOSE apenas documenta a porta usada — não publica sozinho
EXPOSE 80

# CMD é o comando que roda quando o container inicia.
# "daemon off;" faz o nginx rodar em foreground, que é o
# comportamento correto para containers.
CMD ["nginx", "-g", "daemon off;"]
