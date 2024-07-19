# Base image
#FROM ubuntu:20.04

# Set environment variables to non-interactive
#ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
#RUN apt-get update && \
#    apt-get install -y wget gnupg software-properties-common && \
#    wget -qO- https://download.documentfoundation.org/libreoffice/stable/7.5.2/deb/x86_64/LibreOffice_7.5.2_Linux_x86-64_deb.tar.gz | tar xz -C /tmp/ && \
#    dpkg -i /tmp/LibreOffice_7.5.2.2_Linux_x86-64_deb/DEBS/*.deb && \
#    apt-get install -f && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download H2Orestart extension
#RUN wget -O /tmp/H2Orestart-0.6.6.oxt https://extensions.libreoffice.org/assets/downloads/2303/1720302570/H2Orestart-0.6.6.oxt

# Install H2Orestart extension
#RUN libreoffice --headless --norestore --nofirststartwizard --accept="socket,host=localhost,port=2002;urp;" --nodefault --nologo && \
#    unopkg add --shared /tmp/H2Orestart-0.6.6.oxt && \
#    pkill -f soffice

# Copy test files to the container
#COPY /path/to/your/files /test_files

# Expose port for LibreOffice
#EXPOSE 2002

# Set the default command
#CMD ["libreoffice", "--headless", "--norestore", "--nofirststartwizard", "--accept=socket,host=localhost,port=2002;urp;"]


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

# Create a script to run the LibreOffice headless service and keep the container running
RUN echo '#!/bin/bash\nlibreoffice --headless --norestore --nofirststartwizard --accept="socket,host=localhost,port=2002;urp;" --nodefault --nologo &\nsleep infinity' > /start_libreoffice.sh \
    && chmod +x /start_libreoffice.sh

# Create a script to convert hwp files to docx
RUN echo '#!/bin/bash\nfind /hwp_files -name "*.hwp" -exec libreoffice --headless --convert-to docx {} \\;' > /convert_hwp.sh \
    && chmod +x /convert_hwp.sh

# Start the LibreOffice service by default and keep the container running
CMD ["/start_libreoffice.sh"]
