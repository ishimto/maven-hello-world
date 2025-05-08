FROM python:3.12-slim AS build-req
COPY ./requirements.txt .
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install -r requirements.txt


FROM python:3.12-slim AS run-app
RUN useradd --create-home nonroot
USER nonroot
WORKDIR /home/nonroot/
RUN mkdir venv
COPY --from=build-req /opt/venv /home/nonroot/venv
COPY hello.py .
ENV PATH="/home/nonroot/venv/bin:$PATH"
CMD python hello.py
