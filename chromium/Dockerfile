FROM debian:sid

RUN apt-get update && \
    apt-get -y install libglib2.0 libnss3-dev libxtst6 libxss1 libgconf-2-4 libfontconfig1 libpango1.0-0 libxcursor1 libxcomposite1 libasound2 libxdamage1 libxrandr2 libcups2 libgtk-3-0 wget unzip xvfb fonts-noto fonts-liberation libexif12 pulseaudio ffmpeg libgbm1 && \
    rm -rf /var/lib/apt/lists/* && \
    gpasswd -a root pulse-access && \
    cp /etc/pulse/system.pa /etc/pulse/system.pa.orig && \
    grep -v module-suspend-on-idle /etc/pulse/system.pa.orig > /etc/pulse/system.pa

RUN ln -s /lib/x86_64-linux-gnu/libudev.so.1 /lib/x86_64-linux-gnu/libudev.so.0

RUN wget -O /tmp/chrome-version https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2FLAST_CHANGE?alt=media && \
    wget -O chromium.zip https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F`cat /tmp/chrome-version`%2Fchrome-linux.zip?alt=media && \
    wget -O chromedriver_linux64.zip https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F`cat /tmp/chrome-version`%2Fchromedriver_linux64.zip?alt=media && \
    unzip chromium.zip && \
    mv chrome-linux/chrome_sandbox chrome-linux/chrome-sandbox && \
    chown root.root chrome-linux/chrome-sandbox && \
    chmod 4755 chrome-linux/chrome-sandbox && \
    unzip chromedriver_linux64.zip && \
    mv chromedriver_linux64/chromedriver / && \
    rm chromium.zip chromedriver_linux64.zip /tmp/chrome-version

RUN wget https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip && \
    unzip NotoSansCJKjp-hinted.zip && \
    mkdir -p usr/share/fonts/truetype/noto && \
    mv *.otf usr/share/fonts/truetype/noto/ && \
    fc-cache && \
    rm NotoSansCJKjp-hinted.zip

RUN sed -i 's/"$@"/"$@" --no-sandbox/' chrome-linux/chrome-wrapper && \
    ln -s /chrome-linux/chrome-wrapper /usr/bin/google-chrome

RUN echo "#!/bin/bash" > /cd && \
    echo 'exec /cd-bare --whitelisted-ips 0.0.0.0/0' >> /cd && \
    chmod u+x /cd

ADD cd-bare /cd-bare

CMD ["/cd"]
