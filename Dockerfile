###### Composer ######
FROM composer:2.7.7 AS composer

###### PHP Base ######
FROM php:8.3.11-cli-alpine3.20 AS base-php-cli

WORKDIR /srv/app
COPY ./ /srv/app

RUN apk update && \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS && \
    apk add --no-cache \
        supervisor \
        bash \
        git \
        wget \
        zsh && \
    rm -rf /tmp/* /var/cache/apk/* && \
    apk del .build-deps

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/65a1e4edbe678cdac37ad96ca4bc4f6d77e27adf/tools/install.sh -O - | zsh
RUN echo 'export ZSH=/root/.oh-my-zsh' > ~/.zshrc \
    && echo 'ZSH_THEME="simple"' >> ~/.zshrc \
    && echo 'source $ZSH/oh-my-zsh.sh' >> ~/.zshrc \
    && echo 'PROMPT="%{$fg_bold[yellow]%}php:%{$fg_bold[blue]%}%(!.%0~.%~)%{$reset_color%} "' > ~/.oh-my-zsh/themes/simple.zsh-theme

RUN mkdir -p /etc/supervisor/conf.d /var/log/supervisor /var/run/supervisord
RUN chown -R www-data:www-data /etc/supervisor /var/log/supervisor /var/run/supervisord

COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY --from=composer /usr/bin/composer /usr/bin/composer

CMD ["./bash/entrypoint.sh"]

FROM base-php-cli AS dev-php-cli
