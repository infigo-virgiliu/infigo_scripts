@echo off
REM ==============================
REM Simple HTTP Server Batch Script
REM ==============================

REM Change directory to the folder where the .bat is located

REM Set port (change if needed)
set PORT=8085

echo Starting server on http://localhost:%PORT%
echo Press CTRL+C to stop.

REM Run Python HTTP server
python -m http.server %PORT%

pause