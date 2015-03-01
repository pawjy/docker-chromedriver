FROM debian:sid

RUN apt-get update
RUN apt-get -y install libglib2.0 libnss3-dev libxtst6 libxss1 libgconf-2-4 libfontconfig1 libpango1.0-0 libxcursor1 libxcomposite1 libasound2 libxdamage1 libxrandr2 libcups2 libgtk2.0-0 wget unzip libappindicator1 libcurl3 xdg-utils libexif12 xvfb fonts-noto

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb
RUN apt-get -f -y install
RUN sed -i 's/"$@"/"$@" --no-sandbox/' /opt/google/chrome/google-chrome

RUN wget -O /tmp/chromedriver-version http://chromedriver.storage.googleapis.com/LATEST_RELEASE
RUN wget http://chromedriver.storage.googleapis.com/`cat /tmp/chromedriver-version`/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip

RUN wget --no-check-certificate https://www.google.com/get/noto/pkgs/NotoSansCJKJP-hinted.zip
RUN unzip NotoSansCJKJP-hinted.zip
RUN mkdir -p usr/share/fonts/truetype/noto
RUN mv *.otf usr/share/fonts/truetype/noto/
RUN fc-cache

RUN echo "#!/bin/bash" > /cd
RUN echo 'Xvfb :0 -screen 0 1024x768x24 &' >> /cd
RUN echo 'DISPLAY=:0 /chromedriver --whitelisted-ips 0.0.0.0/0' >> /cd
RUN chmod u+x /cd

RUN echo "#!/bin/bash" > /cd-bare
RUN echo 'Xvfb :0 -screen 0 1024x768x24 &' >> /cd-bare
RUN echo 'DISPLAY=:0 /chromedriver "$*"' >> /cd-bare
RUN chmod u+x /cd-bare
