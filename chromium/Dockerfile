FROM debian:sid

RUN apt-get update
RUN apt-get -y install libglib2.0 libnss3-dev libxtst6 libxss1 libgconf-2-4 libfontconfig1 libpango1.0-0 libxcursor1 libxcomposite1 libasound2 libxdamage1 libxrandr2 libcups2 libgtk2.0-0 wget unzip libexif12 xvfb fonts-noto

RUN ln -s /lib/x86_64-linux-gnu/libudev.so.1 /lib/x86_64-linux-gnu/libudev.so.0

RUN wget -O chromium.zip https://download-chromium.appspot.com/dl/Linux_x64
RUN unzip chromium.zip
RUN mv chrome-linux/chrome_sandbox chrome-linux/chrome-sandbox
RUN chown root.root chrome-linux/chrome-sandbox
RUN chmod 4755 chrome-linux/chrome-sandbox

RUN wget -O /tmp/chromedriver-version http://chromedriver.storage.googleapis.com/LATEST_RELEASE
RUN wget http://chromedriver.storage.googleapis.com/`cat /tmp/chromedriver-version`/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip

RUN wget --no-check-certificate https://www.google.com/get/noto/pkgs/NotoSansCJKJP-hinted.zip
RUN unzip NotoSansCJKJP-hinted.zip
RUN mkdir -p usr/share/fonts/truetype/noto
RUN mv *.otf usr/share/fonts/truetype/noto/
RUN fc-cache

RUN sed -i 's/"$@"/"$@" --no-sandbox/' chrome-linux/chrome-wrapper
RUN ln -s /chrome-linux/chrome-wrapper /usr/bin/google-chrome

RUN echo "#!/bin/bash" > /cd
RUN echo 'Xvfb :0 -screen 0 1024x768x24 &' >> /cd
RUN echo 'DISPLAY=:0 /chromedriver --whitelisted-ips 0.0.0.0/0' >> /cd
RUN chmod u+x /cd

RUN echo "#!/bin/bash" > /cd-bare
RUN echo 'Xvfb :0 -screen 0 1024x768x24 &' >> /cd-bare
RUN echo 'DISPLAY=:0 /chromedriver "$*"' >> /cd-bare
RUN chmod u+x /cd-bare
