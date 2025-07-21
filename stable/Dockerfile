FROM pdc-base

WORKDIR /opt

# Clone the PDC repo and checkout stable branch
RUN git clone --branch stable https://github.com/hpc-io/pdc.git

WORKDIR /opt/pdc

# Copy your script from build context into the image
COPY ../build_and_test.sh /opt/pdc/build_and_test.sh

# Make script executable
RUN chmod +x /opt/pdc/build_and_test.sh

# Run the build and test script
CMD ["/opt/pdc/build_and_test.sh"]

