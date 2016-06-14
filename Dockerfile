FROM ubuntu:latest

RUN apt-get update && apt-get install sudo wget sed grep -y

RUN useradd -d /home/wolf -m wolf && usermod -a -G sudo wolf && echo "wolf ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER wolf

RUN sudo apt-get upgrade -y && sudo apt-get update -y && sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm tree htop git clang xz-utils vim lnav

# Custom git additions
RUN wget -qO- https://gist.githubusercontent.com/julienwolflisberg/9fdb5e818528db849717/raw/2a32ae5fdfefd0f47064e9a7c2b85f1f26a0745f/custom_git_config.sh | bash

# INSTALL PYENV WITH MOST RECENT PYTHON INTERPRETERS FOR 2 AND 3
RUN PYTHON2VERSION=$(wget -q -O - https://www.python.org/downloads/source/ | grep "Latest Python 2" | sed -E "s/.*Python (2\.[^<]+).*/\1/gm") ; PYTHON3VERSION=$(wget -q -O - https://www.python.org/downloads/source/ | grep "Latest Python 3" | sed -E "s/.*Python (3\.[^<]+).*/\1/gm") ; cd ${HOME} ; git clone https://github.com/yyuu/pyenv.git ${HOME}/.pyenv && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ${HOME}/.bashrc && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ${HOME}/.bashrc && echo 'eval "$(pyenv init -)"' >> ${HOME}/.bashrc && export PYENV_ROOT="$HOME/.pyenv" && export PATH="$PYENV_ROOT/bin:$PATH" && eval "$(pyenv init -)" && pyenv install $PYTHON2VERSION && pyenv install $PYTHON3VERSION && pyenv global $PYTHON2VERSION $PYTHON3VERSION && pip install -U pip

# COMPILE AND INSTALL NODE.JS IN USERSPACE
# RUN NODEJSVERSION=$(wget -q -O - https://nodejs.org/en/download/current/ | grep -E "<strong>v[0-9]+[^<]*</strong>" | sed -E "s/.*v([0-9]\.[^<]+).*/\1/gm") ; cd ${HOME} ; wget -q https://nodejs.org/dist/v$NODEJSVERSION/node-v$NODEJSVERSION.tar.gz ; tar -zxf node-v$NODEJSVERSION.tar.gz && rm node-v$NODEJSVERSION.tar.gz && mkdir bin && cd node-* && ./configure  --prefix=${HOME}/bin/nodejs && make && make install && cd .. && rm -r node* && echo 'export PATH=${HOME}/bin/nodejs/bin:$PATH' >> ${HOME}/.bashrc && echo 'export NODE_PATH=${HOME}/bin/nodejs/lib/node_modules' >> ${HOME}/.bashrc && export PATH=${HOME}/bin/nodejs/bin:$PATH && export NODE_PATH=${HOME}/bin/nodejs/lib/node_modules
RUN NODEJSVERSION=$(wget -q -O - https://nodejs.org/en/download/current/ | grep -E "<strong>v[0-9]+[^<]*</strong>" | sed -E "s/.*v([0-9]\.[^<]+).*/\1/gm") ; cd ${HOME} && mkdir bin && wget -q https://nodejs.org/dist/v$NODEJSVERSION/node-v$NODEJSVERSION-linux-x64.tar.xz ; tar -xf node-*.tar.xz && rm node-*.tar.xz && mv node-* bin/nodejs && echo 'export PATH=${HOME}/bin/nodejs/bin:$PATH' >> ${HOME}/.bashrc && export PATH=${HOME}/bin/nodejs/bin:$PATH

# INSTALL BOWER & GRUNT
# Should not be necessary, use package.json instead
RUN export PATH=${HOME}/bin/nodejs/bin:$PATH && npm install -g bower grunt-cli

# SETTING HOST OPTIONS
RUN sed -i "s/#force_color_prompt/force_color_prompt/" ${HOME}/.bashrc

# INSTALL GIT PROMPT
RUN wget -q -O "${HOME}/.git-prompt.sh" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh && chmod +x ${HOME}/.git-prompt.sh && echo "source ${HOME}/.git-prompt.sh" | cat - ${HOME}/.bashrc > /tmp/out && mv /tmp/out ${HOME}/.bashrc && sed -r -i "s/PS1=(['\"])/PS1=\1\$(__git_ps1 \"(%s)\")/g" ${HOME}/.bashrc && echo "export GIT_PS1_SHOWDIRTYSTATE=1" >> ${HOME}/.bashrc && echo "export GIT_PS1_SHOWSTASHSTATE=1" >> ${HOME}/.bashrc && echo "export GIT_PS1_SHOWUNTRACKEDFILES=1" >> ${HOME}/.bashrc && echo "export GIT_PS1_SHOWUPSTREAM=\"auto\"" >> ${HOME}/.bashrc

RUN echo "cd ${HOME}" >> ${HOME}/.bashrc

# Cleanup
RUN sudo apt-get clean && sudo apt-get autoremove

CMD bash
