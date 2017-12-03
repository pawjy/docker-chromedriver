FROM debian:sid

RUN apt-get update && \
    apt-get -y install libglib2.0 libnss3-dev libxtst6 libxss1 libgconf-2-4 libfontconfig1 libpango1.0-0 libxcursor1 libxcomposite1 libasound2 libxdamage1 libxrandr2 libcups2 libgtk-3-0 wget unzip xvfb fonts-noto fonts-liberation libexif12 \
        libappindicator1 libcurl3 xdg-utils && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb && \
    apt-get -f -y install && \
    sed -i 's/"$@"/"$@" --no-sandbox/' /opt/google/chrome/google-chrome && \
    rm -rf /var/lib/apt/lists/* google-chrome-stable_current_amd64.deb

RUN wget -O /tmp/chromedriver-version http://chromedriver.storage.googleapis.com/LATEST_RELEASE && \
    wget http://chromedriver.storage.googleapis.com/`cat /tmp/chromedriver-version`/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    rm /tmp/chromedriver-version chromedriver_linux64.zip

RUN wget https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip && \
    unzip NotoSansCJKjp-hinted.zip && \
    mkdir -p usr/share/fonts/truetype/noto && \
    mv *.otf usr/share/fonts/truetype/noto/ && \
    fc-cache && \
    rm NotoSansCJKjp-hinted.zip

RUN echo "#!/bin/bash" > /cd && \
    echo 'Xvfb :0 -screen 0 1024x768x24 &' >> /cd && \
    echo 'DISPLAY=:0 /chromedriver --whitelisted-ips 0.0.0.0/0' >> /cd && \
    chmod u+x /cd

RUN echo "#!/bin/bash" > /cd-bare && \
    echo 'Xvfb :0 -screen 0 1024x768x24 &' >> /cd-bare && \
    echo 'DISPLAY=:0 /chromedriver "$@"' >> /cd-bare && \
    chmod u+x /cd-bare

CMD ["/cd"]
