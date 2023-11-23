FROM quay.io/wakaba/base:stable

RUN apt-get update && \
    apt-get -y install libglib2.0 libnss3-dev libxtst6 libxss1 libgconf-2-4 libfontconfig1 libpango1.0-0 libxcursor1 libxcomposite1 libasound2 libxdamage1 libxrandr2 libcups2 libgtk-3-0 curl unzip xvfb fonts-noto fonts-liberation libexif12 pulseaudio \
        ffmpeg libgbm1 libu2f-udev \
        libcurl4 xdg-utils lsb-release jq && \
    rm -rf /var/lib/apt/lists/* && \
    gpasswd -a root pulse-access && \
    cp /etc/pulse/system.pa /etc/pulse/system.pa.orig && \
    grep -v module-suspend-on-idle /etc/pulse/system.pa.orig > /etc/pulse/system.pa

RUN curl -f https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json > /tmp/chrome.json \
    curl -f `jq -r '.channels.Stable.downloads.chrome[] | select(.platform == "linux64").url' /tmp/chrome.json` > chrome.zip && \
    curl -f `jq -r '.channels.Stable.downloads.chrome[] | select(.platform == "linux64").url' /tmp/chrome.json` > chromedriver.zip && \
    unzip /tmp/chrome.zip && \
    mv chrome-linux64 /chrome && \
    sed -i 's/"$@"/"$@" --no-sandbox/' /chrome/chrome-wrapper && \
    ln -s /chrome/chrome-wrapper /usr/bin/google-chrome && \
    unzip /tmp/chromedriver.zip && \
    mv chromedriver-linux64 /chromedriver && \
    rm -f /tmp/chrome*

RUN curl -f https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip > /tmp/NotoSansCJKjp-hinted.zip && \
    mkdir -p usr/share/fonts/truetype/noto && \
    cd usr/share/fonts/truetype/noto && \
    unzip /tmp/NotoSansCJKjp-hinted.zip && \
    fc-cache && \
    rm /tmp/NotoSansCJKjp-hinted.zip

RUN echo "#!/bin/bash" > /cd && \
    echo 'exec /cd-bare --whitelisted-ips 0.0.0.0/0 --allowed-origins=*' >> /cd && \
    chmod u+x /cd

ADD cd-bare /cd-bare

CMD ["/cd"]
