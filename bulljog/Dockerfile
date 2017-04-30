FROM sagemath/sagemath

RUN sudo apt-get update && sudo apt-get -y dist-upgrade
RUN sudo apt-get install -y xinetd python3 dos2unix netcat vim

WORKDIR /home/bulljog
ENV HOME /home/bulljog
RUN sudo chown sage .
ADD bulljog.sage /home/bulljog/
ADD nsa.py /home/bulljog/
ADD flag.txt /home/bulljog/
ADD run.sh /home/bulljog/
RUN sudo chmod a+x /home/bulljog/run.sh
RUN sudo dos2unix /home/bulljog/*

ADD bulljog.xinetd /etc/xinetd.d/bulljog
RUN sudo dos2unix /etc/xinetd.d/bulljog
RUN  echo "bulljog         11344/tcp" | sudo tee --append /etc/services

RUN service xinetd restart

RUN sudo chown -R sage:sage .

EXPOSE 11344

CMD service xinetd restart && sleep infinity
