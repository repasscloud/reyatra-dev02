#!/bin/sh

# Directory to extract the plugins into
extract_dir="./wp-plugins/"

# Ensure the directory exists
mkdir -p "$extract_dir"

# List of plugin URLs
urls=(
"https://en-au.wordpress.org/plugins/wp-optimize/"
"https://en-au.wordpress.org/plugins/litespeed-cache/"
"https://en-au.wordpress.org/plugins/wordpress-seo/"
"https://en-au.wordpress.org/plugins/redirection/"
"https://en-au.wordpress.org/plugins/wp-statistics/"
"https://en-au.wordpress.org/plugins/mailchimp-for-wp/"
"https://en-au.wordpress.org/plugins/broken-link-checker/"
"https://en-au.wordpress.org/plugins/elementor/"
)

# Loop over each URL
for url in "${urls[@]}"; do
    echo "Processing $url"

    # Use wget to fetch the HTML content of the page
    # Use grep to find the download link (capturing the link by splitting lines and filtering)
    link=$(wget -q -O - "$url" | grep -o 'https://downloads.wordpress.org/plugin/[^"]*' | head -n 1)

    # Full download URL (now extracted directly, without using Perl-compatible regex)
    download_url=$link

    echo "Download URL: $download_url"

    # Download the ZIP file to a temporary file
    temp_zip=$(basename "$url").zip
    wget -O "$temp_zip" "$download_url"

    # Check if the download was successful before attempting to unzip
    if [ -f "$temp_zip" ]; then
        # Extract the ZIP file
        unzip -o "$temp_zip" -d "$extract_dir"

        # Clean up the temporary ZIP file
        rm "$temp_zip"

        echo "Extraction complete for $(basename "$url"). Plugin available in: $extract_dir"
    else
        echo "Failed to download the file for $(basename "$url")."
    fi
done
