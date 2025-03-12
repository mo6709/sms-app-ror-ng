# README
The Docker-built application consists of two separate services that will be executed within the same container. 

You will need to add your own environment variables in the `.env` file.
TWILIO_ACCOUNT_SID=
TWILIO_AUTH_TOKEN=
TWILIO_PHONE_NUMBER=
DEVISE_JWT_SECRET_KEY=
BASE_URL=


RUN docker-compose build 
RUN docker-compose up

backend on `baseurl/api/v1/auth/login`
fornt end on `baseurl/login`
