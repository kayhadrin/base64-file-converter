# base64 File Converter
 
Encode a file to base64, or decode it back to the original.

Usage: 

    node src/main.js encode archive.zip out.txt 
    node src/main.js decode archive.zip decoded.zip
    diff archive.zip decoded.zip && echo Equal files # Displays: Equal files