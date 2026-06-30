import requests
import urllib3
from urllib.parse import urljoin
from bs4 import BeautifulSoup

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


def read_cookie_file(path):
    cookies = {}

    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()

            if not line or "=" not in line:
                continue

            name, value = line.split("=", 1)
            cookies[name.strip()] = value.strip()

    return cookies


def write_cookie_file(path, cookies):
    with open(path, "w", encoding="utf-8") as f:
        for name, value in cookies.items():
            f.write(f"{name}={value}\n")


def getJsessionId(
    base_url="https://localhost:8443/",
    cookie_file="cookieList.txt",
    debug=False
):
    with requests.Session() as session:

        current_url = base_url

        # First two redirects
        for step in range(1, 3):

            response = session.get(
                current_url,
                verify=False,
                allow_redirects=False,
                timeout=10
            )

            if debug:
                print(f"STEP {step}")
                print("URL:", current_url)
                print("Status:", response.status_code)
                print("Location:", response.headers.get("Location"))

            if not (300 <= response.status_code < 400):
                raise RuntimeError(
                    f"Expected redirect at step {step}, got {response.status_code}"
                )

            location = response.headers.get("Location")

            if not location:
                raise RuntimeError(
                    f"Missing Location header at step {step}"
                )

            current_url = urljoin(current_url, location)

        # Load cookies from file
        file_cookies = read_cookie_file(cookie_file)

        # session.cookies.clear()

        for name, value in file_cookies.items():
            session.cookies.set(name, value)

        # Third request
        third_response = session.get(
            current_url,
            verify=False,
            allow_redirects=False,
            timeout=10
        )

        # Update cookie file
        updated_cookies = file_cookies.copy()

        for cookie in third_response.cookies:
            updated_cookies[cookie.name] = cookie.value

        write_cookie_file(cookie_file, updated_cookies)

        # Extract SAMLResponse
        soup = BeautifulSoup(
            third_response.text,
            "html.parser"
        )

        saml_response = soup.find(
            "input",
            {"name": "SAMLResponse"}
        )["value"]

        # Fourth request
        fourth_url = urljoin(base_url, "login/saml2/sso/azure-ad")

        fourth_response = session.post(
            fourth_url,
            data={
                "SAMLResponse": saml_response
            },
            verify=False,
            allow_redirects=False,
            timeout=10
        )

        jsessionid = fourth_response.cookies.get("JSESSIONID")

        if not jsessionid:
            raise RuntimeError(
                "JSESSIONID not found in response cookies."
            )

        return jsessionid