# Oracle Cloud Free Tier - Host the Registration App (FREE, always-on)

This runs the registration app on Oracle's **Always Free** cloud VM so it works
24/7 (even when your PC is off). Cost: **$0 forever** for the instance used here.

## Step 1 - Sign up (once, ~5 min)

1. Go to https://signup.cloud.oracle.com
2. Fill the form: email, password, choose a **Home Region** (any), country.
3. Verify your phone with the OTP.
4. Add a **credit/debit card** — used ONLY for identity verification.
   - A ~$1 temporary hold appears, then is released. You are NOT charged.
5. Submit and wait for the approval email (usually 2–10 minutes).
6. Sign in at https://cloud.oracle.com (use the approval email link).

## Step 2 - Create the free VM (Always Free)

1. In the console menu: **Compute** → **Instances** → **Create instance**.
2. Name: `hello-web`
3. **Image**: Oracle Linux 8  →  change to **Canonical Ubuntu 24.04**.
4. **Shape**: choose **Ampere/AMD** → pick **VM.Standard.E2.1.Micro** (shows
   "Always Free eligible"). RAM 1 GB, 1 OCPU.
5. **Add SSH keys**: choose **Generate a key pair for me**, then click
   **Save private key** → download the file (e.g. `ssh-key-2026.pem`).
6. Click **Create**.

Wait until the instance shows **Running** (1–2 minutes).

## Step 3 - Open port 8080 to the internet

1. Open the instance page → scroll to **Primary VNIC** → click the
   **Subnet** (or go to Networking → Virtual Cloud Networks).
2. Open **Security List** for that subnet → **Add Ingress Rule**:
   - Source Type: **CIDR**
   - Source CIDR: `0.0.0.0/0`
   - IP Protocol: **TCP**
   - Destination Port Range: `8080`
3. Click **Add Ingress Rules**.

## Step 4 - Run the setup (I can do this for you)

On the instance page, copy the **Public IP address**.

You have two options:
- **Option A (I do it):** put the downloaded `.pem` file somewhere on your PC,
  tell me the public IP + where the file is, and I will SSH in and run
  everything (install MySQL + Tomcat + deploy the app).
- **Option B (you do it):** open the **Cloud Shell** (icon top-right) and run:
  ```
  curl -fsSL https://github.com/aravindayya/HelloWeb/raw/main/oracle/setup_oracle.sh -o setup.sh && bash setup.sh
  ```
  (You must add the instance's SSH public key to Cloud Shell first.)

When it finishes, students can register at: **http://<PUBLIC_IP>:8080**

The registration page opens at the root URL; the `students`, `student_phones`
and `users` tables are created automatically on the first start.
