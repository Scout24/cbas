from pybuilder.core import use_plugin, init

use_plugin("python.core")
use_plugin("python.unittest")
use_plugin("python.install_dependencies")
use_plugin("python.flake8")
use_plugin("python.coverage")
use_plugin("python.distutils")
use_plugin("python.cram")


name = "cbas"
default_task = "publish"


@init
def set_properties(project):
    project.depends_on('click')
    project.depends_on('keyring')
    project.depends_on('secretstorage')
    project.depends_on('yamlreader')
