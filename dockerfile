# Start from a specific, official WordPress image with PHP 8.2 and FPM on Alpine Linux
FROM wordpress:6.6.1-php8.2-fpm-alpine

# --- Apache Customizations ---
# Enable the Apache modules you need. You can add more here in the future.
RUN a2enmod headers ext_filter

# --- PHP Customizations ---
# Install the phpredis extension for high-performance Redis caching.
# This block installs build tools, compiles the extension, enables it, and then cleans up.
RUN set -ex; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS; \
    pecl install redis; \
    docker-php-ext-enable redis; \
    apk del .build-deps

# --- WordPress Plugin (Optional but Recommended) ---
# This uses the built-in WordPress CLI to automatically install the Redis plugin.
# This means you don't have to install it manually after deployment.
RUN wp plugin install redis-cache --activate --allow-root
