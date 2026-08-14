# Railway Deployment - Student Registration

Deploys the student registration app to Railway so it runs 24/7 (even when your
PC is off) and anyone on the internet can register.

## What is here

- `ROOT.war`        - the ready-to-run registration web app (opens register.jsp
                      at the root URL). Supports multiple phone numbers.
- `sql/schema.sql`  - full database schema. Tables are also created
                      automatically on first start, so you do NOT need this.
- `../Dockerfile`   - the build file Railway uses (repo root).

## Deploy on Railway (from GitHub)

1. Make sure the latest code is pushed to GitHub (repo: aravindayya/HelloWeb).

2. Go to https://railway.app and open your project (or start a new one).

3. Add MySQL:
   - Click **+ New** -> **Database** -> **MySQL**.
   - Click the MySQL service, open **Variables**, and note the values of:
     `MYSQLHOST`, `MYSQLPORT`, `MYSQLUSER`, `MYSQLPASSWORD`, `MYSQLDATABASE`

4. Add the web service:
   - Click **+ New** -> **Empty Service** -> **Deploy from GitHub**.
   - Connect your GitHub account if asked, then choose `aravindayya/HelloWeb`.
   - Railway will build the app using the `Dockerfile` in the repo root.

5. Set environment variables on the web service:
   - Open the web service -> **Variables** -> add:
     ```
     MYSQLHOST      = <from MySQL>
     MYSQLPORT      = <from MySQL>
     MYSQLUSER      = <from MySQL>
     MYSQLPASSWORD  = <from MySQL>
     MYSQLDATABASE  = <from MySQL>
     ```
   - Redeploy if needed (Deployments -> Deploy).

6. Go live:
   - Web service -> **Settings** -> **Networking** -> **Generate Domain**.
   - Copy the public URL (e.g. https://something.up.railway.app).
   - Send that link to all students. The registration form opens directly.

Tables (`students`, `student_phones`, `users`) are created automatically on the
first start. No SQL work needed.
