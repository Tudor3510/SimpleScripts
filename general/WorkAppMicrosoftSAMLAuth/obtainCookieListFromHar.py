from pathlib import Path
import json
from http.cookies import SimpleCookie


def parse_cookie_header(header_value):
    cookie = SimpleCookie()
    cookie.load(header_value)
    return {name: morsel.value for name, morsel in cookie.items()}


def extract_cookies_from_har(har_path):
    data = json.loads(Path(har_path).read_text(encoding="utf-8"))
    entries = data["log"]["entries"]

    cookies = {}

    # Assuming only one exchange
    entry = entries[0]

    # Cookies explicitly listed in request.cookies
    for c in entry["request"].get("cookies", []):
        cookies[c["name"]] = c["value"]

    # Cookies from Cookie: header
    for h in entry["request"].get("headers", []):
        if h["name"].lower() == "cookie":
            cookies.update(parse_cookie_header(h["value"]))

    # Updated cookies from Set-Cookie headers
    for h in entry["response"].get("headers", []):
        if h["name"].lower() == "set-cookie":
            cookie = SimpleCookie()
            cookie.load(h["value"])
            for name, morsel in cookie.items():
                cookies[name] = morsel.value

    return cookies


def save_cookie_list(cookies, output_file="cookieList.txt"):
    with open(output_file, "w", encoding="utf-8") as f:
        for name, value in cookies.items():
            f.write(f"{name}={value}\n")


if __name__ == "__main__":
    har_file = "exchange.har"  # Change to your .har filename

    cookies = extract_cookies_from_har(har_file)
    save_cookie_list(cookies)

    print(f"Saved {len(cookies)} cookies to cookieList.txt")