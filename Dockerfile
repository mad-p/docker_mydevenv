FROM mad-p/rails

MAINTAINER Kaoru Maeda <kaoru.maeda@gmail.com> mad-p

# setup sshd
RUN mkdir /var/run/sshd
ADD sshd/sshd_config /etc/ssh/sshd_config

# generate locales
RUN locale-gen en_US.UTF-8 ja_JP.UTF-8
RUN bash -c 'LANG=en_US.UTF-8 update-locale'

# create user
RUN useradd maeda
RUN bash -c 'echo "maeda:maeda" | chpasswd'
RUN mkdir -p /home/maeda/.ssh
ADD sshd/authorized_keys /home/maeda/.ssh/authorized_keys
ADD sshd/known_hosts /home/maeda/.ssh/known_hosts
RUN chown -R maeda /home/maeda; chmod 700 /home/maeda/.ssh;chmod 600 /home/maeda/.ssh/authorized_keys
RUN chsh -s /usr/bin/zsh maeda

# setup sudoers
RUN echo "maeda ALL=(ALL) ALL" >> /etc/sudoers.d/maeda; chmod 440 /etc/sudoers.d/maeda

# install emacs23 and curl
RUN add-apt-repository ppa:cassou/emacs
RUN apt-get update -y
RUN apt-get install -y emacs23 curl

CMD /usr/sbin/sshd -D
EXPOSE 2222
