FROM caddy:2

ARG USER_ID=1000
ARG GROUP_ID=1000

# Install other missed extensions
RUN apk add \
      vim \
      curl \
      git \
      sudo \
      procps

# re-build www-data user with same user ID and group ID as a current host user (you)
RUN if getent passwd www-data ; then userdel -f www-data; fi && \
		if getent group www-data ; then groupdel www-data; fi && \
		addgroup --gid ${GROUP_ID} www-data && \
		adduser www-data --uid ${USER_ID} --ingroup www-data --home /home/www-data --shell /bin/bash --disabled-password && \
		mkdir -p /var/www && \
		chown -R www-data:www-data /var/www && \
		mkdir -p /home/www-data && \
		chown -R www-data:www-data /home/www-data

RUN echo 'alias ll="ls -al"' >> ~/.bashrc

COPY .docker /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
