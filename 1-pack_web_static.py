#!/usr/bin/python3
"""
Fabric script to generate a .tgz archive from web_static folder.
"""

from fabric.api import local
from datetime import datetime
import os

def do_pack():
    """
    Generates a .tgz archive from the contents of the web_static folder.

    Returns:
        Archive path if successful, None if unsuccessful.
    """
    # Create versions directory if it doesn't exist
    if not os.path.exists("versions"):
        os.makedirs("versions")

    # Generate archive name with current timestamp
    now = datetime.utcnow()
    archive_name = "web_static_{}{}{}{}{}{}.tgz".format(
        now.year, now.month, now.day, now.hour, now.minute, now.second)

    # Create the tgz command
    tgz_command = "tar -cvzf versions/{} web_static".format(archive_name)

    # Execute the tar command
    print("Packing web_static to versions/{}".format(archive_name))
    result = local(tgz_command)

    # Check if tar command was successful
    if result.failed:
        return None
    else:
        return "versions/{}".format(archive_name)
