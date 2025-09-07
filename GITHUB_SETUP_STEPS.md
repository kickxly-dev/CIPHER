# 🚀 GitHub Actions Setup - Step by Step

## Step 1: Create GitHub Account
1. Go to https://github.com
2. Click "Sign up" (if you don't have an account)
3. Choose a username (e.g., "YourName-Cipher")

## Step 2: Create New Repository
1. Click the "+" icon → "New repository"
2. Repository name: `Cipher-App`
3. Description: `Futuristic Windows Desktop Application`
4. Set to **Public** (required for free GitHub Actions)
5. Check "Add a README file"
6. Click "Create repository"

## Step 3: Upload Your Code
**Method A: Web Upload (Easiest)**
1. In your new repo, click "uploading an existing file"
2. Drag and drop ALL files from `C:\Users\kickx\CascadeProjects\CipherApp\`
3. Write commit message: "Initial Cipher application"
4. Click "Commit changes"

**Method B: Git Commands**
```bash
git clone https://github.com/YourUsername/Cipher-App.git
cd Cipher-App
# Copy all files from CipherApp folder here
git add .
git commit -m "Initial Cipher application"
git push
```

## Step 4: Automatic Build Triggers
Once uploaded, GitHub Actions will:
1. Automatically detect the `.github/workflows/build.yml` file
2. Start building the EXE
3. Create downloadable artifacts

## Step 5: Download Your EXE
1. Go to your repo → "Actions" tab
2. Click the latest build
3. Download "Cipher-Windows-EXE" artifact
4. Extract → You have `Cipher.exe`!

## Step 6: Create Release (Optional)
1. Go to repo → "Releases" → "Create a new release"
2. Tag: `v1.0`
3. Title: `Cipher v1.0 - Download and Run`
4. Upload the `Cipher.exe` file
5. Click "Publish release"

## 🎯 Result:
Direct download link: `https://github.com/YourUsername/Cipher-App/releases/download/v1.0/Cipher.exe`

Users click → Download → Double-click → App runs!
