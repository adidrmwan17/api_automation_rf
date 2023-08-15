import subprocess
from typing import Any, Tuple, List, Union, Optional, Dict
from collections import namedtuple


class configTemplate(object):
    def run_shp_cli(self, source: str, dest: str, vaultsvc_url: str) -> Any:

        cmd_shp: str = "shp-cli config-template -s %s -d %s -e %s" % (
            source,
            dest,
            vaultsvc_url,
        )

        sr: Any = subprocess.run(
            cmd_shp.split(), capture_output=True, text=True, shell=False
        )

        res = namedtuple("result", ["stdout", "stderr", "returncode"])
        return res(sr.stdout, sr.stderr, sr.returncode)
