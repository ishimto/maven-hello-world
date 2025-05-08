FROM python:3.12-slim AS build-req
COPY ./requirements.txt .
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install -r requirements.txt


FROM python:3.12-slim AS run-app
COPY --from=build-req /opt/venv /opt/venv
COPY hello.py .
ENV PATH="/opt/venv/bin:$PATH"
CMD python hello.py
