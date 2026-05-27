cookies = "esctx-salL0PTRixo=AQABCQEAAAAdDD7n; stsservicecookie=estsfd; ..."

cookies_set_later = [
    "ESTSAUTHPERSISTENT=...",
    "ESTSAUTH=..."
]

cookie_dict = {}

# Load existing cookies
for cookie in cookies.split(";"):
    cookie = cookie.strip()
    if "=" in cookie:
        name, value = cookie.split("=", 1)
        cookie_dict[name] = value

# Apply updates/additions
for cookie in cookies_set_later:
    cookie = cookie.strip()
    if "=" in cookie:
        name, value = cookie.split("=", 1)
        cookie_dict[name] = value

# Rebuild cookie string
cookies = ";".join(f"{name}={value}" for name, value in cookie_dict.items())

# Save one cookie per line
with open("cookieList.txt", "w", encoding="utf-8") as file:
    file.write("\n".join(f"{name}={value}" for name, value in cookie_dict.items()))

print(cookies)