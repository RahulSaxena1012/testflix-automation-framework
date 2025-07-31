FROM python:3.11-slim

# Install dependencies
RUN pip install robotframework selenium robotframework-seleniumlibrary

# Install Chrome browser and driver
RUN apt-get update && \
    apt-get install -y wget unzip chromium-driver chromium && \
    rm -rf /var/lib/apt/lists/*

# Set display for headless browser
ENV DISPLAY=:99

WORKDIR /app

COPY . .

# Run Robot Framework tests
CMD ["robot", "--outputdir", "results", "tests/ui/test_search.robot"]