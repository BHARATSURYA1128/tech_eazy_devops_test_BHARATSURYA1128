# 🚀 Techeazy DevOps Assignment

This project demonstrates how to automate the deployment of a Java application to an AWS EC2 instance using only shell scripts and environment configurations — with no external tools or frameworks. The app runs on port 80 and auto-shuts down to avoid costs.

---

## 📋 Step-by-Step Project Setup

### ✅ **Step 1: Launch EC2 Instance**
- Created an EC2 instance (**Ubuntu 22.04**, `t2.micro`) using AWS Console.
- Configured a security group to allow:
  - **SSH (port 22)** from my IP
  - **HTTP (port 80)** from anywhere
- Connected via SSH using:

```bash
ssh -i my-key.pem ubuntu@34.230.4.46
```
### ✅ Step 2: Install Dependencies
Installed required packages inside the EC2 instance:

```bash
sudo apt update
sudo apt install -y openjdk-21-jdk maven git
```
Verified installations:

```bash
java -version
mvn -version
git --version
```
### ✅ Step 3: Clone and Build the Java Application
Cloned the sample Java project from GitHub:

```bash
git clone https://github.com/Trainings-TechEazy/test-repo-for-devops.git
cd test-repo-for-devops
mvn clean package
```
The final JAR file was generated in target/:

```bash
target/hellomvc-0.0.1-SNAPSHOT.jar
```
### ✅ Step 4: Run the App on Port 80
Deployed the app to run on port 80:

```bash
sudo nohup java -jar target/hellomvc-0.0.1-SNAPSHOT.jar --server.port=80 > log.txt 2>&1 &
```
Confirmed the app is running at:

```bash
http://34.230.4.46/hello
Response: Hello from Spring MVC!
```

### ✅ Step 5: Schedule Auto-Shutdown
To avoid EC2 charges, scheduled the instance to shut down automatically:

```bash
sudo shutdown -h +30
```
### ✅ Step 6: Automate the Deployment
Created the following files:

🔹 dev_config.env

```bash
APP_NAME=hellomvc
PORT=80
ENVIRONMENT=dev
SHUTDOWN_TIMER_MINUTES=30
```
🔹 deploy.sh

```bash
#!/bin/bash

source dev_config.env

echo "🔧 Deploying $APP_NAME in $ENVIRONMENT environment..."

sudo pkill -f "$APP_NAME" || true
mvn clean package

sudo nohup java -jar target/${APP_NAME}-0.0.1-SNAPSHOT.jar --server.port=${PORT} > log.txt 2>&1 &

echo "🚀 App running on port $PORT"

sudo shutdown -h +$SHUTDOWN_TIMER_MINUTES
```
🔹 resources/postman_collection.json

```bash
{
  "info": {
    "name": "TechEazy DevOps Assignment",
    "description": "Sample collection to test /hello endpoint on deployed EC2 app.",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "GET /hello",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": "http://34.230.4.46/hello",
          "protocol": "http",
          "host": ["34.230.4.46"],
          "path": ["hello"]
        }
      },
      "response": []
    }
  ]
}
```

Created using cURL and exported via Postman to verify /hello endpoint.

### ✅ Step 7: Push to GitHub
Initialized a Git repo inside the EC2 instance

Added all files and pushed them to GitHub

```bash
git init
git remote add origin https://github.com/BHARATSURYA1128/tech_eazy_devops_BHARATSURYA1128.git
git add .
git commit -m "Initial commit"
git push -u origin main
```
### 🧪 How to Deploy (Usage)
SSH into your EC2 instance.

Run:

```bash
chmod +x deploy.sh
./deploy.sh
```
The script will:

Build the app

Run it on port 80

Auto-shutdown the instance after the configured time

### 📂 File Structure

```bash
.
├── deploy.sh
├── dev_config.env
├── README.md
├── resources/
│   └── postman_collection.json
└── src/main/
         └──target/
                  └── hellomvc-0.0.1-SNAPSHOT.jar
```

### 📬 Postman Collection
Located at:

```bash
resources/postman_collection.json
```
You can import this into Postman for API testing.

### 🧾 Notes
Java version: 21 (OpenJDK)

EC2 type: t2.micro (Free Tier eligible)

No external libraries/tools used

All setup done manually on EC2 instance

## 👏 Thank you!
This project demonstrates the fundamentals of cloud automation using minimal tools — all run and managed from within a Linux EC2 instance.
