#! /bin/sh

WORKSPACE=/home/dataqube/repository
PACKAGE=${WORKSPACE}/${DIST_FOLDER_NAME}/${PACKAGE_NAME}
DIST=${WORKSPACE}/${DIST_FOLDER_NAME}
VENDOR=${WORKSPACE}/vendor
RUBY_VERSION="3.1.4"


DATAQUBE_BIN="
#! /bin/sh

BIN_DIR=\\\$(dirname "\\\$0")
RUBY=\\\${BIN_DIR}/../vendor/ruby/${RUBY_VERSION}/bin/ruby
GEM_PATH=\\\$(realpath \\\${BIN_DIR}/../vendor/bundle/ruby/3.1.0/)

GEM_PATH=\\\${GEM_PATH} \\\${RUBY} \\\${BIN_DIR}/dataqube.rb \\\$@
"

yum update
yum module reset -y ruby
yum install -y git make gcc gcc-c++ wget sudo @ruby:3.1 ruby-devel zlib-devel

useradd dataqube
usermod -aG wheel dataqube
usermod -u ${UID} -g ${GROUP} dataqube

chown ${UID}:${GROUP} /home/dataqube
chown ${UID}:${GROUP} ${WORKSPACE}

su - dataqube -c "
mkdir -p ${VENDOR}
cd ${VENDOR}
wget https://github.com/Homebrew/homebrew-portable-ruby/releases/download/${RUBY_VERSION}/portable-ruby-${RUBY_VERSION}.x86_64_linux.bottle.tar.gz
tar -xvf portable-ruby-${RUBY_VERSION}.x86_64_linux.bottle.tar.gz
mv portable-ruby ruby
rm -f portable-ruby-${RUBY_VERSION}.x86_64_linux.bottle.tar.gz

cd ${WORKSPACE}
rm -rf ${PACKAGE}
vendor/ruby/${RUBY_VERSION}/bin/bundle install
mkdir -p ${PACKAGE}/src

cp -rf bin examples vendor ${PACKAGE}
cp -rf src/dataqube-parser ${PACKAGE}/src

mv ${PACKAGE}/bin/dataqube ${PACKAGE}/bin/dataqube.rb
echo \"${DATAQUBE_BIN}\" > ${PACKAGE}/bin/dataqube
chmod +x ${PACKAGE}/bin/dataqube

cd ${DIST}
tar -czf ${PACKAGE_NAME}-linux-x86.tar.gz ${PACKAGE_NAME}
rm -rf ${PACKAGE_NAME}
rm -rf ${VENDOR}/ruby
"

bash
