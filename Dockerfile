FROM centos:centos7

ARG APPSPEC_VERSION=0.006

RUN yum update -y \
    && \
    yum install -y -q  \
           openssl-devel \
           wget \
           yum-utils \
           gcc \
           perl-devel \
           perl-CPAN \
           perl-App-cpanminus \
           perl-Test-Simple \
           perl-ExtUtils-MakeMaker \
           perl-List-MoreUtils \
           perl-JSON \
   && \
   cpanm List::Util --quiet \
   && \
   cpanm --quiet App::AppSpec@${APPSPEC_VERSION}

ENTRYPOINT ["appspec"]