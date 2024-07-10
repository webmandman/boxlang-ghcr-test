FROM ortussolutions/boxlang:miniserver

RUN rm /app/* -r 

COPY ./ /app
