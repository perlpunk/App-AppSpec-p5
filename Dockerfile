FROM centos:centos7

ARG APPSPEC_REPO="https://github.com/perlpunk/app-spec-p5"
ARG APPSPEC_VERSION=0.013

ARG APP_APPSPEC_REPO="https://github.com/perlpunk/app-appspec-p5"
ARG APP_APPSPEC_VERSION=0.006

RUN yum update -y && \
    yum install -y -q  \
           openssl-devel \
           wget \
           git \
           yum-utils \
           gcc \
           perl-devel \
           perl-CPAN \
           perl-App-cpanminus \
           perl-Test-Simple \
           perl-ExtUtils-MakeMaker \
           perl-List-MoreUtils \
           perl-JSON && \
   cpanm List::Util --quiet && \
   cpanm File::ShareDir::Install --quiet && \
   ( \
    git clone \
      --depth 1 \
      --branch "v${APPSPEC_VERSION}" \
      "${APPSPEC_REPO}" && \
    cd "$(basename "${APPSPEC_REPO}")" && \
    cpanm --quiet . \
   ) && \
   rm -rf "$(basename "${APPSPEC_REPO}")" && \
   ( \
    git clone \
      --depth 1 \
      --branch "v${APP_APPSPEC_VERSION}" \
      "${APP_APPSPEC_REPO}" && \
    cd "$(basename "${APP_APPSPEC_REPO}")" && \
    cpanm --quiet . \
   ) && \
   rm -rf "$(basename "${APP_APPSPEC_REPO}")"

ENTRYPOINT ["appspec"]
