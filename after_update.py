import sys
import json
import os
from subprocess import check_output, check_call, CalledProcessError, STDOUT, DEVNULL

def main():
    os.rmdir("1C_OF/vo2_82_of/core")
    os.symlink(os.path.abspath("1C_OF/vo2_core/"), 
               os.path.abspath("1C_OF/vo2_82_of/core/"), 
               target_is_directory=True)
    
    config = json.load(open("1C_OF/vo2_82_of/src/ExternalDataProcessor.json", "rb"))
    version = config["v8unpack"]

    url = "https://git.sbis.ru/integration/v8unpack.git"

    if os.path.exists("1C_OF/v8unpack"):
        print(f"Update exists repo v8unpack")
        os.chdir("1C_OF/v8unpack")

        print("Remove changes")
        git_change_remote(url)

        print("Fetch data")
        git_fetch()

        print(f"checkout {version}")
        git_checkout(version)

        os.chdir("..")
    else:
        os.chdir("1C_OF")
        git_clone(url, "v8unpack", version)

    os.chdir("..")

    os.symlink(os.path.abspath("1C_OF/v8unpack/exe/v8unpack.exe"), 
               os.path.abspath("1C_OF/vo2_82_of/v8unpack.exe"))
    
        
def git_clone(url, folder, branch):
    cmd_list = ["git", "clone"]
    need_set_config = False
    
    if branch is not None:
        cmd_list.extend(["-b", branch])
        need_set_config = True
        cmd_list.append("--single-branch")
        cmd_list.extend(["--depth", "20"])

    if os.path.basename(folder) == ".":
        clone_folder = os.path.dirname(os.path.join(os.path.abspath(folder), "."))
    else:
        clone_folder = folder

    cmd_list.extend([url, clone_folder])
    check_call(cmd_list, stderr=STDOUT)
    os.chdir(clone_folder)
    if need_set_config:
        git_set_config("*")

    os.chdir("..")


def git_set_config(fetch_branch):
    str_conf = "+refs/heads/{}:refs/remotes/origin/{}".format(fetch_branch, fetch_branch)
    check_call(["git", "config", "remote.origin.fetch", str_conf], stderr=STDOUT)


def git_pull():
    check_output(["git", "pull"], stderr=STDOUT)


def git_checkout(branch):
    check_output(["git", "checkout", branch], stderr=STDOUT)
            

def git_change_remote(url):
    # check_output(["git", "config", "--get", "remote.origin.url"], stderr=STDOUT, encoding='utf-8').strip()
    check_output(["git", "reset", "--hard"], stderr=STDOUT, encoding='utf-8').strip()
    check_output(["git", "clean", "-fd"], stderr=STDOUT, encoding='utf-8').strip()


def git_fetch():
    check_output(["git", "fetch", "--prune"], stderr=STDOUT)

if __name__ == "__main__":
    sys.exit(main())