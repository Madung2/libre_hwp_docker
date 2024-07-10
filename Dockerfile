# Base image
FROM ubuntu:20.04

# Set environment variables to non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages including LibreOffice and JRE
RUN apt-get update && \
    apt-get install -y wget gnupg software-properties-common openjdk-11-jre libreoffice && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download H2Orestart extension
RUN wget -O /tmp/H2Orestart-0.6.6.oxt https://extensions.libreoffice.org/assets/downloads/2303/1720302570/H2Orestart-0.6.6.oxt

# Install H2Orestart extension using unopkg
RUN libreoffice --headless --norestore --nofirststartwizard --accept="socket,host=localhost,port=2002;urp;" --nodefault --nologo & \
    sleep 10 && \
    unopkg add --shared /tmp/H2Orestart-0.6.6.oxt && \
    pkill -f soffice

# Copy test files to the container
COPY /hwp_files /hwp_files

# Expose port for LibreOffice
EXPOSE 2002

# Set the default command
#CMD ["libreoffice", "--headless", "--norestore", "--nofirststartwizard", "--accept=socket,host=localhost,port=2002;urp;"]
# Set the default command to convert hwp files to docx
CMD ["sh", "-c", "find /hwp_files -name '*.hwp' -exec libreoffice --headless --convert-to docx {} \\;"]
