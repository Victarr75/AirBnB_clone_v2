#!/usr/bin/env python3
from fabric.api import *
from datetime import datetime
import os

env.hosts = ['<IP web-01>', '<IP web-02>']

def do_pack():
    """Generates a .tgz archive from the contents of the web_static folder"""
    try:
        if not os.path.exists("versions"):
            os.makedirs("versions")
        date = datetime.now().strftime("%Y%m%d%H%M%S")
        archive_name = "versions/web_static_{}.tgz".format(date)
        local("tar -cvzf {} web_static".format(archive_name))
        return archive_name
    except:
        return None

def do_deploy(archive_path):
    """Distributes an archive to the web servers"""
    if not os.path.exists(archive_path):
        return False
    try:
        archive_name = archive_path.split("/")[-1]
        archive_no_ext = archive_name.split(".")[0]
        release_folder = "/data/web_static/releases/{}/".format(archive_no_ext)
        
        put(archive_path, "/tmp/")
        run("mkdir -p {}".format(release_folder))
        run("tar -xzf /tmp/{} -C {}".format(archive_name, release_folder))
        run("rm /tmp/{}".format(archive_name))
        run("mv {0}web_static/* {0}".format(release_folder))
        run("rm -rf {}web_static".format(release_folder))
        run("rm -rf /data/web_static/current")
        run("ln -s {} /data/web_static/current".format(release_folder))
        
        print("New version deployed!")
        return True
    except:
        return False
