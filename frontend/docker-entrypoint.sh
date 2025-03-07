#!/bin/bash

if [ ! -d "node_modules" ]; then
    if [ ! -f "package.json" ]; then
        echo "Initializing new Angular project..."
        ng new sms-frontend \
            --routing=true \
            --style=scss \
            --skip-git \
            --directory=./ \
            --defaults \
            --skip-tests
    fi
    npm install
fi

ng serve --host 0.0.0.0 --port 4200
