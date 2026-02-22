FROM python:3.13-slim
WORKDIR /usr/local/app

# Install the application dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt \
    && pip uninstall -y opencv-python \
    && pip install --no-cache-dir --force-reinstall "opencv-python-headless>=4.10.0"

# Copy in the source code
COPY . .

# Create user of the app
RUN useradd -m app && chown -R app:app /usr/local/app
USER app

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "main:app"]
