### 1. **Initial Setup**

#### a. Update the System

Immediately after creating your droplet, update the OS and installed packages to ensure you have the latest security patches:

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. **Create a New User**

#### a. Avoid Loggin in as Root

It's a good practice not to use the root account directly. Create a new user with sudo privileges:

```bash
adduser newusername
usermod -aG sudo newusername
```

Logout as root user and login as new user

### 3. **Set Up SSH Key Authentication**

#### a. Generate SSH Keys

On your local machine, generate SSH keys if you haven't done so already:

```bash
ssh-keygen -t rsa -b 4096
```

#### b. Add Your Public Key to the Droplet

Copy your public key to your droplet:

```bash
ssh-copy-id -i key.pub newusername@your_droplet_ip
```

Check if your key is working by loggin using the private key

```bash
ssh -i private-key username@your_droplet_ip
```

#### c. Disable Root Login and Password Authentication

Edit the SSH configuration file:

```bash
sudo vim /etc/ssh/sshd_config
```

Find and update the following lines:

```plaintext
PermitRootLogin no
PasswordAuthentication no
```

Then, restart the SSH service:

```bash
sudo systemctl restart ssh
```

### 4. **Configure the Firewall**

#### a. Use UFW (Uncomplicated Firewall)

Enable the UFW firewall and allow only necessary ports (like SSH, HTTP, and HTTPS):

```bash
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'  # If using Nginx
sudo ufw allow 'Apache Full'  # If using Apache
sudo ufw enable
```

### 5. **Install Fail2ban**

Fail2ban helps protect against brute-force attacks by monitoring log files and banning IP addresses that show malicious signs.

```bash
sudo apt install fail2ban
systemctl enable fail2ban
systemctl start fail2ban
```

You can configure it further by editing the configuration files in `/etc/fail2ban/`.

### 6. Change ownership to the newly created user

```
sudo chown -R hidayahlab:hidayahlab /var/www
```

### 6. **Keep Software Up-to-Date**

Regularly check for and apply updates to keep your software secure:

```bash
sudo apt update && sudo apt upgrade -y
```

### 7. **Install Security Tools**

Consider using additional security tools like:

- **ClamAV**: Antivirus software for scanning files.
- **rkhunter**: Tool to check for rootkits.

```bash
sudo apt install clamav rkhunter
```

### 8. **Monitor Your Droplet**

Set up monitoring to keep an eye on your server’s performance and security:

- Use services like **Prometheus** or **Grafana** for monitoring.
- Regularly check logs in `/var/log/` for any suspicious activity.

### 9. **Limit User Privileges**

Ensure that users have only the permissions they need. Regularly audit user accounts and access levels.

### 10. **Backup Regularly**

Set up automated backups to ensure you have recoverable copies of your data. Many cloud providers offer snapshot features.

### 11. **Use a Security Auditing Tool**

Tools like **Lynis** can help you perform a security audit on your server:

```bash
sudo apt install lynis
sudo lynis audit system
```

### Setup nginx and docker by using the script

#### Create nginx block

```
server {
    listen 80;
    server_name api.dev.tajdidacademy.com;

    # Optionally, redirect all requests to HTTPS
    # return 301 https://$host$request_uri;  # Uncomment if you want to force HTTPS

    location / {
        proxy_pass http://localhost:8000;  # Update this with your application settings
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;

        # Optional: Forward the real visitor IP address
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

After that run
`sudo ln -s /etc/nginx/sites-available/api.dev.tajdidacademy.com /etc/nginx/sites-enabled/`

Then check if all is ok
`sudo nginx -t`

If all is okay restart nginx
`sudo systemctl reload nginx`

### Install SSL certificate

```
sudo apt update
sudo apt install certbot python3-certbot-nginx
```

### Login to github container registery

#### Add github token as env

`export GH_TOKEN=token`

#### Login with new token

`echo $GH_TOKEN | docker login ghcr.io -u mbmohib --password-stdin`

####

Obtain certificate: `sudo certbot --nginx`

###

To change owner of a directory
`sudo chown -R hidayahlab:hidayahlab .`
To set read write execute permission for owner, group and read and execute for others
`sudo chmod -R 775 .`

Check disk space
`df -h`

### Conclusion

By following these best practices, you can significantly enhance the security of your droplet. Remember that security is an ongoing process, so keep yourself updated on the latest threats and security measures.

### Additional Resources

- [DigitalOcean Security Best Practices](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-20-04)
- [UFW Documentation](https://help.ubuntu.com/community/UFW)
- [Fail2ban Documentation](https://www.fail2ban.org/wiki/index.php/Main_Page)

Feel free to ask if you have specific questions on any of these steps!
