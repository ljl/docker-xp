# Base image
FROM enonic/java8

ENV XP_ROOT /server
ENV XP_HOME /xp-home

# Install other software
RUN apt-get -y install wget unzip

# Adding Enonic xp user
ADD launcher.sh /launcher.sh
RUN chmod +x /launcher.sh

# Expose volume
VOLUME /xp-home

# Exposing web port, debug port and telnet port
EXPOSE 8080 5005 5555

CMD /launcher.sh
