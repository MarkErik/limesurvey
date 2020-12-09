#!/bin/bash

ARG version='3.25.2+201131'

# 1. Check if .env file exists
if [ -e .env ]; then
    source .env
else 
    echo "Please set up your .env file before starting your environment."
    exit 1
fi

# 2. Create the data folder if it does not exist
mkdir -p data

# 3. Download the specified version of limesurvey
curl -sSL https://github.com/LimeSurvey/LimeSurvey/archive/$VERSION.tar.gz --output ./data/limesurvey.tar.gz

# 4. Extract the limesurvey executable
tar xzvf ./data/limesurvey.tar.gz --strip-components=1 -C ./data/limesurvey/source/

# 5. Remove the archive and other files not needed
rm -rf ./data/limesurvey.tar.gz ./data/limesurvey/source/docs ./data/limesurvey/source/tests ./data/limesurvey/source/*.md

# 6. Create the directory for storing the limesurvey runtime files
mkdir -p ./data/limesurvey/runtime

# 7. Download plugins
wget http://extensions.sondages.pro/IMG/auto/addScriptToQuestion.zip -P ./data/limesurvey/source/plugins/
unzip ./data/limesurvey/source/plugins/addScriptToQuestion.zip -d ./data/limesurvey/source/plugins/
rm ./data/limesurvey/source/plugins/addScriptToQuestion.zip

# 8. Set permissions
chown -R www-data:www-data ./data/limesurvey/;
find ./data/limesurvey/source/ -type d -exec chmod 755 {} \;
find ./data/limesurvey/source/ -type f -exec chmod 644 {} \;
find ./data/limesurvey/source/plugins/ -type d -exec chmod 750 {} \;
find ./data/limesurvey/source/plugins/ -type f -exec chmod 640 {} \;

# 9. Update local images
docker-compose pull

# 10. Start limesurvey
docker-compose up -d

exit 0