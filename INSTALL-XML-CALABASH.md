# Installing XML Calabash

XML Calabash is a popular XProc processor that can execute the XProc pipeline. Here are several installation methods:

## Method 1: Download Pre-built JAR (Recommended)

### Step 1: Download XML Calabash
```bash
# Create a directory for XML Calabash
mkdir -p ~/tools/xmlcalabash
cd ~/tools/xmlcalabash

# Download the latest version (check https://xmlcalabash.com/download/ for latest)
curl -L -O https://github.com/xmlcalabash/xmlcalabash1/releases/download/1.5.6-120/xmlcalabash-1.5.6-120.jar

# Or use wget if curl is not available
# wget https://github.com/xmlcalabash/xmlcalabash1/releases/download/1.5.6-120/xmlcalabash-1.5.6-120.jar
```

### Step 2: Create a wrapper script
```bash
# Create executable script
cat > ~/tools/xmlcalabash/calabash << 'EOF'
#!/bin/bash
java -jar ~/tools/xmlcalabash/xmlcalabash-1.5.6-120.jar "$@"
EOF

# Make it executable
chmod +x ~/tools/xmlcalabash/calabash

# Add to PATH (add this to your ~/.bashrc or ~/.zshrc)
export PATH="$HOME/tools/xmlcalabash:$PATH"
```

### Step 3: Test the installation
```bash
# Reload your shell or source your profile
source ~/.bashrc  # or ~/.zshrc

# Test XML Calabash
calabash --version
```

## Method 2: Using Homebrew (macOS)

```bash
# Install via Homebrew
brew install xmlcalabash

# Test installation
xmlcalabash --version
```

## Method 3: Using Package Managers (Linux)

### Ubuntu/Debian:
```bash
# Install Java if not already installed
sudo apt update
sudo apt install openjdk-11-jdk

# Download and install XML Calabash manually (no official package)
# Follow Method 1 steps above
```

### CentOS/RHEL/Fedora:
```bash
# Install Java if not already installed
sudo dnf install java-11-openjdk

# Download and install XML Calabash manually
# Follow Method 1 steps above
```

## Method 4: Docker (Cross-platform)

```bash
# Create a Docker container with XML Calabash
docker run -it --rm -v $(pwd):/workspace openjdk:11-jre bash

# Inside the container, download XML Calabash
cd /workspace
curl -L -O https://github.com/xmlcalabash/xmlcalabash1/releases/download/1.5.6-120/xmlcalabash-1.5.6-120.jar

# Run your pipeline
java -jar xmlcalabash-1.5.6-120.jar xml-aggregation-pipeline.xpl
```

## Prerequisites

### Java Requirements
XML Calabash requires Java 8 or later. Check your Java version:

```bash
java -version
```

If Java is not installed:

**macOS:**
```bash
brew install openjdk@11
```

**Ubuntu/Debian:**
```bash
sudo apt install openjdk-11-jdk
```

**Windows:**
Download from [Oracle](https://www.oracle.com/java/technologies/downloads/) or [OpenJDK](https://openjdk.org/)

## Running the Pipeline

Once XML Calabash is installed, you can run the XProc pipeline:

### Basic execution:
```bash
calabash xml-aggregation-pipeline.xpl
```

### With parameters:
```bash
calabash -p input-dir="stats_ops/" \
         -p output-file="aggregated-overview.xml" \
         -p file-pattern="*.xml" \
         xml-aggregation-pipeline.xpl
```

### Using the provided script:
```bash
# Make the script executable
chmod +x run-pipeline.sh

# Update the script to use your calabash command
# Edit run-pipeline.sh and uncomment the calabash line

# Run the pipeline
./run-pipeline.sh
```

## Troubleshooting

### Common Issues:

1. **Java not found:**
   ```bash
   # Check Java installation
   which java
   java -version
   ```

2. **Permission denied:**
   ```bash
   # Make sure the calabash script is executable
   chmod +x ~/tools/xmlcalabash/calabash
   ```

3. **JAR not found:**
   ```bash
   # Verify the JAR file exists
   ls -la ~/tools/xmlcalabash/
   ```

4. **PATH issues:**
   ```bash
   # Add to your shell profile
   echo 'export PATH="$HOME/tools/xmlcalabash:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

### Alternative: Direct Java execution
If the wrapper script doesn't work, you can always run directly:

```bash
java -jar ~/tools/xmlcalabash/xmlcalabash-1.5.6-120.jar xml-aggregation-pipeline.xpl
```

## Updating run-pipeline.sh

After installing XML Calabash, update the [`run-pipeline.sh`](run-pipeline.sh) script:

```bash
# Edit the script to uncomment and use the calabash command
sed -i 's/# calabash/calabash/' run-pipeline.sh
```

Or manually edit the file to uncomment the calabash execution line.