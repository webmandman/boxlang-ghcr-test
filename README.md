# Part One - Boxlang, Github Actions, Docker Container, Deployment with Render.com

The deployment process allows you to commit changes to your website code on GitHub. Then the GitHub action will automatically build the container image and push it to the GitHub Container Registry. Finally, an HTTP GET request to the Render.com redeploy webhook deploys the container image with the latest code changes. 

The entire process, from committing on your machine to a live deployment on Render.com, takes about **90 seconds**!

---

## Why is this Relevant to You?

### Cost-Effective
- **GitHub Repository**: Free.
- **GitHub Container Registry**: Free.
- **Render.com Web Service**: Free.

### Simplicity
- Requires minimal configuration.
- No credit card needed.
- Easy for everyone.

---

## Requirements

1. [GitHub Account](https://github.com)
2. [Render.com Account](https://render.com)
3. Any secrets vault (e.g., [KeeperSecurity Vault](https://www.keepersecurity.com/vault))

---

## Steps to Configure and Deploy

### 1. Get the code and start up the server

Use the template

At the top of this page, click on **Use this Template**, then click on **Create a new repository**. You know the drill - get this new repo cloned to your local environment to start making changes and commit code.

Start up the server with Commandbox

If you do not have commandbox, follow the instruction here: https://commandbox.ortusbooks.com/setup/installation

1. Run this command `box start`
2. Expect the browser to open up the website.

![Website on localhost](/assets/localhost.png)

Look at the server.json file. This is where the server is configured. `cfengine="boxlang"` tells commandbox to start up a boxlang server, and `"javaVersion":"openjdk21_jdk"`, which is a requirement of boxlang, tells commandbox to download and install the jdk in the boxlang server directory. 

Look at the index.bxm file. This is where you can edit the homepage and run some boxlang code.

---

### 2. Create a GitHub Personal Access Token

1. Create an access token. An access token is tied your github account - it grants services rights on your behalf to do things on your account. Protect it - keep in a secrets vault.
    - Go to **Profile Picture → Settings → Developer Settings → Tokens (Classic)**.
2. Create a token and save it in your secrets vault.
    - Make sure these permissions are set: **delete:packages, repo, write:packages**
    - Give it a descriptive note. ie: `For boxlang docker render.com app` 

---

### 3. Create a Repository Secret
1. Go to your repository → **Settings → Secrets and Variables → Actions → Repository Secrets**.
2. Create a new repository secret:
   - **Name**: `GH_PAT`
   - **Value**: Your GitHub Personal Access Token from Step 2.2.

---

### 4. Required source code changes

There is only 1 file that needs to be modified to make this example app work.

1. Open up your github workflow file (`/.github/workflows/publish-ghcr.yaml`)
2. Replace the github username `webmandman` with your username.
3. Save it. Commit and Push your changes.

---

### 5. Understanding the Github Workflow Action file

A GitHub Action is a customizable workflow automation tool in GitHub that enables tasks like building, testing, and deploying code to be executed automatically in response to events in a repository. 

By simply having this Github workflow file in your repo, Github will create an action that will run every time you push commits. 

### Take a closer look

  - First, `on: push` is instructing Github to do a job on every git push to your main/master branch. 
  - Second, it is instructing Github to spin up an instance of **Ubuntu**. 
  - Third, it is running the `docker login`, `docker build` and `docker push` commands. 
  - Lastly, it is going to make an http request to google.com - this is only for now. Later in this tutorial you will be replacing this url with the Render.com **deploy webhook url**. 

---

### 6. Push Your Code to GitHub

- Commit and push your code to GitHub.
- This will start your **Github Workflow Action** under the **Actions** tab.
- Click through the action to see it in action and see the results of everything the action is doing. Its pretty cool! 

Note: If the action fails, you'll have to click into the action results to see the actual error messages. Most common errors can be solved by asking google.

---

### 7. Create an Account at Render.com and Web Service

1. Go to [Render.com](https://render.com) and create an account.
2. Once you have your account, go to Workspace Settings.
3. Under **Container Registry Credentials** click **Add Credential**
    1. Give it a name, ie: `My Github Token`
    2. Select Github for the Registry
    3. Enter your username
    4. Enter your token (from step 2.2)
    5. Save
2. Create a **New Web Service** using the "Existing Image" option.
3. Enter your image URL: ie: `https://ghcr.io/YOUR_GITHUB_USERNAME_HERE/hello-world-ghcr`
    - The field says to enter a Docker hub url, but you can enter a ghcr.io url as well.
    - The url is the same url that you see in the workflow file that the docker push command requires, except do not include the last part ':latest'. 
4. Since the image is private by default, you must supply your access oken. Under Credentials dropdown, select **My Github Token**
5. Now you click on **Connect**
6. Select your Region
7. Select the Free instance type
8. Finally, click on **Deploy Web Service**

---

### 8. Get Your Render.com Redeploy URL

1. Go to the **Settings** page of your newly created web service.
2. Look for the **Deploy Hook** URL.
3. Replace `google.com` in your `/.github/workflows/publish-ghcr.yaml` file.
4. Save your changes.

---

### 10. Push Your Code Again

- Commit and push your code to GitHub.
- Head over to your repo's actions tab, and watch it do its thing.
- Then, head over to Render.com:
- In the **Events** tab of your web service, you’ll see the deployment status.
- Once deployment succeeds, you can visit your web app at the URL provided by Render.com. The url is next to your web service name near top left of the page.

![Website on Render.com](/assets/rendercom.png)

---

### Notes

- The free web service provided by Render.com comes with some limitations.
    - The web serice will shut down after 8-10 minutes of no activity(no http requests).
    - Start Time Between 45 and 90 seconds.
    - Provides 0.1 CPU and 512MB RAM.  
    - Ideal for a hobby web app with zero users.
- Despite being slow, the setup is **free** and doesn't require a credit card.
- You can upgrade your Render.com service anytime for **zero downtime**. 

---

## Conclusion

Follow these steps to achieve an efficient deployment workflow, ensuring your **BoxLang Miniserver website** is live and up-to-date with minimal effort.

Cheers!
