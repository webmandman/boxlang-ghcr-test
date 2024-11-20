# Part One - Boxlang, Github Actions, Docker Container, Deployment with Render.com

The deployment process allows you to commit changes to your website code on GitHub. Then the GitHub action will automatically build the container image and push it to the GitHub Container Registry. Finally, an HTTP GET request to the Render.com redeploy webhook deploys the container image with the latest code changes. 

The entire process, from committing on your machine to a live deployment on Render.com, takes about **90 seconds**!

---

## Why is this Relevant to You?

### Cost-Effective
- **GitHub Repository**: Free.
- **GitHub Container Registry**: Free.
- **Render.com Web Service**: Free.
  - Provides 0.1 CPU and 512MB RAM.  
  - Shuts down after 8 minutes of inactivity, but startup time is only about 45-90 seconds.  
  - Ideal for a hobby web app with zero users.

### Simplicity
- Requires minimal configuration.
- No credit card needed.
- Accessible and easy to implement.

---

## Requirements

1. [GitHub Account](https://github.com)
2. [Render.com Account](https://render.com)
3. Any secrets vault (e.g., [KeeperSecurity Vault](https://www.keepersecurity.com/vault))

---

## Steps to Configure and Deploy

### 1. Create a GitHub Personal Access Token
1. Go to **Profile Picture → Settings → Developer Settings → Tokens (Classic)**.
2. Create a token and save it in your secrets vault.
   - Make sure these permissions are set:
     - delete:packages, repo, write:packages

---

### 2. Create an Empty GitHub Project
1. Go to [github.com](https://github.com) and create a new repository.

---

### 3. Create a Repository Secret
1. Go to your repository → **Settings → Secrets and Variables → Actions → Repository Secrets**.
2. Create a new secret:
   - **Name**: `GH_PAT`
   - **Value**: Your GitHub Personal Access Token from Step 1.

---

### 4. Create Your "Hello World" App
1. Create a new folder/project on your development machine.
2. At the root of your project, create a file named `index.bmx` and add your HTML content.

---

### 5. Create a `Dockerfile`
- At the root of your project, create a file named `dockerfile` (no extension, no periods) with the following content:

```dockerfile
FROM ortussolutions/boxlang:miniserver-alpine
RUN rm /app/* -r 
COPY ./ /app
```

### 6. Create a GitHub Workflow File

1. Create a `.github/workflows/publish-container.yaml` file (two folders deep).
2. Add the following content:

```yaml
name: Docker Image CI for GHCR Boxlang

on:
  push

jobs: 
  build_and_publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build and push the image
        run: |
          docker login --username YOUR_GITHUB_USERNAME_HERE --password ${{secrets.GH_PAT}} ghcr.io
          docker build . --tag ghcr.io/YOUR_GITHUB_USERNAME_HERE/hello-world-ghcr:latest
          docker push ghcr.io/YOUR_GITHUB_USERNAME_HERE/hello-world-ghcr:latest
      - name: Render.com Redeploy Webhook
        uses: fjogeleit/http-request-action@v1
        with:
          url: 'https://google.com'
          method: 'GET'
```
A GitHub Action is a customizable workflow automation tool in GitHub that enables tasks like building, testing, and deploying code to be executed automatically in response to events in a repository. 

By simply having this Github workflow file in your repo, Github will create an action.  First, `on: push` it is instructing Github to do a job on every git push to your main/master branch. Secondly, it is instructing Github to spin up an instance of Ubuntu operating system. Third, it is running the docker login, docker build and docker push commands. Make sure you replace the placeholders. Here is where you name the docker image you want built - name it whatever you like (only use letters and dashes). Lastly, it is going to make an http request to google.com - this is only for now. Later in this tutorial you will be replacing this url with the Render.com Redeploy Webhook url. 

### 7. Push Your Code to GitHub

- Commit and push your code to GitHub.
- This will start the Github action under the **Actions** tab.
  - The step that builds the Docker container and pushes it to `ghcr.io` should succeed as long as you have the dockerfile, the token secret in your environment and properly replaced the placeholders in the workflow file with your Github username.

In the next steps the action will be updated to trigger Render.com to redeploy your app.

---

### 8. Create an Account at Render.com

1. Go to [Render.com](https://render.com) and create an account.
2. Create a **New Web Service** using the "Existing Image" option.
3. Set the image URL as: `https://ghcr.io/YOUR_GITHUB_USERNAME_HERE/hello-world-ghcr`

- Example: `ghcr.io/webmandman/hello-world-ghcr`
4. Since the image is private by default, you must supply your GitHub Personal Access Token.

---

### 9. Get Your Render.com Redeploy URL

1. Go to the **Settings** of your Render.com web service.
2. Look for the **Redeploy Hook** URL.
3. Save this URL to your `publish-container.yaml` file, replacing the `google.com` URL.

---

### 10. Push Your Code Again

- Commit and push your code to GitHub.
- This time, watch every part of the GitHub Action succeed.
- Head over to Render.com:
- In the **Events** tab of your web service, you’ll see the deployment status.
- Once deployment succeeds, you can visit your web app at the URL provided by Render.com.
 - Example: `https://hello-world-ghcr-latest.onrender.com`

---

### Notes

- **Cold Start Time**: Around **45 seconds**.  
- Despite being slow, the setup is **free** and doesn't require a credit card.
- You can upgrade your Render.com service anytime for **zero downtime**.

---

## Conclusion

This method is as simple as it gets, whether you use **GitHub Container Registry** or **Render.com**. It requires only:
- **Two configuration files**.
- **Two service accounts**.

This streamlined process, with no credit card required, makes deploying a **BoxLang Miniserver website** accessible and efficient for everyone.

By following these steps, you can achieve an efficient deployment workflow, ensuring your **BoxLang Miniserver website** is live and up-to-date with minimal effort.
