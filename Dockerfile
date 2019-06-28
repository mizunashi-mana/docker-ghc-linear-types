FROM tweag/linear-types:latest

ENV CABAL_WORKDIR="/root"

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y curl \
 && mkdir -p "${CABAL_WORKDIR}/.ghcup/bin" \
 && curl https://gitlab.haskell.org/haskell/ghcup/raw/master/ghcup > "${CABAL_WORKDIR}/.ghcup/bin/ghcup" \
 && chmod +x "${CABAL_WORKDIR}/.ghcup/bin/ghcup" \
 && "${CABAL_WORKDIR}/.ghcup/bin/ghcup" install-cabal \
 && apt-get remove -y curl \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/*

ENV PATH="${CABAL_WORKDIR}/.ghcup/bin:${CABAL_WORKDIR}/.cabal/bin:$PATH"

ADD assets/Main.hs ${CABAL_WORKDIR}/Main.hs
ADD assets/cabal.project ${CABAL_WORKDIR}/cabal.project
ADD assets/playground.cabal ${CABAL_WORKDIR}/playground.cabal

WORKDIR ${CABAL_WORKDIR}

RUN mkdir -p src \
 && cabal new-update \
 && cabal new-build

ENTRYPOINT ["cabal"]
CMD ["new-repl"]
