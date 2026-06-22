import re
import platform
import subprocess
from pathlib import Path

from auth import getJsessionId


def get_nginx_paths():
    if platform.system() == "Windows":
        nginx_dir = Path(
            r"C:\Users\tudor\Software\nginx\nginx-1.30.0"
        )
    else:
        nginx_dir = Path(
            "/mnt/c/Users/tudor/Software/nginx/nginx-1.30.0"
        )

    nginx_exe = nginx_dir / "nginx.exe"
    nginx_conf = nginx_dir / "conf" / "nginx.conf"

    return nginx_dir, nginx_exe, nginx_conf


def update_nginx_jsessionid(conf_path: Path, new_jsessionid: str) -> None:
    config = conf_path.read_text(encoding="utf-8")

    pattern = re.compile(
        r'('
        r'location\s*/\s*\{'
        r'(?:(?!location\s*/\s*\{).)*?'
        r'proxy_pass\s+https://localhost:8443\s*;'
        r'(?:(?!location\s*/\s*\{).)*?'
        r'proxy_set_header\s+Cookie\s+"JSESSIONID='
        r')'
        r'[^"]*'
        r'(";)',
        re.DOTALL
    )

    updated_config, count = pattern.subn(
        lambda m: f"{m.group(1)}{new_jsessionid}{m.group(2)}",
        config,
        count=1
    )

    if count != 1:
        raise RuntimeError(
            "Could not find the localhost:8443 JSESSIONID entry."
        )

    backup_path = conf_path.with_suffix(".conf.bak")

    backup_path.write_text(
        config,
        encoding="utf-8"
    )

    conf_path.write_text(
        updated_config,
        encoding="utf-8"
    )

    print(f"Updated nginx config: {conf_path}")
    print(f"Backup saved to: {backup_path}")
    print(f"New JSESSIONID: {new_jsessionid}")


def reload_nginx() -> None:
    nginx_dir, nginx_exe, _ = get_nginx_paths()

    result = subprocess.run(
        [
            str(nginx_exe),
            "-s",
            "reload"
        ],
        cwd=str(nginx_dir),
        capture_output=True,
        text=True
    )

    print("stdout:")
    print(result.stdout)

    print("stderr:")
    print(result.stderr)

    if result.returncode != 0:
        raise RuntimeError(
            f"Nginx reload failed with exit code {result.returncode}"
        )

    print("Nginx reloaded successfully.")


def main():
    _, _, nginx_conf = get_nginx_paths()

    jsessionid = getJsessionId()

    update_nginx_jsessionid(
        nginx_conf,
        jsessionid
    )

    reload_nginx()


if __name__ == "__main__":
    main()