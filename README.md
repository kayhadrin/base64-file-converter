# base64 File Converter
 
Encode a file to base64, or decode it back to the original.

# Installation

Just the usual `npm install --global base64-file-converter`.

## Example

    # Assuming you are in this repo's folder, create a dummy archive file
    gzip README.md
    
    # encode to base64
    base64-file-converter encode README.md.gz base64.txt 
    
    # decode from base64
    base64-file-converter decode base64.txt decoded.gz
    
    # Test equality
    diff README.md.gz decoded.gz && echo Equal files 
    # Should display: "Equal files"
    
    gzip -t README.md.gz && echo Integrity check passed
    # Should display: Integrity check passed
