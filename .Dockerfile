FROM ubuntu:18.04

COPY ./scripts/* .

# I should set up an ENV variable for the location
ENV TZ=Africa/Casablanca
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Run the script
RUN ["bash", "script.sh"]

CMD ["ls"]
