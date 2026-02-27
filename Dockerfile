FROM alpine:3.19

# Install Postfix, SASL, and dependencies for regexp mapping
RUN apk add --no-cache postfix postfix-pcre cyrus-sasl ca-certificates tzdata
# Copy the initialization script
COPY entrypoint.sh /entrypoint.sh

# Expose standard SMTP port
EXPOSE 25

# Run the entrypoint
CMD ["/entrypoint.sh"]
