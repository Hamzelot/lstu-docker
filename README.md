# Docker Image for Lstu

What does Lstu mean?
It means Let's Shorten That Url.

## Owner
The writer of the lstu-software is [Luc Didry](https://framagit.org/fiat-tux/hat-softwares/lstu) his project is licensed under the WTFPL.

## Installation

If you run the docker build yourself, the git submodules must be reloaded.

### Docker Compose

Please adjust the environment variables in the .docker-compose file then start

```bash
docker-compose build
docker-compose up

```

The build command is optionally

### Docker

Adjust the environment variable and execute the run command

```bash
docker build -t hamzelot/lstu .

docker run -itd \
-e CONTACT="name@email.eu" \
-p 8080:8080 \
 --name lstu hamzelot/lstu
```

The build command is optionally

### Variables

##### CONTACT [STRING]
Put a way to contact you here  
_Default: "abc@example.com"_
##### LISTEN [ARRAY]
array of IP addresses and ports you want to listen to
_Default: 'http://0.0.0.0:8080'_
``` yaml
    environment:
      LISTEN: >-
        'http://0.0.0.0:8080'
        'http://0.0.0.0:80'
``` 
Don't forget to adjust the HEALTHCHECK in Dockerfile to the correct port if you are not using the default.
##### URL_LENGTH [NUMBER]
The length of the generated links  
_Default: 8_
##### ADMIN_PW_SHA256 [NUMBER] [SHA256]
secret hashed passphrase to access some admin features  
Hash your password by issuing `echo -n s3cr3T | sha256sum` on your terminal  
_Default: (optional, not set, no admin access)_
##### PAGE_OFFSET [NUMBER]
Number of URLs to be displayed per page in /stats  
_Default: 10 (optional)_
##### USE_PROXY [NUMBER]
if you use Lufi behind a reverse proxy like Nginx, you want to set proxy to 1  
_Default: 0_
##### THEME [STRING]
Choose a theme. See the available themes in `themes` directory  
Explanation of use below  
_Default: "default"_
##### PROVIS_STEP [NUMBER]
How many URLs will be provisioned in a batch ?  
_Default: 5_
##### PROVISIONING [NUMBER]
Max number of URLs to be provisioned  
_Default: 100_
##### URL_PREFIX [STRING]
URL sub-directory in which you want Lufi to be accessible  
_Default: "/"_
##### ALLOWED_DOMAINS [ARRAY]
Array of authorized domains for API calls.  
_Default (no default, optional, no domains allowed by default)_
##### FIXED_DOMAIN [STRING]
if set, the shortened URLs will use this domain   
_Default (no default, optional)_
##### BAN_MIN_STRIKE [NUMBER]
Rate-limiting for the API  
After ban_min_strike requests in a second, the IP address will be banned for one hour.  
_Default: 3_
##### BAN_WHITELIST [ARRAY]
You can whitelist IP addresses to prevent you from being banned 
Be careful, the IP addresses are compared as string, not as IP addresses a network range will not work  
_Default: (disabled, optional)_
``` yaml
    environment:
      BAN_WHITELIST: >-
        '198.51.100.42',
        '2001:0DB8::42', 
``` 
##### BAN_BLACKLIST [ARRAY]
You can blacklist IP addresses to always ban those IP addresses  
Be careful, the IP addresses are compared as string, not as IP addresses a network range will not work  
_Default: (disabled, optional)_
``` yaml
    environment:
      BAN_BLACKLIST: >-
        '198.51.100.42',
        '2001:0DB8::42', 
``` 
##### PIWIK [HASHTABLE]
If you want to have piwik statistics, provide a piwik image tracker  
_Default (no default, optional)_
``` yaml
    environment:
      PIWIK: >-
        url => 'http://piwik.example.com',
        idsite => 1, 
``` 

##### SESSION_DURATION [NUMBER]
if you've set ldap or htpasswd above, the session will last `session_duration` seconds before the user needs to reauthenticate   
_Default: 3600_
##### MAX_REDIR [NUMBER]
How many redirections are allowed for the shortened URL before considering it as a spam?  
_Default: 2 (-1 deactivates it)_
##### SPAM_BLACKLIST_REGEX [STRING]
spam blacklist regex. All URLs (or redirection) whose host part matches this regex are considered as spam  
_Default: (optional, no default)_
##### SPAM_PATH_BLACKLIST_REGEX [STRING]
spam path blacklist regex. All URLs (or redirection) whose path part matches this regex are considered as spam  
_Default: (optional, no default)_
##### SPAM_WHITELIST_REGEX [STRING]
spam whitelist regex. All URLs (or redirection) whose host part matches this regex will never be considered as spam  
_Default: (optional, no default)_
##### SKIP_SPAMHAUS [NUMBEER]
set to 1 to skip SpamHaus check (not recommended)  
_Default: 0_
##### SAFEBROWSING_API_KEY [STRING]
put your Google API key to enable Google safebrowsing check. This will allow Lstu to download the Google safebrowsing database and use a local copy to check the URLs.  
Google does not get the URLs that are checked.  
_Default: (optional, no default)_
##### MEMCACHED_SERVERS [ARRAY]
Array of memcached servers to cache URL in order to accelerate responses to often-viewed URL.  
_Default: [] (optional)_
``` yaml
    environment:
      MEMCACHED_SERVERS: >-
        '127.0.0.1:5000'
``` 
MEMCACHED_SERVERS
##### CSP [STRING]
Content-Security-Policy header that will be sent by Lstu  
_Default: default-src 'none'; script-src 'self'; style-src 'self'; img-src 'self' data:; font-src 'self'; form-action 'self'; base-uri 'self'_
The default value is good for `default` and `milligram` themes
##### X_FRAME [STRING]
X-Frame-Options header that will be sent by Lstu  
_Default: "DENY"_  
Valid values are: 'DENY', 'SAMEORIGIN', 'ALLOW-FROM https://example.com/'
##### X_CONTENT_TYPE [STRING]
X-Content-Type-Options that will be sent by Lstu  
_Default: "nosniff"_
##### X_XSS_PROTECTION [STRING]
X-XSS-Protection that will be sent by Lstu  
_Default: "1; mode=block"_
##### LOG_CREATOR_IP [NUMBER]
Set to 1 if you want to register the IP addresses of URL creators  
_Default: 0_

## Own Themes

For a custom theme, you need to create a volume. This must point to the `/usr/lstu/themes` folder. 

After that you can copy your theme into the container with 
`docker cp /PATH/TO/THEME lstu:/usr/lstu/themes/`, after editing the variable with the name of the theme restart the container

Alternatively, of course, the selected storage area may already contain the theme.

##### docker-compose volume

``` bash
    volumes:
      - "data:/usr/lstu/files"
      - "themes:/usr/lstu/themes"
    environment:
      THEME: "NAMEOFTHEME"
```

##### docker volume

Add the `-v THEMES/FILES/LOCATION:/usr/lstu/themes -e THEME="NAMEOFTHEME"` suffix to the command in the Docker header.

## Access

Access is now via http://SERVER_IP:8080.

## TLS Proxy

How to use a Nginx or Apache proxy is described [here](https://framagit.org/fiat-tux/hat-softwares/lstu/-/wikis/installation#reverse-proxy).

!Important! Set the environment variable "USE_PROXY" to 1
