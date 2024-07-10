# Base image
FROM ubuntu:20.04

# Set environment variables to non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages including JRE
RUN apt-get update && \
    apt-get install -y wget gnupg software-properties-common openjdk-11-jre && \
    wget -qO- https://download.documentfoundation.org/libreoffice/stable/7.5.2/deb/x86_64/LibreOffice_7.5.2_Linux_x86-64_deb.tar.gz | tar xz -C /tmp/ && \
    dpkg -i /tmp/LibreOffice_7.5.2.2_Linux_x86-64_deb/DEBS/*.deb || apt-get install -f -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download H2Orestart extension
RUN wget -O /tmp/H2Orestart-0.6.6.oxt https://extensions.libreoffice.org/assets/downloads/2303/1720302570/H2Orestart-0.6.6.oxt

# Install H2Orestart extension using unopkg
RUN /opt/libreoffice7.5/program/soffice --headless --norestore --nofirststartwizard --accept="socket,host=localhost,port=2002;urp;" --nodefault --nologo & \
    sleep 10 && \
    /opt/libreoffice7.5/program/unopkg add --shared /tmp/H2Orestart-0.6.6.oxt && \
    pkill -f soffice

# Copy test files to the container
COPY /hwp_files /hwp_files

# Expose port for LibreOffice
EXPOSE 2002

# Set the default command
CMD ["/opt/libreoffice7.5/program/soffice", "--headless", "--norestore", "--nofirststartwizard", "--accept=socket,host=localhost,port=2002;urp;"]
