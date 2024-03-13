# 베이스 이미지 설정
FROM python:3.11
# maintainer(유지 보수자)를 Samiiz로 지정
LABEL maintainer="Samiiz"
# PYTHONUNBUFFERED 1 을 사용하여
# Python 출력이 버퍼링되지 않고 즉시 터미널로 전송되도록 하는 환경 변수를 설정
ENV PYTHONUNBUFFERED 1
# COPY 원본파일 (복사할위치)/파일이름  /tmp : 임시파일들을 넣을 디렉토리
COPY .requierments.txt /tmp/requierments.txt
COPY .requierments.dev.txt /tmp/requierments.dev.txt
COPY ./app /app
# 컨테이너 내부에서의 작업폴더를 /app으로 설정
WORKDIR /app
# 컨테이너 실행시 8000번 포트에서 수신할 것임을 설정
EXPOSE 8000
# DEV변수를 false로 선언
ARG DEV=false
# RUN : FROM기반의 이미지 위에서 실행될 명령어
# chzzk이라는 가상환경 생성
RUN python -m venv /chzzk && \
    # pip 업그레이드
    /chzzk/bin/pip3 install --upgrade pip && \
    # requierments 내의 종속성 라이브러리들을 설치
    /czzk/bin/pip3 install -r tmp/requierments.txt && \
    # DEV라는 환경번수가 true 일때 if 문 시작 
    if [ $DEV = "true"] ; \
        # "=== THIS IS DEVELOPING ZONE ==="라고 echo
        then echo "=== THIS IS DEVELOPING ZONE ===" && \
        # requierments.dev 내의 종속성 라이브러리들을 설치
        /chzzk/bin/pip3 install -r tmp/requierments.dev.txt ; \
    # fi로 if문 종료
    fi && \
    # 이미 라이브러리들을 설치 했으므로 tmp 디렉토리 삭제(이미지 크기 관리 / 임시파일 정리)
    rm -rf /tmp && \
    # 새로운 사용자를 컨테이너에 추가
    adduser \
        # 비밀번호 비활성화
        --disabled-password \
        # home 디렉토리 생성 제한
        --no-create-home \
        # 새로운 사용자의 이름을 django-user로 지정
        django-user
# 가상환경 내의 python의 경로를 바로 찾을 수 있도록 현재 시스템 PATH에 chzzk/bin 경로를 추가
ENV PATH="chzzk/bin:$PATH"
# 이후 명령에 대한 기본 사용자를 django-user로 지정
USER django-user