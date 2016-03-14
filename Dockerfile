FROM ubuntu:latest

RUN useradd -d /home/wolf -m wolf && usermod -a -G sudo wolf && echo "wolf ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER wolf

RUN sudo apt-get upgrade -y && sudo apt-get update -y && sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm tree htop git clang xz-utils vim

# Custom git additions
RUN wget -qO- https://gist.githubusercontent.com/julienwolflisberg/9fdb5e818528db849717/raw/2a32ae5fdfefd0f47064e9a7c2b85f1f26a0745f/custom_git_config.sh | bash

# INSTALL PYENV WITH MOST RECENT PYTHON INTERPRETERS FOR 2 AND 3
RUN cd ${HOME} ; git clone https://github.com/yyuu/pyenv.git ${HOME}/.pyenv && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ${HOME}/.bashrc && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ${HOME}/.bashrc && echo 'eval "$(pyenv init -)"' >> ${HOME}/.bashrc && export PYENV_ROOT="$HOME/.pyenv" && export PATH="$PYENV_ROOT/bin:$PATH" && eval "$(pyenv init -)" && pyenv install 2.7.11 && pyenv install 3.5.1 && pyenv global 2.7.11 3.5.1

# COMPILE AND INSTALL NODE.JS IN USERSPACE
# RUN cd ${HOME} ; wget -q https://nodejs.org/dist/v5.8.0/node-v5.8.0.tar.gz ; tar -zxf node-v5.8.0.tar.gz && rm node-v5.8.0.tar.gz && mkdir bin && cd node-* && ./configure  --prefix=${HOME}/bin/nodejs && make && make install && cd .. && rm -r node* && echo 'export PATH=${HOME}/bin/nodejs/bin:$PATH' >> ${HOME}/.bashrc && echo 'export NODE_PATH=${HOME}/bin/nodejs/lib/node_modules' >> ${HOME}/.bashrc && export PATH=${HOME}/bin/nodejs/bin:$PATH && export NODE_PATH=${HOME}/bin/nodejs/lib/node_modules
RUN cd ${HOME} && mkdir bin && wget -q https://nodejs.org/dist/v5.8.0/node-v5.8.0-linux-x64.tar.xz ; tar -xf node-*.tar.xz && rm node-*.tar.xz && mv node-* bin/nodejs && echo 'export PATH=${HOME}/bin/nodejs/bin:$PATH' >> ${HOME}/.bashrc && export PATH=${HOME}/bin/nodejs/bin:$PATH

# INSTALL BOWER
# Should not be necessary, use package.json instead
RUN export PATH=${HOME}/bin/nodejs/bin:$PATH && npm install -g bower grunt-cli

# SETTING HOST OPTIONS
RUN sed -i "s/#force_color_prompt/force_color_prompt/" ${HOME}/.bashrc

# INSTALL GIT PROMPT
RUN wget -q -O "${HOME}/.git-prompt.sh" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh && chmod +x ${HOME}/.git-prompt.sh && echo "source ${HOME}/.git-prompt.sh" | cat - ${HOME}/.bashrc > /tmp/out && mv /tmp/out ${HOME}/.bashrc && sed -r -i "s/PS1=(['\"])/PS1=\1\$(__git_ps1 \"(%s)\")/g" ${HOME}/.bashrc && echo "export GIT_PS1_SHOWDIRTYSTATE=1" >> ${HOME}/.bashrc && echo "export GIT_PS1_SHOWSTASHSTATE=1" >> ${HOME}/.bashrc && echo "export GIT_PS1_SHOWUNTRACKEDFILES=1" >> ${HOME}/.bashrc && echo "export GIT_PS1_SHOWUPSTREAM=\"auto\"" >> ${HOME}/.bashrc

RUN echo "cd ${HOME}" >> ${HOME}/.bashrc

CMD bash
